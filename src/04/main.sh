# VALUES OF RESPONSE CODE IN HTTP

# 200 OK 
# 201 Created

# 400 Bad Request
# 401 Unauthorized
# 403 Forbidden
# 404 Not Found

# 500 Internal Server Error
# 501 Not Implemented
# 502 Bad Gateway
# 503 Service Unavailable

# CONSTANT VALUES
min_number_of_records=100
max_number_of_records=1000
diapazon_of_records=$(($max_number_of_records-$min_number_of_records))
column_for_sorting=5
number_of_files=5

# DATE AND CHECKS ON DATE INPUT
if [ -z $1 ]
then 
    date='24/Apr/2023'
else
    regex_date_format="(0[1-9]|[12][0-9]|3[01])/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)/20([01][0-9]|2[0-3])"
    if [[ $1 =~ $regex_date_format ]];
    then 
        date=$1
    else
        echo "Incorrect date input."
        exit 1
    fi
fi

# ARRAYS WITH VALUES FOR LOG
response_codes=('200' '201' '400' '401' '403' '404' '500' '501' '502' '503')
methods=('GET' 'POST' 'PUT''PATCH' 'DELETE')
agents=('Mozilla' 'Google Chrome' 'Opera Safari' 'Internet Explorer' 'Microsoft Edge' 'Crawler and bot' 'Library and net tool')

# LENGTH OF DECLARED ARRAYS:
response_codes_length=${#response_codes[*]}
methods_length=${#methods[*]}
agents_length=${#agents[*]}


file_counter=0
while [ $file_counter -lt $number_of_files ]
do
    log_counter=0
    log_file="access_log_$file_counter"
    number_of_logs=$(($RANDOM%$diapazon_of_records+$min_number_of_records))
    while [ $log_counter -lt $number_of_logs ]
    do      
        i_rc=$RANDOM%$response_codes_length
        i_m=$RANDOM%$methods_length
        i_a=$RANDOM%$agents_length
        time="$(($RANDOM%24)):$(($RANDOM%60)):$(($RANDOM%60))"
        ip="$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256)).$(($RANDOM%256))"
        echo "$ip ${response_codes[i_rc]} \"${methods[i_m]}\" \"${agents[i_a]}\" $date:$time"
        log_counter=$(($log_counter+1))
    done > $log_file
    sort --key=$column_for_sorting $log_file > buffer
    cat buffer > $log_file && rm buffer
    file_counter=$(($file_counter+1))
done