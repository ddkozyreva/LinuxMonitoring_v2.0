#!/bin/bash
sudo apt install -y goaccess
log_file="../04/access1.log"
html_output="logs_report.html"
sudo touch $html_output && chmod 777 $html_output
goaccess $log_file --log-format=COMBINED > ./$html_output
# open $html_output