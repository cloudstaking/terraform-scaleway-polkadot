output "validator_public_ip" {
  value       = scaleway_instance_server.validator.public_ip
  description = "Validator public IP address, you can use it to SSH into it"
}
