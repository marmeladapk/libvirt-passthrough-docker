#!/bin/bash

trap "virsh net-destroy default && systemctl stop libvirtd" exit

systemctl start libvirtd
systemctl start virtlogd

# virt-install --name A --memory 1024 --pxe --disk none --cpu host-passthrough,cache.mode=passthrough --vcpus 2
#virsh define --file /run/ubuntu20.04.xml
#virsh define --file /run/Win10.xml
#virsh define --file /run/Win10-gvtg.xml
#virsh define --file /run/Win10-gvtg-lg.xml

virsh net-start default

# virt-manager
/bin/bash
