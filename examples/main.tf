
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

# Provider(s)
provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
}

module "validator_TMP" {
  source = "../"

  instance_name       = "validatorTMP"
  security_group_name = "validatorTMP-sg"
  chain               = "kusama"
}
