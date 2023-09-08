log=/tmp/roboshop.log


echo -e "\e[36m>>>>>>>>>>>>>>> Create catalogue service <<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Create mongodb repo <<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> installing nodejs <<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Create application user <<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>>${log}
 
echo -e "\e[36m>>>>>>>>>>>>>>>> Create application directory <<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Create application directory <<<<<<<<<<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Download application content <<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>${log}
cd /app

echo -e "\e[36m>>>>>>>>>>>>>>>> Download nodejs dependencies <<<<<<<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.varundevops.online </app/schema/catalogue.js &>>${log}

echo -e "\e[36m>>>>>>>>>>>>>>>> Start catalogue service <<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>>${log}
systemctl enable catalogue &>>${log}
systemctl restart catalogue &>>${log}

