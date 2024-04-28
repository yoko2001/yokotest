#!/bin/bash
echo $$ >> /sys/fs/cgroup/cgroup.procs
sleep 1
cgdelete -r -g cpuset,cpu,io,memory,hugetlb,pids,rdma,misc:/yuri
echo $$
if [ ! -d "/sys/fs/cgroup/yuri/" ];then
	mkdir /sys/fs/cgroup/yuri
else
	echo "cgroup yuri already exists"
fi
echo "+memory +io" >> /sys/fs/cgroup/yuri/cgroup.subtree_control
# echo "+io" >> /sys/fs/cgroup/yuri/cgroup.subtree_control

if [ ! -d "/sys/fs/cgroup/yuri/merge_sort/" ];then
	# mkdir /sys/fs/cgroup/yuri/merge_sort
	mkdir /sys/fs/cgroup/yuri/merge_sort
else
	echo "cgroup yuri/merge_sort already exists"
fi
# sudo mount -t cgroup -o blkio none /sys/fs/cgroup/yuri/merge_sort
# mount -t cgroup -o memory,blkio merge_sort /sys/fs/cgroup/yuri/merge_sort

echo $((314572800)) > /sys/fs/cgroup/yuri/merge_sort/memory.max
echo "set memory.max to"
cat /sys/fs/cgroup/yuri/merge_sort/memory.max
# echo "259:0 rbps=52428800" > /sys/fs/cgroup/yuri/merge_sort/io.max
# echo "8:0 524288000" | sudo tee /sys/fs/cgroup/yuri/merge_sort/io.max

echo "set io.max to"
cat /sys/fs/cgroup/yuri/merge_sort/io.max
echo "adding current shell to merge_sort"
echo $$ >> /sys/fs/cgroup/yuri/merge_sort/cgroup.procs
# sudo touch /sys/fs/cgroup/yuri/merge_sort/blkio.throttle.read_bps_device


