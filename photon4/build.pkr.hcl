build {
  sources = ["source.vmware-iso.vagrant-vmware-iso"]

  provisioner "shell" {
    script = "scripts/vagrant-provision.sh"
  }

  post-processors {
    post-processor "manifest" {
      output = "output/manifest.json"
      strip_path = false
    }

    post-processor "shell-local" {
      execute_command = ["bash", "-c", "{{.Vars}} {{.Script}}"]
      script = "scripts/prepare-vm.sh"
    }

    post-processor "vagrant" {
      keep_input_artifact  = true
      compression_level    = 9
      output               = "output/${var.product}${var.version}-${var.installation}.box"
      vagrantfile_template = "scripts/vagrantfile.tpl"
    }

    post-processor "vagrant-cloud" {
      keep_input_artifact  = true
      access_token         = "${var.cloud_token}"
      box_tag              = "${var.cloud_user}/${var.product}${var.version}-${var.installation}"
      version              = "${formatdate("YYYYMM.DD.0", timestamp())}"
    }
  }
}

