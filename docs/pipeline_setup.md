<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

**Table of Contents**

- [OpenShift OKD Setup](#markdown-header-openshift-okd-setup)
  - [Prerequisites](#markdown-header-prerequisites)
    - [DNS Requirementss](#markdown-header-dns-requirementss)
  - [Non-production pipeline](#markdown-header-non-production-pipeline)
    - [Setting Up](#markdown-header-setting-up)
    - [Installation](#markdown-header-installation)
    - [Check the Docker Registry connection](#markdown-header-check-the-docker-registry-connection)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# OpenShift OKD Setup

The installation and configuration of the OpenShift OKD pipeline is handled via ansible scripts. To install and configure the pipeline, you must have satisfied the following pre-requisites:

- Route 53 is set up, configured and has [these DNS entries for OKD](#dns_requirements).
- Vault must be set up, configured and unsealed.
- Jenkins must be set up, configured with necessary pipeline plugins.
- EC2 is available, [satisfies the hardware requirements (EC2: t3.2xlarge)](#https://docs.okd.io/latest/install/prerequisites.html#production-level-hardware-requirements) and has the [appropriate security groups for OKD](#ref_to_security_groups).
- Security groups for the Jenkins server [must allow communication with OKD server](#ref_to_sgs).

## Foreword

The installation of OpenShift OKD can be a time consuming process and should be handled carefully. The scripts that accompany this installation guide will install all the required dependencies on your host and remote machines, however the installation process may still fail. Troubleshooting these failures can be difficult and there are often several factors that can contribute to errors. A troubleshooting guide is included at the end of this file with common issues and how they can be addressed.

Installations should not be unattended.

## Determining your cluster type

The ansible scripts that accompany this documentation are capable of constructing a two different types of OKD cluster.

- `AIO` - an all-in-one, proof of concept system that is based on a single virtual machine. Not recommended for production use. Requires a T3.2xlarge EC2. Formed of a single master, single etcd and single node on one server.

- `Cluster` - A multi-machine system formed of a single master, single etcd and two nodes.

## Prerequisites

### DNS Requirementss

You must create `A` and `CNAME` records in Route 53 for the OKD master EC2. If you followed the automatic pathway, these records have already been created.

- `A` Record must point to `OKD.server.cloud`

- `CNAME` must point `\*.OKD.server.cloud` forwards to `okd.server.cloud`.

You must be running these scripts from the same machine that installed Vault.

## Non-production pipeline

Constructed by Ansible. This process should not be completed manually, and is discouraged. The ansible scripts for this setup can be completed whether you followed the manual or automatic pathways.

### Setting Up

1. Download the Ansible scripts.

2. In the inventory.yml file, add your OKD server host. Note the domain must be `okd.your.domain`.

3. Navigate to `/roles/okd/vars/main.yml`. Modify the API port if you do not wish to run OKD over the default port 8443. Ensure the certificate TTL is of adequate length.

4. Use `ansible-vault` to decrypt the `passwd.yml` file and add any secrets you require (e.g. Vault root token).

`ansible-vault decrypt passwd.yml`.

Enter your password when prompted.

5. Provide a password for the administrator by modifying the `okdUserPassword` variable.

6. Open the inventory.yml file. Add underneath `[registry-access]` the hostnames of any instances that will communicate with your Docker registry. You **must** add your Jenkins host here.

### Installation

1. Open a terminal, navigate to the directory containing the ansible scripts and enter:

`sudo ./pipeline.sh {{WorkSpace Username}} {{path/to/private/key}} aio`

2. This process will take approximately 40-50 minutes. Take this opportunity to download the [oc client tools](#./quick-reference#openshift_client_tools_installation) on your workspace.

3. Once complete, [check the Docker Registry connection](#check_the_docker_registry_connection).

## Production Pipeline

### Setting up

1. Download the Ansible scripts.

2. In the inventory_okd_cluster.txt file:

- Modify the variable okdDomain (found in `/group_vars/all.yml`) to your OpenShift domain.

- Add your OKD master, etcd and node hosts to the groups: `[masters], [etcd]` and `[nodes]`. Note your master server hostname must be included in `[masters]` AND `[etcd]`. It should look like the following:

```yml
[masters]
okd-master.{{ okdDomain }} openshift_schedulable=true

[etcd]
okd-master.{{ okdDomain }}
```

Note: your master machine hostname must be okd-master.

- Add the jenkins server hostname to the `[registry-access]` inventory group.

```yml
[registry-access] # add below all hostnames of servers that will access the Docker registry
jenkins.tools.cedc.cloud
```

3. You must be running these scripts on the machine that installed Vault (via ansible). A certificate authority certificate and private key will be saved in the directory `/home/WorkSpaceUser/SecureFiles/vault.{{toolsDomain}}/tmp/` as `okd_ca_cert.crt` and `okd_ca_key.key`.

If you have lost these files, run the following playbook to generate a new CA:

`ansible-playbook -i inventory.txt --ask-vault-pass --extra-vars '@passwd.yml' -e "workspaceUser=<your_workspce_username> private_key_file=<path_to_private_key>" playbooks/okd_generate_ca.yml`

You will need to decrypt `passwd.yml` using `ansible-vault decrypt passwd.yml` and add three components of your vault master key, plus the vault token.

4. OpenShift uses HTTPD as its default method authentication. A user and pre-hashed password must be passed in to the inventory file on the following line:

`openshift_master_htpasswd_users={'admin': '$apr1$rxeHqcZv$dEreXx3EQY6bLlvus5oFP0'}`

The values in the default inventory file are admin and the password value is `Password1!`. You can create a htpasswd file on your local machine and generate your own pre-hashed password by performing the following:

```bash
sudo yum install httpd-tools
touch /tmp/htpasswdfile
htpasswd /tmp/htpasswdfile admin
New password: <type_your_password_here>
Re-type new password: <type_your_password_again_here>
# output: Adding password for user admin
```

### Installation

1. Open a terminal, navigate to the directory containing the ansible scripts and enter:

`sudo ./pipeline.sh {{WorkSpace Username}} {{path/to/private/key}} cluster`

Note `cluster type` only accepts the values `aio` and `cluster`

2. This process will take approximately 20-30 minutes. Take this opportunity to download the [oc client tools](#./quick-reference#openshift_client_tools_installation) on your workspace.

3. Once complete, [check the Docker Registry connection](#check_the_docker_registry_connection).

## Check the Docker Registry connection

1. SSH in to the OKD EC2.

2. Run the following commands:

`docker login -u pipeline_user -p $(oc whoami -t) docker-registry-default.apps.okd.{{ your_openshift_server_domain }}`

`docker pull busybox`

`docker tag busybox docker-registry-default.apps.okd.{{ your_openshift_server_domain }}/openshift/busybox:latest`

`docker push docker-registry-default.apps.okd.{{ your_openshift_server_domain }}/openshift/busybox:latest`

You should see an output like the following:

```
root@ip-172-21-1-74 centos]# docker login -u pipeline_user -p $(oc whoami -t) docker-registry-default.apps.okd.test.cedc.cloud
Login Succeeded

[root@ip-172-21-1-74 centos]# docker pull busybox
Using default tag: latest
Trying to pull repository docker.io/library/busybox ...
latest: Pulling from docker.io/library/busybox
697743189b6d: Pull complete
Digest: sha256:061ca9704a714ee3e8b80523ec720c64f6209ad3f97c0ff7cb9ec7d19f15149f
Status: Downloaded newer image for docker.io/busybox:latest

[root@ip-172-21-1-74 centos]# docker tag busybox docker-registry-default.apps.okd.test.cedc.cloud/openshift/busybox:latest

[root@ip-172-21-1-74 centos]# docker push docker-registry-default.apps.okd.test.cedc.cloud/openshift/busybox:latest
The push refers to a repository [docker-registry-default.apps.okd.test.cedc.cloud/openshift/busybox]
adab5d09ba79: Pushed
latest: digest: sha256:4415a904b1aca178c2450fd54928ab362825e863c0ad5452fd020e92f7a6a47e size: 527
```

# Troubleshooting

| Issue / Error                                                                                 | Resolution                                                                                                                                                                                                                                                                                                                                   |
| --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Yum does not update, causes the setup playbook to fail and the OKD installation begins early. | Open port 80 outbound to all traffic                                                                                                                                                                                                                                                                                                         |
| `openshift_service_catalog : Wait for API Server rollout success` ansible task fails          | Restart script                                                                                                                                                                                                                                                                                                                               |
| Pod health status returns OK but you cannot connect to any endpoints via the browser          | Delete the default router                                                                                                                                                                                                                                                                                                                    |
| `approve node certificates when bootstrapping`                                                | Node hostname is not equal to the value of the node _hostname_ in the inventory, set hostname via `hostnamectl set-hostname <inventory_hostname>`. You must also edit `/etc/sysconfig/network` and set `HOSTNAME=<inventory_hostname>`. Ensure correct [master-to-node](https://docs.okd.io/3.11/install/prerequisites.html) ports are open. |
