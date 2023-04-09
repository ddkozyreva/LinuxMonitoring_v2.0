# ------------------- CONSTANT VALUES -----------------------

location="$1"
number_of_folders=$2
str=$3
number_of_files=$4
characters_for_files=$5
size=$6
data=$(date +"%d%m%y")
min_free_space=1

# ------------------------------------------------------------

# ------------------ CHECKS ON INPUT -------------------------

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

# ------------------------------------------------------------

# ---------------- VARIABLES FOR GENERATION ------------------

len=${#str}
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
while [ $counter -lt $number_of_folders ] && [ $free_space -gt $min_free_space ] && [ $inf_counter -lt $max_inf_counter ]
do
    # GENERATION OF FOLDER NAME
    gen_len=$(($RANDOM%$delimeter+$len))
    reserv=$(($gen_len-$len))
    symbol=0
    folder_name=""
    while [ $gen_len -gt 0 ]
    do
        chosen_symbol=${str:$symbol:${symbol+1}}
        folder_name=$folder_name$chosen_symbol
        next=$(($RANDOM%2))

        if [ $reserv -eq 0 ] || [ $next -eq 0 ];
        then
            symbol=$(($symbol+1))
        else
            reserv=$(($reserv-1))
        fi
        gen_len=$(($gen_len-1))

    done


    if [ ! -d "$1${folder_name}_$data" ];
    then 
        # CREATION OF FOLDER NAME
        folder_name="$1/${folder_name}_$data/"
        mkdir -p "$folder_name" && counter=$(($counter+1))
        
        # GENERATION OF FILES FOR CREATED FOLDER
        file_counter=0       
        while [ $file_counter -lt $number_of_files ]
        do
            # GENERATION OF FILE NAME
            char_gen_len=$(($RANDOM%$char_delimeter+$char_len))
            reserv=$(($char_gen_len-$char_len))
            symbol=0
            file_name=""
            while [ $char_gen_len -gt 0 ]
            do
                chosen_symbol=${characters_for_files:$symbol:${symbol+1}}
                file_name=$file_name$chosen_symbol
                next=$(($RANDOM%2))

                if [ $reserv -eq 0 ] || [ $next -eq 0 ];
                then
                    symbol=$(($symbol+1))
                else
                    reserv=$(($reserv-1))
                fi
                char_gen_len=$(($char_gen_len-1))
            done
            echo "$file_name $file_counter $number_of_files"
            if [ ! -f "$folder_name$file_name" ];
            then
            # CREATION OF FILE INTO FOLDER
                touch "$folder_name$file_name" && file_counter=$(($file_counter+1))
            fi
        done
    else
        inf_counter=$(($inf_counter+1))
    fi
    free_space=$(df -h / | tail -n 1 | awk '{print $4}' | rev | cut -c 3- | rev)
done

# ------------------------------------------------------------

# --------------------- ERROR HANDLING -----------------------

if [ $free_space -le $min_free_space ];
then
    echo "The available memory is less then minimal required ($free_space Gi)."
fi

if [ $inf_counter -ge $max_inf_counter ];
then
    echo "It was too many attempts to create folders which already exist. Process was stopped."
    echo "Perhaps it is not possible to create so many folder names from so few characters - the names have became similar."
    echo "Or too many symbols for only 7-charactered folder names."
fi
