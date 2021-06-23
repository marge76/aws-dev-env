#Security groups protocols identifier
# 1 = ICMP
# 6 = TCP

resource "aws_security_group" "ec2_linux_sg" {
  name        = "ec2_linux_sg"
  description = "Standard Security group for Linux EC2 "
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "6"
    description = "Allow Workspaces to SSH onto the EC2"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8"
    to_port     = "0"
    protocol    = "ICMP"
    description = "Allow Workspaces to ping EC2s"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "TCP"
    description = "Allow all TCP traffic to pass to Tools and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "UDP"
    description = "Allow all UDP traffic to pass to Tools and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    description = "HTTPS internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "HTTP internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_linux_sg"
  }
}

resource "aws_security_group" "ec2_linux_sg_workspace" {
  name        = "ec2_linux_sg_workspace"
  description = "Standard Security group for Linux EC2 in workspace VPC"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-workspaces.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "6"
    description = "Allow Workspaces to SSH onto the EC2"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8"
    to_port     = "0"
    protocol    = "ICMP"
    description = "Allow Workspaces to ping EC2s"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  tags = {
    Name = "ec2_linux_sg_workspace"
  }
}

resource "aws_security_group" "ec2_windows_sg" {
  name        = "ec2_windows_sg"
  description = "Standard Security group for Windows EC2 "
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "3389"
    to_port     = "3389"
    protocol    = "6"
    description = "Allow RDP from AWS Workspace"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "5985"
    to_port     = "5986"
    protocol    = "TCP"
    description = "Allow WS-Management and PowerShell remote connections to be used"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "HTTP internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    description = "HTTPS internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "TCP"
    description = "Allow all TCP traffic to pass to Workspaces subnet"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "UDP"
    description = "Allow all UDP traffic to pass to Workspace subnet"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  tags = {
    Name = "ec2_windows_sg"
  }
}

resource "aws_security_group" "ldap_sg" {
  name        = "ldap_sg"
  description = "Allow outbound LDAP to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  egress {
    from_port   = "389"
    to_port     = "389"
    protocol    = "6"
    description = "Allow LDAP to connect to WorkSpace VPC"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  tags = {
    Name = "ldap_sg"
  }
}

resource "aws_security_group" "smtp_sg" {
  name        = "smtp_sg"
  description = "Allow outbound SMTP to allow emails to be sent"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  egress {
    from_port   = "587"
    to_port     = "587"
    protocol    = "TCP"
    description = "SMTP transmission port to AWS SES"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "25"
    to_port     = "25"
    protocol    = "TCP"
    description = "SMTP transmission port to AWS SES"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "465"
    to_port     = "465"
    protocol    = "TCP"
    description = "SMTP transmission port to AWS SES"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "smtp_sg"
  }
}

resource "aws_security_group" "jira_sg" {
  name        = "jira_sg"
  description = "Expose ports required for Jira usage to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where Jira is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  tags = {
    Name = "jira_sg"
  }
}

resource "aws_security_group" "confluence_sg" {
  name        = "confluence_sg"
  description = "Expose ports required for Confluence usage to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where Confluence is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  tags = {
    Name = "confluence_sg"
  }
}

resource "aws_security_group" "bitbucket_sg" {
  name        = "bitbucket_sg"
  description = "Expose ports required for Bitbucket Usage to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where Bitbucket is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "7999"
    to_port     = "7999"
    protocol    = "6"
    description = "TCP Listening port for Bitbucket server"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  tags = {
    Name = "bitbucket_sg"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Expose ports required for Jenkins Usage to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where Jenkins is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "Docker Registry port"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "5000"
    to_port     = "5000"
    protocol    = "6"
    description = "Allow Docker to pull necessary containers from OKD"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

resource "aws_security_group" "vault_sg" {
  name        = "vault_sg"
  description = "Expose ports required for Vault Usage to local network"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}"

  ingress {
    from_port   = "8200"
    to_port     = "8200"
    protocol    = "6"
    description = "Port where Vault service can be accessed from Workspaces and other Tools"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  tags = {
    Name = "vault_sg"
  }
}

resource "aws_security_group" "okd_sg" {
  name        = "ec2_okd_sg"
  description = "Standard Security group specific for openshift OKD ec2 instance"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-test.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where OKD is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "5000"
    to_port     = "5000"
    protocol    = "6"
    description = "Docker Registry port"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "Port where the front-end UI is accessible from"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    description = "Port where the okd Console is accessible from"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "9000"
    to_port     = "9000"
    protocol    = "TCP"
    description = "Port where the back-end Service is accessible from"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "27017"
    to_port     = "27017"
    protocol    = "TCP"
    description = "Port where the Mongo database will be accessible from"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Port where the okd Console is accessible from"
    cidr_blocks = ["${var.tools-vpc["cidr"]}"]
  }

  egress {
    from_port   = "8200"
    to_port     = "8200"
    protocol    = "6"
    description = "Allow OKD to communicate with Vault"
    cidr_blocks = ["${var.tools-vpc["cidr"]}"]
  }

  egress {
    from_port   = "5671"
    to_port     = "5671"
    protocol    = "TCP"
    description = "Allow OKD to communicate with a messaging Broker"
    cidr_blocks = ["${var.tools-vpc["cidr"]}"]
  }

  tags = {
    Name = "okd_sg"
  }
}

resource "aws_security_group" "okd_masters" {
  name        = "ec2_okd_master_sg"
  description = "Standard Security group specific for openshift OKD master ec2 instances"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-test.id}"

  ingress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "6"
    description = "Our defined HTTPS port where OKD is run"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}", "${var.tools-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "53"
    to_port     = "53"
    protocol    = "UDP"
    description = "Master Node communication"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "53"
    to_port     = "53"
    protocol    = "TCP"
    description = "Master Node communication"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8053"
    to_port     = "8053"
    protocol    = "UDP"
    description = "Master Node communication"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8053"
    to_port     = "8053"
    protocol    = "TCP"
    description = "Master Node communication"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "UDP"
    description = "Allow OKD masters to communicate with nodes. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "UDP"
    description = "Allow OKD masters to communicate with nodes. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8444"
    to_port     = "8444"
    protocol    = "TCP"
    description = "Our defined HTTPS port where OKD is run"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "10250"
    to_port     = "10250"
    protocol    = "TCP"
    description = "Allow OKD masters to communicate with nodes. The master proxies to node hosts via the Kubelet for oc commands."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  tags = {
    Name = "okd_master"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_security_group" "okd_nodes" {
  name        = "ec2_okd_nodes_sg"
  description = "Standard Security group specific for openshift OKD node ec2 instances"
  vpc_id      = "${aws_vpc.vpc-eu-west-2-test.id}"

  egress {
    from_port   = "8053"
    to_port     = "8053"
    protocol    = "UDP"
    description = "Allow OKD nodes to communicate with masters. Required for DNS resolution of cluster services."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "8053"
    to_port     = "8053"
    protocol    = "TCP"
    description = "Allow OKD nodes to communicate with masters. Required for DNS resolution of cluster services."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "UDP"
    description = "Allow OKD nodes to communicate with masters. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "4789"
    to_port     = "4789"
    protocol    = "UDP"
    description = "Allow OKD masters to communicate with nodes. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "10250"
    to_port     = "10250"
    protocol    = "TCP"
    description = "Allow OKD masters to communicate with nodes. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "10010"
    to_port     = "10010"
    protocol    = "TCP"
    description = "Allow OKD masters to communicate with nodes. Required for SDN communication between pods on separate hosts."
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "TCP"
    description = "Required for node hosts to communicate to the master API, for the node hosts to post back status, to receive tasks etc"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "8443"
    to_port     = "8443"
    protocol    = "TCP"
    description = "Required for node hosts to communicate to the master API, for the node hosts to post back status, to receive tasks etc"
    cidr_blocks = ["${var.test-vpc["cidr"]}"]
  }

  tags = {
    Name = "okd_nodes"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_security_group" "ec2_linux_test_sg" {
  name        = "ec2_linux_test_sg"
  description = "Standard Security group for Linux EC2 "
  vpc_id      = "${aws_vpc.vpc-eu-west-2-test.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "6"
    description = "Allow Workspaces to SSH onto the EC2"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8"
    to_port     = "0"
    protocol    = "ICMP"
    description = "Allow Workspaces to ping EC2s"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "TCP"
    description = "Allow all TCP traffic to pass to Tools and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "UDP"
    description = "Allow all UDP traffic to pass to Tools and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    description = "HTTPS internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "HTTP internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_linux_test_sg"
  }
}

resource "aws_security_group" "ec2-openvpn-sg" {
  name        = "ec2-openvpn-sg"
  description = "Security group for OpenVPN server "
  vpc_id      = "${aws_vpc.vpc-eu-west-2-workspaces.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "6"
    description = "Allow Workspaces to SSH onto the EC2"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "8"
    to_port     = "0"
    protocol    = "ICMP"
    description = "Allow Workspaces to ping EC2s"
    cidr_blocks = ["${var.workspace-vpc["cidr"]}"]
  }

  ingress {
    from_port   = "969"
    to_port     = "969"
    protocol    = "TCP"
    description = "Allow clients to access openvpn"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "1194"
    to_port     = "1194"
    protocol    = "UDP"
    description = "Allow vpn connection"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "951"
    to_port     = "951"
    protocol    = "TCP"
    description = "Allow clients to access openvpn"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "TCP"
    description = "Allow all TCP traffic to pass to Tools, Test and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "UDP"
    description = "Allow all UDP traffic to pass to Tools Test and Workspaces subnets"
    cidr_blocks = ["${var.tools-vpc["cidr"]}", "${var.workspace-vpc["cidr"]}", "${var.test-vpc["cidr"]}"]
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "6"
    description = "HTTPS internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "6"
    description = "HTTP internet traffic"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2_linux_test_sg"
  }
}
