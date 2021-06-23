// admin role and policies
resource "aws_iam_role" "<<team-name>>-admin" {
  name = "<<team-name>>-admin"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ds.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "admin-policy-attachment" {
  role       = "${aws_iam_role.<<team-name>>-admin.name}"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

// developer role and policies
resource "aws_iam_role" "<<team-name>>-developer" {
  name = "<<team-name>>-developer"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ds.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

variable "developer_policy_arn" {
  description = "IAM Policies for <<team-name>>-developer role"
  type        = "list"

  default = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonWorkSpacesAdmin",
  ]
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = "${aws_iam_role.<<team-name>>-developer.name}"
  count      = "${length(var.developer_policy_arn)}"
  policy_arn = "${var.developer_policy_arn[count.index]}"
}

// tester role and policies
resource "aws_iam_role" "<<team-name>>-tester" {
  name = "<<team-name>>-tester"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ds.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

variable "tester_policy_arn" {
  description = "IAM Policies for <<team-name>>-tester role"
  type        = "list"

  default = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonWorkSpacesAdmin",
  ]
}

resource "aws_iam_role_policy_attachment" "tester-policy-attachment" {
  role       = "${aws_iam_role.<<team-name>>-tester.name}"
  count      = "${length(var.tester_policy_arn)}"
  policy_arn = "${var.tester_policy_arn[count.index]}"
}

// billing role and policy
resource "aws_iam_role" "<<team-name>>-billing" {
  name = "<<team-name>>-billing"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ds.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "billing-policy-attachment" {
  role       = "${aws_iam_role.<<team-name>>-billing.name}"
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

resource "aws_iam_role" "EC2DomainJoinTF" {
  name = "EC2DomainJoinTF"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "AmazonEC2RoleForSCMTF" {
  name        = "AmazonEC2RoleForSCMTF"
  description = "AmazonEC2RoleForSCMTF"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:GetManifest",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ds:CreateComputer",
                "ds:DescribeDirectories"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetEncryptionConfiguration",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "AmazonEC2RoleForSCMTFPolicyAttach" {
  name       = "AmazonEC2RoleForSCMTFPolicyAttach"
  roles      = ["${aws_iam_role.EC2DomainJoinTF.name}"]
  policy_arn = "${aws_iam_policy.AmazonEC2RoleForSCMTF.arn}"
}

resource "aws_iam_instance_profile" "AmazonEC2RoleForSCMTFProfile" {
  name = "AmazonEC2RoleForSCMTFProfile"
  role = "${aws_iam_role.EC2DomainJoinTF.name}"
}

resource "aws_iam_user" "PatchInstanceUser" {
  name = "${var.patchManager["name"]}"
}

#### MAINTENANCE WINDOW ####
resource "aws_iam_role_policy_attachment" "maintenance-role-policy-attachment" {
  role       = "${aws_iam_role.MaintenanceWindowRoleTF.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_policy" "PolicyForMaintenanceWindow" {
  name        = "PolicyForMaintenanceWindow"
  description = "PolicyForMaintenanceWindow"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "arn:aws:iam::657208017015:role/MaintenanceWindowsRole"
        }
    ]
}
EOF
}

resource "aws_iam_role" "MaintenanceWindowRoleTF" {
  name        = "${var.patchManager["maintenanceWindowIAMRoleName"]}"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ssm.amazonaws.com",
          "sns.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    name = "MaintenanceWindowRoleTF"
  }
}

#### PATCH MANAGER & CLOUDWATCH POLICY ####
resource "aws_iam_instance_profile" "PatchManagerRoleProfile" {
  name = "PatchManagerRoleProfile"
  role = "${aws_iam_role.patchManager-role.name}"
}

resource "aws_iam_policy_attachment" "PatchManagerIamRolePolicyAttach" {
  name       = "PatchManagerIamRolePolicyAttach"
  roles      = ["${aws_iam_role.patchManager-role.name}"]
  policy_arn = "${aws_iam_policy.patchManager-policy.arn}"
}

resource "aws_iam_role_policy_attachment" "patchManager-policy-attachment" {
  role       = "${aws_iam_role.patchManager-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role" "patchManager-role" {
  name        = "${var.patchManager["IAMRoleName"]}"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "patchManager-policy" {
  name        = "${var.patchManager["PolicyName"]}"
  description = "Allows EC2 instances to call AWS services on your behalf. Used by Patch Manager"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Sid": "",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["ssm:GetParameter"],
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeAssociation",
        "ssm:GetDeployablePatchSnapshotForInstance",
        "ssm:GetDocument",
        "ssm:DescribeDocument",
        "ssm:GetManifest",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:ListAssociations",
        "ssm:ListInstanceAssociations",
        "ssm:PutInventory",
        "ssm:PutComplianceItems",
        "ssm:PutConfigurePackageResult",
        "ssm:UpdateAssociationStatus",
        "ssm:UpdateInstanceAssociationStatus",
        "ssm:UpdateInstanceInformation"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2messages:AcknowledgeMessage",
        "ec2messages:DeleteMessage",
        "ec2messages:FailMessage",
        "ec2messages:GetEndpoint",
        "ec2messages:GetMessages",
        "ec2messages:SendReply"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["ssm:GetParameter", "ssm:PutParameter"],
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    }
  ]
}
EOF

}