echo ">>>>>>>>>>>>>>>> Create catalogue service <<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo ">>>>>>>>>>>>>>>> Create mongodb repo <<<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo ">>>>>>>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo ">>>>>>>>>>>>>>>> installing nodejs <<<<<<<<<<<<<<<<
yum install nodejs -y

echo ">>>>>>>>>>>>>>>> Create application user <<<<<<<<<<<<<<<<"
useradd roboshop

echo ">>>>>>>>>>>>>>>> Create application directory <<<<<<<<<<<<<<<<"
mkdir /app

echo ">>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo ">>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo ">>>>>>>>>>>>>>>> Download nodejs dependencies <<<<<<<<<<<<<<<<"
npm install

echo ">>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y

echo ">>>>>>>>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<<"
mongo --host mongodb.varundevops.online </app/schema/catalogue.js

echo ">>>>>>>>>>>>>>>> Start catalogue service <<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

