[<< Pathways](README.md)


# Manual Installation of Tools

This section describes how to install the following tools onto Centos/Linux OS based EC2 instances: Jenkins, PostgreSQL, 
Jira, BitBucket, Confluence, Nexus and HashiCorp Vault. It also covers how to secure these tools so they can only be 
accessed over SSL.

Steps for Downloading onto Windows based EC2's has not currently been added.

### Automatic Installation
If you would prefer to run a script to install the necessary tools then follow the [Automatic Installation of Tools](tools-automatic-installation.md) 
section instead. This is recommended as the script completes quicker than a manual installation would take.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Installing Jenkins](#markdown-header-installing-jenkins)
    - [Prerequisites](#markdown-header-prerequisites)
    - [Download Jenkins](#markdown-header-download-jenkins)
    - [Unlock Jenkins](#markdown-header-unlock-jenkins)
- [Installing Jira](#markdown-header-installing-jira)
    - [Prerequisites](#markdown-header-prerequisites_1)
    - [Download Jira](#markdown-header-download-jira)
- [Installing Bitbucket](#markdown-header-installing-bitbucket)
    - [Prerequisites](#markdown-header-prerequisites_2)
    - [Download Bitbucket](#markdown-header-download-bitbucket)
- [Installing Confluence](#markdown-header-installing-confluence)
    - [Prerequisites](#markdown-header-prerequisites_3)
    - [Downloading Confluence](#markdown-header-downloading-confluence)
- [Installing Nexus OSS](#markdown-header-installing-nexus-oss)
    - [Prerequisites](#markdown-header-prerequisites_4)
    - [Downloading Nexus](#markdown-header-downloading-nexus)
- [Installing HashiCorp Vault](#markdown-header-installing-hashicorp-vault)
    - [Prerequisites](#markdown-header-prerequisites_5)
    - [Installing Vault](#markdown-header-installing-vault)
    - [Useful Vault actions](#markdown-header-useful-vault-actions)
        - [Unseal Vault](#markdown-header-unseal-vault)
        - [Build your own Certificate Authority (CA)](#markdown-header-build-your-own-certificate-authority-ca)
        - [Creating roles](#markdown-header-creating-roles)
        - [Generate and Retrieve Certificates](#markdown-header-generate-and-retrieve-certificates)
- [Configure Tools over SSL](#markdown-header-configure-tools-over-ssl)
    - [OPTIONAL: Add keytool to the executable path](#markdown-header-optional-add-keytool-to-the-executable-path)
    - [Vault](#markdown-header-vault)
    - [Bitbucket](#markdown-header-bitbucket)
    - [Confluence](#markdown-header-confluence)
    - [Jenkins](#markdown-header-jenkins)
    - [Jira](#markdown-header-jira)
    - [Nexus](#markdown-header-nexus)
- [Additional Software installation guides](#markdown-header-additional-software-installation-guides)
    - [Updating YUM](#markdown-header-updating-yum)
    - [Installing Java 8 JDK](#markdown-header-installing-java-8-jdk)
    - [Installing Git](#markdown-header-installing-git)
    - [Installing wget](#markdown-header-installing-wget)
    - [Installing unzip](#markdown-header-installing-unzip)
    - [Installing jq tool](#markdown-header-installing-jq-tool)
- [Installing PostgreSQL 9.6](#markdown-header-installing-postgresql-96)
- [Prepare a PostgreSQL Database for Atlassian Tools to use](#markdown-header-prepare-a-postgresql-database-for-atlassian-tools-to-use)
- [Pathways](#markdown-header-pathways)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Installing Jenkins

## Prerequisites


1.  Yum must be updated as outlined in section: [Update YUM](#updating-yum)

2.  Java 8 JDK must have been installed as outlined in section [Installing Java 8 JDK](#installing-java-8-jdk)

3.  Git must have been installed as outlined in section [Installing Git](#installing-git)

4.  wget must have been installed as outlined in section [Installing wget](#installing-wget)

5.  Recommended system requirements for Jenkins to run are "a multicore
    CPU with at least 3GB of RAM and disk write speed \>= 7200 RPM".
    **T2.micro EC2 instances are not powerful enough to run a Jenkins
    server.**
6.  The EC2 you are going to install Jenkins on must temporarily allow inbound traffic on port 8080. We need so we can check the installation is successful. Jenkins will be secured via SSL in a later step and will use 
    port 8443, hence we will close port 8080 later.

## Download Jenkins 

1.  Connect via SSH to the desired EC2 instance where you want to install Jenkins. Steps on how to do this can be found [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)

2.  Run the following commands

    ```
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    ```
    
    ```
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    ```
    
    ```
    yum install jenkins 
    ```
    
    ```
    sudo systemctl start jenkins 
    ```

## Unlock Jenkins

1.  From the browser in your WorkSpace navigate to the IP address or domain of
    your EC2 instance running Jenkins followed by the port number 8080.
    
    For example, if your EC2 had a domain name of jenkins.tools.cedc.cloud then you could use:

    ```
    http://jenkins.tools.cedc.cloud:8080   OR    http://172.26.1.216:8080
    ```

    ![](./images/settingupjenkinsforthefirsttime1.png)

2.  To access Jenkins, you will need your initial Admin password.
    Luckily the page tells you where to find this. Therefore, run the
    following command in the EC2 instance running Jenkins:

    ```
    sudo vi /var/lib/jenkins/secrets/initialAdminPassword
    ```

3.  Copy the password

4.  Enter it into the field on the webpage

5.  Select "Install Suggested Plugins" and wait for Jenkins to finish the installation

    ![](./images/settingupjenkinsforthefirsttime2.png)

6.  Create your first admin user by filling out the required
    information.

    **NB: This is the admin account which is needed to set up Jenkins. All
    other users and admins should be created and managed through the Active
    Directory.**

    ![](./images/settingupjenkinsforthefirsttime3.png)

7.  Click "Save and Continue"

8.  Click "Save and Finish"

# Installing Jira

## Prerequisites

1.  wget must have been installed as outlined in section [Installing wget](#installing-wget)

2.  PostgreSQL must have been installed as outlined in section [Installing PostgreSQL 9.6](#installing-postgresql-96) 

3.  Recommended system requirements for Jira to run are "a multicore CPU
    with at least 2GB of RAM and disk write speed \>= 7200 RPM".
    T2.micro EC2 instances are not powerful enough to run a Jira server.

4. The EC2 you are going to install Jira on must temporarily allow inbound traffic on port 8080. We need this adding
   so we can check the installation is successful. Jira will be secured via SSL in a later step and so will use
   port 8443 which is why we close port 8080 later.

## Download Jira

1.  Connect via SSH to the desired EC2 instance where you want to install Jira. Steps on how to do this can be found [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace).

2.  Download the Jira installation file

    ```
    wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.12.3-x64.bin
    ```

3.  You need to make the installation file executable

    ```
    chmod +x atlassian-jira-software-7.12.3-x64.bin
    ```

4.  You now need to run the file

    ```
    sudo ./atlassian-jira-software-7.12.3-x64.bin
    ```

5.  The Jira installation will now proceed. Follow the on-screen prompts
    to continue with the installation. Choose "express installation" when
    prompted.

6.  Once the installation has completed, Jira should have started. Just in-case it isn't running though you can start it using the following command:

    ```
    service jira start
    ```

    **NB If you ever need to stop Jira then you can use "service jira stop"**
    
7.  From the browser in your WorkSpace navigate to the IP address or domain of your EC2 instance running Jira followed 
    by the port number 8080. This should show you your Jira instance has been installed correctly and is running.
        
    For example, if your EC2 had a domain name of jira.tools.cedc.cloud then you could use:
    
    ```
    http://jira.tools.cedc.cloud:8080  
    ```

# Installing Bitbucket

## Prerequisites


1.  wget must have been installed as outlined in section [Installing wget](#installing-wget)

2.  PostgreSQL must have been installed as outlined in section [Installing PostgreSQL 9.6](#installing-postgresql-96) 

3.  Git v2.2.0 or later must be installed as outlined in section [Installing Git](#installing-git)

4.  The recommended system requirements for Bitbucket to run are "a
    multicore CPU with at least 3GB of RAM with disk write speed \>=
    7200 RPM". T2.micro EC2 instances are not powerful enough to run a
    Bitbucket server.
    
5.  The EC2 you are going to install Bitbucket on must temporarily allow inbound traffic on port 7990. We need this adding
    so we can check the installation is successful. Jira will be secured via SSL in a later step and so will use
    port 8443 which is why we close port 7990 later.

## Download Bitbucket

1.  Connect via SSH to the desired EC2 instance where you want to install BitBucket. Steps on how to do this can be found [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace).

2.  Download the Jira installation file:

    ```
    wget https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-5.15.0-x64.bin
    ```

3.  You need to make the installation file executable

    ```
    sudo chmod +x atlassian-bitbucket-5.15.0-x64.bin 
    ```

5.  You now need to run the file

    ```
    sudo ./atlassian-bitbucket-5.15.0-x64.bin 
    ```

6.  Follow the on-screen prompts. Install a server version of Bitbucket with a "clean installation".

7.  Once the installation has completed, Bitbucket should have started. Just in-case it isn't running though you can start it using the following command:

    ```
    service bitbucket start
    ```
    **NB If you ever need to stop Bitbucket then you can use "service bitbucket stop"**
 
8.  From the browser in your WorkSpace navigate to the IP address or domain of your EC2 instance running Bitbucket followed 
    by the port number 7990. This should show you your BitBucket instance has been installed correctly and is running.
        
    For example, if your EC2 had a domain name of bitbucket.tools.cedc.cloud then you could use:
    
    ```
    http://bitbucket.tools.cedc.cloud:7990   
    ```

# Installing Confluence

## Prerequisites

1.  wget must have been installed as outlined in section [Installing wget](#installing-wget)

2.  PostgreSQL must have been installed as outlined in section [Installing PostgreSQL 9.6](#installing-postgresql-96) 

3.  The recommended system requirements for Confluence to run are "a
    multicore CPU with at least 2GB of RAM with disk write speed \>=
    7200 RPM". T2.micro EC2 instances are not powerful enough to run a
    Confluence server.
    
4. The EC2 you are going to install Confluence on must temporarily allow inbound traffic on port 8090. We need this adding
   so we can check the installation is successful. Confluence will be secured via SSL in a later step and so will use
   port 8443 which is why we close port 8090 later.

## Downloading Confluence

1.  Connect via SSH to the desired EC2 instance where you want to install Confluence. [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace).

2.  Download Confluence

    ```
    wget <https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-6.12.1-x64.bin>
    ```

3.  Make the installation file executable

    ```
    chmod +x atlassian-confluence-6.12.1-x64.bin 
    ```

4.  Run the file

    ```
    sudo ./atlassian-confluence-6.12.1-x64.bin 
    ```
    
5.  Follow the on-screen prompts and this should install Confluence

6.  Once the installation has completed, Confluence should have started. Just in-case it isn't running though you can start it using the following command:

    ```
    sudo /etc/init.d/confluence start  
    ```
    **NB If you ever need to stop Confluence then you can use "sudo /etc/init.d/confluence stop "**
 
7.  From the browser in your WorkSpace navigate to the IP address or domain of your EC2 instance running Confluence followed 
    by the port number 8090. This should show you your Confluence instance has been installed correctly and is running.
        
    For example, if your EC2 had a domain name of confluence.tools.cedc.cloud then you could use:
    
    ```
    http://confluence.tools.cedc.cloud:8090   
    ```

# Installing Nexus OSS

## Prerequisites

1. wget must have been installed as outlined in section [Installing wget](#installing-wget)

2. The EC2 you are going to install Nexus on must temporarily allow inbound traffic on port 8081. We need this adding
   so we can check the installation is successful. Nexus will be secured via SSL in a later step and so will use
   port 8443 which is why we close port 8081 later.

## Downloading Nexus

1.  Install Oracle Java Runtime Environment (JRE) 8

    a.  Go to <https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html>
        and find a version of the JRE that you would like to download for your operating system

    b.  Accept the license agreement for that JRE and you should get a
        "Thank you for accepting" message as shown below

    ![](./images/LA_JRE.png)

    c.  Then right-click the version you want to download and click "Copy link"

    ![](./images/Download_JRE.png)

    d. Connect via SSH to the desired EC2 instance where you want to install Nexus. Steps on how to do this can be 
        found [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)

    e.  Download the JDK onto the Nexus EC2. Replace "{jdkVersionLink}" with the one your copied earlier
    ```
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" {jdkVersionLink}
    ```
       
    f. Run the installation    
    ```
    sudo rpm -Uvh jdk-8u191-linux-x64.rpm
    ```
2.  Add the appropriate tools to download and run Nexus
    ```
    sudo dhclient
    ```

3.  Find a version of Nexus you would like to download from
    <https://help.sonatype.com/repomanager3/download/download-archives---repository-manager-3>
    or just use the latest one as we have done in the following example.

4.  Download and unpackage Nexus into the appropriate directory. Replace
    the {nexusVersion} with whatever version you would like to
    download e.g. 3.14.0-04
    ```
    wget https://download.sonatype.com/nexus/3/{nexusVersion}.tar.gz
    ```
    ```
    tar xvzf latest-unix.tar.gz
    ```
    ```
    sudo mv nexus-{nexusVersion} /opt/nexus
    ```
    ```    
    sudo mv sonatype-work /opt/
    ```
    
5.  Make sure the Nexus is up and running correctly. Note this could take a couple of minutes.
    a. Start the service manually
    ```
    /opt/nexus/bin/nexus start
    ```
    
    b.  In your WorkSpace navigate to your servers IP address or domain
        at port 8081 and you should see your Nexus Repository up and
        running e.g. if your Nexus EC2's domain is nexus.tools.cedc.cloud use:
    ```
    http:/nexus.tools.cedc.cloud:8081
    ```
    ![](./images/Nexus.png)

6.  We can set Nexus up as a system service now that we have verified
    that it works correctly
    
    a. Set the NEXUS_HOME environmental variable
    ```
    echo 'export NEXUS_HOME="/opt/nexus/"' >> $HOME/.bashrc
    ```
    
    b. Edit the nexus.rc file and add the name of the user you want to run the service e.g. run\_as\_user=\"centos\"
    ```
    vi /opt/nexus/bin/nexus.rc
    ```
    
    c. Add the necessary details telling the EC2 how to run the service

    ```
    sudo vi /etc/systemd/system/nexus.service
    ```
    
    Copy the following into that file:
    
    ```
        [Unit]
        Description=nexus service\
        After=network.target

        [Service]
        Type=forking
        LimitNOFILE=65536
        ExecStart=/opt/nexus/bin/nexus start
        ExecStop=/opt/nexus/bin/nexus stop
        User=centos
        Restart=on-abort

        [Install]
        WantedBy=multi-user.target
    ```
    d. Start the service

    ```
    sudo systemctl daemon-reload
    ```
    ```
    sudo systemctl enable nexus.service
    ```
    ```
    sudo systemctl start nexus.service
    ``` 

7. Connect to Nexus UI through the browser again and verify that your repository is up and running. The service 
    may take a few minutes to start-up and run.

    ![](./images/Nexus2.png)


# Installing HashiCorp Vault

Vault allows you to centrally store, access, and distribute secrets like
API keys, AWS IAM/STS credentials, SQL/NoSQL databases, X.509
certificates, SSH credentials, etc.

## Prerequisites

1.  wget must have been installed as outlined in section [Installing wget](#installing-wget)

2.  PostgreSQL must have been installed as outlined in section [Installing PostgreSQL 9.6](#installing-postgresql-96) 

3.  unzip must have been installed as outlined in section [Installing unzip](#installing-unzip) 

4.  jq must have been installed as outlined in section [Installing jq](#installing-jq-tool) 

5.  Recommended system requirements for Vault to run are "a multicore
    CPU with at least 3GB of RAM and disk write speed \>= 7200 RPM".
    T2.micro EC2 instances are not powerful enough to run a Vault
    server.

## Installing Vault

1.  Connect via SSH to the desired EC2 instance where you want to install Vault. Steps on how to do this can be 
    found [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)

2.  Download Vault

    ```
    wget https://releases.hashicorp.com/vault/0.11.4/vault_0.11.4_linux_amd64.zip
    ```

3.  Unzip the file

    ```
    unzip vault_0.11.4_linux_amd64.zip 
    ```

4.  Move vault to the usr/local/bin directory that should be on your
    computers PATH

    ```
    sudo mv vault /usr/local/bin/vault 
    ```

5.  Having the executable in a folder on your system's PATH should allow
    the command to be accessed from the command line. To verify you have
    installed correctly run the following command and you should not get
    some command information instead of "Command not found"

    ```
    vault 
    ```

    ![](./images/installing_vault_1.png)

6.  You need to enable the **mlock** operation. This stops any memory from
    being swapped to disk, which is what you would want unless you plan on making Vault use encrypted
    swaps or no swaps at all.

    ```
    sudo setcap cap_ipc_lock=+ep \$(readlink -f \$(which vault)) 
    ```

#### Setup your database

1.  Edit pg_hba.conf and change "peer" and "md5" to "trust" near the bottom of file 

    ```
    sudo vi /var/lib/pgsql/9.6/data/pg_hba.conf 
    ```

2. Run the following commands to create a table that Vault needs

    ```
    sudo systemctl restart postgresql-9.6.service 
    ```
    
    ```
    sudo passwd postgres
    ```
    
    ```
    sudo su postgres 
    ```
    
    ```
    sudo psql postgres 
    ```
    
    ```
    \c postgres
    ```
    
    ```
    CREATE TABLE vault_kv_store ( 
      parent_path TEXT COLLATE "C" NOT NULL, 
      path        TEXT COLLATE "C",   
      key         TEXT COLLATE "C",  
      value       BYTEA, 
      CONSTRAINT pkey PRIMARY KEY (path, key) 
    );
    ```

    ```
    CREATE INDEX parent_path_idx ON vault_kv_store (parent_path); 
    ```
 
 3. Create a role. Replace {dbuser} and {dbPassword} with your own values
    ```
    CREATE ROLE {dbuser} WITH LOGIN PASSWORD {dbPassword}; 
    ```
    
    ```
    ALTER ROLE {dbuser} SUPERUSER; 
    ```
    
    ```
    \q
    ```
    
    ```
    exit
    ```

#### Create appropriate directories for the service

```
cd /opt/ 
```

```
sudo mkdir /etc/vault 
```

```
sudo mkdir /vault-data 
```

```
sudo mkdir -p /logs/vault/ 
```

#### Create a config file for your server

A server is built by Vault based on a configuration file you provide.
They allow you to customise the listening addresses, storage mechanisms,
security features and more. You can find more about the [available
configuration options
here.](https://www.vaultproject.io/docs/configuration/index.html)

1.  Run the following commands

    ```
    sudo vi /etc/vault/config.json 
    ```

2.  Copy and paste the following into that file. Replace the {vaultAddress} with the IP address or domain name of your EC2 instance, 
    and the {dbuser} and {dbPassword} with the values you used earlier.

    *{*\
    *\"listener\": \[{*\
    *\"tcp\": {*\
    *\"address\" : \"0.0.0.0:8200\",*\
    *\"tls_disable\" : 1*\
    *}*\
    *}\],*\
    *\"api_addr\": \"<http://127.0.0.1:8200>\",*\
    *\"storage\": {*\
    *\"postgresql\": {*\
    *\"connection_url\":*\
    *\"postgresql://{dbuser}:{dbPassword}\@localhost:5432/postgres?sslmode=disable\"*\
    *}*\
    *},*\
    *\"max_lease_ttl\": \"10h\",*\
    *\"default_lease_ttl\": \"10h\",*\
    *\"ui\":true*\
    *}*

#### Configure the service

1.  Open the vault.services file

    ```
    sudo vi /etc/systemd/system/vault.service 
    ```

2.  Copy and paste this code into that file which will define the
    service and use the directories we previously created:

    *[Unit\]*\
    *Description=vault service*\
    *Requires=network-online.target*\
    *After=network-online.target*\
    *ConditionFileNotEmpty=/etc/vault/config.json*\
    \
    *\[Service\]*\
    *EnvironmentFile=-/etc/sysconfig/vault*\
    *Environment=GOMAXPROCS=2*\
    *Restart=on-failure*\
    *ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.json*\
    *StandardOutput=/logs/vault/output.log*\
    *StandardError=/logs/vault/error.log*\
    *LimitMEMLOCK=infinity*\
    *ExecReload=/bin/kill -HUP \$MAINPID*\
    *KillSignal=SIGTERM*\
    \
    *\[Install\]*\
    *WantedBy=multi-user.target*

3.  Run the following commands to enable the Vault service. Change {vaultAddress} to your domain/IP address where 
    your Vault EC2 resides
    
    ```
    sudo systemctl start vault.service 
    ```
    
    ```
    sudo systemctl status vault.service 
    ```
    
    ```
    sudo systemctl enable vault.service 
    ```
    
    ```
    export VAULT_ADDR=http://{vaultAddress}:8200
    ```
    
    ```
    echo "export VAULT_ADDR=http://{vaultAddress}:8200" >> ~/.bashrc
    ```

## Useful Vault actions
Useful actions you may need to repeat. For example, Vault becomes sealed when the EC2 shuts down.
You will have to unseal it before it can be used. 

### Unseal Vault

Vault becomes sealed when the EC2 shuts down as a security precaution. You will have to unseal it 
before it can be used.

1.  Run the following commands

    ```
    sudo mkdir /etc/vault 
    ```
    
    ```
    sudo touch /etc/vault/init.file 
    ```
    
    ```
    sudo chmod 755 /etc/vault/init.file 
    ```
    
    ```
    vault operator init > /etc/vault/init.file 
    ```
    
    ```
    cat /etc/vault/init.file 
    ```

2.  Copy the "Initial Root Token" provided as you will need this to
    login to Vault

3.  Get 3 of the 5 unseal keys printed to the terminal and repeat the following command 3 times, each time with a 
    with a different unseal key.

    ```
    vault operator unseal [sealKey] 
    ```

4.  Vault should now be unsealed and you should be presented with some additional information including your unseal key
    and Root Token. Copy the root token.

5.  Go back to your WorkSpace and navigate to http://{vaultAddress}:8200/ui/ 

6.  The Vault authentication screen should show if your Vault setup
    worked correctly. You can log in to Vault as the Root user by providing the Root Token you
    copied in one of the previous steps

### Build your own Certificate Authority (CA)

#### Via the Vault UI

##### Create Root CA

1.  From your WorkSpace navigate to
    <http://{vaultAddress}:8200/ui/>

2.  Navigate to Secrets in the top menu

    ![](./images/own_cert_auth_1.png)

3.  Click "Enable new engine"

4.  Select "PKI" for the Secrets Engine Type

5.  Enter a Path for the secrets engine which will also be its name e.g. ca_root

6.  Change the default and maximum TTL to 30 days. This is a test
    certificate, so we will only be using 30 days for the TTL. You would
    normally use more e.g. 365 days

7.  Click "Enable Engine"

    ![](./images/own_cert_auth_2.png)

8.  To create a root certificate, click the "Certificates" tab

9.  Click "Configure" in the top right

    ![](./images/own_cert_auth_3.png)

10. Click "Configure CA"

    ![](./images/own_cert_auth_4.png)

11. Fill in the form. As a minimum, you should update the Common Name,
    TTL, Key bits sections, OU and Organisational fields and leave the
    rest as defaults. Below is an example of what you could put in these
    fields. Once you are done click "Save" and you will receive your CA
    certificate.

    ![](./images/own_cert_auth_5.png)

##### Create an Intermediate CA

1.  To enable an intermediate secret engine, navigate to "Secrets" in
    the top menu

2.  Click "Enable new engine"

3.  Enter a Path for the secrets engine which will also be its name e.g. ca_int_1

4.  Change the default and maximum TTL to 25 days. This is going to be
    an intermediate certificate for the ca_root secrets engine we just
    created, and because of that the TTL must be less than the ca_roots
    TTL.

5.  Click "Enable Engine"

    ![](./images/EnableEngine.png)

6.  Click the "Certificates" tab

7.  Click "Configure" in the top right

    ![](./images/configure.png)

8.  Click "Configure CA"

    ![](./images/configureca.png)

9.  Fill in the form. As a minimum, you should update the Common Name,
    TTL, Key bits sections, OU and Organisational fields and leave the
    rest as defaults. Below is an example of what you could put in these
    fields

    ![](./images/CAcertificate.png))

10. Click "Save" and this should generate a CSR.

    ![](./images/csr.png)

11. The certificate needs to be signed by it's parent certificate e.g.
    ca_root

12. Click "Copy CSR"

13. Click "Secrets" at the top to go back to see your active Secrets
    Engines

14. Click your Root Secret Engine e.g. ca_root

    ![](./images/Certificates.png)

15. Go to the "Certificates" tab and click "Configure" in the top right
    corner

    ![](./images/Interconfigure.png)

16. Click "Sign intermediate" and paste the CSR you just copied into the
    box that opens

    ![](./images/Signintermediate.png)

17. Update the TTL to 25 days and add the OU and Organisation

    ![](./images/TTLOU.png)

18. Click "Save" which should display a signed CSR.

19. Click "Copy Certificate"

20. Navigate to the "Secrets" -\> "ca_int_1" -\> "Certificates" page

21. Then click "Set Signed Intermediate"

    ![](./images/Signintermediate.png)

22. You should receive a brief confirmation message

    ![](./images/Confirmation.png)
    
23. You should download this Intermediate Authorities certificate and save it somewhere where you can easily distribute
    it to other users and machines that will need to download it. 

#### Via the CLI API

On your WorkSpace, if you want to use the Vault API tools then you will have to install the Vault binary and add
it to the classpath like we did on the Vault EC2. Then you need to set the Vault address on here too e.g.     
```
echo "export VAULT_ADDR=http://{vaultAddress}:8200" >> ~/.bashrc
```


##### Login to Vault

1.  Run the following commands. {token} needs replacing with your authentication token which can be your Root token.

    ```
    vault login {token} 
    ```
    If LDAP is setup then you can use the following command to log in to vault. You should replace {yourUserName} with your LDAP user name.
    
    ```
    vault login -method=ldap username={yourUserName}
    ```

2.  Enter password when prompted

#### Create a Root CA

1.  Enable pki engine

    ```
    vault secrets enable --path=ca_root pki 
    ```

2.  Tune the certificates to have a maximum time to live

    ```
    vault secrets tune -max-lease-ttl=87600h ca_root 
    ```

3.  Generate the root certificate and save it CA_cert.crt. This will
    generate a self-signed CA certificate and private key. This will be
    revoked at the end of its lease period

    ```
    vault write -field=certificate ca|_root/root/generate/internal common_name="example.com" ttl=87600h > CA_cert.crt
    ```

4.  Configure the CA and CRL URLs so they can be accessed

    ```
    vault write ca_root/config/urls issuing_certificates="http://{vaultAddress}:8200/v1/ca_root/ca"
    crl_distribution_points="http://{vaultAddress}:8200/v1/ca_root/crl"
    ```

#### Create an Intermediate CA

1.  Enable pk engine at the pki_int path

    ```
    vault secrets enable --path=ca_int_1 pki 
    ```

2.  Vault secrets tune --max-lease-ttl=43800h pki_int

    ```
    vault secrets tune -max-lease-ttl=43800h pki_int 
    ```

3.  Generate an intermediate CA and create a CSR called
    pki_intermediate.csr

    ```
    vault write -format=json ca_int_1/intermediate/generate/internal common_name="example.com Intermediate Authority" ttl="43800h" | jq -r '.data.csr' > pki_intermediate.csr
    ```

4.  Sign the intermediate certificate with the root certificate and save
    it as intermediate.cert.pem

    ```
    vault write -format=json ca_root/root/sign-intermediate csr=@pki_intermediate.csr format=pem_bundle | jq -r '.data.certificate' > intermediate.cert.pem
    ```

5.  Import the signed certificate back into the vault

    ```
    vault write ca_int_1/intermediate/set-signed certificate=@intermediate.cert.pem
    ```

### Creating roles

#### Prerequisites 

#### Via the UI

1.  Navigate to "Secrets" and then an Intermediate Certificate Authority e.g. "ca_int_1"

2.  Click "Create role"

    ![](./images/Createrole.png)

3.  Enter a role name, update the Key Bits and change the TTLs

    ![](./images/Keybitttl.png)

4.  Add the OU and Organization names

    ![](./images/OuOrg.png)

5.  Make sure "Allow Localhost", "Allow Subdomain", "Allow bare domains"
    and "Generate Lease" is ticked. In allowed domains add the domain
    name and the IP addresses for that are allowed for this role.

    ![](./images/Domains.png)

6.  Click "Generate Role"

#### Via CLI API

1.  Create a role (called example-dot-com) which we are going to assign
    the certificate to

    ```
    vault write ca_int_i/roles/example-dot-com
    allowed_domains="test.example.com" allow_subdomains=true
    max_ttl="720h"
    ```

### Generate and Retrieve Certificates

The response from the following actions will return a PEM-encoded
private key, key-type and certificate serial number. You need to have your Certificate Authorities and Roles set up
before you can start generating and retrieving certificates.

They are examples given and commands provided where possible that show the different values you will need to fill in
with your own values. These are the bare essentials you will need to fill in and can be customised further. You should see
the [Vault documentation](https://www.vaultproject.io/docs/) for a full list of what options/settings are available. 

The examples are generating certificates that are:
 - signed by the Intermediate Authority named **ca_int_1** 
 - based on the role **example-role** which allows certificates to be requested for subdomains of example.role.com
 - going to be used to authenticate the domain **1.example.role.com**

**NB The private Key and certificate files we create will need to be placed on the EC2 that you want to secure.**

#### Via the UI

1.  Click "Generate Certificate"

    ![](./images/Gencertificate.png)

2.  Enter a role name and update the TTL. The common name must contain a valid domain that was allowed when creating 
    the role.

    ![](./images/rolename.png)

3.  Click "Generate" and you will create a certificate which you can download or copy. The main fields of interest are 
    the certificate and private key fields. You will need to copy those onto the EC2 with the tools you want to secure
    into their own files.

    ![](./images/VaultCertificate.png)
    
    ![](./images/VaultPrivateKey.png)

4.  Create Private key file on the desired EC2 and open for editing. Paste the private key copied from the Vault UI inside
    ```
    touch privateKey.key
    ```
    ```
    vi privateKey.key
    ```

5.  Create a certificate file on the desired EC2 and open for editing. Paste the certificate copied from the Vault UI inside
    ```
    touch certificate.cert
    ```
    ```
    vi certificate.cert
    ```    


#### Via CLI API

1.  Download Vault onto your WorkSpace
    ```
    sudo yum install wget
    ```
    ```
    wget https://releases.hashicorp.com/vault/0.11.4/vault_0.11.4_linux_amd64.zip
    ```
    ```
    unzip vault_0.11.4_linux_amd64.zip 
    ```
    ```
    sudo mv vault /usr/local/bin/vault 
    ```

2.  Update your WorkSpaces system variables so that you can connect to your Vault server. You will need to replace 
    {vaultAddress} to the domain where your Vault EC2 resides e.g. vault.tools.cedc.cloud and {pathToCertificates} to the full system path leading to where your intermediate
    certificate resides.
    
    **NB if you haven't secured Vault yet then you will have to use http instead of HTTPS in the following commands**
    
    **Also you will need your Intermediate Authorities Root Certificate which you should have downloaded when creating
      the authority and put in a safe place for distributing**
    
    ```
    echo 'export VAULT_ADDR="https://{vaultAddress}:8200' >> $HOME/.bashrc
    ```
    ```
    echo 'export VAULT_CACERT="/{pathToCertificates}/intermediate_cert.crt"' >> $HOME/.bashrc
    ```
    ```
    source $HOME/.bash_profile
    ```

3.  Request a certificate via the command line interface
    ```
    vault write ca_int_1/issue/example-role common_name="1.example.role.com" ttl="5h"
    ``` 
    
4.  The above command will provide some output to the terminal. Copy the private key and certificate values into a 
    key and cert file respectively.
    
    a. Copy the private key data into a file on the desired EC2
    ![](./images/Key.png)    

    ```
    touch privateKey.key
    ```
    ```
    vi privateKey.key
    ```
    
    b.  Copy the certificate data into a file on the desired EC2
    ![](./images/Cert.png)
    ```
    touch certificate.cert
    ```
    ```
    vi certificate.cert
    ```  

#### Via CURL request

You would use this option if you are requesting a certificate from
outside of your Vault server

1.  Send a curl request from the machine you wish to create a private key and certificate for

    ```
    curl --header "X-Vault-Token:<RootCAToken>" --request POST --data '{"common_name": "1.example.role.com"}' https://{vaultAddress}:8200/v1/ca_int_1/issue/example-role
    ```

# Configure Tools over SSL

Prerequisites:

1.  You must have created Certificate Authorities and a role in Hashicorp Vault that allows the domain your tools live on e.g. tools.cedc.cloud.
    to be authenticated. The necessary steps have also been added to the [Securing Vault](#vault) section as another working example to help demonstrate how to do these steps.

2.  Additional Commands that are useful to know

    a. Lists all entries in a keystore

    ```
    keytool -list -v -keystore keystore.jks 
    ```

    b. Deletes entry with alias cert_alias in a keystore

    ```
    keytool -delete -alias cert_alias -keystore keystore.jks 
    ```

## OPTIONAL: Add keytool to the executable path

1.  Login as root -- admin privileges are needed for working with keystores

    ```
    sudo su 
    ```

2.  Add the keytool to the executable path -- this allows you to use **keytool** instead of /opt/atlassian/jira/jre/bin/keytool with every command that follows.

    ```
    touch /etc/profile.d/keystore.sh 
    ```
    
    ```
    chmod +wx /etc/profile.d/keystore.sh 
    ```
    
    ```
    vi /etc/profile.d/keystore.sh 
    ```

3.  Add this to the file

    ```
    pathmunge /opt/atlassian/confluence/jre/bin 
    ```

4.  Save and quit the file

    ```
    ./etc/profile
    ```

## Vault

At the moment we are running Vault using an unsecured connection to the
backend database and have disabled Transport Layer Security (TLS). To
enable this, we need to generate and save a certificate pair we can use
and restart the server with TLS enabled.

The following steps will create a secured connection to the EC2 running
vault. This EC2 has been granted the domain "vault.example.com" for
example purposes through using AWS Route 53. You should replace this
with your own domain name.

#### Create a Root CA for our domain

We need to create a Certificate authority for our domain if we don't
have one already. You should follow the steps on [Building your own Certificate Authority (CA)](#build-your-own-certificate-authority-ca) 
with the following values:

-   CA Type = "root"

-   Type = "internal"

-   Common Name = your domain name e.g. "example.com"

-   IP Subject Alternative name \[optional\] is your domain 192.168.0.0

-   TTL = an appropriate time that you want to authenticate this CA for
    e.g. "500 days"

    ![](./images/CADomain.png)

#### Create an Intermediate CA for our domain

We need to create an Intermediate Certificate authority for our domain.
You should follow the steps in [Create an Intermediate CA](#create-an-intermediate-ca) whilst replacing the values with
the ones detailed in the following steps.

1.  When creating a CSR you need to set the following values:

    -   CA Type = "Intermediate"
    
    -   Type = "internal"
    
    -   Common Name = domain of the specific vault server e.g.
        "vault.example.com"
    
    -   IP Subject Alternative name \[optional\] = your servers IP e.g. "192.168.2.64"

    ![](./images/Intcadomain.png)

2.  When getting this CSR signed by the Root CA make sure the following
    fields are set:

    -   CSR = copied in correctly
    
    -   Common Name = domain of the specific vault server e.g. "vault.example.com"
    
    -   IP Subject Alternative name \[optional\] = your servers IP e.g. "192.168.2.64"
    
    -   TTL = less than your Root CA e.g."499 days"
    
    ![](./images/csrsigned.png)

    When the Intermediate CA is generated you need to click the "Download CA
    Certificate in PEM format" as we will need to upload this to our browser
    later to authenticate our connection.

    ![](./images/CAcertpem.png)

#### Create a Role

Next you need to create a Role for the Intermediate CA. This Role will
define the credentials that our Vault Certificate and Key will use. You should follow the steps outlined in 
[Creating roles](#creating-roles) whilst using the following values:

-    Role name = something descriptive e.g. vault-server
    
-   TTL and Max TTL= less than your Intermediate CA's TTL e.g. "300
    days"

-   Allow subdomains and Allow bare domains are ticked

-   Allowed domains = has your vault domain and IP e.g.
    "vault.example.com, 192.168.2.64"

-   Generate lease is ticked
    
    ![](./images/roleintca.png)
    
    ![](./images/roleintca2.png)

#### Get a certificate and a key

Once you have the role created you need to access your server (e.g.
through SSH or RDP) with Vault installed and in the terminal carry out
the following steps.

1.  Create a local key and certificate file. We will store the
    credentials we want our Vault server to hold in these files. We also
    need to change the permissions so that we can edit, run and execute
    these files.

    ```
    cd /etc/vault 
    ```
    
    ```
    sudo touch key.key 
    ```
    
    ```
    sudo touch cert.crt 
    ```
    
    ```
    sudo chmod 777 key.key 
    ```
    
    ```
    sudo chmod 777 cert.crt 
    ```

2.  We need to create a certificate and retrieve it using Vaults HTTP
    API. The following curl command sends a request to the Vault server
    asking for a certificate to be created and will pipe the returned
    JSON string into a file we create.

    ```
    sudo touch all_details.json 
    ```
    
    ```
    sudo chmod 777 all_details.json 
    ```
    
    The following command shows the format of the command you need to run to request a certificate and private key. You need to replace {vaultToken}, {vaultAddress} and {roleName} values with the appropriate values.
    ```
    curl --header "X-Vault-Token: {vaultToken}" --request POST --data '{"common_name": "{domainToAuthenticate}", "ttl" : "36000"}' http://{vaultAddress}:8200/v1/{}/issue/{roleName} > all_details.json
    ```

    An example of the above command filled in with the values we have been using so far would be:
    ```
    curl --header "X-Vault-Token: ccc02366-f9c0-0909-4ab7-32187b66c84b" --request POST --data '{"common_name": "vault.example.com", "ttl" : "36000"}' http://vault.example.com:8200/v1/{}/issue/vault-server > all_details.json
    ```

3.  You can check this command was successful by running **cat
    all_details.json** and ensuring the output looks something similar
    to this

    ![](./images/catoutput.png)

4.  We do not need all the details provided in the all_details.json
    file - We only need the certificate and private_key fields. We can
    extract this content into the appropriate files using the jq and awk
    tools. jq extracts the JSON fields we request and the awk tool
    tidies the output by deleting the "\\n" and adding the newline in.
    This needs to be tidied otherwise the files will be invalid

    ```
    sudo jq ".data.certificate" all_details.json | awk
    '{gsub(/\\n/,"\n")}1' > cert.crt
    ```
    
    ```
    sudo jq ".data.private_key" all_details.json | awk
    '{gsub(/\\n/,"\n")}1' > key.key
    ```

5.  Although the above command puts the newlines back in we still need
    to delete the quote marks at the start and end of the files to
    create valid files. You can do this using vi and just deleting the
    very first and last double quotes (") in the file e.g. removing
    these two red characters in both the key.key and cert.crt files:

    ```
    "-----BEGIN RSA PRIVATE KEY-----
    MIIEpAIBAAKCAQEA0vJJhl64QL3r…
    ……………………………………………………
    kU0SghxkXsUA0GxLyNqJhPGTmd…
    -----END RSA PRIVATE KEY-----"
    ```
    
    ```
    vi key.key 
    ```
    
    ```
    vi cert.crt 
    ```

#### Restart Vault with TLS enabled

We now need to update vaults configuration file to enforce TLS and tell
it where to find our certificate and key files.

1.  Stop the vault service so you can update the config file. You may
    need to kill the process running vault too

    ```
    sudo systemctl stop vault.service 
    ```

2.  Show the processes referencing vault

    ```
    ps -ax | grep vault 
    ```

3.  If there is a process that is running the vault server e.g. 
    ```
    2203 ? SLsl 0:06 /usr/bin/vault server -config=/etc/vault/config.json
    ```

4.  Kill that process using the process ID which is the first number
    mentioned on that process description e.g. 2203

    ```
    sudo kill {processID}
    ```

5.  Edit the config file

    ```
    sudo vi /etc/vault/config.json 
    ```

6.  Add the paths to the key and certificate file and delete the line disabling TLS. You should end up with something 
    similar to this except {dbuser}, {dbPassword} and {vaultAddress} are replaced with your own values.

    ```
    {
    "listener": [{
    "tcp": {
    "address" : "0.0.0.0:8200",
    "tls_cert_file" : "/etc/vault/cert.crt",
    "tls_key_file" : "/etc/vault/key.key"
    }
    }],
    "api_addr": "http://127.0.0.1:8200",
    "storage": {
        "postgresql": {
        "connection_url" : "postgresql://{dbuser}:{dbPassword}@localhost:5432/postgres?sslmode=disable"
        }
     },
    "max_lease_ttl": "8760h",
    "default_lease_ttl": "8760h",
    "disable_mlock": true,
    "ui":true
    }
    ```

7.  Restart the vault service. This will pick up the new configuration
    you have just added

    ```
    sudo systemctl start vault.service 
    ```

#### Test HTTPS Connection

If you try and connect to vault using vault.example.com:8200 or
http://{vaultAddress}:8200 you will now get directed to a page that
looks like this

![](./images/usecurevault.png)

This is because you need to use https instead of http now that TLS is
enabled. When you first open https://{vaultAddress}:8200 though you
will see some variation of the following error message:

![](./images/certerror.png)

To get your WorkSpace to trust the Vault certificate you created, you need to import the intermediate Certificate 
Authority's certificate into your browser. Replace {vaultAddress} with your Vaults domain and 
{intermediateAuthorityPath} with the name of your Intermediate Authority e.g. ca_int_1

1.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{vaultAddress}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

2.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)


## Bitbucket

1.  On your Bitbucket server, generate a Java keystore

    ```
    /opt/atlassian/bitbucket/5.15.0/jre/bin/keytool -genkey -alias host -keyalg RSA -sigalg SHA256withRSA -keystore /var/atlassian/application-data/bitbucket/shared/config/ssl-keystores.jks
    ```

2.  Enter the necessary information e.g. name (domain of the
    application), organisation etc.

3.  Make a note of the password of the keystore. You may see a warning like below:

    ```
    The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using
    "/opt/atlassian/bitbucket/5.15.0/jre/bin/keytool -importkeystore -srckeystore /var/atlassian/application-data/bitbucket/shared/config/ssl-keystores.jks -destkeystore /var/atlassian/application-data/bitbucket/shared/config/ssl-keystores.jks -deststoretype pkcs12"
    ```

4.  Copy the command provided (you will need to provide a direct path to
    the keytool file, highlighted in the code above) and migrate the
    keystore to PKCS12 format.

5.  Get an appropriate certificate created for your BitBucket server. You
    can set the parameters to your liking as long as the common name and
    allowed domain fields contain your BitBucket servers domain name/IP address. 
    
    See the [Generate and Retrieve Certificates](#generate-and-retrieve-certificates) section on how to get a certificate and key. 
    Save the certificate as bitbucket.crt and the key as bitbucket.key.

6.  Combine the bitbucket.crt and bitbucket.key files into a .p12 file.

    ```
    openssl pkcs12 -export -in bitbucket.crt -inkey bitbucket.key -name bitbucket.tools.cedc.cloud -out bitbucket.p12
    ```

7.  Import the combined certificate and key file into the keystore

    ```
    /opt/atlassian/bitbucket/5.15.0/jre/bin/keytool -importkeystore
    -srckeystore bitbucket.p12 -destkeystore
    /var/atlassian/application-data/bitbucket/shared/config/ssl-keystores.jks
    -srcstoretype pkcs12 -alias bitbucket.tools.cedc.cloud
    ```

8.  Make a backup of the bitbucket.properties file
    ```
    cd /var/atlassian/application-data/bitbucket/shared/
    ```
    ```
    cp bitbucket.properties bitbucket.properties.bak 
    ```

9.  Edit bitbucket.properties
    ```
    vi bitbucket.properties
    ```

10. Paste in the following underneath the PostgreSQL settings. Be sure
    to change the two {bitbucketAddress} values (to your EC2s domain e.g. bitbucket.tools.cedc.cloud), {keyStorePassword},
    and {keyPassword}

    ```
    # Listens on port 8080 and converts traffic to https and pushes to port 8443
    server.port=8080
    server.redirect-port=8443
    server.require-ssl=true
    # Listens on port 8443 for SSL connections
    server.additional-connector.1.port=8443
    server.additional-connector.1.address={BitbicketAddress}
    server.additional-connector.1.secure=true
    server.additional-connector.1.scheme=https
    server.additional-connector.1.protocol=TLS
    server.additional-connector.1.ssl.enabled=true
    server.additional-connector.1.ssl.key-store=/var/atlassian/application-data/bitbucket/shared/config/ssl-keystores.jks
    server.additional-connector.1.ssl.key-store-password={keyStorePassword}
    server.additional-connector.1.ssl.key-password={keyPassword}
    server.additional-connector.1.ssl.key-alias={BitbicketAddress}
    server.additional-connector.1.ssl.key-store-type=jks
    ```

11. Restart Bitbucket

    ```
    systemctl restart atlbitbucket 
    ```
    
    ```
    systemctl restart atlbitbucket.service 
    ```
    
13. To get your WorkSpace to trust the Bitbucket certificate you created, you need to import the Intermediate Certificate 
    authorities certificate into your browser. 
    
    **NB You can skip this step if you use the same Certificate Authority to issue certificates for multiple tools, and 
    have already uploaded the Certificate Authority's certificate to the browser.**

    a.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{yourVaultDomain}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

    b.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)


## Confluence

1.  On your Confluence server, generate a Java keystore

    ```
    /opt/atlassian/confluence/jre/bin/keytool -genkey -alias host -keyalg RSA -sigalg SHA256withRSA -keystore /opt/atlassian/confluence/host.jks
    ```

1.  Enter the necessary information e.g. name (domain of the application), organisation etc.

2.  Make a note of the password of the keystore. You may see a warning
    like:

    ```
    The JKS keystore uses a proprietary format. It is recommended to
    migrate to PKCS12 which is an industry standard format using
    "/opt/atlassian/confluence/jre/bin/keytool -importkeystore -srckeystore /opt/atlassian/confluence/host.jks -destkeystore /opt/atlassian/confluence/host.jks -deststoretype pkcs12"
    ```

3.  Copy the command provided (you will need to provide a direct path to
    the keytool file, highlighted in the code above) and migrate the
    keystore to PKCS12 format.

4.  Get an appropriate certificate created for your Confluence server. You
    can set the parameters to your liking as long as the common name and
    allowed domain fields contain your Confluence servers domain name/IP address. 
    
    See the [Generate and Retrieve Certificates](#generate-and-retrieve-certificates) section on how to get a certificate and key. 
    Save the certificate into confluence.crt and the key as confluence.key.

5.  Combine the confluence.crt and confluence.key files into a .p12
    file.

    ```
    openssl pkcs12 -export -in confluence.crt -inkey confluence.key -name confluence.tools.cedc.local -out confluence.p12
    ```

6.  Import the combined certificate and key file into the keystore

    ```
    /opt/atlassian/confluence/jre/bin/keytool -importkeystore -srckeystore confluence.p12 -destkeystore /opt/atlassian/confluence/host.jks -srcstoretype pkcs12 -alias confluence.tools.cedc.local
    ```

7.  Make a backup of the server.xml file and open it for editing

    ```
    cd /opt/atlassian/confluence/conf
    ```
    ```
    cp server.xml server.xml.bak 
    ```

    ```
    vi server.xml 
    ```

8.  Copy and paste the following code block into server.xml underneath the **HTTPS --
    Direct connector with no proxy** heading. Your result should look like this:

    ```xml
    <!--
             ==============================================================================================================
             HTTPS - Direct connector with no proxy, for unproxied HTTPS access to Confluence.
    
             For more info see https://confluence.atlassian.com/x/s3UC
             ==============================================================================================================
            -->
    
    
               <Connector port="8443" maxHttpHeaderSize="8192"
                       maxThreads="150" minSpareThreads="25"
                       protocol="org.apache.coyote.http11.Http11Nio2Protocol"
                       enableLookups="false" disableUploadTimeout="true"
                       acceptCount="100" scheme="https" secure="true"
                       clientAuth="false" sslProtocol="TLSv1.2" sslEnabledProtocols="TLSv1.2" SSLEnabled="true"
                       URIEncoding="UTF-8" keystorePass="123456" keystoreFile="/opt/atlassian/confluence/keystore.jks"
                       ciphers="TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
                           TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384,
                           TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                           TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256,
                           TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
                           TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,
                           TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384,
                           TLS_ECDH_RSA_WITH_AES_256_CBC_SHA,TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA,
                           TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
                           TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,
                           TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256,
                           TLS_ECDH_RSA_WITH_AES_128_CBC_SHA,TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA"/>
    
    ```

9. Make a backup of web.xml
    ```
    cd /opt/atlassian/confluence/WEB-INF
    ```
    ```
    cp web.xml web.xml.bak 
    ```

10. Open web.xml and go to the bottom of the file. Before the
    terminating `<web-app\>` tag paste in the following:

    ```
    <security-constraint>
      <web-resource-collection>
        <web-resource-name>Restricted URLs</web-resource-name>
        <url-pattern>/</url-pattern>
      </web-resource-collection>
      <user-data-constraint>
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>
      </user-data-constraint>
    </security-constraint>
    ```

11. Restart confluence

    ```
    systemctl restart confluence 
    ```
    
    ```
    systemctl restart confluence.service 
    ```
12. To get your WorkSpace to trust the Confluence certificate you created, you need to import the Intermediate Certificate 
    authorities certificate into your browser. 
    
    **NB You can skip this step if you use the same Certificate Authority to issue certificates for multiple tools, and 
    have already uploaded the Certificate Authority's certificate to the browser.**

    a.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{yourVaultDomain}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

    b.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)



## Jenkins

1.  On your Jenkins server, generate a Java keystore

    ```
    /usr/lib/jvm/jre/bin/keytool -genkey -alias host -keyalg RSA -sigalg SHA256withRSA -keystore /var/lib/jenkins/secrets/host.jks
    ```

2.  Make a note of the password of the keystore. You may see a warning like:

    ```
    JKS keystore uses a proprietary format. It is recommended to migrate
    to PKCS12 which is an industry standard format using 
    
    "/usr/lib/jvm/jre/bin/keytool -importkeystore -srckeystore /var/lib/jenkins/secrets/host.jks -destkeystore /var/lib/jenkins/secrets/host.jks -deststoretype pkcs12"
    ```

3.  Copy the command provided, without the quote marks.

4.  You will need to provide a direct path to the keytool file; highlighted in the code above. Migrate the keystore to PKCS12
    format by running that above command

5.  Drop the 'host' *self-signed* certificate from the keystore.

    ```
    /usr/lib/jvm/jre/bin/keytool -delete -alias host -keystore /var/lib/jenkins/secrets/host.jks
    ```

6.  Get an appropriate certificate created for your Jenkins server. You
    can set the parameters to your liking as long as the common name and
    allowed domain fields contain your Jenkins servers domain name/IP address. 
    
    See the [Generate and Retrieve Certificates](#generate-and-retrieve-certificates) section on how to get a certificate and key. 
    Save the certificate into jenkins.crt and the key as jenkins.key.
    
7.  Combine the jenkins.crt and jenkins.key files in to a .p12 file.

    ```
    openssl pkcs12 -export -in jenkins.crt -inkey jenkins.key -name
    jenkins.tools.cedc.local -out jira.p12
    ```

8.  Import the combined certificate and key file into the keystore.

    ```
    /usr/lib/jvm/jre/bin/keytool -importkeystore -srckeystore jenkins.p12 -destkeystore /var/lib/jenkins/secrets/host.jks -srcstoretype pkcs12 -alias jenkins.tools.cedc.local
    ```
    
9. Make a backup of the Jenkins file and opening the original for editing
    ```
    cd /etc/sysconfig
    ```
    ```
    sudo cp jenkins jenkins.bak 
    ```
    ```
    vi jenkins 
    ```
    
10. Update the following settings, replacing {keyStorePassword} with your keystores password and {jenkinsAddress} with 
    your Jenkins domain name.
    
    ```
    JENKINS_PORT="8080"                 to  JENKINS_PORT="-1"
    JENKINS_HTTPS_PORT=""               to  JENKINS_HTTPS_PORT="8443"
    JENKINS_HTTPS_KEYSTORE=""           to  JENKINS_HTTPS_KEYSTORE="var/lib/jenkins/secrets/host.jks"
    JENKINS_HTTPS_KEYSTORE_PASSWORD=""  to  JENKINS_HTTPS_KEYSTORE_PASSWORD="{keyStorePassword}"
    JENKINS_HTTPS_LISTEN_ADDRESS=""     to  JENKINS_HTTPS_LISTEN_ADDRESS="{jenkinsAddress}"
    ```

11. The settings should now look similar to this (we have set the keystore password to 123456 and have Jenkins running
    at jenkins.tools.cedc.local):

    ``` bash
    ## Type:        integer(0:65535)
    ## Default:     8080
    ## ServiceRestart: jenkins
    #
    # Port Jenkins is listening on.
    # Set to -1 to disable
    #
    
    JENKINS_PORT="-1"
    
    ## Type:        integer(0:65535)
    ## Default:     ""
    ## ServiceRestart: jenkins
    #
    # HTTPS port Jenkins is listening on.
    # Default is disabled.
    #
    
    JENKINS_HTTPS_PORT="8443"
    
    ## Type:        string
    ## Default:     ""
    ## ServiceRestart: jenkins
    #
    # Path to the keystore in JKS format (as created by the JDK 'keytool').
    # Default is disabled.
    #
    JENKINS_HTTPS_KEYSTORE="var/lib/jenkins/secrets/host.jks"
    
    ## Type:        string
    ## Default:     ""
    ## ServiceRestart: jenkins
    #
    # Password to access the keystore defined in JENKINS_HTTPS_KEYSTORE.
    # Default is disabled.
    #
    JENKINS_HTTPS_KEYSTORE_PASSWORD="123456"
    
    ## Type:        string
    ## Default:     ""
    ## ServiceRestart: jenkins
    #
    # IP address Jenkins listens on for HTTPS requests.
    # Default is disabled.
    #
    JENKINS_HTTPS_LISTEN_ADDRESS="jenkins.tools.cedc.local
    ```
    
12. To get your WorkSpace to trust the Jenkins certificate you created, you need to import the Intermediate Certificate 
    authorities certificate into your browser. 
    
    **NB You can skip this step if you use the same Certificate Authority to issue certificates for multiple tools, and 
    have already uploaded the Certificate Authority's certificate to the browser.**

    a.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{yourVaultDomain}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

    b.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)


## Jira

1.  On your Jira server, generate a Java keystore

    ```
    /opt/atlassian/jira/jre/bin/keytool -genkey -alias host -keyalg RSA -keystore /opt/atlassian/jira/host.jks
    ```

2.  Enter the necessary information e.g. name (domain of the application), organisation etc.

3.  Make a note of the password of the keystore. You may see a warning like:
    ```
    The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using
    "/opt/atlassian/jira/jre/bin/keytool -importkeystore -srckeystore /opt/atlassian/jira/host.jks -destkeystore /opt/atlassian/jira/host.jks -deststoretype pkcs12"
    ```

4.  Copy the command provided and run it (you will need to provide a direct path to
    the keytool file, highlighted in the code above) and migrate the keystore to PKCS12 format.

5.  Get an appropriate certificate created for your Jira server. You
    can set the parameters to your liking as long as the common name and
    allowed domain fields contain your Jira servers domain name/IP address. 
    
    See the [Generate and Retrieve Certificates](#generate-and-retrieve-certificates) section on how to get a certificate and key. 
    Save the certificate into jira.crt and the key as jira.key.

6.  Combine the jira.crt and jira.key files into a .p12 file.

    ```
    openssl pkcs12 -export -in jira.crt -inkey jira.key -name jira.tools.cedc.cloud -out jira.p12
    ```

7.  Import the combined certificate and key file into the keystore

    ```
    /opt/atlassian/jira/jre/bin/keytool -importkeystore -srckeystore jira.p12 -destkeystore /opt/atlassian/jira/host.jks -srcstoretype pkcs12 -alias jira.tools.cedc.cloud
    ```

8.  Make a backup of the server.xml file and open the original for editing
    ```
    cd /opt/atlassian/jira/conf/
    ```
    ```
    cp server.xml server.xml.bak 
    ```
    ```
    vi server.xml 
    ```

9. Under the default connector heading that looks like:

    ```
    <!--
             ==============================================================================================================
             DEFAULT - Direct connector with no proxy for unproxied access to Jira.
    
             If using a http/https proxy, comment out this connector.
             ==============================================================================================================
            -->
    ```

10. Copy and paste the below. Be sure to change the {keyAlias} attribute to the alias of your role combined
        CERTIFICATE and KEY. e.g. jira.tools.cedc.cloud and the {keyStorePassword} attribute to the password of your keystore
     
    ``` xml
    <Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol" relaxedPathChars="[]|" relaxedQueryChars="[]|{}^&#x5c;&#x60;&quot;&lt;&gt;"
                  maxHttpHeaderSize="8192" SSLEnabled="true"
                  maxThreads="150" minSpareThreads="25"
                  enableLookups="false" disableUploadTimeout="true"
                  acceptCount="100" scheme="https" secure="true"
                  sslEnabledProtocols="TLSv1.2,TLSv1.3"
                  clientAuth="false" useBodyEncodingForURI="true"
                  keyAlias="{keyAlias}" keystoreFile="/opt/atlassian/jira/host.jks" keystorePass="{keyStorePassword}" keystoreType="JKS"
                   ciphers="TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
                           TLS_ECDH_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDH_ECDSA_WITH_AES_256_GCM_SHA384,
                           TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
                           TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256,
                           TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384,
                           TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA,
                           TLS_ECDH_RSA_WITH_AES_256_CBC_SHA384,TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA384,
                           TLS_ECDH_RSA_WITH_AES_256_CBC_SHA,TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA,
                           TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,
                           TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA,
                           TLS_ECDH_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA256,
                           TLS_ECDH_RSA_WITH_AES_128_CBC_SHA,TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA"/>
    ```

11. You will need to comment out the former HTTP connector tag that
    looks like:

    ```
    <Connector port="8080"...............>
    ```

12. Save and quit the file (e.g. esc -> :wq -> enter)

13. Make a backup of the web.xml file by entering:
    ```
    cd opt/Atlassian/jira/Atlassian-jira/WEB-INF
    ```
    ```
    cp web-xml web-xml.bak 
    ```
    ```
    vi web-xml  
    ```

14. Go to the end of the web.xml file, copy and paste in the following and then save the file:

    ```xml
    <security-constraint>
        <web-resource-collection>
            <web-resource-name>all-except-attachments</web-resource-name>
            <url-pattern>*.jsp</url-pattern>
            <url-pattern>*.jspa</url-pattern>
            <url-pattern>/browse/*</url-pattern>
            <url-pattern>/issues/*</url-pattern>
        </web-resource-collection>
        <user-data-constraint>
            <transport-guarantee>CONFIDENTIAL</transport-guarantee>
        </user-data-constraint>
    </security-constraint>
    ```

15. Restart Jira:

    ```
    systemctl restart jira
    ```
    
    ```
    systemctl restart jira.service
    ```

16. To get your WorkSpace to trust the Jira certificate you created, you need to import the Intermediate Certificate 
    authorities certificate into your browser. 
    
    **NB You can skip this step if you use the same Certificate Authority to issue certificates for multiple tools, and 
    have already uploaded the Certificate Authority's certificate to the browser.**

    a.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{yourVaultDomain}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

    b.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)




## Nexus

#### Prerequisites
Requires the keytool to be installed on your WorkSpace.

#### Steps

1.  Get an appropriate certificate created for your Nexus server. You
    can set the parameters to your liking as long as the common name and
    allowed domain fields contain your Nexus servers domain name/IP
    address. 

    See the [Generate and Retrieve Certificates](#generate-and-retrieve-certificates) section on how to get a certificate and key
    Save the certificate into cert.crt and the key as key.key.

2.  Store your private key and certificate in a key store on your **Nexus EC2**.

    b.  Create a keystore. Enter the necessary company information, when prompted e.g. keystore passwords (in
        this example I am using 123456) and when asked if all correct, enter yes
    ```
    keytool -genkey -alias keystore -keyalg RSA -keystore /opt/nexus/etc/ssl/keystore.jks
    ```

    c.  Create a P12 file containing your certificate and key and import
        that into your key store
    ```
    openssl pkcs12 -export -in cert.crt -inkey key.key -name nexus.tools.cedc.cloud -out nexus.p12
    ```
    ```
    keytool -importkeystore -srckeystore nexus.p12 -destkeystore/opt/nexus/etc/ssl/keystore.jks -srcstoretype pkcs12 -alias nexus.tools.cedc.cloud
    ```     

3.  Update Nexus's properties file to use this keystore by doing the following:
    ```
    sudo vi /opt/sonatype-work/nexus3/etc/nexus.properties
    ```
    a. Add to bottom: application-port-ssl=8443

    b. Uncomment the nexus-args line (remove space and \#)

    c. Add "${jetty.etc}/jetty-https.xml" to end of nexus-args comma separated list

    ![](./images/NexusPropertiesFile.png)

    d.  Then edit the HTTPS properties file by adding your keystore passwords (3 in total)

        sudo vi /opt/nexus/etc/jetty/jetty-https.xml

    ![](./images/NexusHttpsPropertiesFile.png)

4.  To get your WorkSpace to trust the Nexus certificate you created, you need to import the Intermediate Certificate 
    authorities certificate into your browser. 
    
    **NB You can skip this step if you use the same Certificate Authority to issue certificates for multiple tools, and 
    have already uploaded the Certificate Authority's certificate to the browser.**

    a.  Get the certificate
        
    ```
    touch ca.pem
    ```
    ```
    curl <http://{yourVaultDomain}:8200/v1/{intermediateAuthorityPath}/ca/pem> > ca.pem
    ```

    b.  Refer to this section on how to [Add a certificate authority to the browser](first-time-tools-setup.md#add-a-certificate-authority-to-the-browser)

5.  Restart the service

    ```
    sudo systemctl restart nexus.service
    ```

6.  Access the SSL version of Nexus by going to https://{nexusAddress}:8443 and you should see a green padlock
    next to your domain name.

# Additional Software installation guides

You may need to update or download some additional software before you can install the tools onto your various EC2s.
The following software is not needed for every EC2. The "Prerequisites" sections will tell you if a tool requires any 
software to be acquired/updated before you can install it and will link back to the appropriate steps in this section.

## Updating YUM

Yellowdog Updater Modified (YUM) is a free open-source command line
package manager for Linux based OSs. Allows for automatic updates, and
package and dependency management on RPM-based distributions.

**NB: The machine you want to update YUM on must have internet access to
work. It will give this ambiguous message if you don't have it "Could
not retrieve mirrorlist".**

1.  Login to your WorkSpace and open MATE Terminal

2.  Connect via SSH to the desired EC2 instance as shown [here](./quick-reference.md##accessing-an-ec2-instance-from-a-workspace)
3.  Once connected run the following command:

    ```
    sudo yum -y update 
    ```

4.  If any packages need updating then they will be, otherwise your Yum
    installation is up to date.

    ![](./images/49.png)

## Installing Java 8 JDK

1.  Login to your WorkSpace and open MATE terminal

2.  Connect via SSH to the desired EC2 instance. Steps for this can be found [here](./quick-reference.md##accessing-an-ec2-instance-from-a-workspace)
    
3.  Once you are logged in ensure you have updated up as shown in
    section 18 run the following command:

    ```
    sudo yum install java-1.8.0-openjdk-devel  
    ```

4.  When prompted, type **y** and hit enter.

5.  If Java 8 is already installed then Yum won't do anything, otherwise, it will install Java 8

    ![](./images/installingjava8openjdkonanec2-1.png)

## Installing Git

1. SSH in to your desired EC2 instance as shown [here](./quick-reference.md##accessing-an-ec2-instance-from-a-workspace) 
    and run the following commands:

    ```
    sudo yum install wget  
    ```
    
    ```
    sudo yum groupinstall "Development Tools"
    ```
    
    ```
    sudo yum remove git-1.8.3.1
    ```
    
    ```
    sudo yum install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel
    ```

2. Download a compatible release of git by running the following commands (we would recommend the version be >= v2.2.0):

    ```
    sudo cd /usr/bin/
    ```
    ```
    sudo wget https://github.com/git/git/archive/v2.18.1.tar.gz 
    ```
    ```
    sudo tar -zxf v2.18.1.tar.gz
    ```
    ```
    cd git-2.18.1
    ```
    ```
    sudo make configure
    ```
    ```
    sudo ./configure --prefix=/usr/local
    ```
    ```
    sudo make install
    ```
    ```
    git --version
    ```

3.  If git --version does not work, you need to add the git directory to the PATH. 

    a. Copy the git directory by entering the directory and typing pwd.

    b.  Use echo \$PATH to show your path and copy this in case a mistake is made in the next step.
    
    c.  Enter the following in the terminal:
    ```
    export PATH=/usr/bin/git-2.18.1/:$PATH
    ```
    
    d. You should now be able to access git through the command line:
    
    ```
    git --version
    ```

## Installing wget

For you to be able to download applications from the internet via the command line it is important to install wget.

1.  Login to your WorkSpace and open MATE terminal

2.  Connect via SSH to the desired EC2 instance as shown [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)
    
3.  Once you have logged in [updating YUM](#updating-yum) and run the following command:

    ```
    sudo yum install wget
    ```

## Installing unzip

For you to be able to unzip folder on your EC2 instances line it is important to install unzip.

1.  Login to your WorkSpace and open MATE terminal

2.  Connect via SSH to the desired EC2 instance as shown [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)
    
3.  Once you are logged in [updating YUM](#updating-yum) and run the following command:

    ```
    sudo yum install unzip
    ```

## Installing jq tool

For you to be able to use the jq tool it is important to install jq tool. You will need the [install jq](#installing-jq-tool) before you can
install jq

1.  Login to your WorkSpace and open MATE terminal

2.  Connect via SSH to the desired EC2 instance as shown [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)
    
3.  Once you are logged in run the following commands:

    ```
    wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    ```
    
    ```
    chmod +x ./jq
    ```
    
    ```
    cp jq /usr/bin
    ```

# Installing PostgreSQL 9.6

1.  SSH into your EC2 instance where you would like to install PostgreSQL as shown [here](./quick-reference.md#accessing-an-ec2-instance-from-a-workspace)
                                                                                       
2.  Install PostgreSQL

    ```
    sudo yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
    ```
    
    ```
    sudo yum install postgresql96
    ```
    
    ```
    sudo yum install postgresql96-server
    ```
    
    ```
    sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
    ```

3.  Enable PostgreSQL to run on startup

    ```
    sudo systemctl enable postgresql-9.6
    ```
    
    ```
    sudo systemctl start postgresql-9.6
    ```

4. To configure PostgreSQL, first change the password of the postgres
    user. Run the following command

    ```
    sudo passwd postgres
    ```

5. Enter a new non-dictionary-based password

6. Switch to the postgres user

    ```
    su postgres
    ```

7. Enter the PostgreSQL Shell
    
    ```
    psql postgres
    ```

8. You should see something like this if everything is installed correctly:

    ![](./images/installingpostgresqk9.6.png)


# Prepare a PostgreSQL Database for Atlassian Tools to use


1.  In the PostgreSQL Shell, create a new user. Change "db_user" to the
    username for the application's admin user. Also, change
    "changePassword" to a password of your choice.

    ```
    CREATE USER db_user WITH PASSWORD 'changePassword';
    ```

2.  Verify you have created a new user by entering **\\du.** You should
    get an output similar to the image below:

    ![](./images/prepareapostgresqldatabaseforatlassiantools1.png)

3.  Create a new database. Change "databaseName" with the name for the
    application which can be found in the [Conventions guide](./conventions-guide.md).

    ```
    CREATE DATABASE <databaseName> WITH ENCODING 'UNICODE' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;
    ```

4.  Verify you have created a new database by entering **\l.** The
    output should be similar to the image below:

    ![](./images/prepareapostgresqldatabaseforatlassiantools2.png)

5.  Grant the new user all permissions for the database. Change
    "databaseName" with the name of your database you set earlier. Also,
    change "username" with the name of the user you created earlier.

    ```
    GRANT ALL PRIVILEGES ON DATABASE <databaseName> TO <username>;
    ```

6.  If you now once again verify your database by entering **\l** you
    should see an output similar to the image below:

    ![](./images/prepareapostgresqldatabaseforatlassiantools3.png)

You have now created a new database. We still need to change some
PostgreSQL permission settings before proceeding to deploy Jira.

7.  Exit the PostgreSQL Shell by typing **\q**

8.  Then type **exit**. You should now be switched back to the user you
    logged in as.

9.  Need to open the pg_hba.conf file

    ```
    sudo vi /var/lib/pgsql/9.6/data/pg_hba.conf
    ```

10. Go to the end of the file by pressing shift g

11. You will see the following table:

    ![](./images/prepareapostgresqldatabaseforatlassiantools4.png)

12.  Change the method for local and host from 'peer' to 'trust'

    ![](./images/prepareapostgresqldatabaseforatlassiantools5.png)

13.  Save the file

14.  Restart the postgresql-9.6 service

    ```
    sudo systemctl restart postgresql-9.6
    ```

<h1>Pathways</h1>

|         |  | |
| :-------------: |:--:|:-------------:|
||[Before you begin](before-you-begin.md) | |
||[Conventions Guide](conventions-guide.md) | |
||[Quick Reference](quick-reference.md) | |
||[AWS Overview](aws-overview.md) | |
| **Manual** |  | **Auto**
|&#8595;| |&#8595;
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md) 
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)  
| ***Tools Manual Installation***   | | [Tools Automatic Install](tools-automatic-installation.md)
| [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First time setup of tools](first-time-tools-setup.md)
||[First time setup of workspaces](first-time-workspaces-setup.md)


[<< Setup Single Sign-On (SSO)](setup-single-sign-on.md)

[Create a WorkSpace (team workspaces) >>](create-a-workspace.md##create-additional-workspaces)