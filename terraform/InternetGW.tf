# Internet gateway for vpc-eu-west-2-workspaces
resource "aws_internet_gateway" "igw-eu-west-2a-workspace" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-workspaces.id}"

  tags = {
    Name = "igw-eu-west-2a-workspace"
    Managed = "Managed By Terraform"
  }
}

# Internet gateway for vpc-eu-west-2-tools
resource "aws_internet_gateway" "igw-eu-west-2a-2b" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"

  tags = {
    Name = "igw-eu-west-2a-2b"
    Managed = "Managed By Terraform"
  }
}


# Internet gateway for vpc-eu-west-2-test
resource "aws_internet_gateway" "igw-eu-west-2a-test" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"

 tags = {
    Name = "igw-eu-west-2a-test"
    Managed = "Managed By Terraform"
  }
}
