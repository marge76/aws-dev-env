# Private subnet for Workspace VPC
resource "aws_subnet" "subnet-2a-priv-workspaces" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  cidr_block        = "${var.workspace-vpc["private_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.workspace-vpc["private_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Public subnet for workspace VPC
resource "aws_subnet" "subnet-eu-west-2a-pub-workspaces" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  cidr_block        = "${var.workspace-vpc["public_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.workspace-vpc["public_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Second private subnet for Workspace VPC
resource "aws_subnet" "sn-eu-west-2b-priv-workspaces" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  cidr_block        = "${var.workspace-vpc["private_subnet_2_cidr"]}"
  availability_zone = "${var.availability_zone_2b}"

 tags = {
    Name = "${var.workspace-vpc["private_subnet_2_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Private subnet for atlassian tools subnet
resource "aws_subnet" "subnet-2a-priv-tools-atlassian" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-tools.id}"
  cidr_block        = "${var.tools-vpc["priv_tools_atlassian_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.tools-vpc["priv_tools_atlassian_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Private subnet for OPS tools subnet
resource "aws_subnet" "subnet-2a-priv-tools-ops" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-tools.id}"
  cidr_block        = "${var.tools-vpc["priv_tools_ops_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.tools-vpc["priv_tools_ops_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Private subnet for pipeline's subnet
resource "aws_subnet" "subnet-eu-west-2b-priv-tools-pipeline" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-tools.id}"
  cidr_block        = "${var.tools-vpc["priv_pipeline_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2b}"

 tags = {
    Name = "${var.tools-vpc["priv_pipeline_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Public subnet for west 2a zone (pub tools)
resource "aws_subnet" "subnet-eu-west2a-pub-tools" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-tools.id}"
  cidr_block        = "${var.tools-vpc["pub_tools_1_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.tools-vpc["pub_tools_1_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# # # # # # TEST VPC SUBNETS

# Public subnet for Test VPC
resource "aws_subnet" "subnet-eu-west-2a-pub-okd" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-test.id}"
  cidr_block        = "${var.test-vpc["public_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.test-vpc["public_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Private subnet 1 for Test VPC
resource "aws_subnet" "subnet-eu-west-2a-priv-okd" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-test.id}"
  cidr_block        = "${var.test-vpc["private_subnet_cidr"]}"
  availability_zone = "${var.availability_zone_2a}"

 tags = {
    Name = "${var.test-vpc["private_subnet_name"]}"
    Managed = "Managed By Terraform"
  }
}

# Private subnet 2 for Test VPC
resource "aws_subnet" "subnet-eu-west-2b-priv-okd" {
  vpc_id            = "${aws_vpc.vpc-eu-west-2-test.id}"
  cidr_block        = "${var.test-vpc["private_subnet_2_cidr"]}"
  availability_zone = "${var.availability_zone_2b}"

 tags = {
    Name = "${var.test-vpc["private_subnet_2_name"]}"
    Managed = "Managed By Terraform"
  }
}