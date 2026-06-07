#!/bin/bash

source ./common.sh

check_root

dnf module disable redis &>>script_file
validate $? "disabling redis"

dnf module enable redis:7 -y &>>script_file
validate $? "enabling redis"

dnf install redis -y &>>script_file
validate $? "installingg redis"

sed -I -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no" /etc/redis/redis.conf
validate $? "edited redis.conf to accept remote connection"

systemctl enable redis &>>$script_file
validate $? "enabling redis"

systemctl start redis &>>$script_file
validate $? "start redis"

print_time