<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Welcome](#markdown-header-welcome)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Welcome

By following this documentation, you have the choice of two pathways - each pathway describes how to build an AWS environment.

The pathways are split into **Manual Pathway** and **Automatic Pathway**. Each pathway will lead you to the **First Time Setup** section, where you will create WorkSpaces for users in your Active Directory, Configure CloudWatch and GuardDuty, Create EC2 Snapshot (backup) policies and configure WorkSpaces ready for secure development.

You must choose which path to follow to set up your AWS infrastructure.

The **Manual Pathway** contains instructions that provide guidance on how to create individual resources and connect them together. In addition, some technical background is included.

The **Automatic Pathway** contains instructions to execute Terraform, Ansible and PowerShell scripts. When configured, these scripts build the Environment pictured in the [Environment Diagram](./pathways.md#environment-diagram), install a suite of development tools and automatically import a set of users and groups into your Active Directory.

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
||[First Time Setup of WorkSpaces](first-time-WorkSpaces-setup.md)








