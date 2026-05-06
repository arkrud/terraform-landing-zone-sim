terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

locals {
  name_prefix = "${var.project}-${var.env}-${var.region_code}-bg"

  slots = {
    blue  = "b"
    green = "g"
  }
}

resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Shared blue/green ALB security group"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
    Tier = "bluegreen-service"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_http_in" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_all_out" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Blue/green app security group"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-app-sg"
    Tier = "bluegreen-service"
  })
}

resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "app_all_out" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb" "app" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-alb"
    Tier = "bluegreen-service"
  })
}

resource "aws_lb_target_group" "app" {
  for_each = local.slots

  name     = "${local.name_prefix}-${each.value}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-${each.value}-tg"
    Tier = "bluegreen-service"
    Slot = each.key
  })
}

resource "aws_instance" "app" {
  for_each = local.slots

  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_ids[each.key == "blue" ? 0 : 1]
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    cat > /usr/share/nginx/html/index.html <<HTML
    <html>
      <body>
        <h1>${var.project} ${var.env} ${each.key}</h1>
        <p>Single ALB blue/green target group model</p>
      </body>
    </html>
    HTML
    systemctl start nginx
  EOF

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-${each.value}-app"
    Tier = "bluegreen-service"
    Slot = each.key
  })
}

resource "aws_lb_target_group_attachment" "app" {
  for_each = local.slots

  target_group_arn = aws_lb_target_group.app[each.key].arn
  target_id        = aws_instance.app[each.key].id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app[var.active_slot].arn
  }
}
