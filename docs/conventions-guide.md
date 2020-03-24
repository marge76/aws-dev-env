[<< Pathways](README.md)

[<Before you begin](./before-you-begin.md)

# Conventions Guide

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [The Purpose of this Guide](#markdown-header-the-purpose-of-this-guide)
- [VPC's](#markdown-header-vpcs)
    - [Naming](#markdown-header-naming)
    - [CIDR Blocks](#markdown-header-cidr-blocks)
    - [Subnets](#markdown-header-subnets)
- [Route Tables](#markdown-header-route-tables)
- [NAT Gateways](#markdown-header-nat-gateways)
- [Security Groups](#markdown-header-security-groups)
    - [Recommended Security Groups](#markdown-header-recommended-security-groups)
        - [ec2_linux_sg](#markdown-header-ec2_linux_sg)
        - [ec2_windows_sg](#markdown-header-ec2_windows_sg)
        - [ldap_sg](#markdown-header-ldap_sg)
        - [smtp_sg](#markdown-header-smtp_sg)
        - [jira_sg](#markdown-header-jira_sg)
        - [confluence_sg](#markdown-header-confluence_sg)
        - [bitbucket_sg](#markdown-header-bitbucket_sg)
        - [nexus_sg](#markdown-header-nexus_sg)
        - [jenkins_sg](#markdown-header-jenkins_sg)
        - [vault_sg](#markdown-header-vault_sg)
- [EC2 Instances](#markdown-header-ec2-instances)
- [Route 53 Active Directory Domain](#markdown-header-route-53-active-directory-domain)
- [IAM Roles](#markdown-header-iam-roles)
- [Pathways](#markdown-header-pathways)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# The Purpose of this Guide

The purpose of this guide is to aid you in correctly naming components in the AWS environment to allow best practices and also help others to understand how your environment is put together and works.

This guide should be followed as much as possible however if there is a need to change the way you name components then feel free to do this.

This guide is broken down into different sections based on the component being created.

# VPC's

## Naming

VPC's should be named like the following and you should replace `{region}` with the region you are working in and replace `{purpose}` with what the VPC will be containing for example tools or workspaces.

```
vpc-{region}-{purpose}
```

Example

```
vpc-eu-west-2-tools
```

## CIDR Blocks

The CIDR blocks should be an internal IP address for example 192 or 172, and the second octal should differ by 10. An example is given below:

```
172.16.0.0/21
172.26.0.0/21
```

## Subnets

---

Subnets should be named like the following. You should replace `{region}` with the region you are working in including availability zone, `{typ}` with either private or public, and `{purpose}` with what the subnet is going to house.

```
sn-{region}-{type}-{purpose}
```

Example

```
sn-eu-west-2a-pri-tools
```

# Route Tables

Route tables should be named like the following. You should replace `{region}` with the region your working in including the availability zone, and `{direction_of_data_travel}` with how the data is going to travel.

```
{region}-{direction_of_data_travel}
```

Example

```
eu-west-2a-public>>IGW
```

# NAT Gateways

NAT Gateways should be named like the following. You should replace `{region}` with the region your working in including the availability zone, `{type}` with what type the NAT Gateway is eg public or private, and `{purpose}` eg tools/workspace.

```
natgw-{region}-{type}-{purpose}
```

Example

```
natgw-eu-west-2a-pub-tools
```

# Security Groups

Security groups should be named like the following. You should change `{tool}` with the name of the tool or type of ec2 the security group will be applied to.

```
{tool}_sg
```

Example

```
jira_sg
```

## Recommended Security Groups

Below are recommended minimal security groups for all applications and tools. These ports must be opened as a minimum for the environment to function.

### ec2_linux_sg

Standard Security group for Linux EC2

Inbound

| Type        | Protocol     | Port Range | Source               | Description                          |
| ----------- | ------------ | ---------- | -------------------- | ------------------------------------ |
| SSH         | TCP          | 22         | WorkSpaces_Subnet/21 | Allow WorkSpaces to SSH onto the EC2 |
| Custom ICMP | Echo Request | 8-0        | WorkSpaces_Subnet/21 | Allow WorkSpaces to ping EC2s        |

Outbound

| Type    | Protocol | Port Range | Destination          | Description                                        |
| ------- | -------- | ---------- | -------------------- | -------------------------------------------------- |
| HTTP    | TCP      | 80         | 0.0.0.0/0            | HTTP Internet Traffic                              |
| HTTPS   | TCP      | 443        | 0.0.0.0/0            | HTTPS Internet Traffic                             |
| All TCP | TCP      | 0-65535    | Tools_Subnet/21      | Allow all TCP traffic to pass to WorkSpaces subnet |
| All UDP | UDP      | 0-65535    | Tools_Subnet/21      | Allow all UDP traffic to pass to WorkSpaces subnet |
| All TCP | TCP      | 0-65535    | WorkSpaces_Subnet/21 | Allow all TCP traffic to pass to WorkSpaces subnet |
| All UDP | UDP      | 0-65535    | WorkSpaces_Subnet/21 | Allow all UDP traffic to pass to WorkSpaces subnet |

### ec2_windows_sg

Standard Security group for Windows EC2

Inbound

| Type | Protocol | Port Range | Source               | Description                   |
| ---- | -------- | ---------- | -------------------- | ----------------------------- |
| RDP  | TCP      | 3389       | WorkSpaces_Subnet/21 | Allow RDP from AWS WorkSpaces |

Outbound

| Type       | Protocol | Port Range | Destination          | Description                                                      |
| ---------- | -------- | ---------- | -------------------- | ---------------------------------------------------------------- |
| HTTP       | TCP      | 80         | 0.0.0.0/0            | HTTP Internet Traffic                                            |
| HTTPS      | TCP      | 443        | 0.0.0.0/0            | HTTPS Internet Traffic                                           |
| All TCP    | TCP      | 0-65535    | WorkSpaces_Subnet/21 | Allow all TCP traffic to pass to WorkSpaces subnet               |
| All UDP    | UDP      | 0-65535    | WorkSpaces_Subnet/21 | Allow all UDP traffic to pass to WorkSpaces subnet               |
| Custom TCP | TCP      | 5985-5986  | 0.0.0.0/0            | Allow WS-Management and PowerShell remote connections to be used |

### ldap_sg

Allow outbound LDAP to the local network.

Outbound

| Type | Protocol | Port Range | Destination          | Description                        |
| ---- | -------- | ---------- | -------------------- | ---------------------------------- |
| LDAP | TCP      | 389        | WorkSpaces_Subnet/21 | Allow LDAP to connect to local VPC |

### smtp_sg

Allow outbound SMTP to allow emails to be sent.

Outbound

| Type | Protocol | Port Range | Destination          | Description             |
| ---- | -------- | ---------- | -------------------- | ----------------------- |
| CUSTOM TCP | TCP      | 587         | 0.0.0.0/0            | SMTP transmission port to AWS SES |
| SMTPS | TCP      | 465         | 0.0.0.0/0            | SMTP transmission port to AWS SES |
| SMTP | TCP      | 25         | 0.0.0.0/0            | SMTP transmission port to AWS SES |


### jira_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8443       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8443       | WorkSpaces_Subnet/21 | HTTPS Listener |

### confluence_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8443       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8443       | WorkSpaces_Subnet/21 | HTTPS Listener |

### bitbucket_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8443       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8443       | WorkSpaces_Subnet/21 | HTTPS Listener |
| Custom TCP Rule | TCP      | 7999       | Tools_Subnet/21      | SSH Listener   |
| Custom TCP Rule | TCP      | 7999       | WorkSpaces_Subnet/21 | SSH Listener   |

### nexus_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8443       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8443       | WorkSpaces_Subnet/21 | HTTPS Listener |

### jenkins_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8443       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8443       | WorkSpaces_Subnet/21 | HTTPS Listener |

### vault_sg

Inbound

| Type            | Protocol | Port Range | Source               | Description    |
| --------------- | -------- | ---------- | -------------------- | -------------- |
| Custom TCP Rule | TCP      | 8200       | Tools_Subnet/21      | HTTPS Listener |
| Custom TCP Rule | TCP      | 8200       | WorkSpaces_Subnet/21 | HTTPS Listener |

# EC2 Instances

EC2's should be named like the following. You should change `{region}` with the region you are working including the availability zone, and `{tool_name}` with the name of the tool which is to be installed on the EC2 or the purpose of the EC2.

```
{region}-{tool_name}
```

Example

```
eu-west-2a-confluence
```

# Route 53 Active Directory Domain

Your domain should be of the form:

```
{project_name}.cloud
```

The domain for your Active Directory should be of the form:

```
ad.{project_name}.cloud
```

The domain for your Route 53 service should be of the form:

```
tools.{project_name}.cloud
```

# IAM Roles

IAM Roles should be names like the following. You should change `{project_name}` with the name of your project, and `{role_purpose}` with the name of the role.

```
{project_name}-{role_purpose}
```

Example

```
ibm-billing
```

<h1>Pathways</h1>

|         |  |  |
| :-------------: |:--:|:-------------:|
||[Before you begin](before-you-begin.md) | |
||***Conventions Guide***| |
||[Quick Reference](quick-reference.md) | |
||[AWS Overview](aws-overview.md) | |
| **Manual** |  | **Auto** |
|**&#8595;**| |**&#8595;**
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md) 
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)   
| [Tools Manual Installation](tools-manual-installation.md)   | | [Tools Automatic Install](tools-automatic-installation.md)
| [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First time setup of tools](first-time-tools-setup.md)
||[First time setup of workspaces](first-time-workspaces-setup.md)



[<< Before you begin](before-you-begin.md)

[Quick Reference >>](quick-reference.md)
