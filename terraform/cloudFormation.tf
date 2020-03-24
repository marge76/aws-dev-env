resource "aws_cloudformation_stack" "EC2AutomaticScheduleCloudFormationStack" {
  name               = "EC2-automatic-schedule-tf"
  template_body      = "${file("${path.module}/${var.project["ec2ScheduleCfTemplateLocation"]}")}"
  capabilities       = ["CAPABILITY_IAM"]
  parameters         = "${var.scheduleParams}"
  timeout_in_minutes = 5

  tags = {
    Name = "EC2-automatic-schedule-tf"
  }
}

variable "scheduleParams" {
  type = "map"

  default = {
    Regions           = ""
    StartedTags       = ""
    StoppedTags       = ""
    CrossAccountRoles = ""
  }
}
