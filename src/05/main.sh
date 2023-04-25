check_input() {
    if [ -z $choice ] || [ $choice -ge 5 ];
    then
        echo "Choose one option as first parameter:
        1 - All entries sorted by response code
        2 - All unique IPs found in the entries
        3 - All requests with errors (response code - 4xx or 5xxx)
        4 - All unique IPs found among the erroneous requests"
        exit 1
    fi
}

# MAIN PROCESS
main() {
    echo "Enter the path to file with logs"
    read log_file

    if [ $choice -eq 1 ];
    then 
        awk '{print | "sort --key=6"}' $log_file
    fi

    if [ $choice -eq 2 ];
    then 
        awk '{print $1 | "uniq"}' $log_file
    fi

    if [ $choice -eq 3 ];
    then 
        awk '{ \
        if ($9 ~ /4**/ || $9 ~ /5**/) 
            print $0;
        }' $log_file
    fi

    if [ $choice -eq 4 ];
    then
        awk '{ \
        if ($9 ~ /4**/ || $9 ~ /5**/) {
            print $1 | "uniq"
        }
        }' $log_file
    fi
}

# log_file="/Users/loretath/Developer/DO4_LinuxMonitoring_v2.0-0/src/04/access_log_1"
choice=$1
check_input
main