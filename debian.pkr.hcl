variable "user_fullname" {
  default = "Mr Packer"
}

variable "user_username" {
  default = "packer"
}

variable "user_password" {
  default = "password"
}

variable "root_password" {
  default = "password"
}

source "qemu" "debian" {
  iso_url          = "./debian-12.1.0-amd64-netinst.iso"
  iso_checksum     = "9da6ae5b63a72161d0fd4480d0f090b250c4f6bf421474e4776e82eea5cb3143bf8936bf43244e438e74d581797fe87c7193bbefff19414e33932fe787b1400f"
  output_directory = "output_debian"
  shutdown_command = "echo '${var.root_password}' | sudo -S shutdown -h now"
  disk_size        = "5000M"
  format           = "qcow2"
  ssh_username     = var.user_username
  ssh_password     = var.user_password
  ssh_timeout      = "30m"
  vm_name          = "debian"
  boot_wait        = "10s"
  headless         = "true"
  cpus             = "1"
  memory           = "1024"
  vnc_port_min     = 5916
  vnc_port_max     = 5916

  http_content = {
    "/debian.preseed" = templatefile("debian.preseed", { var = var })
  }

  boot_command = [
    "<wait><wait><wait><esc><wait><wait><wait>",
    "/install.amd/vmlinuz ",
    "initrd=/install.amd/initrd.gz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/debian.preseed ",
    "interface=auto ",
    "hostname=debian ",
    "domain=local ",
    "vga=788 noprompt quiet --<enter>"
  ]
}

build {
  sources = ["source.qemu.debian"]
}