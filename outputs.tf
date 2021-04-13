output "validator_public_ip" {
  value       = scaleway_instance_server.validator.public_ip
  description = "Validator public IP address, you can use it to SSH into it"
}

output "http_username" {
  value       = module.cloud_init.http_username
  description = "Username to access private endpoints (e.g node_exporter)"
}

output "http_password" {
  value       = module.cloud_init.http_password
  description = "Password to access private endpoints (e.g node_exporter)"
}

