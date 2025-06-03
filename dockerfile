# Dockerfile for Ubuntu 24.04 amb XFCE, VNC, VSCode, Python, i SSH
FROM ubuntu:24.04

# Variables d'entorn
ENV DEBIAN_FRONTEND=noninteractive

# Update i instal·lacions bàsiques
RUN apt-get update && apt-get install -y \
    apt-utils \
    software-properties-common \
    wget \
    curl \
    git \
    sudo \
    net-tools \
    iputils-ping \
    nano \
    openssh-server

# XFCE i VNC server
RUN apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    x11vnc \
    xvfb \
    xterm

# XFCE, VNC server, i dependencies
RUN apt-get update && apt-get install -y \
    dbus-x11 \
    libglx-mesa0 \
    mesa-utils \
    xdg-utils \
    x11-xserver-utils \
    x11-utils \
    xserver-xorg-core \
    xorgxrdp \
    xauth \
    xinit \
    x11-apps \
    dbus-x11
# Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get update && \
    apt-get install -y code

# Python i development tools
RUN apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential

#Actualització
RUN apt-get update && apt-get install -y \
    dbus-x11 \
    libgl1 \
    xdg-utils \
    x11-xserver-utils

RUN apt-get install -y dbus-x11

# Configurar SSH
RUN mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Neteja
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Afegeixo el startup script
COPY container-init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/container-init.sh

# Exposo els ports necessaris
EXPOSE 5901 22

# creo usuari developer
RUN useradd -m -s /bin/bash developer && \
    echo 'developer:developer' | chpasswd && \
    usermod -aG sudo developer

# faig servir l'usuari developer
USER developer
WORKDIR /home/developer

# VNC password
RUN mkdir -p ~/.vnc && \
    echo "password" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

# XFCE startup script
RUN echo '#!/bin/sh\nstartxfce4 &' > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Torno a l'usuari root per a l'entrypoint
USER root

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/container-init.sh"]