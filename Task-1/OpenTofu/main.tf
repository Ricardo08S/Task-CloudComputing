terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "null_resource" "cache_image" {
  provisioner "local-exec" {
    command = "wget -O /tmp/ubuntu-20.04.qcow2 ${var.ubuntu_image}"
  }
}

resource "libvirt_volume" "base" {
  name   = "base.qcow2"
  source = "/tmp/ubuntu-20.04.qcow2"
  pool   = var.libvirt_disk_path
  format = "qcow2"
  depends_on = [null_resource.cache_image]
}

resource "libvirt_volume" "ubuntu20-qcow2" {
  count          = length(var.vm)
  name           = "ubuntu20-${count.index}.qcow2"
  base_volume_id = libvirt_volume.base.id
  pool           = var.libvirt_disk_path
  size           = 5368709120
}

data "template_file" "user_data" {
  count    = length(var.vm)
  template = <<EOF
  #cloud-config
  runcmd:
    - sed -i '/PermitRootLogin/d' /etc/ssh/sshd_config
    - echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
    - systemctl restart sshd
  ssh_pwauth: true
  disable_root: false
  chpasswd:
    list: |
      rics:rics
    expire: false
  users:
    - name: rics
      gecos: rics
      groups:
        - sudo
      sudo:
        - ALL=(ALL) NOPASSWD:ALL
      home: /home/rics
      shell: /bin/bash
      lock_passwd: false
      ssh_authorized_keys:
        - ssh-rsa AAAA.....Keys.....
  EOF
}

data "template_file" "network_config" {
  count    = length(var.vm)
  template = <<EOF
  version: 2
  ethernets:
    ens3:
      dhcp4: true
  EOF
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count          = length(var.vm)
  name           = "commoninit-${count.index}.iso"
  user_data      = data.template_file.user_data[count.index].rendered
  network_config = data.template_file.network_config[count.index].rendered
  pool           = var.libvirt_disk_path
}

resource "libvirt_domain" "ubuntu" {
  count  = length(var.vm)
  name   = var.vm[count.index]
  memory = "1024"
  vcpu   = 1

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
    hostname       = var.vm[count.index]
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu20-qcow2[count.index].id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "web_server_ip" {
  value = libvirt_domain.ubuntu[1].network_interface[0].addresses[0]
}

output "db_server_ip" {
  value = libvirt_domain.ubuntu[0].network_interface[0].addresses[0]
}

 