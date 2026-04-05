output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.http.arn
}

output "portal_target_group_arns" {
  value = aws_lb_target_group.portal_tgs[*].arn
}

output "portal_target_group_names" {
  value = aws_lb_target_group.portal_tgs[*].name
}
