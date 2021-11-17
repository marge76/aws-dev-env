<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Welcome](#markdown-header-welcome)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

#  Quick Start

This is a condensed version of the longer instructions contained in this documentation. It should probably be considered happy path.

- Create a new AWS environment
- Clone this repository. Make a new branch off master for your team
- Find and replace <<team_name>> to a shortened lowercase version of your team name.
- Find and replace <<TEAM-NAME>> to a shortened uppercase version of your team name.
- Generated a new ssh key.
- Add the public key to vars.tf 'ec2_key_pair '.
- Set value of 'path_to_EC2_private_key' in vars.tf to path of privatekey
- Create a new IAM user with programatic access in AWS account called env-mgr - not Access Key and Secret Key.
- Update vars.tf with Access Key and Secret Key   !!!Do not push these secrets back to github!!!
- Enter in some new passwords for AD and windows machine in vars.tf
- accept/subscribe to the terms and conditions of any AMI's you will use. For example, if you want to use Centos 7 EC2s then you would - - have to go to this page
- install terraform
- Run terraform init —upgrade
- Run terraform plan
- Run terraform apply . (this should take 20-30 mins)

- it appears that the AD setup isn't working exactly so go to AWS console, find EC2 instance with name admanage and click connect
run the following:

```powershell
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $user = [adsi]"WinNT://localhost/Administrator,user"
  $user.SetPassword("myadminpassword")
  $user.SetInfo()
  netsh advfirewall firewall delete rule name="WinRM in"
  Write-Host "Restarting WinRM Service..."
  Stop-Service winrm
  Set-Service winrm -StartupType "Automatic"
  Start-Service winrm
  dism /online /enable-feature /all /featurename:Microsoft-Windows-GroupPolicy-ServerAdminTools-Update
  dism /online /enable-feature /all /featurename:ActiveDirectory-PowerShell
  dism /online /enable-feature /all /featurename:DirectoryServices-AdministrativeCenter
  dism /online /enable-feature /all /featurename:DirectoryServices-ADAM-Tools
  dism /online /enable-feature /all /featurename:DNS-Server-Tools
```
- Go to aws console, chose workspaces, create new workspace
- since the AD hasnt got any users in, create 1 workspace with your details. choose linux amazon vm
- once you get into your workspace install freerdp using yum
- also clone this repository and check out your branch so you have all your changes. NODE
- you then want to connect to the windows vm called ad-manage (find the ip address for this on aws console on ec2 page)
- run freerdp /v:admange.tools.<<team-name>>.cloud /d:ad /u:Admin /p:myadminpassword
- note if passwrod doesn't work, go to aws console, directory service, click on your directory, reset 'Admin' user password and then set your password
- you then need to get the powershell script ADSetup.ps1 and the groups and users csv files into that windows box (probably via an s3 bucket)
- at the bottom of ADSetup.ps1 are two lines which you will need to edit to point to the right AD, and csv files
- Run the script
- Once you have all the users created then you can go back to workspaces, create new workspace, chose your AD, click list all users, then select only the people who need VMs and create them some linux VMs.
- From the workspace, in the ansible folder create passwd.yml using ansible-Vault (you may need to install ansible)
```yaml
sudo_pass: password of you workspace user
bitBucketKeyStorePass: password1
jiraKeyStorePass: password1
postgresPassword: password1
okdUserPassword: okd-password
jenkinsAdminPass: jenkins-admin
okdAdminPassword: okd-admin
okdServicePassword: okd-service
```
- Run ./workspace.sh $(whoami) <<privkeytoec2>>
- Run ./pipeline.sh <<team-name>> cluster
- [First Time Setup of Tools](first-time-tools-setup.md) follow this to set up tools.

Each pathway must be followed in sequential order.

|         |  |  |
| :-------------: |:--:|:-------------:|
||<span style="font-size:20px">Start</span> | |
||[Before You Begin](before-you-begin.md) | |
||[Conventions Guide](conventions-guide.md) | |
||[Quick Reference](quick-reference.md) | |
||[AWS Overview](aws-overview.md) | |
| **Manual** |  | **Auto** |
|**&#8595;**| |**&#8595;**
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md)
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)   
| [Tools Manual Installation](tools-manual-installation.md)   | | [Tools Automatic Install](tools-automatic-installation.md)
| [Create a WorkSpace (Additional workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (Additional workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First Time Setup of Tools](first-time-tools-setup.md)
||[First Time Setup of WorkSpaces](first-time-workspaces-setup.md)
