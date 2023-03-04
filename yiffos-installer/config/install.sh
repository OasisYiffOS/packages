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
sudo mkfs.btrfs -f -L yiffos "${OSI_DEVICE_PATH}${IS_NVME}3"

# Set mount point
export R=/mnt/root

# Mount partitions to /mnt
sudo mount -o compress=zstd "${OSI_DEVICE_PATH}${IS_NVME}3" $R
sudo mount --mkdir "${OSI_DEVICE_PATH}${IS_NVME}1" $R/boot/efi

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

sudo echo "root:x:0:0:root:/root:/bin/bash" > $R/etc/passwd
sudo echo "bin:x:1:1:bin:/dev/null:/usr/bin/false" >> $R/etc/passwd
sudo echo "daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false" >> $R/etc/passwd
sudo echo "messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false" >> $R/etc/passwd
sudo echo "systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false" >> $R/etc/passwd
sudo echo "nobody:x:99:99:Unprivileged User:/dev/null:/usr/bin/false" >> $R/etc/passwd

sudo echo "root:x:0:" > $R/etc/group
sudo echo "bin:x:1:daemon" >> $R/etc/group
sudo echo "sys:x:2:" >> $R/etc/group
sudo echo "kmem:x:3:" >> $R/etc/group
sudo echo "tape:x:4:" >> $R/etc/group
sudo echo "tty:x:5:" >> $R/etc/group
sudo echo "daemon:x:6:" >> $R/etc/group
sudo echo "floppy:x:7:" >> $R/etc/group
sudo echo "disk:x:8:" >> $R/etc/group
sudo echo "lp:x:9:" >> $R/etc/group
sudo echo "dialout:x:10:" >> $R/etc/group
sudo echo "audio:x:11:" >> $R/etc/group
sudo echo "video:x:12:" >> $R/etc/group
sudo echo "utmp:x:13:" >> $R/etc/group
sudo echo "usb:x:14:" >> $R/etc/group
sudo echo "cdrom:x:15:" >> $R/etc/group
sudo echo "adm:x:16:" >> $R/etc/group
sudo echo "messagebus:x:18:" >> $R/etc/group
sudo echo "systemd-journal:x:23:" >> $R/etc/group
sudo echo "input:x:24:" >> $R/etc/group
sudo echo "mail:x:34:" >> $R/etc/group
sudo echo "kvm:x:61:" >> $R/etc/group
sudo echo "systemd-journal-gateway:x:73:" >> $R/etc/group
sudo echo "systemd-journal-remote:x:74:" >> $R/etc/group
sudo echo "systemd-journal-upload:x:75:" >> $R/etc/group
sudo echo "systemd-network:x:76:" >> $R/etc/group
sudo echo "systemd-resolve:x:77:" >> $R/etc/group
sudo echo "systemd-timesync:x:78:" >> $R/etc/group
sudo echo "systemd-coredump:x:79:" >> $R/etc/group
sudo echo "uuidd:x:80:" >> $R/etc/group
sudo echo "systemd-oom:x:81:" >> $R/etc/group
sudo echo "wheel:x:97:" >> $R/etc/group
sudo echo "nogroup:x:99:" >> $R/etc/group
sudo echo "users:x:999:" >> $R/etc/group

sudo echo "/bin/bash" > $R/etc/shells

sudo touch $R/var/log/{btmp,lastlog,faillog,wtmp}
sudo chgrp -v utmp $R/var/log/lastlog
sudo chmod -v 664  $R/var/log/lastlog
sudo chmod -v 600  $R/var/log/btmp

umount -l $R/proc
rm -rf $R/proc/self

export INSTALL_ROOT=$R
yes | bulge setup
yes | bulge gi base
yes | bulge i gnutls libxcrypt libgcrypt grub2 btrfs-progs grep
yes | bulge i networkmanager
yes | bulge i bulge

yes | bulge i vim nano

yes | bulge gi gnome

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

sudo genfstab -U $R > $R/etc/fstab

# Do we need this?
sudo cp /usr/sbin/chroot $R/usr/sbin/chroot

echo '#!/bin/bash' > $R/root/yiffosP2
echo 'ln -s /usr/bin/bash /usr/bin/sh' >> $R/root/yiffosP2
echo 'ln -s /run/dbus/ /var/run/dbus' >> $R/root/yiffosP2
echo 'systemd-machine-id-setup' >> $R/root/yiffosP2
echo 'systemctl preset-all' >> $R/root/yiffosP2
echo 'systemctl disable systemd-time-wait-sync.service' >> $R/root/yiffosP2
KVER=$(bulge list | grep -e "^linux " | grep -oP "[\d\.]+-")
echo "dracut --kver ${KVER}yiffOS --force" >> $R/root/yiffosP2
echo 'grub-mkconfig -o /boot/grub/grub.cfg' >> $R/root/yiffosP2
echo 'pwconv' >> $R/root/yiffosP2
echo 'grpconv' >> $R/root/yiffosP2
chmod +x $R/root/yiffosP2

sudo chroot "/mnt/root" /usr/bin/env -i	\
	HOME=/root                  	\
	TERM="$TERM"                	\
	PS1='(yiffOS chroot) \u:\w\$ ' 	\
	PATH=/usr/bin:/usr/sbin     	\
	/bin/bash /root/yiffosP2

exit 0