# VMware Photon 4.0 Packer Template

## Description

This repository is used to build Vagrant boxes for the [VMware's Photon OS](https://github.com/vmware/photon). It uses the new templating language (HCL2) for [HashiCorp's Packer](http://packer.io).

The official [VMware Packer template repository](https://github.com/vmware/photon-packer-templates) is out of date. It doesn't support Photon 4.0 or its multiple variants (minimal, developer, ostree host, and real time) or provide adequate security.

## Prerequisites

* VMware Fusion or Workstation
* [Packer](http://packer.io) >= 1.7.0

## Providers

Currently, only the [VMware (vmware-iso)](https://www.packer.io/docs/builders/vmware-iso.html) builder is supported, as it meets my requirements.

## Usage

Use the included `Makefile` targets to perform various Packer tasks. There are three top-level targets:

* validate
* build
* publish

**publish** - `VAGRANT_CLOUD_TOKEN` and `VAGRANT_CLOUD_USER` environmental variables must be set.

There are additional targets for each specific installation. Run `make help` to see all available targets:

```shell
» make help
Targets:
  validate
   
  build
    build-developer
    build-minimal
    build-ostree
    build-rt

  publish
    publish-developer
    publish-minimal
    publish-ostree
    publish-rt

  clean
```

#### Photon Base ISO

Photon OS 4.0 GA Full ISO is used for all builds. The `iso_url` and `iso_sha1` are defined in the file variables.pkr.hcl.

### Configuration

The `variables.pkf.hcl` file contains all variable definitions and defaults.

The `override.pkrvars.hcl` file should be used to override the defaults.

#### Vagrant Cloud Publishing

To publish to your own Vagrant Cloud account, call `publish[-*]` targets with the following environment variables set:

```shell
VAGRANT_CLOUD_TOKEN="<your client token>"
VAGRANT_CLOUD_USER="<your account>"
```

The box name (`photon4-<installation>`) and version (`YYYYMM.DD.0`) will be generated automatically.
