output "public_ip" {
  value = module.validator.validator_public_ip
}

output "ssh" {
  value = "ssh root@${module.validator.validator_public_ip}"
}
