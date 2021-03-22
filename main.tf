locals {
  chain = {
    kusama   = { name = "kusama", short = "ksm" },
    polkadot = { name = "polkadot", short = "dot" }
    other    = { name = var.chain, short = var.chain }
  }

  security_group_name = var.security_group_name != "" ? var.security_group_name : "${var.instance_name}-sg"

  docker_compose = templatefile("${path.module}/templates/generate-docker-compose.sh.tpl", {
    chain                   = var.chain
    enable_polkashots       = var.enable_polkashots
    latest_version          = data.github_release.polkadot.release_tag
    additional_common_flags = var.polkadot_additional_common_flags
  })

  cloud_init = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
    chain             = lookup(local.chain, var.chain, local.chain.other)
    enable_polkashots = var.enable_polkashots
    additional_volume = var.additional_volume
    docker_compose    = base64encode(local.docker_compose)
  })
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

  # nginx (reverse-proxy for p2p)
  inbound_rule {
    action = "accept"
    port   = 80
  }
}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_volume" "validator" {
  count = var.additional_volume ? 1 : 0

  size_in_gb = var.additional_volume_size
  type       = "b_ssd"
}

resource "scaleway_account_ssh_key" "validator" {
  name       = "${var.instance_name}-key"
  public_key = var.ssh_key
}

resource "scaleway_instance_server" "validator" {
  name = var.instance_name
  type = var.instance_type

  image                 = "ubuntu_focal"
  ip_id                 = scaleway_instance_ip.public_ip.id
  enable_ipv6           = true
  security_group_id     = scaleway_instance_security_group.validator.id
  additional_volume_ids = var.additional_volume ? [scaleway_instance_volume.validator.0.id] : []

  cloud_init = local.cloud_init

  tags = var.tags

  depends_on = [scaleway_account_ssh_key.validator]
}

data "github_release" "polkadot" {
  repository  = "polkadot"
  owner       = "paritytech"
  retrieve_by = "latest"
}
