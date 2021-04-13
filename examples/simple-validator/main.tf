
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

  instance_name                    = var.instance_name
  ssh_key                          = var.ssh_key
  enable_polkashots                = true
  polkadot_additional_common_flags = "--name=CLOUDSTAKING-TEST --telemetry-url 'wss://telemetry.polkadot.io/submit/ 1'"

  # This is optional
  tags = ["blue", "terraform"]
}
