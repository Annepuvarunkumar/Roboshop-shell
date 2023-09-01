echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<
yum install nodejs -y

echo "<<<<<<<<<< hello world >>>>>>>>>>"echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
npm install

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
mongo --host mongodb.varundevops.online </app/schema/catalogue.js

echo ">>>>>>>>>>>>>>>> hello world<<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

