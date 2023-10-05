log=/tmp/roboshop.log

func_exit_status() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
  fi
}

func_appprequ() {
  echo -e "\e[36m>>>>>>>>>>>>>>> create ${component} service <<<<<<<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> create application user <<<<<<<<<<<<<<<\e[0m"
  id roboshop &>>${log}
  if [ $? -ne 0 ]; then
   useradd roboshop &>>${log}
  fi
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> cleanup existing application content <<<<<<<<<<<<<<<\e[0m"
  rm -rf /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> create application directory <<<<<<<<<<<<<<<\e[0m"
  mkdir /app &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> download application content <<<<<<<<<<<<<<<\e[0m"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> Extract application content <<<<<<<<<<<<<<<\e[0m"
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  func_exit_status
}

func_systemd() {
  echo -e "\e[36m>>>>>>>>>>>>>>> start ${component} service<<<<<<<<<<<<<<<\e[0m"
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl start  ${component} &>>${log}
  func_exit_status
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
   echo -e "\e[36m>>>>>>>>>>>>>>> Install mongo client <<<<<<<<<<<<<<<\e[0m"
   yum install mongodb-org-shell -y &>>${log}
   func_exit_status

   echo -e "\e[36m>>>>>>>>>>>>>>> load user schema <<<<<<<<<<<<<<<\e[0m"
   mongo --host mongodb.varundevops.online </app/schema/${component}.js &>>${log}
   func_exit_status
 fi

  if [ "${schema_type}" == "mysql" ]; then
    echo -e "\e[36m>>>>>>>>>>>>>>> Install mysql client <<<<<<<<<<<<<<<\e[0m"
    yum install mysql -y &>>${log}
    func_exit_status

    echo -e "\e[36m>>>>>>>>>>>>>>> Load schema <<<<<<<<<<<<<<<\e[0m"
    mysql -h mysql.varundevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
    func_exit_status
 fi

}

func_nodejs() {
  log=/tmp/roboshop.log

  echo -e "\e[36m>>>>>>>>>>>>>>> Create mongo repo <<<<<<<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs <<<<<<<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}
  func_exit_status

 func_appprequ

  echo -e "\e[36m>>>>>>>>>>>>>>> Install nodejs dependencies <<<<<<<<<<<<<<<\e[0m"
  npm install &>>${log}
  func_exit_status

 func_schema_setup

 func_systemd
}

func_java() {
  echo -e "\e[36m>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<\e[0m"
  cp shipping.service /etc/systemd/system/shipping.service &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> Install maven <<<<<<<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}
  func_exit_status

 func_appprequ

  echo -e "\e[36m>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/ ${component}-1.0.jar  ${component}.jar &>>${log}
  func_exit_status

 func_schema_setup

 func_systemd
}

func_python() {
  echo -e "\e[36m>>>>>>>>>>>>>>> Create ${component} service <<<<<<<<<<<<<<<\e[0m"
  cp payment.service /etc/systemd/system/payment.service &>>${log}
  func_exit_status

  echo -e "\e[36m>>>>>>>>>>>>>>> Install python <<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status

  func_appprequ
  sed -i "s/rabbitmq_app_password/${rabbitmq_app_password}/" /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>>>>>>>> Build ${component} service <<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status

  func_systemd
}

