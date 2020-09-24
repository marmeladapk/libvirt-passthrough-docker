# Libvirt & virt-manager in a container

I got annoyed that my version of Ubuntu doesn't support Intel GVT-g, so I used Docker to solve this in an overkill way.

Unfortunately this solution is not super-portable. My host system already has libvirt and qemu-kvm installed, so that some devices and groups are present. One thing that is dependent on host system is group id number of kvm group. This could also be less secure than libvirt running on host as I don't know if AppArmor policies are applied inside the container. Anyway, container has almost full access to your host. It would probably make more sense to package libvirt, virt-manager and qemu as snaps or flatpaks.

This should, hopefully, be easy to upgrade to newer versions of Ubuntu.

### Building
- Prepare your host (and VMs)
    - install libvirt and qemu-kvm - that's my host configuration
    - [Check out ArchLinux wiki for GVT-g](https://wiki.archlinux.org/index.php/Intel_GVT-g)
    - [Check out Looking Glass guide](https://looking-glass.hostfission.com/wiki/Installation)
- Run `cat /etc/group | grep kvm` to find out your kvm group id and change it in the main Dockerfile
- Run looking glass build (lg-build folder) for new-ish Looking Glass - if you don't plan to use it comment it from main Dockerfile

### Features

Features are dependent on host system so your mileage may vary.

- Intel GVT-g (mediated passthrough of Intel integrated GPU)
- Looking glass (disable multisampling if you get egl errors) + GVT-g
- USB device passthrough with device list updating when attaching/detaching devices
- PCI passthrough
- Working virt-manager GUI and sound inside the container
- State preservation via volumes (didn't check if it works with filesystems created for VMs so be careful with your data)

### TODO

- spice blocks keyboard when mouse left vm screen e.g. over a dock (mouse on dock doesn't unlock, mouse over virt-manager window unlocks)
- spice filesharing doesn't work (possibly because container messes up paths)
- connect to libvirt with virt manager from outside of the container - it will probably need local ssh, socket doesn't work for some reason - this could eliminate the need for virt-manager and other graphical packages inside the container
- sound on looking glass
- graceful shutdown of container with running vm
- GVT-d - full passthrough of Intel iGPU
- GPU passthrough (Nvidia)
