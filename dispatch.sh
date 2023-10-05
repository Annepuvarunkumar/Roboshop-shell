source common.sh

echo -e "\e[36m>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<\e[0m"
cp dispatch.service /etc/systemd/system/dispatch.service



echo -e "\e[36m>>>>>>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<\e[0m"
yum install golang -y




useradd roboshop
mkdir /app


curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app


unzip /tmp/dispatch.zip


cd /app


go mod init dispatch
go get
go build



systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch

