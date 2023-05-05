#!/bin/bash

# Установка nginx :ри необходимости
installation() {
    if ! [[ -n $(dpkg -l | grep nginx) ]];
    then sudo apt install -y nginx
    fi
}
# Функция, собирающая метрики
get_metrics() {
    # Средний показатель загрузки за 1 мин
    cpu="$(cat /proc/loadavg | awk '{print $1}')"
    # Свободная оперативная память
    memory_avail="$(free | grep Mem | awk '{print $4}')"
    # Свободное место на диске
    disk_avail="$(df /| grep / | awk '{print $4}')"

    echo "# HELP cpu CPU info 1 min"
    echo "# TYPE cpu gauge"
    echo "cpu $cpu"

    echo "# HELP memory_avail available RAM"
    echo "# TYPE memory_avail gauge"
    echo "memory_avail $memory_avail"

    echo "# HELP disk_avail free disk space"
    echo "## TYPE disk_avail gauge"
    echo "disk_avail $disk_avail"
}

main_process() {
    installation

    sudo cp nginx.conf /etc/nginx/nginx.conf 
    sudo nginx -t
    sudo service nginx restart

    sudo cp prometheus.yml /etc/prometheus/prometheus.yml
    sudo service prometheus restart

    sudo touch 9.html; chmod 777 9.html

    while true; 
    do 
        get_metrics > ./9.html
        curl 127.0.0.1:81
        sleep 3
    done;
}

main_process

