source common.sh

if [ -z "$1" ]; then
  echo Password Input Missing
  exit
fi

MYSQL_ROOT_PASSWORD=$1

echo -e "${color} Disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>/tmp/backend.log
status_check

echo -e "${color} Enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y &>>/tmp/backend.log
status_check

echo -e "${color} Install nodejs 18 version \e[0m"
dnf install nodejs -y &>>/tmp/backend.log
status_check

echo -e "${color} Create backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>/tmp/backend.log
status_check

id expense &>>/tmp/backend.log
if [ $? -ne 0 ]; then
  echo -e "${color} Create user named expense for Application\e[0m"
  useradd expense &>>/tmp/backend.log
  status_check
fi

if [ ! -d /app ]; then
  echo -e "${color} Create directory called app for Application \e[0m"
  mkdir /app &>>/tmp/backend.log
  status_check
fi

echo -e "${color} Download backend application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>/tmp/backend.log
status_check

cd /app &>>/tmp/backend.log
echo -e "${color} Extract backend application content \e[0m"
unzip /tmp/backend.zip &>>/tmp/backend.log
status_check

echo -e "${color} Download nodejs dependencies \e[0m"
npm install &>>/tmp/backend.log
status_check

echo -e "${color} Install mysql client to load the Schema\e[0m"
dnf install mysql -y &>>/tmp/backend.log
status_check

echo -e "${color} Load the schema \e[0m"
mysql -h mysql-dev.vijayavanimanju.online -uroot -p${MYSQL_ROOT_PASSWORD} < /app/schema/backend.sql &>>/tmp/backend.log
status_check

echo -e "${color} Start backend service \e[0m"
systemctl daemon-reload &>>/tmp/backend.log
systemctl enable backend &>>/tmp/backend.log
systemctl start backend &>>/tmp/backend.log
status_check
