#!/bin/bash

# ----------------
# Upgrade packages
# ----------------
if [ -x /bin/rpm-ostree ]
then
  /bin/rpm-ostree update
  /bin/rpm-ostree status
else
  /bin/echo "Updating packages"
  /usr/bin/tdnf check-update --quiet
  /usr/bin/tdnf upgrade --assumeyes --quiet 
  /usr/bin/tdnf clean all --quiet
fi

# --------------------
# Tweak grub2 settings
# --------------------
if [ -x /bin/rpm-ostree ]
then
  # commands below will break ostree host
else
  /bin/sed -i 's/set gfxmode=.*/set gfxmode="1024x768"/' /boot/grub2/grub.cfg
  /bin/sed -i '/linux/ s/$/ net.ifnames=0/' /boot/grub2/grub.cfg
  /bin/echo 'GRUB_CMDLINE_LINUX=\"net.ifnames=0\"' >> /etc/default/grub
fi

# ----------------
# Add vagrant user
# ----------------
/bin/echo "Adding vagrant user"
HOME_DIR="/home/vagrant"

# Add vagrant group
/sbin/groupadd vagrant

# Set up a vagrant user and add the insecure key for User to login
if [ -x /bin/rpm-ostree ]
then
  /sbin/useradd -G vagrant -m -p '$1$vagrant$I4pvEJo5vdKqeokP0vb9t/' vagrant
else
  /sbin/useradd -G vagrant,docker -m -p '$1$vagrant$I4pvEJo5vdKqeokP0vb9t/' vagrant
fi

# Avoid password expiration (https://github.com/vmware/photon-packer-templates/issues/2)
/bin/chage -I -1 -m 0 -M 99999 -E -1 vagrant

# Configure a sudoers for the vagrant user
/bin/echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant

# Set up insecure vagrant ssh key
/bin/mkdir -m 700 -p ${HOME_DIR}/.ssh
/bin/echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ${HOME_DIR}/.ssh/authorized_keys
/bin/chmod 600 ${HOME_DIR}/.ssh/authorized_keys
/bin/chown -R vagrant:vagrant ${HOME_DIR}/.ssh

# --------------------------
# Basic vagrant box security
# --------------------------
/bin/echo "Adjusting SSH security"

# Restore login only through unprivileged users
/bin/sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config

# Disable Password Authentication
/bin/sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
/bin/sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# ---------------------
# Tweak console message
# ---------------------
/bin/echo "Adding console information"
DATE=$(/bin/date -I)
/bin/cat <<EOT >> /etc/issue

    Build date: ${DATE}

  IPv4 Address: \4
  IPv6 Address: \6

   Credentials: vagrant / vagrant
                   root / vagrant

EOT

# --------------------------
# Zero out disk space
# --------------------------
/bin/echo "Zeroing storage"
/bin/dd if=/dev/zero of=/var/EMPTY bs=1M 2>/dev/null
/bin/sync ; /bin/sleep 5; /bin/sync
/bin/rm -f /var/EMPTY

