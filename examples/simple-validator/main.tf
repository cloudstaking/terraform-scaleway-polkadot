
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
  zone = "fr-par-1"
}

module "validator" {
  source = "../.."

  instance_name     = var.instance_name
  ssh_key           = var.ssh_key
  additional_volume = var.additional_volume
  enable_polkashots = var.enable_polkashots
}
