variable "headless" {
  type    = string
  default = "true"
}

variable "shutdown_command" {
  type    = string
  default = "sudo /sbin/halt -p"
}

variable "checksum" {
  type    = string
  default = "5fa0d2cbe8a757c5d6b00c21851bd6d01765a9764fc1ceca3446842d133f1652"
}

variable "version" {
  type    = string
  default = "2105"
}

variable "url" {
  type    = string
  default = "http://mirror.ufscar.br/centos/8-stream/isos/x86_64/CentOS-Stream-8-20230517.0-x86_64-dvd1.iso"
}

variable "builderip" {
  type    = string
  default = "192.168.15.7"
}

source "virtualbox-iso" "virtualbox" {
  boot_command           = ["<tab> text inst.ks=http://${var.builderip}:{{ .HTTPPort }}/ks.cfg<enter><wait>"]
  disk_size              = "40960"
  guest_additions_mode   = "attach"
  guest_additions_sha256 = "b81d283d9ef88a44e7ac8983422bead0823c825cbfe80417423bd12de91b8046"
  guest_os_type          = "RedHat_64"
  hard_drive_interface   = "sata"
  headless               = "${var.headless}"
  http_directory         = "http"
  iso_checksum           = "sha256:${var.checksum}"
  iso_url                = "${var.url}"
  shutdown_command       = "${var.shutdown_command}"
  ssh_password           = "proibm10"
  ssh_timeout            = "40m"
  ssh_username           = "rmontagnana"
  vboxmanage             = [[ "modifyvm", "{{ .Name }}", "--memory", "2048"], [ "modifyvm", "{{ .Name }}", "--nic1", "nat" ], [ "modifyvm", "{{ .Name }}", "--nic-type1", "82540EM" ], [ "modifyvm", "{{ .Name }}", "--bridge-adapter2", "Intel(R) Dual Band Wireless-AC 3165" ], [ "modifyvm", "{{ .Name }}", "--nic2", "bridged" ], [ "modifyvm", "{{ .Name }}", "--nic-type2", "82540EM" ], [ "modifyvm", "{{ .Name }}", "--cpus", "2" ], [ "modifyvm", "{{ .Name }}", "--nested-hw-virt", "on" ], [ "modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga" ], [ "modifyvm", "{{ .Name }}", "--vram", "16" ]]
}

build {
  sources = ["source.virtualbox-iso.virtualbox"]
  
  provisioner "file" {
    source = "/Program Files (x86)/vagrant_deploys/etc/id_rsa.pub"
    destination = "/tmp/authorized_keys"
  }

  provisioner "shell" {
    execute_command = "sudo {{ .Vars }} sh {{ .Path }}"
    scripts         = ["scripts/postInstall.sh"]
  }

  post-processor "vagrant" {
    keep_input_artifact = false
    provider_override   = "virtualbox"
  }
}