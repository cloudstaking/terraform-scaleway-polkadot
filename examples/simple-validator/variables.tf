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

variable "polkadot_additional_common_flags" {
  default     = ""
  description = "Application layer - the content of this variable will be appended to the polkadot command arguments"
}
