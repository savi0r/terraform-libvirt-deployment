variable "vms" {
  description = "Map of vm names."
  type        = map(any)
}

variable "networks" {
  description = "list of network names."
  type        = list(string)
}

variable "iso_address" {
  description = "ip addr of deployment node on provision network"
  type        = string
}

variable "provision_ipaddr" {
  description = "ip addr of deployment node on provision network"
  type        = string
}

variable "os_mgmt_ipaddr" {
  description = "ip addr of deployment node on provision network"
  type        = string
}
