output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "alb_arn" {
  value = aws_lb.app.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "instance_id" {
  value = aws_instance.app.id
}

output "slot" {
  value = var.slot
}
