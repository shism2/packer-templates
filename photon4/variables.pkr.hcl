variable "cloud_token" {
  type = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "cloud_user" {
  type = string
  default = "${env("VAGRANT_CLOUD_USER")}"
}

variable "installation" {
  type = string
  default="minimal"
}

variable "iso_sha1" {
  type = string
  default="sha1:2221ab214b517a15c60bd5e2aacdb9388581bcd9"
}

variable "iso_url" {
  type = string
  default="https://packages.vmware.com/photon/4.0/GA/iso/photon-4.0-1526e30ba.iso"
}

variable "memory" {
  type = string
  default="2048"
}

variable "product" {
  type = string
  default="photon"
}

variable "storage" {
  type = string
  default="20480"
}

variable "vcpu" {
  type = string
  default="2"
}

variable "version" {
  type = string
  default="4"
}

variable "vm_version" {
  type = string
  default="15"
}

