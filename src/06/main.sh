log_file="access_1.log"
goaccess $log_file --log-format=COMBINED > ./logs_report.html
open logs_report.html