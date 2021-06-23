resource "aws_eip" "elasticIPVPN" {
  vpc = true

  tags = {
    Name = "elasticIPVPN"
  }
}

resource "aws_eip_association" "eip_assoc_workspace" {
  instance_id   = "${aws_instance.ec2-eu-west-2a-openvpn.id}"
  allocation_id = "${aws_eip.elasticIPVPN.id}"
}
