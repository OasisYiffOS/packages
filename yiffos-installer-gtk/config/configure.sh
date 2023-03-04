#!/usr/bin/bash

# The script gets called with the following environment variables set:
# OSI_USER_NAME          : User's name. Not ASCII-fied
# OSI_USER_AUTOLOGIN     : Whether to autologin the user
# OSI_USER_PASSWORD      : User's password. Can be empty if autologin is set.
# OSI_FORMATS            : Locale of formats to be used
# OSI_TIMEZONE           : Timezone to be used
# OSI_ADDITIONAL_SOFTWARE: Space-separated list of additional packages to install

# sanity check that all variables were set
if [ -z ${OSI_LOCALE+x} ] || \
   [ -z ${OSI_DEVICE_PATH+x} ] || \
   [ -z ${OSI_DEVICE_IS_PARTITION+x} ] || \
   [ -z ${OSI_DEVICE_EFI_PARTITION+x} ] || \
   [ -z ${OSI_USE_ENCRYPTION+x} ] || \
   [ -z ${OSI_ENCRYPTION_PIN+x} ] || \
   [ -z ${OSI_USER_NAME+x} ] || \
   [ -z ${OSI_USER_AUTOLOGIN+x} ] || \
   [ -z ${OSI_USER_PASSWORD+x} ] || \
   [ -z ${OSI_FORMATS+x} ] || \
   [ -z ${OSI_TIMEZONE+x} ] || \
   [ -z ${OSI_ADDITIONAL_SOFTWARE+x} ]
then
    echo "Installer script called without all environment variables set!"
    exit 1
fi

# Set mount point
export R=/mnt/root

# Enable basic systemd services
while read i; do
	sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	systemctl enable $i
done < /etc/os-installer/bits/systemd.services

# Make GDM start gnome-initial-setup on first boot
sudo cp -v /etc/os-installer/bits/gdm/custom.conf $R/etc/gdm/custom.conf
sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	chown gdm:gdm /etc/gdm/custom.conf

# This will be changed by the GNOME setup
echo "LANG=en_US.UTF-8" | sudo tee $R/etc/locale.conf

# Set hostname
echo "yiffos" | sudo tee $R/etc/hostname

# Sync and unmount
sudo sync
sudo umount -R $R

exit 0