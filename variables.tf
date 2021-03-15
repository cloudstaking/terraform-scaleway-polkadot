variable "security_group_name" {
  default     = "validator-sg"
  description = "Name of the security group"
}

variable "instance_name" {
  default     = "validator"
  description = "Name of the Scaleway instance"
}

variable "instance_type" {
  default     = "DEV1-M"
  description = "Instance type. For Kusama DEV1-M is fine, for Polkadot GP1-M."
}

variable "volume_size" {
  description = "Volume size where the chain state is going to be saved - check Kusama/Polkadot requirements"
  default     = 200
}

variable "chain" {
  description = "Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io"
  default     = "kusama"
}
