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
        regex_data_formet="202[23]-(0\d|1[0-2])-(0[1-9]|[12]\d|3[01]) ([01]\d|2[0-3]):([0-5]\d)"
        elements_for_deletion=$(find $location -newermt "$start_time" ! -newermt "$end_time")
        # rm -rf $elements_for_deletion
        for file in $elements_for_deletion;
        do
            echo $file
        done


        #  if ! [[ "$(date "+%Y-%m-%d %H:%M" -d "$Date_Finish $Time_Finish" 2> /dev/null)" = "$Date_Finish $Time_Finish" ]]
        #     then
        # #     if  [[ "$Date_Finish"='(0?[1-9]|[12][0-9]|3[01])'-'(0?[1-9]|1[012])'-'[2][2-3]' ]] && [[ "$Time_Finish"='([1][1-9]|[2][0-3])':'([1-5][0-9]|[0-9])' ]]    
        #         echo ""
        #         echo "You entered an invalid search end date, example: (YYYY-MM-DD HH:MM)"
        #         read -p "Enter the end time in the following format (YYYY-MM-DD HH:MM): " Date_Finish Time_Finish   
        #     else
        #         data=0     

    fi

    if [ $choice -eq 3 ];
    then


        # elements_for_deletion=$(find $location -newermt "$start_time" ! -newermt "$end_time")
        # rm -rf $elements_for_deletion
       # 4 и более символов - буквы A-Za-z, далее _, затем дата корректного формата:
        regex_folder_name='[A-Za-z]{4,}_(0[1-9]|[12]\d|3[01])(0[1-9]|1[0-2])2[23]'
        data_for_deletion=$(find $location -type d | grep -E $regex_folder_name)
        for element_for_deletion in $data_for_deletion;
        do echo $element_for_deletion
        done

        #../02/access_log
        # echo $(find / -type d 2>/dev/null | grep -E $regex_folder_name) ../02/log.txt

        # \.\/(s+w+e+_160423\/)+a+s+_160423\.tr # https://regexr.com/
    fi
}

main_process 2> output.txt
