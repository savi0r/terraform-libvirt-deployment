## Introduction

This project is powered by terraform by utilising [libvirt provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) which will bring up a whole infrustructure by creating VMs and later on by running tractor project on them we will have a complete staging environment.

## Pre-deployment

In order to use this tool you must first edit `vars.tf` in which you can define your VMs, their descriptions and also your networks based on your needs, afterwards if you decided that you need bridging in your project you have to define them either by modifying `/etc/network/interfaces` or by your preffered method. Also the storage pool which is created in this project mounted in `/data/vms` I decided to create a lvm and mount it there, make sure to provide enough space.

##Run the project

After doing your tweaks you are good to go , run the project by creating a module like this :
```
module "deployment" {
  source   = "savi0r/libvirt"
  vms      = var.vms
  networks = var.networks
  provision_ipaddr = var.provision_ipaddr
  os_mgmt_ipaddr = var.os_mgmt_ipaddr
}
```

Also you need to provide variables which determines the specification of vms ,take this as an example:

```
#Disk size must be defined in bytes
variable "vms" {
  description = "Map of vm names."
  type        = map(any)
  default = {
    "stg1-controller1001" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 4,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.0.1"
    },
    "stg1-controller1002" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 4,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.0.2"
    },
    "stg1-controller1003" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 4,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.0.3"
    },
    "stg1-network6001" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 60 * 1000000000,
      "ip_addr" = "192.168.0.41"
    },
    "stg1-network6002" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 60 * 1000000000,
      "ip_addr" = "192.168.0.42"
    },
    "stg1-storage3001" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.1"
    },
    "stg1-storage3002" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.2"
    },
    "stg1-storage3003" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.3"
    },
    "stg1-storage3004" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.4"
    },
    "stg1-storage3005" = {
      "memory"  = 8 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.5"
    },
    "stg1-storage3101" = {
      "memory"     = 8 * 1024,
      "vcpu"       = 2,
      "os_disk"    = 10 * 1000000000,
      "spare_disk" = 200 * 1000000000,
      "ip_addr"    = "192.168.3.101"
    },
    "stg1-storage3102" = {
      "memory"     = 8 * 1024,
      "vcpu"       = 2,
      "os_disk"    = 10 * 1000000000,
      "spare_disk" = 200 * 1000000000,
      "ip_addr"    = "192.168.3.102"
    },
    "stg1-storage3103" = {
      "memory"     = 8 * 1024,
      "vcpu"       = 2,
      "os_disk"    = 10 * 1000000000,
      "spare_disk" = 200 * 1000000000,
      "ip_addr"    = "192.168.3.103"
    },
    "stg1-compute2001" = {
      "memory"  = 24 * 1024,
      "vcpu"    = 8,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.2.1"
    },
    "stg1-compute2002" = {
      "memory"  = 24 * 1024,
      "vcpu"    = 8,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.2.2"
    },
    "stg1-compute2003" = {
      "memory"  = 24 * 1024,
      "vcpu"    = 8,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.2.3"
    },
    "stg1-monitoring7001" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.3.241"
    },
    "stg1-monitoring7002" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.3.242"
    },
    "stg1-monitoring7003" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 25 * 1000000000,
      "ip_addr" = "192.168.3.243"
    },
    "stg1-logging8001" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.231"
    },
    "stg1-logging8002" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.232"
    },
    "stg1-logging8003" = {
      "memory"  = 16 * 1024,
      "vcpu"    = 2,
      "os_disk" = 100 * 1000000000,
      "ip_addr" = "192.168.3.233"
    }
  }
}

variable "networks" {
  description = "list of network names."
  type        = list(string)
  default     = ["OS_MGMT", "CEPH_PUBLIC", "CEPH_CLUSTER", "OS_TUNNEL", "OS_INTERNET", "INTERNET"]
}

variable "provision_ipaddr" {
  description = "ip addr of deployment node on provision network"
  type        = string
  default     = "192.168.3.254"
}

variable "os_mgmt_ipaddr" {
  description = "ip addr of deployment node on provision network"
  type        = string
  default     = "172.31.3.254"
}
```

Afterwards , you have to provide your public key in a file named `id_rsa.pub` in the same directory where main.tf and vars.tf reside.

Your main directory would look like this:
```
├── main.tf
├── variables.tf
├── id_rsa.pub
```