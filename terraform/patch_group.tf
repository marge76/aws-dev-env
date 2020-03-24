resource "aws_ssm_patch_group" "centos_patch_group" {
    baseline_id = "${aws_ssm_patch_baseline.patch-baseline-centos.id}"
    patch_group = "defaultCentOSBaseline"
}

resource "aws_ssm_patch_group" "windows_patch_group" {
    baseline_id = "${aws_ssm_patch_baseline.patch-baseline-windows.id}"
    patch_group = "defaultWindowsBaseline"
}