terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://pve.hem-pel.com/api2/json"
}

variable "control_plane_count" {
  default = 3
}

variable "worker_count" {
  default = 3
}

variable "default_password" {
  default = "ChangeMe!"
}

variable "memory" {
  default = 4096
}

variable "cpu" {
  default = 2
}

locals {
  control_nodes = { for i in range(var.control_plane_count) : "cp${i+1}" => "control-plane" }
  worker_nodes  = { for i in range(var.worker_count) : "w${i+1}"  => "worker" }
  all_nodes     = merge(local.control_nodes, local.worker_nodes)
}

resource "proxmox_lxc" "k8s_nodes" {
  for_each    = local.all_nodes

  target_node  = "pve"
  hostname     = "k8s-${each.key}"
  ostemplate   = "local:vztmpl/ubuntu-24.10-standard_24.10-1_amd64.tar.zst"
  password     = var.default_password
  unprivileged = true
  hastate      = "started"

  cores  = var.cpu
  memory = var.memory

  rootfs {
    storage = "local-lvm"
    size    = "5G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }

  # Optional: add tags/labels for identification
  tags = each.value
}

