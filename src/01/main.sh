location=$1
number_of_folders=$2
str=$3
number_of_files=$4
characters_for_files=$5
size=$6

if [ -z "$str" ];
then 
    echo "Empty list of characters for folder names"
    exit 0
fi


if [ -z "$characters_for_files" ];
then 
    echo "Empty list of characters for file names"
    exit 0
fi

if [ ${#str} -gt 7 ];
then
    echo "Too much symbols for name of folders"
    exit 0
fi

if [ ${#characters_for_files} -gt 7 ]
then
    echo "Too much symbols for name of files"
    exit 0
fi

if [ "${location:0:1}" != "/" ];
then 
    echo "Specify an absolute path, not a relative one."
    exit 1
fi

if [ $size -gt 100 ];
then 
    echo "The size enormous. It will be used 100kb as the size of generated files."
    size=100
fi

if [ $size -le 0 ];
then 
    echo "The size unappropriate."
    exit 2
fi

len=${#str}

counter=0
folder_name=${str:$symbol:${symbol+1}}
while [ $counter -le $number_of_folders ]
do
    gen_len=$(($RANDOM%7+1))
    symbol=$(($RANDOM%$len))
    buffer_string=${str:$symbol:${symbol+1}}
    folder_name=$folder_name$buffer_string

    counter=$(($counter+1))
done

echo $folder_name
# a="qw"
# b="c"
# a=$a$b
# echo $a