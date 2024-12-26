#!/bin/bash
first_param=$1
if [ $# -eq 0 ]; then
    echo "ramon_x needs a parameter"
    exit 1
fi
nvme_major_minor="253:2"  # 假设nvme设备的major号为259，minor号为2

CGROUPNAME=pressure
cgdelete -r memory:/yuri/${CGROUPNAME}
cgdelete -r memory:/yuri/${CGROUPNAME}

if [ ! -d "/sys/fs/cgroup/yuri/" ];then
	mkdir /sys/fs/cgroup/yuri
else
	echo "cgroup yuri already exists"
fi
echo "+memory" >> /sys/fs/cgroup/yuri/cgroup.subtree_control
echo "+io" >> /sys/fs/cgroup/yuri/cgroup.subtree_control

if [ ! -d "/sys/fs/cgroup/yuri/${CGROUPNAME}/" ];then
	mkdir /sys/fs/cgroup/yuri/${CGROUPNAME}
else
	echo "cgroup yuri/${CGROUPNAME} already exists"
fi

let totalmem=$(($first_param * 1024 * 1024)) #256mb = (4*128mb)*50%

echo ${totalmem} > /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/memory.max

#echo "$nvme_major_minor  rbps=26214400" > /sys/fs/cgroup/yuri/${CGROUPNAME}/io.max

echo "$nvme_major_minor  rbps=52428800" > /sys/fs/cgroup/yuri/${CGROUPNAME}/io.max

# echo "$nvme_major_minor  rbps=26214400 wbps=94371840" > /sys/fs/cgroup/yuri/${CGROUPNAME}/io.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/${CGROUPNAME}/io.max

exit 0
