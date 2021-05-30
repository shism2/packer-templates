source "vmware-iso" "vagrant-vmware-iso" {
  headless          = false
  boot_wait         = "5s"
  boot_command      = ["<tab><wait> ",
                       "insecure_installation=1 ",
                       "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart-${var.installation}.json ",
                       "<enter>"]
  guest_os_type     = "vmware-photon-64"

  iso_checksum      = "${var.iso_sha1}"
  iso_url           = "${var.iso_url}"

  display_name      = "${title(var.product)} OS ${var.version} (${var.installation})"
  vm_name           = "${var.product}${var.version}"
  vmdk_name         = "${var.product}${var.version}-disk1"

  cpus              = var.vcpu
  memory            = var.memory
  disk_size         = var.storage
  disk_type_id      = 0

  ssh_username      = "root"
  ssh_password      = "vagrant"
  ssh_wait_timeout  = "10m"
  version           = "${var.vm_version}"

  network              = "nat"
  network_adapter_type = "vmxnet3"

  http_directory   = "scripts"
  output_directory = "output/${var.product}${var.version}-${var.installation}.vmwarevm"

  shutdown_command  = "shutdown -h now"

  vmx_data_post = {
    "chipset.useAcpiBattery" = "TRUE",
    "chipset.useApmBattery"  = "TRUE",
    "ulm.disableMitigations" = "TRUE",
    "usb.present"            = "FALSE",
    "annotation"             = "Build Date: ${formatdate("YYYY-MM-DD", timestamp())}"
  }
}

