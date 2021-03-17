variable "security_group_name" {
  default     = "validator-sg"
  description = "Name of the security group"
}

variable "security_group_whitelisted_ssh_ip" {
  default     = "0.0.0.0/0"
  description = "List of CIDRs that instance is going to accept SSH connections from"
}

variable "instance_name" {
  default     = "validator"
  description = "Name of the Scaleway instance"
}

variable "instance_type" {
  default     = "DEV1-M"
  description = "Instance type. For Kusama DEV1-M is fine, for Polkadot GP1-M."
}

variable "additional_volume" {
  description = "By default, DEV1-M comes with 40GB disk size. Set to true to create an additional volume and mount it under /srv"
  default     = true
  type        = bool
}

variable "volume_size" {
  description = "Volume size where the chain state is going to be saved (only applies if additional_volume variable set) - check Kusama/Polkadot requirements"
  default     = 200
}

variable "chain" {
  description = "Which chain you are using: kusama or polkadot. It is used to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = true
  description = "Pull the latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}
