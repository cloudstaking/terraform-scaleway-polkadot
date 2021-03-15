# terraform-scaleway-validator

Terraform module to bootstrap Scaleway Instances for Kusama or Polkadot validators. The module creates the security groups, instance volumes (`200 GB` by default) and ensure the latest snapshots from 

## Requirements

```
export SCW_DEFAULT_ORGANIZATION_ID=XXXXX-XXX-XXXX-XXXXXXXXX
export SCW_ACCESS_KEY=YYYYYYYYYY
export SCW_SECRET_KEY=ZZZZZZZZZ
```

## Usage

```hcl
module "cloudstaking_kusama" {
  source = "github.com/cloudstaking/terraform-scaleway-validator?ref=1.0.0"

  instance_name       = "ksm-validator"
  security_group_name = "ksm-validator"
  chain               = "kusama"
}
```

#### Providers

| Name | Version |
|------|---------|
| scaleway | n/a |

#### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| chain | Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io | `string` | `"kusama"` |
| instance_name | Name of the Scaleway instance | `string` | `"validator"` |
| instance_type | Instance type. For Kusama DEV1-M is fine, for Polkadot GP1-M. | `string` | `"DEV1-M"` |
| security_group_name | Name of the security group | `string` | `"validator-sg"` |
| volume_size | Volume size where the chain state is going to be saved - check Kusama/Polkadot requirements | `number` | `200` |

#### Outputs

| Name | Description |
|------|-------------|
| validator_public_ip | Validator public IP address, you can use it to SSH into it |
