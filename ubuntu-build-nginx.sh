#!/bin/bash

# Install Nginx Reverse Proxy from Building Source

curl -fsSL https://nginx.org/keys/nginx_signing.key | sudo apt-key add -

echo "deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx
deb-src http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | sudo tee /etc/apt/sources.list.d/nginx.list

sudo "apt -y install install update-notifier-common"
sudo chown _apt:root /var/lib/update-notifier/package-data-downloads/partial/
sudo rm /var/lib/update-notifier/package-data-downloads/partial/*.FAILED
sudo "apt -y install --reinstall update-notifier-common"

mkdir -p /opt/rebuild-nginx && cd /opt/rebuild-nginx
sudo su -c "apt -y source nginx"
sudo su -c "apt-get build-dep nginx"

export VERSION=
cd /opt/rebuildnginx/nginx-$VERSION
sudo dpkg-buildpackage -b
ls -lah /opt/rebuildnginx

cat /opt/rebuild-nginx/nginx-$VERSION/debian/rules


sudo su -c "apt -y install nginx"
openssl dhparam -dsaparam -out /etc/nginx/ssl/dhparam.pem 4096
systemctl enable nginx.service && systemctl start nginx.service && sleep 2 && systemctl status nginx.service
nginx -c /etc/nginx/nginx.conf -t 
sudo systemctl restart nginx.service
touch /etc/nginx/sites-available/vhost
ln -s /etc/nginx/sites-available/vhost /etc/nginx/sites-enabled/

# Nginx Restart
systemctl --force restart nginx 
