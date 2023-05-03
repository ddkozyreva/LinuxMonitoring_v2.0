#!/bin/bash
html_output="logs_report.html"

if ! [[ -n $(dpkg -l | grep goaccess) ]];
then sudo apt install -y goaccess
fi

sudo touch $html_output && chmod 777 $html_output
goaccess ../04/access*.log --log-format=COMBINED > ./$html_output