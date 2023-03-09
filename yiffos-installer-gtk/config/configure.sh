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

# Generate users
sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	systemd-sysusers

# Make GDM start gnome-initial-setup on first boot
#sudo cp -v /etc/os-installer/bits/gdm/custom.conf $R/etc/gdm/custom.conf
#sudo chroot "/mnt/root" /usr/bin/env -i	\
#	HOME=/root                  	\
#	TERM="$TERM"                	\
#	PS1='(yiffOS chroot) \u:\w\$ ' 	\
#	PATH=/usr/bin:/usr/sbin     	\
#	chown gdm:gdm /etc/gdm/custom.conf

# This will be changed by the GNOME setup
echo "LANG=en_US.UTF-8" | sudo tee $R/etc/locale.conf

# Set hostname
echo "yiffOS" | sudo tee $R/etc/hostname

# Run GNOME postinsts
echo "#!/bin/bash" 							| sudo tee -a $R/gnomepostinst.sh
echo "useradd -mG wheel ${OSI_USER_NAME}"				| sudo tee -a $R/gnomepostinst.sh
echo "echo ${OSI_USER_NAME}:${OSI_USER_PASSWORD} | chpasswd" 		| sudo tee -a $R/gnomepostinst.sh
echo "glib-compile-schemas /usr/share/glib-2.0/schemas" 		| sudo tee -a $R/gnomepostinst.sh
echo "update-mime-database /usr/share/mime/" 				| sudo tee -a $R/gnomepostinst.sh
echo "gtk-query-immodules-3.0 --update-cache" 				| sudo tee -a $R/gnomepostinst.sh
echo "gdk-pixbuf-query-loaders --update-cache" 				| sudo tee -a $R/gnomepostinst.sh
echo "for f in /usr/share/icons/**/; do" 				| sudo tee -a $R/gnomepostinst.sh
echo "gtk4-update-icon-cache -t -f \$f" 				| sudo tee -a $R/gnomepostinst.sh
echo "gtk-update-icon-cache -t -f \$f" 					| sudo tee -a $R/gnomepostinst.sh
echo "done" 								| sudo tee -a $R/gnomepostinst.sh

sudo chmod +x $R/gnomepostinst.sh

sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	/gnomepostinst.sh

sudo rm $R/gnomepostinst.sh

# Fix up /var/run
sudo cp -r $R/var/run/* $R/run
sudo rm -r $R/var/run
sudo ln -s /run $R/var/run

# Sync and unmount
sudo sync
sudo umount -R $R

exit 0
