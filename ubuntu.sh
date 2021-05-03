#!/bin/bash
VM=ubuntu
DISK=${VM}.img
CDROM=seed.iso
virt-install --name ${VM} \
    --disk ./${DISK},device=disk,bus=virtio \
    --disk ${CDROM},device=cdrom \
    --ram 2048 --vcpu 1  \
    --os-type linux --os-variant generic \
    --network bridge=lan1,model=virtio \
    --console pty,target_type=serial \
    --noautoconsole \
    --vnc  \
    --hvm --accelerate \
    --virt-type=kvm  \
    --boot hd
