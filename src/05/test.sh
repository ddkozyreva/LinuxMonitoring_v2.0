#!/bin/bash

# Define the file with logs and absolute path to file with logs
file_name="access1.log"
file_with_pwd="my_pwd.txt"
sudo touch $file_with_pwd && chmod 777 $file_with_pwd
path=$(pwd | rev | cut -c 2- | rev)
echo "${path}4/$file_name" > $file_with_pwd


# Redirect input (0<$file_with_pwd) and run the scrypt
# with different options

exec 0<$file_with_pwd && bash main.sh 1 | less
exec 0<$file_with_pwd && bash main.sh 2 | less
exec 0<$file_with_pwd && bash main.sh 3 | less
exec 0<$file_with_pwd && bash main.sh 4 | less