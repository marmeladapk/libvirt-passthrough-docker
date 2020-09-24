FROM ubuntu:20.04
# FROM jrei/systemd-ubuntu:20.04

RUN apt-get update && apt-get -y upgrade && \
    apt-get --no-install-recommends -y install \
        iproute2 \
        jq \
        python3 \
        qemu-system-x86 \
        udhcpd \
        virt-manager \
        libvirt-daemon-system libvirt-clients bridge-utils \
        ovmf \
        gir1.2-spiceclientgtk-3.0 \
        kmod \
        libegl1 libgl1-mesa-glx \
        dbus-x11 \
    && apt-get clean

RUN apt-get -y install less nano looking-glass-client dnsmasq-base && apt-get clean && rm -rf /var/lib/apt/lists/*
# libgl1-mesa-dri libegl-mesa0 alsa-utils apulse pulseaudio-utils

# https://bugzilla.redhat.com/show_bug.cgi?id=1774373#c7
# RUN echo "remember_owner=0" >> /etc/libvirt/qemu.conf

# https://www.redhat.com/archives/libvirt-users/2017-February/msg00078.html
# RUN echo "namespaces = []" >> /etc/libvirt/qemu.conf

# Modify group id to match host system
RUN groupmod -g 129 kvm

# https://aspiceodyssey.wordpress.com/2017/04/28/fedora25-3d-accelerated-guest/
RUN usermod -a -G video libvirt-qemu

# https://github.com/gdraheim/docker-systemctl-replacement
COPY systemctl.py /usr/bin/systemctl

#RUN systemctl enable libvirtd
#RUN systemctl enable virtlogd

#COPY domain_examples/ubuntu20.04.xml /run/ubuntu20.04.xml
#COPY domain_examples/Win10.xml /run/Win10.xml
#COPY domain_examples/Win10-gvtg.xml /run/Win10-gvtg.xml
#COPY domain_examples/Win10-gvtg-lg.xml /run/Win10-gvtg-lg.xml
COPY pulse-client.conf /etc/pulse/client.conf
COPY qemu /etc/libvirt/hooks/qemu
COPY default-network.xml /run/default-network.xml
COPY net-start.service /usr/lib/systemd/system/net-start.service
# Change default network to not clash with host libvirt default network
# Autostart does not work for some reason
RUN systemctl start libvirtd && virsh net-undefine default && virsh net-define /run/default-network.xml && virsh net-autostart default && rm /run/default-network.xml && systemctl stop libvirtd

# Enable local tcp socket
# RUN echo "listen_tcp = 1" >> /etc/libvirt/libvirtd.conf && echo "libvirtd_opts=\"-l\"" >> /etc/default/libvirtd

# Required for sound - https://github.com/TheBiggerGuy/docker-pulseaudio-example
ENV HOME /home/root

# Copy new looking glass client
COPY lg-build/LookingGlass/client/build/looking-glass-client /usr/bin/looking-glass-client

#COPY run.sh /run/run.sh
#ENTRYPOINT ["/run/run.sh"]
ENTRYPOINT ["/usr/bin/systemctl", "init", "libvirtd", "virtlogd", "net-start"]

