resource "aws_ssm_maintenance_window" "maintenanceWindow" {
    name = "MaintenanceWindowForPatchingCriticalAndImportantUpdates"
    schedule = "cron(0 0 21 ? * * *)"
    duration = 2
    cutoff = 1  
}

resource "aws_ssm_maintenance_window_target" "maintenanceWindowTarget" {
  window_id = "${aws_ssm_maintenance_window.maintenanceWindow.id}"
  resource_type = "INSTANCE"

  targets {
      key = "tag:PatchGroup"
      values = ["defaultCentOSBaseline", "defaultWindowsBaseline"]
  }
}

resource "aws_ssm_maintenance_window_task" "maintenanceWindowTask" {
    window_id = "${aws_ssm_maintenance_window.maintenanceWindow.id}"
    name = "MaintenanceWindowTask"
    description      = "This is a maintenance window task"
    task_type = "RUN_COMMAND"
    task_arn = "AWS-RunPatchBaseline"
    priority         = 1
    service_role_arn = "${aws_iam_role.MaintenanceWindowRoleTF.arn}"
    max_concurrency  = "7"
    max_errors       = "1"
    task_parameters {
        name = "Operation"
        values = ["Install"]
    }
    targets {
        key = "WindowTargetIds"
        values = ["${aws_ssm_maintenance_window_target.maintenanceWindowTarget.id}"]
    }

}

