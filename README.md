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

