#!/usr/bin/bash

# Ensure CA certs exists
sudo /usr/sbin/make-ca -gfx

# Sync repos before starting install
sudo bulge s

exit 0