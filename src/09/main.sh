#!/bin/bash
sudo cp nginx.conf /etc/nginx/nginx.conf 
sudo nginx -t
sudo service nginx restart

# Функция, собирающая метрики 
info() {
    cpu="$(cat /proc/loadavg | awk '{print $1}')" # показатель загрузки средний за 1 мин
    mem_avail="$(free | grep Mem | awk '{print $4}')" # свободная оперативная память
    disk_avail="$(df /| grep / | awk '{print $4}')" # свободное место на диске

    echo "# HELP cpu CPU info 1 min"
    echo "# TYPE cpu gauge"
    echo "cpu $cpu"

    echo "# HELP mem_avail available RAM"
    echo "# TYPE mem_avail gauge"
    echo "mem_avail $mem_avail"

    echo "# HELP disk_avail free disk space"
    echo "## TYPE disk_avail gauge"
    echo "disk_avail $disk_avail"
}



main_process() {
    sudo cp prometheus.yml /etc/prometheus/prometheus.yml
    sudo service prometheus restart

    while true; do
    info > ./9.html
    curl 127.0.0.1:9001

    sleep 3
    done
}

main_process

