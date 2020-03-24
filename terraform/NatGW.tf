############## Nat gateway for west 2a public workspaces ############
resource "aws_eip" "elasticIP" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-eu-west2a-pub-workspaces" {
  allocation_id = "${aws_eip.elasticIP.id}"
  subnet_id     = "${aws_subnet.subnet-eu-west-2a-pub-workspaces.id}"

  tags {
    Name = "natgw-eu-west2a-pub-workspaces"
    Managed = "Managed By Terraform"
  }
}

############## Nat gateway for west 2a public tools ############
resource "aws_eip" "elasticIP2" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-eu-west2a-pub-tools" {
  allocation_id = "${aws_eip.elasticIP2.id}"
  subnet_id     = "${aws_subnet.subnet-eu-west2a-pub-tools.id}"

  tags {
    Name = "natgw-eu-west2a-pub-tools"
    Managed = "Managed By Terraform"
  }
}


############## Nat gateway for west 2a public test ############

resource "aws_eip" "elasticIP3" {
  vpc = true
}

resource "aws_nat_gateway" "natgw-eu-west2a-pub-test" {
  allocation_id = "${aws_eip.elasticIP3.id}"
  subnet_id     = "${aws_subnet.subnet-eu-west-2a-pub-okd.id}"

  tags {
    Name = "natgw-eu-west2a-pub-test"
    Managed = "Managed By Terraform"
  }
}