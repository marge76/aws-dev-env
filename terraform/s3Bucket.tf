resource "aws_s3_bucket" "SecureBucket" {
  count  = "${var.project["create_secure_bucket"]}"
  bucket = "<<team-name>>-securebucket"
  acl    = "private"
}
