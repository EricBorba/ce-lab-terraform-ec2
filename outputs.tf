output "web_public_ips" {
  description = "Public IPs of the web server instances, keyed by subnet ID"
  value       = { for k, v in module.ec2_web : k => v.public_ip }
}

output "web_private_ips" {
  description = "Private IPs of the web server instances, keyed by subnet ID"
  value       = { for k, v in module.ec2_web : k => v.private_ip }
}

output "app_private_ips" {
  description = "Private IPs of the app server instances, keyed by subnet ID"
  value       = { for k, v in module.ec2_app : k => v.private_ip }
}

output "web_security_group_id" {
  description = "Web security group ID"
  value       = module.security_group_web.security_group_id
}

output "app_security_group_id" {
  description = "App security group ID"
  value       = module.security_group_app.security_group_id
}
