#! /bin/bash
# ------------------- CONSTANT VALUES ------------------------
location="$1"
number_of_folders=$2
characters_for_folders=$3
number_of_files=$4
characters_for_files=$5
size=$6
min_free_space=1
max_acceptable_file_size=100
# ------------------------------------------------------------
# ---------------- PARAMETERS FOR GENERATION -----------------
get_parameters() {
    data=$(date +"%d%m%y")
    len=${#characters_for_folders}
    counter=0
    free_space=$(df -h / | tail -n 1 | awk '{print $4}' | rev | cut -c 3- | rev)
}
# ------------------------------------------------------------

# ------------------ CHECKS ON INPUT -------------------------

check_input() {
 if [ -z "$characters_for_folders" ];
    then echo "Empty list of characters for folder names" && exit 0
    fi

    if [ -z "$characters_for_files" ];
    then echo "Empty list of characters for file names" && exit 0
    fi

    if [ -z "$file_str" ];
    then echo "Empty list of characters for file names" && exit 0
    fi

    if [ -z "$ext_str" ];
    then echo "Empty list of characters for file extension" && exit 0
    fi

    if [ $number_of_folders -le 0 ];
    then echo "Enter posiive number for number of folders" && exit 0
    fi

    if [ $number_of_files -le 0 ];
    then echo "Enter a positive number for number of files" && exit 0
    fi

    if [ ${#characters_for_folders} -gt 7 ];
    then echo "Too much symbols for name of folders" && exit 0
    fi

    if [ ${#file_str} -gt 7 ]
    then echo "Too much symbols for name of files" && exit 0
    fi

    if [ ${#ext_str} -gt 3 ]
    then echo "Too much symbols for extension of files" && exit 0
    fi

    if [ "${location:0:1}" != "/" ];
    then echo "Specify an absolute path, not a relative one." && exit 0
    fi

    if [ -z "$size" ];
    then echo "Enter the size as 6th argument." && exit 0
    fi

    if [ $size -gt $max_acceptable_file_size ];
    then 
    echo "The size enormous. It will be used 100kb as the size of generated files." && size=100
    fi

    if [ $size -le 0 ];
    then 
    echo "The size unappropriate." &&  exit 0
    fi
}
# ------------------------------------------------------------

# --------------------- FILE GENERATOR -----------------------

fill_file_on_1K() {
    for _ in {0..500}; 
    do echo "$(($RANDOM%10))">> $1
    done
}
fill_file() {
    cur_size=1
    while [ $cur_size -le $size ] && [ $cur_size -le $max_acceptable_file_size ]
    do fill_file_on_1K $1 && cur_size=$(($cur_size + 1))
    done
}
get_match_str_for_files() {
    match_str="_$data.$ext_str"
    j=0
    while [ $j -lt ${#characters_for_files} ]
    do
        match_str="?$match_str" && j=$(($j+1))
    done
}
file_generator() {
    data=$(date +"%d%m%y")
    char_len=${#characters_for_files}
    char_location="$1/"
    touch "${char_location}${characters_for_files}_${data}.$ext_str"
    get_match_str_for_files
    tail_len=$((8+${#ext_str}))
    file_counter=1
    while [ $file_counter -lt $number_of_files ] && [ $free_space -gt $min_free_space ]
    do
        slider=0
        while [ $slider -lt $char_len ] && [ $file_counter -lt $number_of_files ]
        do
            for char_str in $(find $char_location -type f -name $match_str);
            do
                if [ $file_counter -lt $number_of_files ];
                then            
                    preambule_len=$((${#char_str}-$char_len-$tail_len))
                    tail_=$(($char_len-$slider))
                    echo "1 ${char_str:0:${#char_str}}"
                    echo "2 ${char_str:0:$preambule_len}"
                    file_name="${char_str:0:$((slider+1+preambule_len))}${char_str:$((slider+preambule_len)):$tail_}_${data}.$ext_str"
                    touch $file_name
                    file_counter=$(($file_counter+1))
                    fill_file $file_name
                    echo "file_name $file_name"
                fi
            done;
            slider=$(($slider+1))
        done
        match_str="?$match_str"
        char_len=$(($char_len+1))
    done
}
# ------------------------------------------------------------

# ------ MAIN FUNCTION OF FILES AND FOLDERS GENERATION -------

# FOLDERS GENERATION

get_match_str_for_folders() {
    j=0
    folder_match_str="_$data"
    while [ $j -lt ${#characters_for_folders} ]
    do
    folder_match_str="?$folder_match_str" && j=$(($j+1))
    done
}

get_characters_for_files() {
    character_str_slider=0
    sep="." && ext_str="" && file_str="" && sep_point=${#characters_for_files}
    while [ $character_str_slider -lt ${#characters_for_files} ]
    do 
        symbol="${characters_for_files:character_str_slider:1}"
        if [ "$symbol" = "$sep" ]; then sep_point=$character_str_slider
        fi
        if [ $character_str_slider -gt $sep_point ]; then ext_str="${ext_str}$symbol" 
        fi
        if [ $character_str_slider -lt $sep_point ]; then file_str="${file_str}$symbol" 
        fi
        character_str_slider=$(($character_str_slider+1))
    done
}
main_process() {
    get_parameters
    get_characters_for_files
    check_input
    characters_for_files=$file_str
    len=${#characters_for_folders}
    folder_name="$location/${characters_for_folders}_$data"
    mkdir -p "$folder_name" && counter=1
    file_generator "$folder_name"
    get_match_str_for_folders
    while [ $counter -lt $number_of_folders ] && [ $free_space -gt $min_free_space ]
    do
        i=0
        while [ $i -lt $len ] && [ $counter -lt $number_of_folders ]
        do
            for str in $(find $location -type d -name $folder_match_str);
            do
                if [ $counter -lt $number_of_folders ] && [ $free_space -gt $min_free_space ];
                then            
                    preambule_len=$((${#str}-$len-7))
                    tail_=$(($len-$i))
                    folder_name="${str:0:$((i+1+preambule_len))}${str:$((i+preambule_len)):$tail_}_$data"
                    mkdir -p $folder_name && counter=$(($counter+1))
                    file_generator "$folder_name"
                    free_space=$(df -h / | tail -n 1 | awk '{print $4}' | rev | cut -c 3- | rev)
                fi
            done; i=$(($i+1))
        done
        folder_match_str="?$folder_match_str" && len=$(($len+1))
    done
}

main_process
