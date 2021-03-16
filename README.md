# terraform-scaleway-polkadot

Terraform module to bootstrap Scaleway instances for Kusama/Polkadot validators. It creates security group, instance volume (`200 GB` by default) and ensure the latest snapshots from [Polkashots](https://polkashots.io).

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
  source = "github.com/cloudstaking/terraform-scaleway-validator?ref=1.0.0"

  instance_name       = "ksm-validator"
  security_group_name = "ksm-validator"
  chain               = "kusama"
}
```

## Providers

| Name | Version |
|------|---------|
| scaleway | n/a |

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| chain | Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io | `string` | `"kusama"` |
| instance_name | Name of the Scaleway instance | `string` | `"validator"` |
| instance_type | Instance type. For Kusama DEV1-M is fine, for Polkadot GP1-M. | `string` | `"DEV1-M"` |
| security_group_name | Name of the security group | `string` | `"validator-sg"` |
| volume_size | Volume size where the chain state is going to be saved - check Kusama/Polkadot requirements | `number` | `200` |

## Outputs

| Name | Description |
|------|-------------|
| validator_public_ip | Validator public IP address, you can use it to SSH into it |
