resource "aws_s3_bucket" "SecureBucket" {
  count  = "${var.project["create_secure_bucket"]}"
  bucket = "${var.project["name"]}securebucket"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "bucketPolicy" {
  count  = "${var.project["create_secure_bucket"]}"
  bucket = "${aws_s3_bucket.SecureBucket.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Principal": "*",
            "Action": [
                "s3:Put*",
                "s3:Delete*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.project["name"]}securebucket",
                "arn:aws:s3:::${var.project["name"]}securebucket/*"
            ],
            "Condition": {
                "StringNotLike": {
                    "aws:userId": [
                        "${aws_iam_role.cedc-admin.unique_id}:*",
                        "111111111111"
                    ]
                }
            }
        }
    ]
}
POLICY
}
