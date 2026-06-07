#!/bin/bash
source ./common.sh
check_root

app_setup

maven_setup

systemd_setup

print_time

dnf install mysql -y
validate $? "installing MySQL"

mysql -h mysql.jeev.shop -u root -p mysql_root_password -e 'use cities' &>>$script_file
if [ $? -ne 0 ]
then
	mysql -h mysql.jeev.shop -u root -p $mysql_root_password < /app/db/schema.sql &>>$script_file
	mysql -h mysql.jeev.shop -u root -p $mysql_root_password < /app/db/cities.sql &>>$script_file
	mysql -h mysql.jeev.shop -u root -p $mysql_root_password < /app/db/cities.sql &>>$script_file
else 
echo -e "$y shipping schema is already loaded into mysql $n"
fi

systemctl restart shipping &>>$script_file
validate $? "restarting shipping service"

print_time