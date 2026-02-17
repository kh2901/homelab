variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "target_node" {
  type    = string
  default = "pve"
}

variable "storage" {
  type    = string
  default = "local-lvm"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

variable "vms" {
  default = {
    "dns-01" = { cpu=1, memory=256, disk=8, tags=["network","dns","adguard"] }
    "ntp-01" = { cpu=1, memory=256, disk=8, tags=["network","ntp","chrony"] }
    "monitor-01" = { cpu=1, memory=512, disk=8, tags=["monitoring","uptime"] }
    "vpn-01" = { cpu=1, memory=256, disk=8, tags=["vpn","tailscale"] }
  }
}
