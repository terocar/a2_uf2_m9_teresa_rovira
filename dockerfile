# Dev Environment: Ubuntu 24.04 with XFCE, VNC, VSCode, Python & SSH
FROM ubuntu:24.04

# Set noninteractive mode
ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PASS=devpass \
    USER=devuser

# Base system setup
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    sudo \
    net-tools \
    iputils-ping \
    nano \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

# XFCE Desktop and VNC
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-taskmanager \
    tightvncserver \
    x11vnc \
    xvfb \
    xterm \
    dbus-x11 \
    libgl1-mesa-glx \
    x11-apps \
    && apt-get clean

# Install VSCode (method changed)
RUN wget -qO vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" \
    && apt-get install -y ./vscode.deb \
    && rm vscode.deb

# Python toolchain
RUN apt-get update && apt-get install -y \
    python3-full \
    python3-pip \
    python3-venv \
    build-essential \
    && python3 -m pip install --upgrade pip

# SSH Configuration
RUN mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create non-root user
RUN useradd -m -s /bin/bash $USER \
    && echo "$USER:devpass" | chpasswd \
    && usermod -aG sudo $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Container setup script
COPY container-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/container-init.sh

# VNC setup
USER $USER
WORKDIR /home/$USER
RUN mkdir -p .vnc \
    && echo "$VNC_PASS" | vncpasswd -f > .vnc/secret \
    && chmod 600 .vnc/secret \
    && echo '#!/bin/sh\nunset SESSION_MANAGER\nstartxfce4 &' > .vnc/launch.sh \
    && chmod +x .vnc/launch.sh

EXPOSE 5901 22
USER root
ENTRYPOINT ["/usr/local/bin/container-init.sh"]