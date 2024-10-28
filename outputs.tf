# output "load_balancer_dns_name" {
#   description = "LoadBalancer dns name"
#   value = module.alb.load_balancer_dns_name
# }

output "auto_scaling_group_name" {
  description = "Auto scaling group name"
  value = aws_autoscaling_group.jenkins_master_asg.name
}

output "launch_template_id" {
  description = " launch template id"
  value = aws_launch_template.application_lt.id
}


