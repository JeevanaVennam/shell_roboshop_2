#!/bin/bash

source ./common.sh

check_root

dnf module disable nginx -y &>> $script_file
validate $? "disabling nginx"

dnf module enable nginx:1.24 -y &>>$script_file
validate $? "nginx enabled"

dnf module install nginx -y &>>$script_file
validate $? "nginx installation"

systemctl enable nginx &>>$script_file
validate $? "enabling nginx"

systemctl start nginx &>>$script_file
validate $? "starting nginx"

rm -rf /usr/share/nginx/html/*
validate $? "removal of files from html directory"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$script_file
validate $? "downloading frontend content"

cd /usr/share/nginx/html/
validate $? "changing directory to html"

unzip /tmp/frontend.zip &>>$script_file
validate $? "unzipping frontend content"

cp $script_file/nginx.conf /etc/nginx/nginx.conf &>>$script_file
validate $? "copying nginx conf file"

systemctl restart nginx &>>$script_file
validate $? "restarting nginx service"

echo -e "$g frontend setup completed and script executed succefully $n" &>>$script_file
 