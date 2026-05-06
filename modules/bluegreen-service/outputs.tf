output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "active_slot" {
  value = var.active_slot
}

output "blue_instance_id" {
  value = aws_instance.app["blue"].id
}

output "green_instance_id" {
  value = aws_instance.app["green"].id
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.app["blue"].arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.app["green"].arn
}
