#!/bin/bash
set -e

PAGINA=$1

dnf install -y nginx

cp /tmp/$PAGINA.html /usr/share/nginx/html/index.html

mkdir -p /usr/share/nginx/html/backend1
mkdir -p /usr/share/nginx/html/backend2
cp /tmp/$PAGINA.html /usr/share/nginx/html/backend1/index.html
cp /tmp/$PAGINA.html /usr/share/nginx/html/backend2/index.html

restorecon -Rv /usr/share/nginx/html/

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

systemctl enable --now nginx
