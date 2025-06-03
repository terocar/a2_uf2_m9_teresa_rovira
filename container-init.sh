#!/bin/bash

# Start essential services
service ssh start
dbus-daemon --system --fork

# VNC server startup
su - devuser -c "vncserver :1 -geometry 1280x720 -depth 24 -localhost no -SecurityTypes None -xstartup /home/devuser/.vnc/launch.sh"

# Keep container alive
tail -f /dev/null