#!/bin/bash
first_param=$1
if [ $# -eq 0 ]; then
    echo "ramon_x needs a parameter"
    exit 1
fi
swapoff /dev/zram0

modprobe -r zram
sleep 1

modprobe zram num_devices=1
swapoff /dev/zram0
numstream=$(cat /sys/block/zram0/max_comp_streams)
echo "numstream = ${numstream}"
algo=$(cat /sys/block/zram0/comp_algorithm)
echo "used algorythm is ${algo}"

# Initialize /dev/zram0 with 256MB disksize
echo $(($1 * 1024 * 1024)) > /sys/block/zram0/disksize
echo $(($1 * 1024 * 1024)) > /sys/block/zram0/mem_limit

#swap on
mkswap /dev/zram0
#setting the max priority
swapon -p 1005 /dev/zram0