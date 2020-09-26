#!/bin/bash

uid=`id -u`

# https://medium.com/@SaravSun/running-gui-applications-inside-docker-containers-83d65c0db110
# http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/
# docker build -t libvirt-docker:latest .

sudo apparmor_parser -r -W ./aa_profile

docker run -d --rm \
     --stop-timeout 100 \
     --name libvirtd \
     --privileged \
     --security-opt apparmor=docker-unconfined \
     --env="DISPLAY" \
     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
     -v /dev:/dev \
     --net=host \
     -v /run/udev:/run/udev:shared \
     -v /dev/bus/usb:/dev/bus/usb:rw,shared \
     -v `pwd`/xubuntu-20.04.1-desktop-amd64.iso:/run/xubuntu-20.04.1-desktop-amd64.iso:ro \
     -v /dev/dri:/dev/dri:rw \
     -v /run/user/${uid}/pulse:/run/user/0/pulse \
     -v ~/.config/pulse/cookie:/home/root/.config/pulse/cookie:ro \
     -v libvirt-conf:/etc/libvirt \
     -v libvirt-dbus:/home/root/.config/dconf \
     -v libvirt-var:/var/lib/libvirt \
     libvirt-docker:latest

# Remove AppArmor profile when container stops, non-blocking
(docker container wait libvirtd && sudo apparmor_parser -R ./aa_profile) &

