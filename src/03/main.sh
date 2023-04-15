choice=$1

if [ $choice -ne 1 ] && [ $choice -ne 1 ] && [ $choice -ne 1 ];
then
    echo "Incorrect first parameter. You can choose:"
    echo "1 - clean system by log file. And enter path to log file as the 2nd parameter."
    echo "2 - clean system by creation date and time."
    echo "3 - clean system by name mask. And enter name mask ()."
fi

main_process() {
    if [ $choice -eq 1 ];
    then
        while read y
        do
        element_for_deletion=$(echo "$y" | awk '{print $1}')
        rm -rf "$element_for_deletion"
        done < $2
    fi
}

main_process 2> output.txt