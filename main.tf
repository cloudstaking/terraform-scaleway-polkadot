locals {
  kusama   = { name = "kusama", short = "ksm" }
  polkadot = { name = "polkadot", short = "dot" }
}

resource "scaleway_instance_security_group" "validator" {
  name        = var.security_group_name
  description = "Default server instances SG"

  inbound_default_policy = "drop"

  # SSH
  inbound_rule {
    action   = "accept"
    port     = 22
    ip_range = var.security_group_whitelisted_ssh_ip
  }

  # libp2p port
  inbound_rule {
    action = "accept"
    port   = 30333
  }
}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_volume" "validator" {
  count = var.additional_volume ? 1 : 0

  size_in_gb = var.volume_size
  type       = "b_ssd"
}

resource "scaleway_instance_server" "validator" {
  name = var.instance_name
  type = var.instance_type

  image                 = "debian_buster"
  ip_id                 = scaleway_instance_ip.public_ip.id
  enable_ipv6           = true
  security_group_id     = scaleway_instance_security_group.validator.id
  additional_volume_ids = [scaleway_instance_volume.validator.0.id]

  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
    chain             = var.chain == "kusama" ? local.kusama : local.polkadot
    enable_polkashots = var.enable_polkashots
    additional_volume = var.additional_volume
  })

  tags = ["validator"]
}
