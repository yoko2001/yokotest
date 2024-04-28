#!/bin/bash
swapoff /dev/nvme0n1
swapon -p 10 /dev/nvme0n1
modprobe brd rd_nr=1 rd_size=$((64 * 1024))
swapoff /dev/ram0

#swap on
mkswap /dev/ram0
#setting the max priority
swapon -p 1005 /dev/ram0

