#!/bin/bash

source ./common.sh
check_root

echo "Please enter root password to setup"
read -s mysql_root_password

dnf install mysql-server -y &>>$script_file
validate $? "installing mysql"

systemctl enable mysqld &>>$script_file
validate $? "enabling mysql"

systemctl start mysqld &>>$script_file
validate $? "starting mysql"

mysql_secure_installation --set-root-pass $mysql_root_password &>>$script
_file
validate $? "setting mysql root password

print_time