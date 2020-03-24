resource "aws_ssm_document" "ADInstanceSSM" {
  name          = "ADInstanceSSM"
  document_type = "Command"

  content = <<DOC
  {
    "schemaVersion": "1.2",
    "description": "Check ip configuration of a windows instance.",
    "runtimeConfig": {
        "aws:domainJoin": {
            "properties": {
                "directoryId": "${aws_directory_service_directory.directory.id}",
                "directoryName": "${var.ad["domain"]}",
                "dnsIpAddresses": [
                     "${aws_directory_service_directory.directory.dns_ip_addresses[0]}",
                     "${aws_directory_service_directory.directory.dns_ip_addresses[1]}"
                  ]
            }
        }
    }
  }
DOC
    depends_on = ["aws_directory_service_directory.directory"]
}

resource "aws_ssm_association" "ssm_associate_windows" {
  name = "${aws_ssm_document.ADInstanceSSM.name}"
  instance_id="${aws_instance.ec2-eu-west-2a-tools-admanage.id}"
  depends_on = ["aws_ssm_document.ADInstanceSSM", "aws_instance.ec2-eu-west-2a-tools-admanage"]
}

resource "aws_ssm_patch_baseline" "patch-baseline-windows" {
  name             = "patch-baseline"
  operating_system = "WINDOWS"

    global_filter {
    key    = "CLASSIFICATION"
    values = ["ServicePacks"]
  }
  
    approval_rule {
    approve_after_days = 7
    compliance_level   = "HIGH"

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["CriticalUpdates", "SecurityUpdates", "Updates"]
    }

    patch_filter {
      key    = "MSRC_SEVERITY"
      values = ["Critical", "Important", "Moderate"]
    }
  }
}
resource "aws_ssm_patch_baseline" "patch-baseline-centos" {
  name             = "patch-baseline-centos"
  operating_system = "CENTOS"
    global_filter {
    key    = "CLASSIFICATION"
    values = ["Security", "Bugfix", "Recommended"]
  }
  
    approval_rule {
    approve_after_days = 7
    compliance_level   = "HIGH"

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["Security", "Bugfix", "Recommended"]
    }

  }
}