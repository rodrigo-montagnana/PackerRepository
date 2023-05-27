variable "headless" {
  type    = string
  default = "true"
}

variable "shutdown_command" {
  type    = string
  default = "sudo /sbin/halt -p"
}

variable "version" {
  type    = string
  default = "2105"
}

variable "url" {
  type    = string
  default = "http://mirror.ufscar.br/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230517.0-x86_64-dvd1.iso"
}

source "virtualbox-iso" "virtualbox" {
  boot_command           = ["<tab> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  disk_size              = "8000"
  guest_additions_path   = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_additions_sha256 = "b81d283d9ef88a44e7ac8983422bead0823c825cbfe80417423bd12de91b8046"
  guest_os_type          = "RedHat_64"
  hard_drive_interface   = "sata"
  headless               = "${var.headless}"
  http_directory         = "http"
  iso_url                = "${var.url}"
  shutdown_command       = "${var.shutdown_command}"
  ssh_password           = "proibm10"
  ssh_timeout            = "20m"
  ssh_username           = "rmontagnana"
  vboxmanage             = [[ "modifyvm", "{{ .Name }}", "--memory", "2024"], [ "modifyvm", "{{ .Name }}", "--cpus", "2" ]]
}

build {
  sources = ["source.virtualbox-iso.virtualbox", "source.vmware-iso.vmware"]

  provisioner "shell" {
    execute_command = "sudo {{ .Vars }} sh {{ .Path }}"
    scripts         = ["scripts/vagrant.sh", "scripts/update.sh", "scripts/vmtools.sh", "scripts/zerodisk.sh"]
  }
}