#!/bin/bash

# Inicio SSH server
service ssh start

# Inicio D-Bus system daemon
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# Inicio VNC server amb l'usuari developer
su - developer -c "vncserver :1 -geometry 1280x800 -depth 24"

# Per mantenir el contenidor funcionant
tail -f /dev/null

if ! command -v dbus-launch &> /dev/null; then
    echo "Error: dbus-launch not found. Ensure dbus-x11 is installed." >&2
    exit 1
fi