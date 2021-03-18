# terraform-scaleway-polkadot

Terraform module to bootstrap ready-to-use _single node_ (or optionally _active-standby_) Kusama/Polkadot validators in Scaleway. It creates security group, instance volume (`200 GB` by default) and ensure the latest snapshot from [Polkashots](https://polkashots.io).

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
module "kusama_validator" {
  source = "github.com/cloudstaking/terraform-scaleway-polkadot?ref=1.1.0"

  instance_name       = "ksm-validator"
  security_group_name = "ksm-validator"
  chain               = "kusama"
}
```

If `enable_polkashots` is set, it'll take ~10 minutes to download and extract the latest snapshot. You can check the process within the instance

```sh
$ tail -f  /var/log/cloud-init-output.log
4323850K .......... .......... .......... .......... .......... 99%  313M 0s
4323900K .......... ......                                     100% 56.2M=78s

2021-03-17 14:27:38 (54.2 MB/s) - ‘/srv/kusama.RocksDb.7z’ saved [4427690609/4427690609]

Scanning the drive for archives:
1 file, 4427690609 bytes (4223 MiB)

Extracting archive: kusama.RocksDb.7z
```

## Providers

| Name | Version |
|------|---------|
| scaleway | n/a |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| additional_volume | By default, DEV1-M comes with 40GB disk size. Set to true to create an additional volume and mount it under /srv | `bool` | `true` |
| chain | Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io | `string` | `"kusama"` |
| enable_polkashots | Pull the latest Polkadot/Kusama (depending on chain variable) from polkashots.io | `bool` | `true` |
| instance_name | Name of the Scaleway instance | `string` | `"validator"` |
| instance_type | Instance type. For Kusama DEV1-M is fine, for Polkadot GP1-M. | `string` | `"DEV1-M"` |
| security_group_name | Name of the security group | `string` | `"validator-sg"` |
| security_group_whitelisted_ssh_ip | List of CIDRs that instance is going to accept SSH connections from | `string` | `"0.0.0.0/0"` |
| tags | Tags for the instance | `list` | `[]` |
| volume_size | Volume size where the chain state is going to be saved (only applies if additional_volume variable set) - check Kusama/Polkadot requirements | `number` | `200` |

## Outputs

| Name | Description |
|------|-------------|
| validator_public_ip | Validator public IP address, you can use it to SSH into it |


