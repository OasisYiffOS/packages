#! /bin/bash

glib-compile-schemas /usr/share/glib-2.0/schemas

# Make a user and group to run GDM
groupadd -g 21 gdm
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm
passwd -ql gdm