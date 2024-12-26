#! /bin/bash
#set -e

sleep 1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
gcc pagewalker.c -lm -O0 -o pagewalker
sudo ./set_cgroup_x.sh 512
sudo ./zramon_x.sh 200

sudo bash -c "echo $$ >> /sys/fs/cgroup/cgroup.procs"

# sudo swapoff /dev/ram0
# sudo ./set_trace.sh
sleep 1
CGROUPNAME=pressure

cat /sys/fs/cgroup/yuri/$CGROUPNAME/memory.stat > startmemstat.txt
sudo bash -c "echo $$ >> /sys/fs/cgroup/yuri/$CGROUPNAME/cgroup.procs"
echo "now in the group are:"
cat /sys/fs/cgroup/yuri/$CGROUPNAME/cgroup.procs
#start
# sudo sh -c "echo 1 > /sys/kernel/debug/tracing/tracing_on"
./pagewalker &
sleep 5
./pagewalker &
sleep 5
./pagewalker &
sleep 5
./pagewalker &

./pagewalker &

# sudo cat /sys/kernel/debug/tracing/trace_pipe > trace_record_p.txt &

sleep 300
sudo killall pagewalker
#end
# sudo sh -c "echo 0 > /sys/kernel/debug/tracing/tracing_on"
cat /sys/fs/cgroup/yuri/$CGROUPNAME/memory.stat > endmemstat.txt
cat /sys/fs/cgroup/yuri/$CGROUPNAME/memory.peak > peak.txt
