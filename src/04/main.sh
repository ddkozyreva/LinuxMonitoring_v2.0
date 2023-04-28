#!/bin/bash

# CONSTANT VALUES
min_number_of_records=100
max_number_of_records=1000
diapazon_of_records=$(($max_number_of_records-$min_number_of_records))
column_for_sorting=4
number_of_files=5
max_years_ago=10
resource="https://translate.google.com/?hl=ru"
protocol="HTTP/1.1"
url_from="https://ru.wikipedia.org/wiki/Google_%D0%9F%D0%B5%D1%80%D0%B5%D0%B2%D0%BE%D0%B4%D1%87%D0%B8%D0%BA"
max_bytes=8192
# ARRAYS WITH VALUES FOR LOG
response_codes=('200' '201' '400' '401' '403' '404' '500' '501' '502' '503')
methods=('GET' 'POST' 'PUT''PATCH' 'DELETE')
agents=('Mozilla' 'Google Chrome' 'Opera Safari' 'Internet Explorer' 'Microsoft Edge' 'Crawler and bot' 'Library and net tool')

# LENGTH OF DECLARED ARRAYS:
response_codes_length=${#response_codes[*]}
methods_length=${#methods[*]}
agents_length=${#agents[*]}

generate_date() {
    let days_backwards=$RANDOM%31
    let months_backwards=$RANDOM%11
    let years_backwards=$RANDOM%$max_years_ago
    date_ago="-$days_backwards days -$months_backwards months -$years_backwards years"
    date=$(date -d "$date_ago" '+%d/%b/%Y')
}
generate_time(){
    let hours=$RANDOM%24
    let minutes=$RANDOM%60
    let seconds=$RANDOM%60
    time_ago="-$seconds seconds -$minutes minutes -$hours hours"
    time=$(date -d "$time_ago" '+%H:%M:%S %z')
}

file_counter=1
while [ $file_counter -le $number_of_files ]
do
    export LANG=""
    log_counter=0
    log_file="access$file_counter.log"
    sudo touch $log_file && chmod 777 $log_file
    number_of_logs=$(($RANDOM%$diapazon_of_records+$min_number_of_records))
    generate_date
    while [ $log_counter -lt $number_of_logs ]
    do      
        let i_rc=$RANDOM%$response_codes_length
        let i_m=$RANDOM%$methods_length
        let i_a=$RANDOM%$agents_length
        let object_size=$RANDOM%$max_bytes
        generate_time
        ip="$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256))"
        echo "$ip - $USER [$date:$time] \"${methods[i_m]} $resource $protocol\" ${response_codes[i_rc]} $object_size \"$url_from\" \"${agents[i_a]}\""
        log_counter=$(($log_counter+1))
    done > $log_file
    sudo touch buffer && chmod 777 buffer
    sort --key=$column_for_sorting $log_file > buffer
    cat buffer > $log_file && sudo rm buffer
    file_counter=$(($file_counter+1))
done
 