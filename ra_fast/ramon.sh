#!/bin/bash
swapoff /dev/dm-1
<<<<<<< HEAD
swapon -p 100 /dev/dm-1
=======
swapon -p 10 /dev/dm-1
>>>>>>> 629970e (reshape git tree)
modprobe brd rd_nr=1 rd_size=$((64 * 1024))
swapoff /dev/ram0

#swap on
mkswap /dev/ram0
#setting the max priority
swapon -p 1005 /dev/ram0

