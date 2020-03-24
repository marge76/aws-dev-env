provider "aws" {
  access_key = "${var.project["access_key"]}"
  secret_key = "${var.project["secret_key"]}"
  region     = "${var.project["region"]}"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "${var.project["ec2_key_name"]}"
  public_key = "${var.project["ec2_key_pair"]}"
}