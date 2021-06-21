# Terraforming AWS

Welcome to the terraforming project. This project allows the user to create, change or destroy an AWS environment.

## Background

Terraform is a tool that is used for building, modifying, managing and destroying cloud environments. For this project, Terraform is configured to the AWS Cloud infrastructure.

## Getting Started

Terraform uses the .tf file extension for its configuration files, these are used to create and modify the environment.

Terraform uses the .tfstate file extension for its **state configuration** files, these are used to manage and destroy the environment.

This project contains two files:

**cedc_terraform.tf**

Houses the basic configuration of the environment
**Only modify this file if a fundamental change to the structure of the environment is required.**

**vars.tf**

Houses the variables used in the main cedc_terraform.tf file.

**ALL CHANGES MADE BY THE USER SHOULD BE IN THIS FILE ONLY.**

## <span style="color:red">IMPORTANT</span>

When pulling this project, ensure you remove the .tfstate and .tfstatebackup files. This allows you to manage your own environment and are in this repository for development purposes – they will be removed at a later date.

## Installing Terraform

For Terraform to work on your machine, you must first install Terraform and add it to your terminal $PATH. All these instructions are for Mac users only; other platforms will follow.

## For Mac OS
1. Downloading Terraform for Mac. The following example command will download the Terraform .zip file from the HashiCorp website. You should look to use the latest version available.

```
wget https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_darwin_amd64.zip
```

2. Next unzip the folder.

```
unzip terraform_0.15.5_darwin_amd64.zip
```

3. Move the Terraform file to your terminal path

```
sudo mv terraform /usr/local/bin
```

4. Ensure Terraform has installed correctly by running the following command.

```
terraform --version
```

Your should get a version number something like:

```
Terraform v0.15.5
```

5. That's it. You should now have Terraform installed and be able to run any Terraform command.

## For Windows OS
1. Download installation .exe file from https://www.terraform.io/downloads.html
2. Extract the zip file at appropriate location (Please save this .exe file somewhere easier to access such as c:\tools\terraform)
3. Add location of the directory where you saved this terraform file into your environment path variable by following the steps below.
    1. In Search, search for and then select: System (Control Panel)
    2. Click the Advanced system settings link.
    3. Click Environment Variables. In the section System Variables, find the PATH environment variable and select it. Click Edit. If the PATH environment variable does not exist, click New.
    4. In the Edit System Variable (or New System Variable) window, specify the value of the PATH environment variable (**c:\tools\terraform** in this example). Click OK. Close all remaining windows by clicking OK.
4. Verifying the Installation by running the following command in terminal window
```
terraform -v
```
Your should get a version number something like:
```
Terraform v0.15.5
```
-----

```
terraform -help
```

to get a list of commands used for Terraform.

## The .tf files

As a rule of thumb users should only change the details in the vars.tf file. The cedc_terraform.tf file should be left alone.

You should save a local copy of the .tfstate and .tfstatebackup files so that you can manage your own environments, unless you are making a new environment.

It is also important to note that when running Terraform **it only uses the .tf files from the directory you are currently working in.** Therefore, it is possible for you to manage multiple environments just by moving from one directory to another.

#### Generating key pair

1. In the Terraform directory, create a sub-directory called `keys`.
2. Run the following command/

```
ssh-keygen -f key.pem
```

3. The keygen will ask you for a passphrase. It is up to you to use a passphrase, to skip using passphrase, press enter.
4. That’s it. You should now have a 2048-bit RSA SSH key saved in your directory.
   Two files would have been generated with the name you specified earlier. One file will have the .pub file extension; this is the key you need to enter into the vars.tf. The other file is what you will use as your private key to login to the EC2. **MAKE SURE TO KEEP THIS KEY SAFE AND DO NOT SHARE**

## Initialising the environment

1. In order to create a new environment, you must first change your working directory to where tf (terraform) files are located.

2. Run the command below which will perform several different initialization steps in order to prepare a working directory for use.

```
terraform init
```

## Building an environment

1. In order to create a new environment, you must first change your working directory to where both cedc_terraform.tf and vars.tf files are located.

2. Apply the changes to the vars.tf files. Ensure all fields are filled in, else Terraform will throw errors or may build the environment incorrectly.

3. If this is the first time you are making this environment ensure both .tfstate and .tfstatebackup files have been deleted.

4. If you are ready to generate the environment run the following command.

```
terraform apply
```

This will first output what Terraform is about to do and it will wait for your input of either 'yes' or 'no'. Use this opportunity to review your set configuration before building the environment. The input will only except 'yes' as the 'go ahead' command, anything else will be seen as a 'no' and the operation will not proceed.

You are happy with your configuration, type 'yes' and hit enter.

That's it! Sit back and watch Terraform build the environment for you.

## Destroying the environment

If you would like to destroy the entire environment you can use the following command:

```
terraform destroy
```

Terraform will use the .tfstate file to destroy the environment. However, please note that at the time of writing Terraform does not support the creation or destruction of workspaces. Due to workspace dependencies, the terraform destroy will fail if a workspace is present. Therefore, you must ensure that you manually delete any workspaces in your environment before initiating the destruction command.

-----

## Limitations

#### 1. Automatic Workspace creation

As mentioned above, Terraform currently does not support the creation of workspaces. Therefore if a workspace is required then you should create it manually. However, Terraform will have already supplied the environment you need to launch the workspace.

#### 2. Connecting to an EC2

Another limitation of Terraform is that it does not generate a key pair to use with the EC2. Therefore, it is necessary to either generate a new key-pair, or use an existing one. Either way, **you should only enter the PUBLIC KEY to the vars.tf file and not your private key.**

## Issues

#### 1. Mailing Lists not created

The following error can occur if using certain versions of AWS 
```
Traceback (most recent call last): File "/usr/local/bin/aws", line 19, in <module> import awscli.clidriver 
File "/usr/local/lib/python3.6/site-packages/awscli/clidriver.py", line 24, in <module> from botocore.history import 
get_global_history_recorder ModuleNotFoundError: No module named 'botocore.history'
```
How to resolve:

1. Run the following commands:
    
    ```
    > pip uninstall awscli
    > curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
    > unzip awscli-bundle.zip
    > sudo ./awscli-bundle/install -b /usr/bin/aws
    ```

2. Refresh terminal e.g. close and open a new one or use your system specific refresh commands (source ~/.bashrc)

3. Run the following command and confirm the correct output is given instead of the previous error message
    ```
    > aws

    usage: aws [options] <command> <subcommand> [<subcommand> ...] [parameters]
    To see help text, you can run:
    aws help
    aws <command> help
    aws <command> <subcommand> help
    aws: error: too few arguments
    ```
   
#### 2. AWS credentials not set


Error: Missing credentials ie. access_key, secret_key and region

How to resolve:

1. Run the following command and enter your credentials when prompted
    ```
    > aws configure
    ```

2. The run Terraform normally

--------
## Further Reading

- [Terraform](https://www.terraform.io) - Terraform's main website
- [Terraform_AWS_Commands](https://www.terraform.io/docs/providers/aws/index.html) - A list of Terraform commands for AWS
- [HashiCorp](https://www.hashicorp.com) - HashiCorp's main website. They are the creators of Terraform
