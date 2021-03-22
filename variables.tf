variable "security_group_name" {
  default     = ""
  description = "Security group name"
}

variable "security_group_whitelisted_ssh_ip" {
  default     = "0.0.0.0/0"
  description = "List of CIDRs the instance is going to accept SSH connections from."
}

variable "instance_name" {
  default     = "validator"
  description = "Name of the Scaleway instance"
}

variable "instance_type" {
  default     = "DEV1-M"
  description = "Instance type: for Kusama DEV1-M is fine, for Polkadot maybe GP1-M. Check requirements in the Polkadot wiki"
}

variable "chain" {
  description = "Chain name: kusama or polkadot. Variable required to download the latest snapshot from polkashots.io"
  default     = "kusama"
}

variable "enable_polkashots" {
  default     = true
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "ssh_key" {
  description = "SSH Key to use for the instance"
}

variable "tags" {
  default     = []
  description = "Tags for the instance"
}

variable "additional_volume" {
  description = "By default, DEV1-M comes with 40GB disk size. Set this variable in order to create an additional volume (mounted in /srv)"
  default     = true
  type        = bool
}

variable "additional_volume_size" {
  description = "Volume size where the chain state is going to be saved (only applies if additional_volume variable set) - check Kusama/Polkadot requirements"
  default     = 200
}

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "Application layer - when `enable_docker_compose = true`, the content of this variable will be appended to the polkadot command arguments"
}
