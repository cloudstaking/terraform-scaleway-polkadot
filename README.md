# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in Scaleway. Besides infrastructure (security group, instance, volume, etc), it also does:
- Pulls the latest snapshot from [Polkashots](https://polkashots.io)
- Creates a docker-compose with the [latest polkadot's release](https://github.com/paritytech/polkadot/releases) and nginx reverse-proxy (for libp2p port).

## Requirements

It requires to have Scaleway account and the following environment variables exported. 

```
export SCW_DEFAULT_ORGANIZATION_ID=XXXXX-XXX-XXXX-XXXXXXXXX
export SCW_ACCESS_KEY=YYYYYYYYYY
export SCW_SECRET_KEY=ZZZZZZZZZ
```

More information within the [Scaleway Terraform Provider](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs)

## Usage

```hcl
module "validator" {
  source = "github.com/cloudstaking/terraform-scaleway-polkadot?ref=1.2.0"

  instance_name = "ksm-validator"
  ssh_key       = "ssh-rsa XXXXXXXXXXXXXX"
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance with `tail -f  /var/log/cloud-init-output.log`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| scaleway | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cloud_init | ../cloud_init |  |

## Resources

| Name |
|------|
| [scaleway_account_ssh_key](https://registry.terraform.io/providers/hashicorp/scaleway/latest/docs/resources/account_ssh_key) |
| [scaleway_instance_ip](https://registry.terraform.io/providers/hashicorp/scaleway/latest/docs/resources/instance_ip) |
| [scaleway_instance_security_group](https://registry.terraform.io/providers/hashicorp/scaleway/latest/docs/resources/instance_security_group) |
| [scaleway_instance_server](https://registry.terraform.io/providers/hashicorp/scaleway/latest/docs/resources/instance_server) |
| [scaleway_instance_volume](https://registry.terraform.io/providers/hashicorp/scaleway/latest/docs/resources/instance_volume) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| http\_password | Password to access private endpoints (e.g node\_exporter) |
| http\_username | Username to access private endpoints (e.g node\_exporter) |
| validator\_public\_ip | Validator public IP address, you can use it to SSH into it |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
