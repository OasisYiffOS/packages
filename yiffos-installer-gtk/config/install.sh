#!/usr/bin/bash

# The script gets called with the following environment variables set:
# OSI_LOCALE              : Locale to be used in the new system
# OSI_DEVICE_PATH         : Device path at which to install
# OSI_DEVICE_IS_PARTITION : 1 if the specified device is a partition (0 -> disk)
# OSI_DEVICE_EFI_PARTITION: Set if device is partition and system uses EFI boot.
# OSI_USE_ENCRYPTION      : 1 if the installation is to be encrypted
# OSI_ENCRYPTION_PIN      : The encryption pin to use (if encryption is set)

# sanity check that all variables were set
if [ -z ${OSI_LOCALE+x} ] || \
   [ -z ${OSI_DEVICE_PATH+x} ] || \
   [ -z ${OSI_DEVICE_IS_PARTITION+x} ] || \
   [ -z ${OSI_DEVICE_EFI_PARTITION+x} ] || \
   [ -z ${OSI_USE_ENCRYPTION+x} ] || \
   [ -z ${OSI_ENCRYPTION_PIN+x} ]
then
    echo "Installer script called without all environment variables set!"
    exit 1
fi

# Partition the disk
# Load the partitioning scheme from part.sfdisk
sudo sfdisk ${OSI_DEVICE_PATH} < /etc/os-installer/bits/part.sfdisk

# Check if NVMe or not
if [[ "${OSI_DEVICE_PATH}" == *"nvme"*"n"* ]];
then
	IS_NVME="p"
else
	IS_NVME=""
fi

# Create filesystems on the target disk
sudo mkfs.fat -F32 "${OSI_DEVICE_PATH}${IS_NVME}1"
sudo mkfs.btrfs -f -L yiffos "${OSI_DEVICE_PATH}${IS_NVME}2"

# Set mount point
export R=/mnt/root

# Mount partitions to /mnt
sudo mkdir -p $R
sudo mount "${OSI_DEVICE_PATH}${IS_NVME}2" $R
sudo mkdir -p $R/boot/efi
sudo mount "${OSI_DEVICE_PATH}${IS_NVME}1" $R/boot/efi

sudo mkdir -pv $R/{etc,var}
sudo mkdir -pv $R/usr/{bin,lib,sbin}
for i in bin lib sbin; do
	sudo ln -sv usr/$i $R/$i
done
case $(uname -m) in
	x86_64) sudo mkdir -pv $R/lib64 ;;
esac

sudo mkdir -pv $R/{dev,proc,sys,run}
sudo mount -v --bind /dev $R/dev
sudo mount -vt proc proc $R/proc
sudo mount -vt sysfs sysfs $R/sys

sudo mkdir -pv $R/{boot,home,mnt,opt,srv}
sudo mkdir -pv $R/etc/{opt,sysconfig}
sudo mkdir -pv $R/lib/firmware
sudo mkdir -pv $R/media/{floppy,cdrom}
sudo mkdir -pv $R/usr/{,local/}{include,src}
sudo mkdir -pv $R/usr/local/{bin,lib,sbin}
sudo mkdir -pv $R/usr/{,local/}share/{color,dict,doc,info,locale,man}
sudo mkdir -pv $R/usr/{,local/}share/{misc,terminfo,zoneinfo}
sudo mkdir -pv $R/usr/{,local/}share/man/man{1..8}
sudo mkdir -pv $R/var/{cache,local,log,mail,opt,spool}
sudo mkdir -pv $R/var/lib/{color,misc,locate}

sudo install -dv -m 0750 $R/root
sudo install -dv -m 1777 $R/tmp $R/var/tmp

echo "root:x:0:0:root:/root:/bin/bash" 						| sudo tee -a $R/etc/passwd
echo "bin:x:1:1:bin:/dev/null:/usr/bin/false" 					| sudo tee -a $R/etc/passwd
echo "daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false" 			| sudo tee -a $R/etc/passwd
echo "messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false" | sudo tee -a $R/etc/passwd
echo "systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false" 		| sudo tee -a $R/etc/passwd
echo "systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false" 		| sudo tee -a $R/etc/passwd
echo "uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false"	| sudo tee -a $R/etc/passwd
echo "systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false" 	| sudo tee -a $R/etc/passwd
echo "nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false" 		| sudo tee -a $R/etc/passwd

echo "root:x:0:" | sudo tee -a $R/etc/group
echo "bin:x:1:daemon" | sudo tee -a $R/etc/group
echo "sys:x:2:" | sudo tee -a $R/etc/group
echo "kmem:x:3:" | sudo tee -a $R/etc/group
echo "tape:x:4:" | sudo tee -a $R/etc/group
echo "tty:x:5:" | sudo tee -a $R/etc/group
echo "daemon:x:6:" | sudo tee -a $R/etc/group
echo "floppy:x:7:" | sudo tee -a $R/etc/group
echo "disk:x:8:" | sudo tee -a $R/etc/group
echo "lp:x:9:" | sudo tee -a $R/etc/group
echo "dialout:x:10:" | sudo tee -a $R/etc/group
echo "audio:x:11:" | sudo tee -a $R/etc/group
echo "video:x:12:" | sudo tee -a $R/etc/group
echo "utmp:x:13:" | sudo tee -a $R/etc/group
echo "usb:x:14:" | sudo tee -a $R/etc/group
echo "cdrom:x:15:" | sudo tee -a $R/etc/group
echo "adm:x:16:" | sudo tee -a $R/etc/group
echo "messagebus:x:18:" | sudo tee -a $R/etc/group
echo "systemd-journal:x:23:" | sudo tee -a $R/etc/group
echo "input:x:24:" | sudo tee -a $R/etc/group
echo "mail:x:34:" | sudo tee -a $R/etc/group
echo "kvm:x:61:" | sudo tee -a $R/etc/group
echo "systemd-journal-gateway:x:73:" | sudo tee -a $R/etc/group
echo "systemd-journal-remote:x:74:" | sudo tee -a $R/etc/group
echo "systemd-journal-upload:x:75:" | sudo tee -a $R/etc/group
echo "systemd-network:x:76:" | sudo tee -a $R/etc/group
echo "systemd-resolve:x:77:" | sudo tee -a $R/etc/group
echo "systemd-timesync:x:78:" | sudo tee -a $R/etc/group
echo "systemd-coredump:x:79:" | sudo tee -a $R/etc/group
echo "uuidd:x:80:" | sudo tee -a $R/etc/group
echo "systemd-oom:x:81:" | sudo tee -a $R/etc/group
echo "wheel:x:97:" | sudo tee -a $R/etc/group
echo "nogroup:x:99:" | sudo tee -a $R/etc/group
echo "users:x:999:" | sudo tee -a $R/etc/group

echo "/bin/bash" | sudo tee -a $R/etc/shells

sudo touch $R/var/log/{btmp,lastlog,faillog,wtmp}
sudo chgrp -v utmp $R/var/log/lastlog
sudo chmod -v 664  $R/var/log/lastlog
sudo chmod -v 600  $R/var/log/btmp

sudo umount -l $R/proc
sudo rm -rf $R/proc/self

export INSTALL_ROOT=$R

yes |  sudo env INSTALL_ROOT=$R bulge setup
yes |  sudo env INSTALL_ROOT=$R bulge gi base
yes |  sudo env INSTALL_ROOT=$R bulge i gnutls libxcrypt libgcrypt grub2 btrfs-progs grep
yes |  sudo env INSTALL_ROOT=$R bulge i networkmanager
yes |  sudo env INSTALL_ROOT=$R bulge i bulge

yes |  sudo env INSTALL_ROOT=$R bulge i linux-firmware vim nano e2fsprogs gcr sudo xf86-input-libinput make-ca accountsservice

yes |  sudo env INSTALL_ROOT=$R bulge gi gnome

yes |  sudo env INSTALL_ROOT=$R bulge i gnome-backgrounds


sudo mount -vt tmpfs tmpfs $R/run
sudo ln -s /run $R/var/run
sudo ln -s /run/lock $R/var/lock

sudo mount -vt proc proc $R/proc

sudo grub-install --target=x86_64-efi --efi-directory=$R/boot/efi --boot-directory=$R/boot --bootloader-id=yiffOS

case $(uname -m) in
    i?86)   sudo ln -sfv ld-linux.so.2 $R/lib/ld-lsb.so.3
    ;;
    x86_64) sudo ln -sfv ../lib/ld-linux-x86-64.so.2 $R/lib64
            sudo ln -sfv ../lib/ld-linux-x86-64.so.2 $R/lib64/ld-lsb-x86-64.so.3
    ;;
esac

sudo genfstab -U $R | sudo tee $R/etc/fstab

echo '#!/bin/bash' | sudo tee -a $R/root/yiffosP2
echo 'ln -s /usr/bin/bash /usr/bin/sh' | sudo tee -a $R/root/yiffosP2
echo 'ln -s /run/dbus/ /var/run/dbus' | sudo tee -a $R/root/yiffosP2
echo 'systemd-machine-id-setup' | sudo tee -a $R/root/yiffosP2
echo 'systemctl preset-all' | sudo tee -a $R/root/yiffosP2
echo 'systemctl disable systemd-time-wait-sync.service' | sudo tee -a $R/root/yiffosP2
KVER=$( INSTALL_ROOT=$R bulge list | grep -e "^linux " | grep -oP "[\d\.]+-")
echo "dracut --kver ${KVER}yiffOS --force" | sudo tee -a $R/root/yiffosP2
echo 'grub-mkconfig -o /boot/grub/grub.cfg' | sudo tee -a $R/root/yiffosP2
echo 'pwconv' | sudo tee -a $R/root/yiffosP2
echo 'grpconv' | sudo tee -a $R/root/yiffosP2

sudo chmod +x $R/root/yiffosP2

sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	/root/yiffosP2

exit 0
