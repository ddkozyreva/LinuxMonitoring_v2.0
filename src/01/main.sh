# ------------------- CONSTANT VALUES -----------------------

location="$1"
number_of_folders=$2
characters_for_folders=$3
number_of_files=$4
characters_for_files=$5
size=$6
data=$(date +"%d%m%y")
min_free_space=1

# ------------------------------------------------------------

# ------------------ CHECKS ON INPUT -------------------------

if [ -z "$characters_for_folders" ];
then 
    echo "Empty list of characters for folder names"
    exit 0
fi


if [ -z "$characters_for_files" ];
then 
    echo "Empty list of characters for file names"
    exit 0
fi

if [ $number_of_folders -le 0 ];
then
    echo "Enter posiive number for number of folders"
    exit 0
fi

if [ $number_of_files -le 0 ];
then
    echo "Enter a positive number for number of files"
    exit 0
fi

if [ ${#characters_for_folders} -gt 7 ];
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

# ------------------------------------------------------------

# ---------------- VARIABLES FOR GENERATION ------------------

len=${#characters_for_folders}
char_len=${#characters_for_files}

counter=0
inf_counter=0
max_inf_counter=$(($number_of_folders**7 * $len))
file_inf_counter=0
max_file_inf_counter=$(($number_of_files**7 * $len))
max_symbols=7
delimeter=$(($max_symbols+1-$len))
char_delimeter=$(($max_symbols+1-$char_len))

# ------------------------------------------------------------

# ------ MAIN FUNCTION OF FILES AND FOLDERS GENERATION -------

free_space=$(df -h / | tail -n 1 | awk '{print $4}' | rev | cut -c 3- | rev)
len=${#characters_for_folders}
folder_name="$1${characters_for_folders}_$data"
mkdir -p "$folder_name" && counter=1

# FILES GENERATION FOR INIT FOLDER
char_len=${#characters_for_files}
char_location="$folder_name/"
touch "${char_location}${characters_for_files}_${data}"
b=""
j=0
while [ $j -lt ${#characters_for_files} ]
do
    b="$b?"
    j=$(($j+1))
done
b="${b}_$data"
file_counter=1
while [ $file_counter -lt $number_of_files ] && [ $free_space -gt $min_free_space ]
do
    k=0
    while [ $k -lt $char_len ] && [ $file_counter -lt $number_of_files ]
    do
        for char_str in $(find $char_location -type f -name $b);
        do
            if [ $file_counter -lt $number_of_files ];
            then            
                preambule_len=$((${#char_str}-$char_len-7))
                tail_=$(($char_len-$k))
                file_name="${char_str:0:$((k+1+preambule_len))}${char_str:$((k+preambule_len)):$tail_}_$data"
                touch $file_name
                file_counter=$(($file_counter+1))
            fi
        done;
        k=$(($k+1))
    done
    b="?$b"
    char_len=$(($char_len+1))
done
# END OF FILES GENERATION FOR INIT FOLDER



j=0
a=""
while [ $j -lt $len ]
do
a="$a?"
j=$(($j+1))
done
a="${a}_$data"

# FOLDERS GENERATION
while [ $counter -lt $number_of_folders ] && [ $free_space -gt $min_free_space ]
do
    i=0
    while [ $i -lt $len ] && [ $counter -lt $number_of_folders ]
    do
        echo $(find $location -type d -name $a)
        for str in $(find $location -type d -name $a);
        do
            if [ $counter -lt $number_of_folders ];
            then            
                preambule_len=$((${#str}-$len-7))
                tail_=$(($len-$i))
                folder_name="${str:0:$((i+1+preambule_len))}${str:$((i+preambule_len)):$tail_}_$data"
                mkdir -p $folder_name
                counter=$(($counter+1))

                # FILES GENERATION
                char_len=${#characters_for_files}
                char_location="$folder_name/"
                touch "${char_location}${characters_for_files}_${data}"
                b=""
                j=0
                while [ $j -lt ${#characters_for_files} ]
                do
                    b="$b?"
                    j=$(($j+1))
                done
                b="${b}_$data"
                file_counter=1
                while [ $file_counter -lt $number_of_files ] && [ $free_space -gt $min_free_space ]
                do
                    k=0
                    while [ $k -lt $char_len ] && [ $file_counter -lt $number_of_files ]
                    do
                        echo $(find $char_location -type f -name $b)
                        for char_str in $(find $char_location -type f -name $b);
                        do
                            if [ $file_counter -lt $number_of_files ];
                            then            
                                preambule_len=$((${#char_str}-$char_len-7))
                                tail_=$(($char_len-$k))
                                file_name="${char_str:0:$((k+1+preambule_len))}${char_str:$((k+preambule_len)):$tail_}_$data"
                                touch $file_name
                                file_counter=$(($file_counter+1))
                            fi
                        done;
                        k=$(($k+1))
                    done
                    b="?$b"
                    char_len=$(($char_len+1))
                done
                # END OF FILES GENERATION

            fi
        done;
        i=$(($i+1))
    done
    a="?$a"
    len=$(($len+1))
done
