resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name          = "${var.ad["domain"]}"
  domain_name_servers  = ["${aws_directory_service_directory.directory.dns_ip_addresses}"]

 tags = {
    Name = "dhcp_options"
    Managed = "Managed By Terraform"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver_workspaces" {
  vpc_id          = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_options.id}"
}

resource "aws_vpc_dhcp_options_association" "dns_resolver_tools" {
  vpc_id          = "${aws_vpc.vpc-eu-west-2-tools.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_options.id}"
}

resource "aws_vpc_dhcp_options_association" "dns_resolver_test" {
  vpc_id          = "${aws_vpc.vpc-eu-west-2-test.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_options.id}"
}


