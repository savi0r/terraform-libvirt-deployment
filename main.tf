provider "libvirt" {
  uri = "qemu:///system"
}

data "template_file" "provision_network" {
  template = file("${path.module}/provision_network.xslt")
  vars = {
    provision_ipaddr = var.provision_ipaddr
  }
}

data "template_file" "os_mgmt_network" {
  template = file("${path.module}/os_mgmt_network.xslt")
  vars = {
    os_mgmt_ipaddr = var.os_mgmt_ipaddr
  }
}

resource "libvirt_network" "PROVISION" {
  name = "PROVISION"
  xml {
    xslt = data.template_file.provision_network.rendered
  }
  autostart = true
}

resource "libvirt_network" "OS_MGMT" {
  name = "OS_MGMT"
  mode = "none"
  xml {
    xslt = data.template_file.os_mgmt_network.rendered
  }
  autostart = true
}

resource "libvirt_network" "CEPH_PUBLIC" {
  name = "CEPH_PUBLIC"
  mode = "none"
  dhcp {
    enabled = false
  }
  autostart = true
}

resource "libvirt_network" "OS_TUNNEL" {
  name = "OS_TUNNEL"
  mode = "none"
  dhcp {
    enabled = false
  }
  autostart = true
}

resource "libvirt_network" "CEPH_CLUSTER" {
  name = "CEPH_CLUSTER"
  mode = "none"
  dhcp {
    enabled = false
  }
  autostart = true
}

resource "libvirt_network" "OS_INTERNET" {
  name = "OS_INTERNET"
  mode = "none"
  dhcp {
    enabled = false
  }
  autostart = true
}

resource "libvirt_network" "INTERNET" {
  name   = "INTERNET"
  mode   = "bridge"
  bridge = "br0"
  dhcp {
    enabled = false
  }
  autostart = true
}

resource "libvirt_pool" "openstack_staging_cluster" {
  name = "openstack_staging_cluster"
  type = "dir"
  path = "/data/vms/staging"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each       = var.vms
  name           = "${each.key}_commoninit.iso"
  pool           = libvirt_pool.openstack_staging_cluster.name
  user_data      = data.template_file.user_data[each.key].rendered
  network_config = data.template_file.network_config.rendered
}

data "template_file" "user_data" {
  for_each = var.vms
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = each.key
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config_dhcp.cfg")
}

resource "libvirt_volume" "os_image" {
  name   = "base_os_image"
  pool   = libvirt_pool.openstack_staging_cluster.name
  source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "master_volume" {
  for_each       = var.vms
  name           = "${each.key}_main_volume"
  pool           = libvirt_pool.openstack_staging_cluster.name
  size           = each.value.os_disk
  base_volume_id = libvirt_volume.os_image.id
}

resource "libvirt_volume" "secondary_volume" {
  for_each = { for k, v in var.vms : k => v if try(v.spare_disk, "") != "" }
  pool     = libvirt_pool.openstack_staging_cluster.name
  name     = "${each.key}_secondary_volume"
  size     = each.value.spare_disk
}

resource "libvirt_domain" "domain-ubuntu" {
  for_each  = var.vms
  name      = each.key
  memory    = each.value.memory
  vcpu      = each.value.vcpu
  autostart = true

  disk {
    volume_id = libvirt_volume.master_volume[each.key].id
  }

  dynamic "disk" {
    for_each = try(each.value.spare_disk, "") == "" ? [] : [1]
    content {
      volume_id = libvirt_volume.secondary_volume[each.key].id
    }
  }

  network_interface {
    network_id = libvirt_network.PROVISION.id
    addresses  = [each.value.ip_addr]
  }

  dynamic "network_interface" {
    for_each = var.networks
    content {
      network_name = network_interface.value
    }
  }

  xml {
    xslt = file("${path.module}/nested_virtualization.xslt")
  }

  cloudinit = libvirt_cloudinit_disk.commoninit[each.key].id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}

terraform {
  required_version = ">= 0.12"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.10"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
