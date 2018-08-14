#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install -y curl

echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
curl -k "https://master.inf.puppet.vm:8140/packages/current/install.bash" | sudo bash
