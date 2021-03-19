
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
  source = "../"

  instance_name       = "validator"
  security_group_name = "validator-sg"

  additional_volume                = true
  enable_polkashots                = true
  enable_docker_compose            = true
  polkadot_additional_common_flags = "--name=CLOUDSTAKING --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'"
}
