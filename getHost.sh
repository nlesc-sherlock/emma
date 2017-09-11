#!/bin/bash
#host_num=`calc ${NUM_HOSTS}-1 | sed 's/\t//g'`
host_num=0
host_name="$HOST_NAME$host_num"
port=2222
lines=`awk -v env_var=$NUM_HOSTS 'BEGIN { a=2; mul = a * env_var; print (mul + 4)}'`
#port=$( vagrant.exe ssh-config emma3 | grep Port | cut -d " " -f 4)
mkdir -p ${KEYS_LOCATION}/$host_name/
cp .vagrant/machines/$host_name/virtualbox/private_key ${KEYS_LOCATION}/$host_name/private_key
cp ${HOST_NAME}.key ${KEYS_LOCATION}/
chmod 600 ${KEYS_LOCATION}/$host_name/private_key
chmod 600 ${KEYS_LOCATION}/${HOST_NAME}.key
sudo ssh-keygen -f "/root/.ssh/known_hosts" -R [127.0.0.1]:$port 2> /tmp/err 1>/tmp/out
sudo sed -i 's/## vagrant-hostmanager-start.*//g' /etc/hosts
sudo sed -i 's/.*'"$HOST_NAME"'.*//g' /etc/hosts
sudo sed -i 's/## vagrant-hostmanager-end.*//g' /etc/hosts
sudo sed -i '/^\s*$/d' /etc/hosts
ssh -i ${KEYS_LOCATION}/$host_name/private_key ubuntu@127.0.0.1 -o StrictHostKeyChecking=no -p $port "tail -n $lines /etc/hosts" | sudo tee -a /etc/hosts
