data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

data "aws_ami" "amazon_windows_2016" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
}

############## EC2 in availability Zone 2a-atlassian ##################

# Centos EC2 instance for Squid Proxy

resource "aws_instance" "ec2-eu-west-2a-squid-proxy-tools" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t3.xlarge"
  subnet_id                   = "${aws_subnet.subnet-eu-west2a-pub-tools.id}"
  vpc_security_group_ids      = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.ec2_squid_sg.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  source_dest_check           = false
  associate_public_ip_address = "true"
  key_name                    = "${var.project["ec2_key_name"]}"
  monitoring                  = true

  tags = {
    Name       = "ec2-eu-west-2a-squid-proxy-tools"
    Managed    = "Managed By Terraform"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-squid-proxy-tools"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = false
  }
}

resource "aws_instance" "ec2-eu-west-2a-squid-proxy-workspace" {
  ami                         = "${data.aws_ami.centos.id}"
  instance_type               = "t3.xlarge"
  subnet_id                   = "${aws_subnet.subnet-eu-west-2a-pub-workspaces.id}"
  vpc_security_group_ids      = ["${aws_security_group.ec2_linux_sg_workspace.id}", "${aws_security_group.ec2_squid_sg_workspace.id}"]
  iam_instance_profile        = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  source_dest_check           = false
  associate_public_ip_address = "true"
  key_name                    = "${var.project["ec2_key_name"]}"
  monitoring                  = true

  tags = {
    Name       = "ec2-eu-west-2a-squid-proxy-workspace"
    Managed    = "Managed By Terraform"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-squid-proxy-workspace"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = false
  }
}

# Centos EC2 instance for Bitbucket
resource "aws_instance" "ec2-eu-west-2a-tools-bitbucket" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t3.large"
  subnet_id              = "${aws_subnet.subnet-2a-priv-tools-atlassian.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.bitbucket_sg.id}", "${aws_security_group.ldap_sg.id}", "${aws_security_group.smtp_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name               = "${var.project["ec2_key_name"]}"
  monitoring             = true

  tags = {
    Name       = "ec2-eu-west-2a-tools-bitbucket"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours-extended"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-tools-bitbucket"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 250
    delete_on_termination = false
  }
}

# Centos EC2 instance for JIRA
resource "aws_instance" "ec2-eu-west-2a-tools-jira" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.medium"
  subnet_id              = "${aws_subnet.subnet-2a-priv-tools-atlassian.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.jira_sg.id}", "${aws_security_group.ldap_sg.id}", "${aws_security_group.smtp_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name               = "${var.project["ec2_key_name"]}"
  monitoring             = true

  tags = {
    Name       = "ec2-eu-west-2a-tools-jira"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours-extended"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-tools-jira"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 120
    delete_on_termination = false
  }
}

# EC2 instance for Confluence
resource "aws_instance" "ec2-eu-west-2a-tools-confluence" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.medium"
  subnet_id              = "${aws_subnet.subnet-2a-priv-tools-atlassian.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.confluence_sg.id}", "${aws_security_group.ldap_sg.id}", "${aws_security_group.smtp_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name               = "${var.project["ec2_key_name"]}"
  monitoring             = true

  tags = {
    Name       = "ec2-eu-west-2a-tools-confluence"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours-extended"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-tools-confluence"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 120
    delete_on_termination = false
  }
}

# EC2 instance for Vault
resource "aws_instance" "ec2-eu-west-2a-tools-vault" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.medium"
  subnet_id              = "${aws_subnet.subnet-2a-priv-tools-ops.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.vault_sg.id}", "${aws_security_group.ldap_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name               = "${var.project["ec2_key_name"]}"
  monitoring             = true

  tags = {
    Name       = "ec2-eu-west-2a-tools-vault"
    Managed    = "Managed By Terraform"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-tools-vault"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 120
    delete_on_termination = false
  }
}

# Windows server 2k16 EC2 instance for AD Management
resource "aws_instance" "ec2-eu-west-2a-tools-admanage" {
  ami                     = "${data.aws_ami.amazon_windows_2016.image_id}"
  disable_api_termination = "true"
  instance_type           = "t2.medium"
  subnet_id               = "${aws_subnet.subnet-2a-priv-tools-ops.id}"
  vpc_security_group_ids  = ["${aws_security_group.ec2_windows_sg.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.AmazonEC2RoleForSCMTFProfile.name}"
  key_name                = "${var.project["ec2_key_name"]}"
  monitoring              = true

  tags = {
    Name       = "ec2-eu-west-2a-tools-admanage"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours"
    PatchGroup = "defaultWindowsBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-tools-admanage"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  provisioner "file" {
    source      = "powershell_scripts/"
    destination = "C:/Users/admin/Desktop/scripts"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("${var.project["path_to_EC2_private_key"]}")}"
    }
  }

  user_data = <<EOF
<script>
  winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
</script>
<powershell>
  netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
  $user = [adsi]"WinNT://localhost/Administrator,user"
  $user.SetPassword("${var.project["windows_server_admin_pwd"]}")
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
</powershell>
EOF
}

############## END OF EC2 in availability Zone 2a ##################

############## EC2 in availability Zone 2b ##################

# EC2 instance for Jenkins
resource "aws_instance" "ec2-eu-west-2b-jenkins" {
  ami                    = "${data.aws_ami.centos.id}"
  instance_type          = "t2.xlarge"
  subnet_id              = "${aws_subnet.subnet-eu-west-2b-priv-tools-pipeline.id}"
  vpc_security_group_ids = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.jenkins_sg.id}", "${aws_security_group.ldap_sg.id}", "${aws_security_group.smtp_sg.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name               = "${var.project["ec2_key_name"]}"
  monitoring             = true

  tags = {
    Name       = "ec2-eu-west-2b-jenkins"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2b-jenkins"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 500
    delete_on_termination = false
  }
}

# EC2 instance for OKD - ALL IN ONE
resource "aws_instance" "ec2-eu-west-2a-okd" {
  ami                     = "${data.aws_ami.centos.id}"
  disable_api_termination = "true"
  instance_type           = "t3.2xlarge"
  subnet_id               = "${aws_subnet.subnet-eu-west-2a-priv-okd.id}"
  vpc_security_group_ids  = ["${aws_security_group.ec2_linux_sg.id}", "${aws_security_group.okd_sg.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name                = "${var.project["ec2_key_name"]}"
  monitoring              = true

  tags = {
    Name       = "ec2-eu-west-2a-okd"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-okd"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 256
    delete_on_termination = false
  }

  count = "${var.project["okd_aio"]}"
}

# EC2 instanceS for OKD - CLUSTER

resource "aws_instance" "ec2-eu-west-2a-okd-master" {
  ami                     = "${data.aws_ami.centos.id}"
  disable_api_termination = "true"
  instance_type           = "t3.xlarge"
  subnet_id               = "${aws_subnet.subnet-eu-west-2a-priv-okd.id}"
  vpc_security_group_ids  = ["${aws_security_group.ec2_linux_test_sg.id}", "${aws_security_group.okd_sg.id}", "${aws_security_group.okd_masters.id}", "${aws_security_group.okd_nodes.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name                = "${var.project["ec2_key_name"]}"
  monitoring              = true

  tags = {
    Name       = "ec2-eu-west-2a-okd"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-okd"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = false
    volume_size           = 256
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_instance" "ec2-eu-west-2a-okd-node" {
  ami                     = "${data.aws_ami.centos.id}"
  disable_api_termination = "true"
  instance_type           = "t3.large"
  subnet_id               = "${aws_subnet.subnet-eu-west-2a-priv-okd.id}"
  vpc_security_group_ids  = ["${aws_security_group.ec2_linux_test_sg.id}", "${aws_security_group.okd_sg.id}", "${aws_security_group.okd_nodes.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.PatchManagerRoleProfile.name}"
  key_name                = "${var.project["ec2_key_name"]}"
  monitoring              = true

  tags = {
    Name       = "ec2-eu-west-2a-okd-node"
    Managed    = "Managed By Terraform"
    Schedule   = "uk-office-hours"
    PatchGroup = "defaultCentOSBaseline"
  }

  volume_tags = {
    Name     = "ec2-eu-west-2a-okd-node"
    Managed  = "Managed By Terraform"
    snapshot = "daily"
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = false
    volume_size           = 256
  }

  count = "${var.project["okd_cluster"]}"
}
