## Hosted Zones

resource "aws_route53_zone" "privateDNS" {
  name = "${var.project["domain"]}"

  vpc {
    vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"
  }

  vpc {
    vpc_id = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  }

 tags = {
    Name    = "Route 53 for ${var.project["domain"]}"
    Managed = "Managed By Terraform"
  }
}

resource "aws_route53_zone" "testDNS" {
  name = "${var.project["testdomain"]}"

  vpc {
    vpc_id = "${aws_vpc.vpc-eu-west-2-test.id}"
  }

  vpc {
    vpc_id = "${aws_vpc.vpc-eu-west-2-tools.id}"
  }

  vpc {
    vpc_id = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
  }

 tags = {
    Name    = "Route 53 for ${var.project["testdomain"]}"
    Managed = "Managed By Terraform"
  }
}

## Record Sets for privateDNS Zone

resource "aws_route53_record" "Bitbucket" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "bitbucket"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-tools-bitbucket.private_ip}"]
}

resource "aws_route53_record" "Jira" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "jira"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-tools-jira.private_ip}"]
}

resource "aws_route53_record" "Confluence" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "confluence"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-tools-confluence.private_ip}"]
}



resource "aws_route53_record" "Jenkins" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "jenkins"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2b-jenkins.private_ip}"]
}

resource "aws_route53_record" "SquidProxy-tools" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "squid-tools"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-squid-proxy-tools.private_ip}"]
}

resource "aws_route53_record" "SquidProxy-workspace" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "squid-workspace"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-squid-proxy-workspace.private_ip}"]
}

resource "aws_route53_record" "Vault" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "vault"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-tools-vault.private_ip}"]
}

resource "aws_route53_record" "AD" {
  zone_id = "${aws_route53_zone.privateDNS.id}"
  name    = "admanage"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-tools-admanage.private_ip}"]
}

## Record Sets for testDNS Zone
# AIO

resource "aws_route53_record" "okd-master-aio" {
  zone_id = "${aws_route53_zone.testDNS.id}"
  name    = "okd-master"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-okd.private_ip}"]
  count = "${var.project["okd_aio"]}"

}

resource "aws_route53_record" "okd-master-aio-cname" {
  zone_id = "${aws_route53_zone.testDNS.id}"
  name    = "*.okd-master"
  type    = "CNAME"
  ttl     = "300"
  records = ["okd-master.${var.project["testdomain"]}"]
  count = "${var.project["okd_aio"]}"

}

# Cluster
resource "aws_route53_record" "okd-node" {
  zone_id = "${aws_route53_zone.testDNS.id}"
  name    = "okd-node"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-okd-node.private_ip}"]
  count = "${var.project["okd_cluster"]}"
}
resource "aws_route53_record" "okd-master" {
  zone_id = "${aws_route53_zone.testDNS.id}"
  name    = "okd"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2-eu-west-2a-okd-master.private_ip}"]
}
resource "aws_route53_record" "okd-node-cname" {
  zone_id = "${aws_route53_zone.testDNS.id}"
  name    = "*.okd"
  type    = "CNAME"
  ttl     = "300"
  records = ["okd.${var.project["testdomain"]}"]
  count = "${var.project["okd_cluster"]}"
}
