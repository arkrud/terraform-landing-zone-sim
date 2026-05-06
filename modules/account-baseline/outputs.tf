output "terraform_execution_role_arn" {
  value = aws_iam_role.terraform_execution.arn
}

output "readonly_role_arn" {
  value = aws_iam_role.readonly.arn
}

output "baseline_log_group_name" {
  value = aws_cloudwatch_log_group.baseline.name
}

output "env_marker_parameter_name" {
  value = aws_ssm_parameter.env_marker.name
}