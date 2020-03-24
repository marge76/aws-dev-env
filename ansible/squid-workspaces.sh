#!/bin/bash

######### How to use this file #########

# This script should only be used if you need to recreate the Squid Proxy Service and certificates in the Workspace VPC
# for any reason or if you need to setup a new Proxy server for the Workspace environment that you didn't do previously.
#
# This shell script will install and setup a SSL secured Squid proxy service on an EC2 accessible at squid-workspace.tools.cedc.cloud.
# Once the service is up and running a root certificate will be generated from Vault and saved into your secure s3 bucket.
#
# There are a few pre-requisites that need to be carried out before you can run this script:
#    1) Your Vault EC2 should be running and unsealed
#    2) The private subnets for your Workspace VPC should change their target for traffic destined for 0.0.0.0 to a NAT gateway.
        This is because you will need internet access to get the service and Workspaces setup.
#    3) You will need to possibly update the variables in the following files if you have deviated form our initial installation:
#        - passwd.yml
#        - group_vars/all.yml
#        - roles/squid-proxy/vars/main.yml
#
# Once all the pre-requisites have been carried out you can run this file using the following command:
#   sh squid-workspaces.sh <your_private_key_file_location>
#
# Following the successful running of this script the der file placed in the secure s3 bucket will need to be added to the
# certificate store of your users workspaces. This can be done using commands similar to the following (note that the location
# of your ca-trust may differ depending on the Workspace type you are using):
#   1) sudo yum install ca-certificates
#   2) sudo cp ~/Downloads/root_cert_squid_workspace.der /etc/pki/ca-trust/source/anchors/root_cert_squid_workspace.der
#   3) sudo update-ca-trust force-enable
#   4) sudo update-ca-trust extract
#
# Finally after all Workspaxce users have done the previous commands, you will have to update the route tables for your
# Workspace's private subnets. The traffic destined for 0.0.0.0 should now target your Squid Proxy Workspace EC2 and the
# NAT gateway you created should be deleted.

######### Install dependencies #########
echo "Installing Ansible"
sudo easy_install pip
sudo pip install ansible

echo "Installing sshpass"
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/sshpass-1.06-2.el7.x86_64.rpm

echo "Running Ansible playbook"
########################################

#### Inventory file static template ####
read -r -d '' inventory_template << EOF
[all:vars]
ansible_user=centos
ansible_private_key_file='{{ private_key_file }}'
ansible_become_pass='{{ sudo_pass }}'

[squid-proxy-workspace]
squid-workspace.tools.cedc.cloud pid_file_path="/var/run/squid.pid"

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

###### Generate inventory.yml file ########
cat << EOF > inventory-squid.yml
${inventory_template}
EOF
echo "inventory-squid.yml file created successfully"
##########################################

ansible-playbook -i inventory-squid.yml --ask-vault-pass --extra-vars '@passwd.yml' -e "private_key_file=$1 aws_access_key=${AWS_ACCESS_KEY} aws_secret_key=${AWS_SECRET_KEY} aws_region=${AWS_REGION}" squid.yml