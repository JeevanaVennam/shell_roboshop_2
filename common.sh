#!/bin/bash
user_id=$(id -u)
r="\e[31m"
g="\e[32m"
y="\e[33m"
n="\e[0m"

log_folder="/var/log/roboshop_logs"
script_name=$(echo $0 | cut -d "." -f1)
script_file=$log_folder/$script_name.log
script_dir=$(pwd)
mkdir -p $log_folder
check_root()
{

if [ $user_id -eq 0 ]
then
echo -e "$g you are in root access $n" &>>$script_file
else
echo -e "$r Please try using root access $n" &>>$script_file
exit 1
fi
}

validate()
{
if [ $1 -eq 0 ]
then
echo "$2 is successful"
else
echo "$2 failed"
exit 1
fi
}

app_setup()
{

id roboshop
if [ $? -ne 0 ]
then 
	useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$script_file
        validate $? "roboshop user creation"
else
	echo "roboshop user already exist"
fi

mkdir /app
validate $? "application directory creation"

curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$script_file
validate $? "downloading $app_name content"

cd /app
validate $? "changing to app directory"

rm -rf*
validate $? "removing previous content from app directory"


unzip /tmp/app_name.zip &>>$script_file
validate $? "unzipping $app_name content"

}




nodejs_setup()
{

dnf module disable nodejs &>>$script_file
validate $? "disabling nodejs:20"
dnf module enable nodejs:20 -y &>>$script_file
validate $? "enabling nodejs:20"
dnf module install nodejs -y &>>$script_file
validate $? "installing nodejs:20"
npm install
validate $? "installed dependencies"

}


maven_setup()
{

dnf install maven -y &>>$script_file
validate $? "installing maven"

mvn clean package &>>$script_file
validate $? "Packaging the shipping application"

mv target/shipping-1.0.jar shipping.jar &>>$script_file
validate $? "moving and renaming the jar file"

}



python_setup()
{

dnf install python3 gcc python3-devel -y &>>$script_file
validate $? "installing Python 3 packages"

pip3 install -r requirements.txt &>>$script_file
validate $? "installing dependencies"

cp $script_dir/payment.service /etc/system/system/payment.service &>>$script_file
validate $? "copying payment service"

}

systemd_setup()
{

cp script_dir/$app_name.service /etc/system/system/$app_name.service
validate $? "copying $app_name service files"

systemctl daemon-reload &>>$script_file

systemctl enable $app_name
validate $? "enabling $app_name"

systemctl start $app_name
validate $? "starting $app_name"

}


print_time()
{

end_time=$(date +%s)
total_time=$(($end_time - $start_time))
echo -e "$y scriptexecuted successfully, time taken: $total_time seconds $n"

}