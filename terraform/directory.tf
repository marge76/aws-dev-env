resource "aws_directory_service_directory" "directory" {
  name       = "${var.ad["domain"]}"
  password   = "${var.ad["password"]}"
  edition    = "Standard"
  type       = "MicrosoftAD"
  alias      = "${var.ad["alias"]}"
  enable_sso = true

  vpc_settings {
    vpc_id     = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
    subnet_ids = ["${aws_subnet.sn-eu-west-2b-priv-workspaces.id}", "${aws_subnet.subnet-2a-priv-workspaces.id}"]
  }

  tags = {
    Project = "${var.project["name"]}"
    Managed = "Managed By Terraform"
  }
}

resource "aws_directory_service_conditional_forwarder" "example" {
  directory_id       = "${aws_directory_service_directory.directory.id}"
  remote_domain_name = "${var.project["domain"]}"

  dns_ips = ["${cidrhost(aws_vpc.vpc-eu-west-2-workspaces.cidr_block, 2)}", "${cidrhost(aws_vpc.vpc-eu-west-2-tools.cidr_block, 2)}"]
}

resource "aws_directory_service_conditional_forwarder" "testforwarder" {
  directory_id       = "${aws_directory_service_directory.directory.id}"
  remote_domain_name = "${var.project["testdomain"]}"

  dns_ips = ["${cidrhost(aws_vpc.vpc-eu-west-2-workspaces.cidr_block, 2)}"]
}
