resource "aws_ssm_parameter" "portal" {
  name        = "/${var.portal_name}/${var.parameter_key}"
  type        = "String"
  value       = var.parameter_value
  description = "Portal configuration parameter"
}
