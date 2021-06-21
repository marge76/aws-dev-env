[<< Pathways](README.md)

# Before You Begin

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Key Occurrences users may find whilst using this walkthrough](#markdown-header-key-occurrences-users-may-find-whilst-using-this-walkthrough)
- [Format of this document](#markdown-header-format-of-this-document)
- [Using text editors to modify file contents](#markdown-header-using-text-editors-to-modify-file-contents)
- [Choosing the appropriate region, email service and directory](#markdown-header-choosing-the-appropriate-region-email-service-and-directory)
- [Pathways](#markdown-header-pathways)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Key Occurrences users may find whilst using this walkthrough

Whilst making your way through this Walkthrough guide, each section may contain a list of 'Key Occurrences'. If something is not working as expected, these key occurrences should be your first point of call for troubleshooting.

- Please check the system hardware and software requirements of applications
  before installing.

- Performance of servers may vary depending on the software you
  install. A `T2.Micro` will install Jenkins with no issues but will
  struggle under load.

# Format of this document

If an item or field is not mentioned, then assume that does not require additional configuration. You should use the default settings
provided or leave the field blank, if possible.

Screenshots are provided showing working examples of how to complete sections.

Code, port numbers and other command line text is formatted in this
document like `this example code` or:

```txt
this example code
```

Some pages may have additional advisory content before the section begins. Please read these notes carefully.

# Using text editors to modify file contents

The instructions in this document assume that the reader has a basic
knowledge of using text editors in the command line. Our examples use vi
or vim, for those unfamiliar with **vi**, the following information commands may be useful.

1.  Enter a file by typing:

```bash
vi filename.txt
```

If the file does not exist, this will create it.

2.  When you enter a file, you are in "Read" mode.

3.  Whilst in `read` mode:

    - Use the arrow keys to navigate

    - Press `Shift` and `g` to go to the end of the file.

    - Type /pattern to search for a string 'pattern' e.g.
      **/8080** will highlight strings matching **8080**.

      - Press **n** to go to the next matching string.

4.  Press `i` to enter Insert (`write`) mode. Press `ESC` to enter `read` mode Whilst in Insert mode:

    - Use the arrow keys to navigate and insert text in the appropriate space.

    - To save and quit a file, press `ESC` then type **:wq**.

    - To quit a file without saving, press `ESC` then type **:q!**.

If the user prefers to use an alternative text editor, such as `nano`,
feel free to use that. You may need to install the editor using `yum`.

# Choosing the appropriate region, email service and directory

You must select the region: London (`eu-west-2`).

- A list of all regions and which components they support can be [found
  here]https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/).

Amazon's Simple Email Service (SES) is only available in the Ireland
region, the SES only acts as a relay.

For the provisioning of WorkSpaces, Microsoft Active Directories must be used.

<h1>Pathways</h1>

|         |  |  |
| :-------------: |:--:|:-------------:|
||***Before you begin*** | |
||[Conventions Guide](conventions-guide.md)| |
||[Quick Reference](quick-reference.md) | |
||[AWS Overview](aws-overview.md) | |
| **Manual** |  | **Auto** |
|**&#8595;**| |**&#8595;**
| [AWS Manual Setup](aws-manual-infrastructure.md) | | [AWS Automatic Setup](aws-automatic-infrastructure.md)
| [Create a WorkSpace (AD setup)](create-a-workspace.md) | | [Create a WorkSpace (AD setup)](create-a-workspace.md) 
| [Setup Single Sign on](setup-single-sign-on.md) | | [Setup Single Sign on](setup-single-sign-on.md) <br> [ - Import Users](setup-single-sign-on.md#Import-Users-and-Groups-to-the-Active-Directory) <br> [ - Configuring the AWS Management Console and AD](setup-single-sign-on.md#Configuring-the-AWS-Management-Console-and-AD)   
|[Tools Manual Installation](tools-manual-installation.md)   | | [Tools Automatic Install](tools-automatic-installation.md)
| [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)  | | [Create a WorkSpace (team workspaces)](create-a-workspace.md##create-additional-workspaces)
||**&#8595;**
||[Additional AWS Setup](additional-aws-setup.md) | |
||[First time setup of tools](first-time-tools-setup.md)
||[First time setup of workspaces](first-time-workspaces-setup.md)

[Conventions Guide >>](conventions-guide.md)
