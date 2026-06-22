#!/bin/bash
set -e

dnf install -y haproxy
dnf update -y openssl openssl-libs openssh openssh-server

mkdir -p /etc/haproxy/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/haproxy/certs/proxy.key \
  -out    /etc/haproxy/certs/proxy.crt \
  -subj "/C=IT/ST=Roma/L=Roma/O=Lab/CN=proxy.local"

cat /etc/haproxy/certs/proxy.crt /etc/haproxy/certs/proxy.key > /etc/haproxy/certs/proxy.pem
chmod 600 /etc/haproxy/certs/proxy.pem

cp /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg

setsebool -P haproxy_connect_any 1

firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

haproxy -c -f /etc/haproxy/haproxy.cfg

systemctl restart sshd

systemctl enable --now haproxy
