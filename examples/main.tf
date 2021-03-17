
terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

# Provider(s)
provider "scaleway" {}

module "validator" {
  source = "../"

  instance_name       = "validator"
  security_group_name = "validator-sg"
  chain               = "kusama"
}
