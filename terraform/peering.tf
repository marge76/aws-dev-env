# Create peering connection
resource "aws_vpc_peering_connection" "peering-workspace-to-vpc-eu-west-2-tools" {
  peer_vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"      #Accepter VPC
  vpc_id      = "${aws_vpc.vpc-eu-west-2-workspaces.id}" #Requester VPC
  auto_accept = true

 tags = {
    Name    = "Workspace -> vpc-eu-west-2-tools"
    Managed = "Managed By Terraform"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

## Test VPC 
resource "aws_vpc_peering_connection" "peering-workspace-to-vpc-eu-west-2a-test" {
  peer_vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"       #Accepter VPC
  vpc_id      = "${aws_vpc.vpc-eu-west-2-workspaces.id}" #Requester VPC
  auto_accept = true

 tags = {
    Name    = "Workspace -> vpc-eu-west-2-test"
    Managed = "Managed By Terraform"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection" "peering-tools-to-vpc-eu-west-2b-test" {
  peer_vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"  #Accepter VPC
  vpc_id      = "${aws_vpc.vpc-eu-west-2-tools.id}" #Requester VPC
  auto_accept = true

 tags = {
    Name    = "Tools -> vpc-eu-west-2-test"
    Managed = "Managed By Terraform"
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

###### Assign peering connection to appropriate route tables ######
resource "aws_route" "eu-west-2a-workspace_private_to_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2a-workspace-private.id}"
  destination_cidr_block    = "${var.tools-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
}


resource "aws_route" "eu-west-2a-private_to_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2a-private.id}"
  destination_cidr_block    = "${var.workspace-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
}

resource "aws_route" "eu-west-2b-private_to_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2b-private.id}"
  destination_cidr_block    = "${var.workspace-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2-tools.id}"
}

## Test VPC 

### Test to WS/Tools
resource "aws_route" "eu-west-2a-test_private_to_ws_pcx" {
  route_table_id            = "${aws_route_table.test-eu-west-2-private.id}"
  destination_cidr_block    = "${var.workspace-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2a-test.id}"
}

resource "aws_route" "eu-west-2b-test_private_to_tools_pcx" {
  route_table_id            = "${aws_route_table.test-eu-west-2-private.id}"
  destination_cidr_block    = "${var.tools-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
}

### WS/Tools to Test
resource "aws_route" "eu-west-2a-workspace_private_to_test_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2a-workspace-private.id}"
  destination_cidr_block    = "${var.test-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-workspace-to-vpc-eu-west-2a-test.id}"
}

resource "aws_route" "eu-west-2a-tools_private_to_test_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2a-private.id}"
  destination_cidr_block    = "${var.test-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
}

resource "aws_route" "eu-west-2b-tools_private_to_test_pcx" {
  route_table_id            = "${aws_route_table.eu-west-2b-private.id}"
  destination_cidr_block    = "${var.test-vpc["cidr"]}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering-tools-to-vpc-eu-west-2b-test.id}"
}
