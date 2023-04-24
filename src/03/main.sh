choice=$1
location="/"
if [ $choice -eq 1 ];
then access_log=$2
fi

if [ $choice -eq 2 ];
then start_time=$2 && end_time=$3
fi

error_log() {
    echo "Incorrect first parameter. You can choose:"
    echo "1 - clean system by log file. And enter path to log file as the 2nd parameter."
    echo "2 - clean system by creation date and time. Example:  sh main.sh 2 'YYYY-MM-DD HH:MM' (like '2023-04-16 13:13')"
    echo "3 - clean system by name mask. And enter name mask ()."
}

check_input() {
    if [ -z $choice ];
    then error_log && exit 0
    fi

    if [ $choice -ne 1 ] && [ $choice -ne 2 ] && [ $choice -ne 3 ];
    then error_log && exit 0
    fi
}


main_process() {
    check_input
    if [ $choice -eq 1 ];
    then
        while read y
        do
        element_for_deletion=$(echo "$y" | awk '{print $1}')
        rm -rf "$element_for_deletion"
        done < $access_log
    fi

    if [ $choice -eq 2 ];
    then
        regex_date_format="202[23]-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01]) ([01][0-9]|2[0-3]):([0-5][0-9])"
        if [[ $start_time =~ $regex_date_format ]] && [[ $end_time =~ $regex_date_format ]];
        then
            elements_for_deletion=$(find $location -newermt "$start_time" ! -newermt "$end_time")
            for file in $elements_for_deletion;
            do
                echo $file
                # rm -rf $file #$elements_for_deletion
            done
        else
            echo "Incorrect data/time format. Please, try again in format 'YYYY-MM-DD HH:MM 'YYYY-MM-DD HH:MM'"
        fi    

    fi

    if [ $choice -eq 3 ];
    then
        # 4 и более символов - буквы A-Za-z, далее _, затем дата корректного формата:
        regex_folder_name='[A-Za-z]{4,}_(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[0-2])2[23]'
        data_for_deletion=$(find $location -type d | grep -E $regex_folder_name)
        for element_for_deletion in $data_for_deletion;
        do 
        echo $element_for_deletion
        # rm -rf $element_for_deletion 
        done
    fi
}

main_process 2> output.txt
