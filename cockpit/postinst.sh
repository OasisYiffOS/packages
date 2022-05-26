#!/bin/bash

useradd --system --home-dir /nonexistent --no-create-home cockpit-ws
useradd --system --home-dir /nonexistent --no-create-home cockpit-wsinstance

chown root:cockpit-wsinstance  /usr/lib/cockpit/cockpit-session
sudo chmod 4750 /usr/lib/cockpit/cockpit-session