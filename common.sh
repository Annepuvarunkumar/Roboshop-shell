nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>> Create user service <<<<<<<<<<<<<<<\e[0m"
  cp $(component).service /etc/systemd/system/$(component).service &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Create mongo repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<<\e[0m"
  useradd roboshop &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> remove application directory <<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> download application content <<<<<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/$(component).zip https://roboshop-artifacts.s3.amazonaws.com/$(component).zip &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/$(component).zip &>>${log}
  cd /app

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}


  echo -e "\e[36m>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m"
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> load user schema <<<<<<<<<<<<<<<\e[0m"
  mongo --host mongodb.varundevops.online </app/schema/$(component).js &>>${log}

  echo -e "\e[36m>>>>>>>>>>>>>>> start user service <<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable $(component) &>>${log}
  systemctl restart $(component) &>>${log}
}