resource "aws_route_table" "workspace-eu-west-2a-public-to-igw" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-workspaces.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-eu-west-2a-workspace.id}"
  }

  tags = {
    Name    = "workspace-eu-west-2a-public->IGW"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route_table" "eu-west-2a-public-to-igw" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-eu-west-2a-2b.id}"
  }

  route {
    cidr_block                = "${var.test-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2a-test.id}"
  }

  route {
    cidr_block                = "${var.tools-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
  }

  tags = {
    Name    = "eu-west-2a-public->IGW"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route_table" "eu-west-2a-workspace-private" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-workspaces.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-eu-west2a-pub-workspaces.id}"
  }

  route {
    cidr_block                = "${var.test-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2a-test.id}"
  }

  route {
    cidr_block                = "${var.tools-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
  }

  tags = {
    Name    = "eu-west-2a-workspace-private"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route_table" "eu-west-2a-private" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-eu-west2a-pub-tools.id}"
  }

  route {
    cidr_block                = "${var.test-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
  }

  route {
    cidr_block                = "${var.workspace-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
  }

  tags = {
    Name    = "eu-west-2a-private"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route_table" "eu-west-2b-private" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-eu-west2a-pub-tools.id}"
  }

  route {
    cidr_block                = "${var.test-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
  }

  route {
    cidr_block                = "${var.workspace-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
  }

  tags = {
    Name    = "eu-west-2b-private"
    Managed = "Managed By Terraform"
  }
}

### Test VPC Route Tables

resource "aws_route_table" "test-eu-west-2a-public" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-eu-west-2a-test.id}"
  }

  tags = {
    Name    = "test-eu-west-2a-public->IGW"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route_table" "test-eu-west-2-private" {
  vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw-eu-west2a-pub-test.id}"
  }

  route {
    cidr_block                = "${var.workspace-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2a-test.id}"
  }

  route {
    cidr_block                = "${var.tools-vpc["cidr"]}"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
  }

  tags = {
    Name    = "test-eu-west-2-private"
    Managed = "Managed By Terraform"
  }
}

############### Subnet Associations ###################

resource "aws_route_table_association" "pri_to_pub" {
  subnet_id      = "${aws_subnet.subnet-2a-priv-workspaces.id}"
  route_table_id = "${aws_route_table.eu-west-2a-workspace-private.id}"
}

resource "aws_route_table_association" "pri_to_pub2" {
  subnet_id      = "${aws_subnet.sn-eu-west-2b-priv-workspaces.id}"
  route_table_id = "${aws_route_table.eu-west-2a-workspace-private.id}"
}

resource "aws_route_table_association" "pub_to_igw" {
  subnet_id      = "${aws_subnet.subnet-eu-west-2a-pub-workspaces.id}"
  route_table_id = "${aws_route_table.workspace-eu-west-2a-public-to-igw.id}"
}

resource "aws_route_table_association" "eu-west-2a_to_igw" {
  subnet_id      = "${aws_subnet.subnet-eu-west2a-pub-tools.id}"
  route_table_id = "${aws_route_table.eu-west-2a-public-to-igw.id}"
}

resource "aws_route_table_association" "eu-west-2a_to_priv_tools_atlassian" {
  subnet_id      = "${aws_subnet.subnet-2a-priv-tools-atlassian.id}"
  route_table_id = "${aws_route_table.eu-west-2a-private.id}"
}

resource "aws_route_table_association" "eu-west-2a_to_priv_tools_ops" {
  subnet_id      = "${aws_subnet.subnet-2a-priv-tools-ops.id}"
  route_table_id = "${aws_route_table.eu-west-2a-private.id}"
}

resource "aws_route_table_association" "eu-west-2b-private" {
  subnet_id      = "${aws_subnet.subnet-eu-west-2b-priv-tools-pipeline.id}"
  route_table_id = "${aws_route_table.eu-west-2b-private.id}"
}

## Test VPC Subnet Associations

resource "aws_route_table_association" "test-pub_to_igw" {
  subnet_id      = "${aws_subnet.subnet-eu-west-2a-pub-okd.id}"
  route_table_id = "${aws_route_table.test-eu-west-2a-public.id}"
}

resource "aws_route_table_association" "test-priv_2a_to_nat" {
  subnet_id      = "${aws_subnet.subnet-eu-west-2a-priv-okd.id}"
  route_table_id = "${aws_route_table.test-eu-west-2-private.id}"
}

resource "aws_route_table_association" "test-priv_2b_to_nat" {
  subnet_id      = "${aws_subnet.subnet-eu-west-2b-priv-okd.id}"
  route_table_id = "${aws_route_table.test-eu-west-2-private.id}"
}
