#!/bin/bash
for i in control master node1 node2 node3
do
  virsh start ${i}
done
