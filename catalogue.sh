#!/bin/bash

source ./common.sh

app_name=catalogue

check_root

app_setup

nodejs_setup

systemd_setup


cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "copying mongo.repo file"
dnf install mongodb-mongosh -y &>>$script_file

validate $? "installation of mongo client"

status=$(mongosh --host mongodb.jeev.shop --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $status -lt 0 ]
then 
	mongosh --host mongodb.jeev.shop </app/db/master-data.js &>>$script_file
	validate $? "loading catalogue data to mongoDB"
else
	echo -e "Data is already loaded"

fi

print_time

echo -e "$g catalogue setup is completed and script execution completed $n" &>>$script_file