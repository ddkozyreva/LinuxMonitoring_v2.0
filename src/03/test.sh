#! /bin/bash

sudo chmod 777 main.sh
start_time=$(date -d '-1 minutes' '+%Y-%m-%d %H:%M')
end_time=$(date -d '2 minutes' '+%Y-%m-%d %H:%M')
location="/"

# ----- First way -----
echo "FIRST WAY OF CLEANING"
cd ../02/
bash main.sh az az.az 100Mb
cd ../03/
echo "BEFORE DELETION:"
df -h / | tail -n 1 | awk '{print $4}'
bash main.sh 1 ../02/access.log
echo "AFTER DELETION:"
df -h / | tail -n 1 | awk '{print $4}'

# ----- Second way -----
echo "SECOND WAY OF CLEANING"
cd ../02/
bash main.sh az az.az 100Mb
cd ../03/
echo "BEFORE DELETION:"
df -h / | tail -n 1 | awk '{print $4}'
bash main.sh 2 $start_time $end_time
echo "AFTER DELETION:" 
df -h / | tail -n 1 | awk '{print $4}'

# ----- Third way -----
echo "THIRD WAY OF CLEANING"
cd ../02/
bash main.sh az az.az 100Mb
cd ../03/
echo "BEFORE DELETION:"
df -h / | tail -n 1 | awk '{print $4}'
bash main.sh 3
echo "AFTER DELETION:" 
df -h / | tail -n 1 | awk '{print $4}'
