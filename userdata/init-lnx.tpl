#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum install -y curl

NAME=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

echo "${master_ip} master.inf.puppet.vm master" >> /etc/hosts
curl -k "https://master.inf.puppet.vm:8140/packages/current/install.bash" | sudo bash -s main:certname=$NAME

echo "target_env: ${target_env}" > /opt/puppetlabs/facter/facts.d/target_env.yaml

puppet agent -t 
