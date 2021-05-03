#!/bin/bash
sudo mkdir /media/nbd
# the ip address start from 10.1.100.109
BASE=109
GW=10.1.100.1
NTP=10.1.100.1
DNS=10.1.100.1
for i in control node0 node1 node2 node3
do
    echo "changing configuration for disk image ${i}"
    IP="10.1.100.${BASE}/24"
    BASE=`expr ${BASE} + 1`
    sudo modprobe nbd
    sudo qemu-nbd --connect /dev/nbd0 ./${i}.img
    sleep 1
    sudo mount /dev/nbd0p1 /media/nbd
    echo ${i} | sudo tee /media/nbd/etc/hostname
    echo "10.1.100.109  control" | sudo tee -a /media/nbd/etc/hosts
    echo "10.1.100.110  node0" | sudo tee -a /media/nbd/etc/hosts
    echo "10.1.100.111  node1" | sudo tee -a /media/nbd/etc/hosts
    echo "10.1.100.112  node2" | sudo tee -a /media/nbd/etc/hosts
    echo "10.1.100.113  node3" | sudo tee -a /media/nbd/etc/hosts
    sudo sed -i -e "s/dhcp4: true/dhcp4: false/g" /media/nbd/etc/netplan/50-cloud-init.yaml
    sudo sed -i -e "/match:/d" /media/nbd/etc/netplan/50-cloud-init.yaml
     sudo sed -i -e "/set-name/d" /media/nbd/etc/netplan/50-cloud-init.yaml
    sudo sed -i -e "/macaddress/d" /media/nbd/etc/netplan/50-cloud-init.yaml
    sudo sed -i -e "/version/d" /media/nbd/etc/netplan/50-cloud-init.yaml
    echo "            addresses: [ ${IP} ]" | sudo tee -a /media/nbd/etc/netplan/50-cloud-init.yaml
    echo "            gateway4: ${GW}" | sudo tee -a /media/nbd/etc/netplan/50-cloud-init.yaml
    echo "            nameservers:" | sudo tee -a /media/nbd/etc/netplan/50-cloud-init.yaml
    echo "                addresses: [ ${DNS} ]" | sudo tee -a /media/nbd/etc/netplan/50-cloud-init.yaml
    sudo sed -i -e '/^server/d' /media/nbd/etc/chrony/chrony.conf
    echo "server ${NTP} iburst" | sudo tee -a /media/nbd/etc/chrony/chrony.conf
    sudo sed -i -e '/^DNS=/d' /media/nbd/etc/systemd/resolved.conf
    echo "DNS=${DNS}" | sudo tee -a /media/nbd/etc/systemd/resolved.conf
    sudo umount /media/nbd
    sleep 1
    sudo qemu-nbd --disconnect /dev/nbd0
    sleep 3
    sudo rmmod nbd
    sleep 2
done
sudo rmdir /media/nbd


