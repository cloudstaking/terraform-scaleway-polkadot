locals {
  security_group_name = var.security_group_name != "" ? var.security_group_name : "${var.instance_name}-sg"

  disk_size = {
    additional_volume      = var.disk_size >= 40 ? true : false
    additional_volume_size = var.disk_size
  }
}

resource "scaleway_instance_security_group" "validator" {
  name        = local.security_group_name
  description = "Default server instances SG"

  inbound_default_policy = "drop"

  # SSH
  inbound_rule {
    action = "accept"
    port   = 22
  }

  # nginx (reverse-proxy for p2p)
  inbound_rule {
    action = "accept"
    port   = 80
  }

  # https for TLS-ALPN challange only when public_fqdn is given:
  # https://caddyserver.com/docs/automatic-https#tls-alpn-challenge
  dynamic "inbound_rule" {
    for_each = range(var.public_fqdn != "" ? 1 : 0)
    content {
      action = "accept"
      port   = 443
    }
  }

  # node-exporter
  inbound_rule {
    action = "accept"
    port   = 9100
  }
}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_volume" "validator" {
  count = local.disk_size.additional_volume ? 1 : 0

  size_in_gb = local.disk_size.additional_volume_size
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
  additional_volume_ids = local.disk_size.additional_volume ? [scaleway_instance_volume.validator.0.id] : []
  cloud_init            = module.cloud_init.clout_init

  tags = var.tags

  depends_on = [scaleway_account_ssh_key.validator]
}

module "cloud_init" {
  source = "github.com/cloudstaking/terraform-cloudinit-polkadot?ref=main"

  application_layer                = var.application_layer
  additional_volume                = local.disk_size.additional_volume
  cloud_provider                   = "scaleway"
  chain                            = var.chain
  polkadot_additional_common_flags = var.polkadot_additional_common_flags
  enable_polkashots                = var.enable_polkashots
  p2p_port                         = var.p2p_port
  proxy_port                       = var.proxy_port
  public_fqdn                      = var.public_fqdn
  http_username                    = var.http_username
  http_password                    = var.http_password
}

