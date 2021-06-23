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
