#! /bin/bash
#set -e
g++ sort.cpp -O0 -o sort

sudo ./zramon.sh
sudo ./set_cgroup_128m.sh
sudo ./set_trace.sh
sleep 1
cat /sys/fs/cgroup/yuri/merge_sort/memory.stat > startmemstat.txt
echo $$ >> /sys/fs/cgroup/yuri/merge_sort/cgroup.procs
#start
sudo sh -c "echo 1 > /sys/kernel/debug/tracing/tracing_on"
./sort > info.txt 2>&1 &
sudo cat /sys/kernel/debug/tracing/trace_pipe > trace_record_p.txt &

sleep 200
#end
sudo sh -c "echo 0 > /sys/kernel/debug/tracing/tracing_on"
cat /sys/fs/cgroup/yuri/merge_sort/memory.stat > endmemstat.txt

# sudo ./mv.sh
