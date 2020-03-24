
resource "aws_eip" "elasticIPSquidTools" {
  vpc = true

  tags = {
    Name = "elasticIPSquidTools"
  }
}

resource "aws_eip" "elasticIPSquidWorkspace" {
  vpc = true

  tags = {
    Name = "SquidElasticIPWorkspace"
  }
}

resource "aws_eip_association" "eip_assoc-tools" {
  instance_id   = "${aws_instance.ec2-eu-west-2a-squid-proxy-tools.id}"
  allocation_id = "${aws_eip.elasticIPSquidTools.id}"
}

resource "aws_eip_association" "eip_assoc_workspace" {
  instance_id   = "${aws_instance.ec2-eu-west-2a-squid-proxy-workspace.id}"
  allocation_id = "${aws_eip.elasticIPSquidWorkspace.id}"
}