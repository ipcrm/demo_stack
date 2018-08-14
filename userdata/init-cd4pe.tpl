#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install -y yum-utils device-mapper-persistent-data lvm2 curl
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
chkconfig docker on
service docker start


echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
curl -k "https://master.inf.puppet.vm:8140/packages/current/install.bash" | sudo bash
