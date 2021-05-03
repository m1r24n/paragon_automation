#!/bin/bash
VM=control
DISK=${VM}.img
BRIDGE=lan100
virt-install --name ${VM} \
    --disk ./${DISK},device=disk,bus=virtio \
    --ram 12288 --vcpu 2  \
    --os-type linux --os-variant generic \
    --network bridge=${BRIDGE},model=virtio \
    --console pty,target_type=serial \
    --noautoconsole \
    --vnc  \
    --hvm --accelerate \
    --virt-type=kvm  \
    --boot hd

for VM in node0 node1 node2 node3
do
    DISK=${VM}.img
    virt-install --name ${VM} \
        --disk ./${DISK},device=disk,bus=virtio \
        --ram 20480 --vcpu 8  \
        --os-type linux --os-variant generic \
        --network bridge=${BRIDGE},model=virtio \
        --console pty,target_type=serial \
        --noautoconsole \
        --vnc  \
        --hvm --accelerate \
        --virt-type=kvm  \
        --boot hd
done
