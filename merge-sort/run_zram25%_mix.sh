#! /bin/bash
#set -e
# test all zram status
g++ sort.cpp -O0 -o sort

sudo ./zramon-300m.sh
sudo ./set_cgroup_300m.sh
#sudo ./set_trace.sh
sleep 1
cat /sys/fs/cgroup/yuri/merge_sort/memory.stat > startmemstat.txt
sudo sh -c "echo $$ >> /sys/fs/cgroup/yuri/merge_sort/cgroup.procs"
#start
#sudo sh -c "echo 1 > /sys/kernel/debug/tracing/tracing_on"
sudo cat /sys/kernel/debug/tracing/trace_pipe > trace_record_p.txt &
./sort > info.txt 2>&1 &
sleep 1

sleep 90
#end
sudo sh -c "echo $$ >> /sys/fs/cgroup/cgroup.procs"
reset
#sudo sh -c "echo 0 > /sys/kernel/debug/tracing/tracing_on"
cat /sys/fs/cgroup/yuri/merge_sort/memory.stat > endmemstat.txt

# sudo ./mv.sh
