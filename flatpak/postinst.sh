#! /bin/bash
groupadd flatpak
useradd -c "Flatpak user" \
        -g flatpak -s /bin/false flatpak