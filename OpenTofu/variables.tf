variable "libvirt_disk_path" {
  description = "Path for libvirt pool"
  default     = "default"
}

variable "ubuntu_image" {
  description = "ubuntu 20.04 images"
  default     = "https://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
}

variable "vm" {
  description = "List of VM"
  default     = ["mesin-1", "mesin-2"]
}