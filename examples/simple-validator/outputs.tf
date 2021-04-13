output "public_ip" {
  value = module.validator.validator_public_ip
}

output "ssh" {
  value = "ssh root@${module.validator.validator_public_ip}"
}

output "http_username" {
  value = module.validator.http_username
}

output "http_password" {
  value = module.validator.http_password
}
