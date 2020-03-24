#!/bin/bash

######### How to use this file #########

# This script should only be used if you need to recreate the Squid Proxy Service and update the certificates in the Tools VPC.
#
# This shell script will install and setup a SSL secured Squid proxy service on an EC2 accessible at squid-tools.tools.cedc.cloud.
# Once the service is up and running a root certificate will be generated from Vault and saved into your secure s3 bucket and the
# certificate store of the tools/hosts specified in the "Install Squid's root certificates to all tools EC2" task which is in the
# squid-tools.yml file.
#
# There are a few pre-requisites that need to be carried out before you can run this script:
#    1) Your Vault EC2 should be running and unsealed
#    2) For security purposes the EC2 you are installing the Squid Proxy on should not be directly accessible from a workspace,
#        so to get around this issue we SSH into an accessible EC2 on the same network e.g. Bitbucket as defined in the
#        [squid-proxy-tools:vars] section of our inventory.yml file. The Bitbucket EC2 must therefore be turned on and the
#        following commands need to be run to allow your Bitbuckets SSH service to use your EC2's SSH private key
#        - eval "$(ssh-agent)"
#        - ssh-add <your_private_key_file_location>
#    3) You will need to possibly update the variables in the following files if you have deviated form our initial installation:
#        - passwd.yml
#        - group_vars/all.yml
#        - roles/squid_certification_tools/vars/main.yml
#        - roles/squid-proxy/vars/main.yml
#
# Once all the pre-requisites have been carried out you can run this file using the following command:
#   sh squid-tools.sh <your_private_key_file_location>


######### Install dependencies #########
echo "Installing Ansible"
sudo easy_install pip
sudo pip install ansible

echo "Installing sshpass"
sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/sshpass-1.06-2.el7.x86_64.rpm

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

ansible-playbook -i inventory.yml --ask-vault-pass --extra-vars '@passwd.yml' -e "private_key_file=$1 aws_access_key=${AWS_ACCESS_KEY} aws_secret_key=${AWS_SECRET_KEY} aws_region=${AWS_REGION}" squid-tools.yml