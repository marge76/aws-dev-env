# VPC for Workspaces
resource "aws_vpc" "vpc-eu-west-2-workspaces" {
  cidr_block = "${var.workspace-vpc["cidr"]}"

  tags = {
    Name = "${var.workspace-vpc["name"]}"
    Managed = "Managed By Terraform"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# VPC for tools
resource "aws_vpc" "vpc-eu-west-2-tools" {
  cidr_block = "${var.tools-vpc["cidr"]}"

  tags = {
    Name = "${var.tools-vpc["name"]}"
    Managed = "Managed By Terraform"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}

# VPC for Testing
resource "aws_vpc" "vpc-eu-west-2-test" {
  cidr_block = "${var.test-vpc["cidr"]}"

  tags = {
    Name = "${var.test-vpc["name"]}"
    Managed = "Managed By Terraform"
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}