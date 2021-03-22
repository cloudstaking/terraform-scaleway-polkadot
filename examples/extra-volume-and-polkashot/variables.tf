variable "instance_name" {
  description = "Name of the Scaleway instance"
}

variable "ssh_key" {
  description = "SSH Key to attach to the machine"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "enable_polkashots" {
  description = "Pull latest Polkadot/Kusama (depending on chain variable) from polkashots.io"
  type        = bool
}

variable "additional_volume" {
  description = "By default, DEV1-M comes with 40GB disk size. Set this variable in order to create an additional volume (mounted in /srv)"
  type        = bool
}
