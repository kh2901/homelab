provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true
}

resource "proxmox_virtual_environment_vm" "vms" {
  for_each = var.vms

  name      = each.key
  node_name = var.target_node

  tags = each.value.tags

  clone {
    vm_id = 9000   # ID of debian-13-cloud-base template
  }

  cpu {
    cores = each.value.cpu
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = each.value.disk
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "debian"
      keys     = [var.ssh_public_key]
    }
  }

  boot_order = ["scsi0"]

  on_boot = true
}

