#!/bin/bash

source ./common.sh

check_root

cp $script_dir/mongo.repo /etc/yum.repos.d/mongo.repo &>>$script_file
validate $? "copying mongo.repo file"

dnf install mongodb-org -y &>>$script_file
validate $? "mongo db installation"

systemctl enable mongod &>>$script_file
validate $? "mongod service enabling"

systemctl start mongod &>>$script_file
validate $? "starting mongod service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$script_file
validate $? "allowing remote connection to mongodb"

systemctl restart mongod &>>$script_file

echo -e "$g Mongodb installed successfully and script execution completed $n" &>>$script_file