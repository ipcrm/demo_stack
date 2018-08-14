#!/bin/bash
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

hostnamectl set-hostname cd4pe.inf.puppet.vm
echo '127.0.0.1  cd4pe.inf.puppet.vm cd4pe' > /etc/hosts

echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
curl -k "https://master.inf.puppet.vm:8140/packages/current/install.bash" | sudo bash

puppet agent -t
