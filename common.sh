log=/tmp/roboshop.log

func_appprequ() {
   echo -e "\e[36m>>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<<\e[0m"
   useradd roboshop &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> cleanup existing application content <<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> download application content <<<<<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  cd /app
}

func_systemd() {
  echo -e "\e[36m>>>>>>>>>>>>>>> start ${component} service<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable  ${component} &>>${log}
  systemctl start  ${component} &>>${log}
}

func_nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Create mongo repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

func_appprequ

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> load user schema <<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.varundevops.online </app/schema/${component}.js &>>${log}

func_systemd
}

func_java() {
  echo -e "\e[36m>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<\e[0m"
  cp shipping.service /etc/systemd/system/shipping.service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install maven <<<<<<<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}

func_appprequ

  echo -e "\e[36m>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/ ${component}-1.0.jar  ${component}.jar &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install mysql client <<<<<<<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<\e[0m"
  mysql -h mysql.varundevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql

func_systemd
}