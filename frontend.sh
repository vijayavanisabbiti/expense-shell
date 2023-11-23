echo -e "\e[34m Installing Nginx \e[0m"
dnf install nginx -y

echo -e "\e[34m Copy Expense Config file \e[0m"
cp expense.conf /etc/nginx/default.d/expense.conf

echo -e "\e[34m Clean Old Nginx file \e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[34m Download Frontend application code \e[0m"
curl -o /tmp/frontend.zip https://expense-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[34m Extract the downloaded frontend code \e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[34m Restart Nginx service \e[0m"
systemctl enable nginx
systemctl restart nginx
