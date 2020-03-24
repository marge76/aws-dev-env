#!/bin/bash

# ######### Install dependencies #########
echo "Installing Ansible"
sudo easy_install pip
sudo pip install ansible

echo "Installing sshpass"
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/sshpass-1.06-2.el7.x86_64.rpm

echo "Running Ansible playbook"
# ########################################

#### Inventory file static template ####
read -r -d '' inventory_template << EOF
# This file is auto generated by shell script, be careful when making changes to this file

[all:vars]
ansible_user=centos
ansible_private_key_file='{{ private_key_file }}'
ansible_become_pass='{{ sudo_pass }}'

## Following config allows us to connect to the squid proxy tools server via bitbucket host i.e. jump server
[squid-proxy-tools:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q centos@bitbucket.tools.cedc.cloud"'

[vault-server]
vault.tools.cedc.cloud

[bitbucket-server]
bitbucket.tools.cedc.cloud 

[confluence-server]
confluence.tools.cedc.cloud 

[jenkins-server]
jenkins.tools.cedc.cloud 

[jira-server]
jira.tools.cedc.cloud

[squid-proxy-tools]
squid-tools.tools.cedc.cloud 

[squid-proxy-workspace]
squid-workspace.tools.cedc.cloud

##### OpenShift All-In-One Specific #####
[okd-server]
okd.test.cedc.cloud 

[registry-access] # add below all hostnames of servers that will access the Docker registry (Jenkins)
jenkins.tools.cedc.cloud

######################################### 

[workspaces]

###### DO NOT CHANGE #########
[localworkspace]
localhost ansible_connection=local
##############################


EOF
#######################################

###### Capture AWS credentials ########

echo "Please enter AWS Access Key:"
read AWS_ACCESS_KEY

echo "Please enter AWS Secret Key:"
read AWS_SECRET_KEY

echo "Please enter AWS Region e.g. eu-west-2 [default=eu-west-2]"
read AWS_REGION

# Check the region is not supplied empty, otherwise set it to default eu-west-1
if [ "$AWS_REGION" == "" ];then
        AWS_REGION="eu-west-1"
fi
#########################################

###### Capture Workspace details ########

echo "Please enter User name for worspaces (use comma to pass multiple values):"
read USERNAMES

echo "Please enter domain name of Active Directory"
read AD_DOMAIN

# Process comma separated list of users from command line
IFS=',' read -r -a array <<< $USERNAMES

# Loop through the array
for element in "${array[@]}"
do
    echo "Please enter workspace IP address of user ${element}"
    read ip_address

    echo "Please enter ssh password for user ${element}"
    read ssh_pass

    read -r -d '' workspaceUsers << EOF
    ${workspaceUsers}
    - $element
EOF

    read -r -d '' users << EOF
${users}
${ip_address} ansible_ssh_user=${AD_DOMAIN}\\\\${element} ansible_ssh_pass=${ssh_pass} ansible_become_pass=${ssh_pass}
EOF
done
##########################################

#### Generate workspaceusers.yml file ####
cat << EOF > workspaceUsers.yml
users:
    ${workspaceUsers}
EOF
echo "workspaceUsers.yml file created successfully"
##########################################

###### Generate inventory.yml file ########
cat << EOF > inventory.yml
${inventory_template}

[workspaces]
$users

###### DO NOT CHANGE #########
[localworkspace]
localhost ansible_connection=local
##############################
EOF
echo "inventory.yml file created successfully"
##########################################

ansible-playbook -i inventory.yml --ask-vault-pass --extra-vars '@passwd.yml' -e "workspaceUser=$1 private_key_file=$2 aws_access_key=${AWS_ACCESS_KEY} aws_secret_key=${AWS_SECRET_KEY} aws_region=${AWS_REGION}" dev_tools.yml