[<< Pathways](README.md)

# Automatic Installation of Tools 

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Key Occurrences](#markdown-header-key-occurrences)
    - [Vault](#markdown-header-vault)
    - [Yum](#markdown-header-yum)
- [Automatic Installation of Tools](#markdown-header-automatic-installation-of-tools)
        - [Manual Installation](#markdown-header-manual-installation)
    - [Prerequisites](#markdown-header-prerequisites)
    - [Ansible](#markdown-header-ansible)
        - [Background](#markdown-header-background)
        - [Copy your EC2Key into your WorkSpace](#markdown-header-copy-your-ec2key-into-your-workspace)
        - [Add private key to SSH Agent](#markdown-header-add-private-key-to-ssh-agent)
        - [Update the Scripts for your environment](#markdown-header-update-the-scripts-for-your-environment)
    - [Run Ansible](#markdown-header-run-ansible)
        - [Order of running the Ansible Scripts](#markdown-header-order-of-running-the-ansible-scripts)
        - [Installing and configuring Squid for Workspaces](#markdown-header-installing-and-configuring-squid-for-workspaces)
        - [Installing and configuring Squid for tools and install Dev tools](#markdown-header-installing-and-configuring-squid-for-tools-and-install-dev-tools)
- [Adding new workspaces](#markdown-header-adding-new-workspaces)
- [Pathways](#markdown-header-pathways)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Key Occurrences

There are a number of key occurrences one has to be aware of when running ansible to install and deploy the various tools. For guidance, these are listed below with a small explanation as to why they occur.

## Vault

- When running Ansible to install, set-up and secure vault, Ansible will only complete successfully if the script is run **once** on a clean EC2. If, after the installation of Vault Ansible tries to install/unseal vault, it will fail with a big error on the command line.

  The reason for this is because ansible has to unseal vault twice.

  * When the installation is new, and vault is not secured via SSL.

  * When the certificates have been installed and vault is fully secured via SSL.

  The commands used to unseal Vault are different and depend on whether vault is secured. These commands will fail if the command is only supposed to be used when vault is not-secure.

  If ansible has to be run multiple times, you must remove the vault installation task from the dev_tools.yml. This will stop the installation of vault from occurring and ansible should be able to run fine; without any errors.



- Vault seals itself if the EC2 it runs on is restarted or shut down. This should be scheduled to occur every evening. When sealed, any `curl` request sent to vault to get certificates will only return an error.
  
   Therefore, it is important that you check to make sure that vault is unsealed before running any commands that submit `curl` requests to vault.

   Your environment administrator will be able to unseal vault if required.

## Yum

Yum is updated on every EC2 instance when ansible is first run. This is to ensure that all the latest packages yum contains are available, including security updates.

 If the ansible script is stopped while updating yum, it cannot pick up from where it left off - therefore Ansible will throw an error. This also means that to carry on using the ansible scripts, new EC2 instances must be launched in your environment.
 
  To avoid this, **never** stop the ansible scripts via `ctl-c` until yum has finished updating.

# Automatic Installation of Tools

Ansible is open source software that automates software provisioning, configuration management, and application deployment. Ansible connects via SSH, remote PowerShell or via other remote APIs.

### Manual Installation

If you would prefer to install all of the Development Tools manually, then follow the [Manual Installation of Tools](./tools-manual-installation.md)
section instead of this one.

## Prerequisites

---

Before attempting this section please make sure:

1.  Your Ansible Scripts are saved in a location which you can access from your WorkSpace.
    For example, in a S3 bucket to which you have appropriate access permissions. You can see how to upload and download content to an S3 bucket on the
    [Storing content in S3](./quick-reference.md#storing-content-in-s3)

2.  You are using a **non-Windows** WorkSpace. If you are using a Windows Workspace, you will **not** be able to perform
    the automatic installation as Ansible cannot be run from a Windows machine.

    You will need to create
    another non-Windows WorkSpace or follow the manual steps [as described here](./tools-manual-installation.md).

3.  Ensure all your intended users are added to the AD and that the default passwords have been set.

4.  Ensure you have manually provisioned WorkSpaces for all the users you intend on having. The automated Ansible scripts will SSH into these WorkSpaces and will install tools needed, along with any restrictions. Therefore it is important that the WorkSpaces show as "available" in AWS Management console.

5.  Before running Ansible you will also need to go and change a security group for the workspaces. When you create your first WorkSpace AWS automatically create a security group for all WorkSpaces to use. Ansible SSH's into the WorkSpaces to install things and therefore port 22 needs to be opened. To do this follow the steps below:

    a. Log onto AWS Managment Console

    b. From the service menu select "EC2"

    c. From the left-hand navigation panel select "Security Groups"

    d. In the listed security groups look for a security group whose description is "Amazon WorkSpaces Security Group"

    e. Under the "Inbound" tab click "Edit"

    f. Click "Add Rule"

    g. For the type select "SSH"

    h. For the source enter the CIDR block for workspaces.

    i. Click "Save"

## Ansible

---

### Background

Ansible is a tool for automatically provisioning, installing and setting up software on remote servers. The Ansible scripts included in this documentation allow the user to:

- Install Atlassian Software (Jira, Bitbucket, Confluence), Hashicorp Vault, Jenkins and Sonatype Nexus.

  - All the above tools will be secured via TLS/HTTPS.

- Install a suite of Integrated Development Environments (IDEs) and other Development Tools on WorkSpaces - so that development can commence quickly and easily. The WorkSpaces will also:

  - Be secured using SSH certificates, so that only permitted users are allowed access.

  - Have restricted clipboard access (no copy and pasting in or out).

Please note, before running Ansible, you must have [fully configured the Active Directory](./setup-single-sign-on.md) and [provisioned WorkSpaces](./create-a-workspace.md).

### Copy your EC2Key into your WorkSpace

When you created the EC2 instances you will have had to provide/create a private key pair to access them. This script requires that key to be presented as a command line argument to run the script. You need to create a file e.g. ec2Key.pem and copy your private key into there

### Add private key to SSH Agent
Ansible will require the private key to be added to SSH agent so that it can successfully make a connection to the EC2 instance made for Tool's squid proxy.

Run following commands to add your private key to SSH agent
```
eval "$(ssh-agent)"
ssh-add <private_key_file_location >
```

### Update the Scripts for your environment

You will need the following:

1. Create a administrators password for all of the boxes. This will be encrypted and installed in an ansible-vault file we will
   pass to our ansible script

   a. Create the password file and when prompted enter a password that will be used to read/write to it

   ```
   ansible-vault create passwd.yml
   ```

   b. Edit the file and add the following, replacing "yourSudoPassword" with the admin password you would like your Servers to have

   ```
   sudo_pass: {password value}
   bitBucketKeyStorePass: {password value}
   jiraKeyStorePass: {password value}
   postgresPassword: {password value}
   ```

   c. Save the file and encrypt it

   ```
   ansible-vault encrypt passwd.yml
   ```


2. In both shell scripts (workspace.sh and squid.sh)- Amend the block that looks like following according to your setup. I.e. your domain names may be different for each of the tools listed below. Therefore carefully make relevant changes.

**These shell scripts can be opened for editing in any text editor/IDE.**


```
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

[nexus-server]
nexus.tools.cedc.cloud

[okd-server]
okd.test.cedc.cloud

[squid-proxy-tools]
squid-tools.tools.cedc.cloud

[squid-proxy-workspace]
squid-workspace.tools.cedc.cloud
```

## Run Ansible

Included in the automated Ansible scripts is a bash script which installs, and runs ansible. It also has various prompts which are required to allow Ansible to log onto the WorkSpaces and provision them with all the required tools and restrictions. Run the command below to run Ansible. Make sure you replace `{yourWorkspaceAccountName}` with the account name you logged in with and also change `{EC2SSHKeyLocation}` with the path to your EC2 SSH key.

### Order of running the Ansible Scripts

**For smooth operation, Ansible must be run in the order described below.**

<div style="color:yellow">

1. Installing and configuring Squid for Workspaces - Run Ansible playbook named Squid from {Workspace Squid EC2} to install Squid Proxy server for all workspaces.

2. Installing and configuring Squid for tools and install Dev tools- Run Ansible playbook named dev_tools. This playbook does following

    - Install Tool's squid proxy server and configure it 
    - Install Root CA certificate to each of the tools instances
    - Install Root CA certificate to each of the workspaces including the workspace where Ansible will be run from
    - Install development tools to all workspaces
</div>

### Installing and configuring Squid for Workspaces 

Squid is a proxy server which can control which websites your Workspaces and tools can access. The following script will
install and set up this proxy server configured with public domain blacklists created by the [blackweb project](https://github.com/maravento/blackweb).
Additionally a cron job will be created through this script which will run on your EC2 to update the list of blacklisted
websites once a week. 

You can add additional websites to the blacklist or whitelist by editing the roles/squid-proxy-lockdown/templates/squid.conf.j2 file
either before or after running this script. You will need to restart the squid service afterwards though. For more information
on updating this file please refer to the [squid.conf online documentation](https://www.pks.mpg.de/~mueller/docs/suse10.2/html/opensuse-manual_en/manual/sec.squid.configfile.html).

1. SSH into the EC2 instance which will run as a squid proxy server for workspaces

2. Run the shell script to call Ansible setup

```
sudo ./squid.sh {EC2SSHKeyLocation}
```
<span style="text-decoration:underline"> Wait for this task to complete before moving on to running further Ansible scripts.</div>

### Installing and configuring Squid for tools and install Dev tools

This playbook can be run from any workspace client. Open terminal on the workspace and run the following command from the directory where ansible scripts are stored.

```
sudo ./workspace.sh {yourWorkspaceAccountName} {EC2SSHKeyLocation}
```

That's it. Ansible should now run and install everything.


# Adding new workspaces

If you are adding new WorkSpaces to your environment, you should use the setupNewWorkspaces.sh shell script. This will 
install tools such as Java, Docker and VSCode as well as generate the required security certificates. 

The certificates needed to access the secured tools, e.g. Jenkins, will be placed in the /etc/ directory on the users WorkSpace. 
This certificate must be added to the 
[trust store of your internet browser.](./first-time-tools-setup.md#add-a-certificate-authority-to-the-browser).

A p12 certificate is required for the user to access a secured WorkSpace. This certificate is uploaded to an S3 bucket 
during the WorkSpace script setup. The S3 bucket is defined in group_vars/all.yml, the certificate will be stored in a 
file named after the user. The user will need to download the p12 certificate and 
[add the p12 to their computer's trusted certificate store](./first-time-workspace-setup.md#secure-access).

**Note this script will not generate certificates for Windows users. This has to be done manually**

Before running the script, you will need to update the following variables and files:


1. passwd.yml

    a. You will need to decrypt this file before you can edit it
    
    ```
    ansible-vault decrypt passwd.yml
    ```
        
    b.Then you will need to update the following variables in that file to give you something similar to:
    ```
    sudo_pass: <sudo-password for workspaces>
    AWS_ACCESS_KEY: <aws-access-key>
    AWS_SECRET_KEY: <your-aws-secret-key>
    AWS_REGION: <your-aws-region>
    ```

2. group_vars/all.yml - you will need to change the following to match your environment. 
    
    ```
    domain: tools.cedc.cloud
    bucketName: secureBucket
    vault:
      host: vault.{{ domain }}
      port: 8200
      cert_ttl: 8759h #must be less than when your Intermediate Certificate Authority expires otherwise your certificates will be empty
      role_name: dev_tools
      team_role_name: team
      int_ca: pki_int_cedc
      project_name: "cedc"
    ```

3. workspaceInventory.yml - Add the relevent details for the workspaces you want to update/install tools to e.g.

    ```
    # [workspaces]
    172.16.2.23 ansible_ssh_user=ad\\johnd ansible_ssh_pass=Changeit1! ansible_become_pass=Changeit1!
    172.16.2.80 ansible_ssh_user=ad\\janed ansible_ssh_pass=Changeit1! ansible_become_pass=Changeit1!
    
    # DO NOT CHANGE--------------------------
    [localworkspace]
    localhost ansible_connection=local
    # -----
    ```

4. workspaceUsers.yml - Add the users names here again as this will be traversed to create the relevent certificates e.g.

    ```
    users:
      - johnd
      - janed
    ```
    
5. Run the ansible script
    ```
    sudo ./setupNewWorkspaces.sh {yourWorkspaceAccountName} {EC2SSHKeyLocation}
    ```


<h1>Pathways</h1>

|         |  |  |
| :-------------: |:--:|:-------------:|
||[Before you begin](before-you-begin.md) | |
||[Conventions Guide](conventions-guide.md) | |
||[Quick Reference](quick-reference.md) | |
||[AWS Overview](aws-overview.md) | |
| **Manual** |  | **Auto** |
|**&#8595;**| |**&#8595;**
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md) 
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)  
|[Tools Manual Installation](tools-manual-installation.md)  | | ***Tools Automatic Install***
| [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First time setup of tools](first-time-tools-setup.md)
||[First time setup of workspaces](first-time-workspaces-setup.md)


[<< Setup Single Sign-On (SSO)](setup-single-sign-on.md)

[First time setup of tools >>](first-time-tools-setup.md)
