#!/bin/bash

vdiskmanager="/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager"

if [ -f output/manifest.json ]
then
  # path to vmx file
  VMX=$(jq -r '.builds[-1].files[].name' output/manifest.json | grep 'vmx$')
  echo "VMX (${VMX})"

  DEVICE=$(grep "cdrom-raw" ${VMX} | cut -d. -f 1)
  echo "Removing CDROM (${DEVICE}) and Ethernet devices"
  /usr/bin/sed -e "/^${DEVICE}/d" -e "/^ethernet0\./d" $VMX > "${VMX}.new"
  /bin/mv "${VMX}.new" "${VMX}"

  # vmdk files
  VMDKS=$(jq -r '.builds[-1].files[].name' output/manifest.json | egrep 'vmdk$' | egrep -v "\-s[0-9][0-9]")
  echo "VMDKS ($VMDKS)"
  for vmdk in $VMDKS
  do
    # ------------------------
    # Defragment Virtual Disks
    # ------------------------
    echo "Defragmenting disk (${vmdk})"
    "${vdiskmanager}" -d ${vmdk}

    # --------------------
    # Shrink Virtual Disks
    # --------------------
    echo "Shrinking disk (${vmdk})"
    "${vdiskmanager}" -k ${vmdk}
  done
else
  echo "Missing manifest file."
fi

if [ -d $PACKER_CACHE_DIR/port ]
then
  rm -rf $PACKER_CACHE_DIR/port
fi

