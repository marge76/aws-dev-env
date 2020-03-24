[<< Pathways](README.md)

[< Before you begin](before-you-begin.md)

# AWS Overview

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Component definitions](#markdown-header-component-definitions)
- [Default AMI Usernames](#markdown-header-default-ami-usernames)
- [Pathways](#markdown-header-pathways)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Component definitions

**AWS**: Amazon Web Services cloud provider.

**VPC**: A virtual network in the cloud which holds a range of IP addresses.

**Subnetwork** (subnet): A segment of a VPC's IP address range where you can place groups of isolated resources.

**Active Directory**: A highly available and cost-effective primary directory in the AWS Cloud. Used to manage users, groups, and computers. It enables you to associate [Amazon EC2](https://aws.amazon.com/ec2/) instances to your domain easily and supports many [AWS and third-party applications and services](https://aws.amazon.com/directoryservice/details/).

**EC2: Elastic Compute Cloud**: A web service that provides secure, resizable compute capacity in the cloud. It is designed to make web-scale cloud computing easier for developers. EC2s are referred to as "instances" or "boxes"

**Identity and Access Management (IAMS)**: Enables you to manage access to AWS services and resources securely. Using IAM, you can create and manage AWS users and groups, and use permissions to allow and deny their access to AWS resources.

**Internet Gateway**: The Amazon VPC side of a connection to the public Internet

**NAT Gateway**: A highly available, managed Network Address Translation (NAT) service for your resources in a private subnet to access the Internet.

**Workspace**: A virtual computer

**CloudWatch**: A utility that lets you monitor and manage your different resources, including EC2 instances and WorkSpaces through setting restrictions and warnings through alarms.

**GuardDuty** is a threat detection utility that protects your AWS account and workloads.

# Default AMI Usernames

Amazon Machine Images (AMIs) are operating systems installed on an EC2 instance at the time of provisioning. When connecting to an EC2 instance via ssh, you will first need to connect as the default user. Some default users for some AMIs are listed below.

| AMI            | Default Username     |
| -------------- | -------------------- |
| CentOS         | centos               |
| Debian         | admin _or_ root      |
| Fedora         | fedora _or_ ec2-user |
| RHEL           | root _or_ ec2-user   |
| SUSE           | root _or_ ec2-user   |
| Amazon Linux 2 | ec2-user             |
| Ubuntu         | ubuntu               |


<h1>Pathways</h1>

|         |  |  |
| :-------------: |:--:|:-------------:|
||[Before you begin](before-you-begin.md) | |
||[Conventions Guide](conventions-guide.md)| |
||[Quick Reference](quick-reference.md) | |
||***AWS Overview*** | |
| **Manual** |  | **Auto** |
|**&#8595;**| |**&#8595;**
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md) 
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)   
|[Tools Manual Installation](tools-manual-installation.md)   | | [Tools Automatic Install](tools-automatic-installation.md)
| [Create a WorkSpace (Additional workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (Additional workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First time setup of tools](first-time-tools-setup.md)
||[First time setup of workspaces](first-time-workspaces-setup.md)

[Choose your setup pathway >>](pathways.md)
