#!/bin/bash

groupadd -g 65 lightdm
useradd  -c "LightDM Daemon"    \
         -d /var/lib/lightdm    \
         -u 65 -g lightdm       \
         -s /bin/false lightdm