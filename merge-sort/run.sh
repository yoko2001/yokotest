g++ sort.cpp -o sort
start_time=$(date +%s)
./sort
end_time=$(date +%s)
time_diff=$((end_time - start_time))
echo "runtime:$time_diff s"