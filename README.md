# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in Scaleway. Besides infrastructure components (security group, instance, volume, etc), it also:

- Optionally pulls latest snapshot from [Polkashots](https://polkashots.io)
- [Node exporter](https://github.com/prometheus/node_exporter) with HTTPs to securly pull metrics from your monitoring systems.
- Nginx as a reverse proxy for libp2p
- Support for different deplotments methods: either using docker/docker-compose or deploying the binary itself in the host.

It uses the latest official Ubuntu 20.04 LTS (no custom image). 

## Requirements

It requires to have Scaleway account and the following environment variables exported. 

```
export SCW_ACCESS_KEY=YYYYYYYYYY
export SCW_SECRET_KEY=ZZZZZZZZZ
```

More information within the [Scaleway Terraform Provider](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs)

## Usage

```hcl
module "kusama_validator" {
  source = "github.com/cloudstaking/terraform-scaleway-polkadot?ref=1.3.0"

  instance_name = "ksm-validator"
  ssh_key       = "ssh-rsa XXXXXXXXXXXXXX"
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance with `tail -f  /var/log/cloud-init-output.log`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| scaleway | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloud_init | github.com/cloudstaking/terraform-cloudinit-polkadot?ref=main |  |

## Resources

| Name |
|------|
| [scaleway_account_ssh_key](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/account_ssh_key) |
| [scaleway_instance_ip](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_ip) |
| [scaleway_instance_security_group](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group) |
| [scaleway_instance_server](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_server) |
| [scaleway_instance_volume](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_volume) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ssh\_key | SSH Key to use for the instance | `any` | n/a | yes |
| application\_layer | You can deploy the Polkadot using docker containers or in the host itself (using the binary) | `string` | `"host"` | no |
| chain | Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io | `string` | `"kusama"` | no |
| disk\_size | Disk size. For digital ocean and Scaleway volume is created and mounted under /home | `number` | `200` | no |
| enable\_polkashots | Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `false` | no |
| http\_password | Password to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| http\_username | Username to access endpoints (e.g node\_exporter) | `string` | `""` | no |
| instance\_name | Instance name | `string` | `"validator"` | no |
| instance\_type | Instance type: for Kusama DEV1-M is fine, for Polkadot maybe GP1-M. Check requirements in the wiki | `string` | `"DEV1-M"` | no |
| p2p\_port | P2P port for Polkadot service, used in `--listen-addr` args | `number` | `30333` | no |
| polkadot\_additional\_common\_flags | CLI arguments appended to the polkadot service (e.g validator name) | `string` | `""` | no |
| proxy\_port | nginx reverse-proxy port to expose Polkadot's libp2p port. Polkadot's libp2p port should not be exposed directly for security reasons (DOS) | `number` | `80` | no |
| public\_fqdn | Public domain for validator. If set, Caddy will use it to request LetsEncrypt certs. This variable is particulary useful to provide a secure channel (HTTPs) for [node\_exporter](https://github.com/prometheus/node_exporter) | `string` | `""` | no |
| security\_group\_name | Name of the Security group attached to the instance | `string` | `""` | no |
| tags | n/a | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| http\_password | Password to access private endpoints (e.g node\_exporter) |
| http\_username | Username to access private endpoints (e.g node\_exporter) |
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
