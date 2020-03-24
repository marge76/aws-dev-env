resource "aws_flow_log" "west-2-tools-flow-log" {
  iam_role_arn    = "${aws_iam_role.cedc-flow-logger.arn}"
  log_destination = "${aws_cloudwatch_log_group.cw-eu-west-2-tools.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.vpc-eu-west-2-tools.id}"
}

resource "aws_flow_log" "west-2-workspaces-flow-log" {
  iam_role_arn    = "${aws_iam_role.cedc-flow-logger.arn}"
  log_destination = "${aws_cloudwatch_log_group.cw-eu-west-2-workspaces.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.vpc-eu-west-2-workspaces.id}"
}

resource "aws_cloudwatch_log_group" "cw-eu-west-2-tools" {
  name = "cw-eu-west-2-tools"
}

resource "aws_cloudwatch_log_group" "cw-eu-west-2-workspaces" {
  name = "cw-eu-west-2-workspaces"
}

resource "aws_iam_role" "cedc-flow-logger" {
  name = "cedc-flow-logger"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cw-role-policy" {
  name = "cw-role-policy"
  role = "${aws_iam_role.cedc-flow-logger.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

### EC2 CPU Utilisation ###
resource "aws_cloudwatch_metric_alarm" "bitbucket-cpu-utilisation" {
  alarm_name          = "bitbucket-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-bitbucket.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "confluence-cpu-utilisation" {
  alarm_name          = "confluence-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-confluence.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jira-cpu-utilisation" {
  alarm_name          = "jira-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-jira.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-cpu-utilisation" {
  alarm_name          = "jenkins-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2b-jenkins.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "okd-master-cpu-utilisation" {
  alarm_name          = "okd-master-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd-master.id}"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_cloudwatch_metric_alarm" "okd-node-cpu-utilisation" {
  alarm_name          = "okd-node-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd-node.id}"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_cloudwatch_metric_alarm" "okd-cpu-utilisation" {
  alarm_name          = "okd-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd.id}"
  }

  count = "${var.project["okd_aio"]}"
}

resource "aws_cloudwatch_metric_alarm" "vault-cpu-utilisation" {
  alarm_name          = "vault-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-vault.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "admanage-cpu-utilisation" {
  alarm_name          = "admanage-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-admanage.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "squid-tools-cpu-utilisation" {
  alarm_name          = "squid-tools-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-squid-proxy-tools.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "squid-workspace-cpu-utilisation" {
  alarm_name          = "squid-workspace-cpu-utilisation-checker-tf"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "95"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-squid-proxy-workspace.id}"
  }
}

### EC2 Credit Balance Checker ###

resource "aws_cloudwatch_metric_alarm" "bitbucket-credit-balance" {
  alarm_name          = "bitbucket-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-bitbucket.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "confluence-credit-balance" {
  alarm_name          = "confluence-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-confluence.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jira-credit-balance" {
  alarm_name          = "jira-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-jira.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins-credit-balance" {
  alarm_name          = "jenkins-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2b-jenkins.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "okd-master-credit-balance" {
  alarm_name          = "okd-master-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd-master.id}"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_cloudwatch_metric_alarm" "okd-node-credit-balance" {
  alarm_name          = "okd-node-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd-node.id}"
  }

  count = "${var.project["okd_cluster"]}"
}

resource "aws_cloudwatch_metric_alarm" "okd-credit-balance" {
  alarm_name          = "okd-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-okd.id}"
  }

  count = "${var.project["okd_aio"]}"
}

resource "aws_cloudwatch_metric_alarm" "vault-credit-balance" {
  alarm_name          = "vault-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-vault.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "admanage-credit-balance" {
  alarm_name          = "admanage-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-tools-admanage.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "squid-tools-credit-balance" {
  alarm_name          = "squid-tools-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-squid-proxy-tools.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "squid-workspace-credit-balance" {
  alarm_name          = "squid-workspace-credit-balance-checker-tf"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "500"
  alarm_description   = "This metric monitors an ec2's credit spending habits"
  alarm_actions       = ["${aws_sns_topic.cloudwatch-alarms-mailing-list.arn}"]

  dimensions {
    InstanceId = "${aws_instance.ec2-eu-west-2a-squid-proxy-workspace.id}"
  }
}
