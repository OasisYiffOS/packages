#!/usr/bin/env bash
cat > /lib/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660"
EOF

chgrp kvm /usr/libexec/qemu-bridge-helper
chmod 4750 /usr/libexec/qemu-bridge-helper
ln -sv qemu-system-`uname -m` /usr/bin/qemu
