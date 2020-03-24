#!/bin/bash

######### Install dependencies #########
echo "Installing Ansible"
sudo easy_install pip
sudo pip install ansible

echo "Installing sshpass"
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/sshpass-1.06-2.el7.x86_64.rpm

##########################################

ansible-playbook -i workspaceInventory.yml --ask-vault-pass --extra-vars '@passwd.yml' -e "workspaceUser=$1 private_key_file=$2 dev_workspaces.yml