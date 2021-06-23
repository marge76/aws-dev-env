variable "project" {
  type = "map"

  default = {
    name                          = "<<TEAM-NAME>>"
    region                        = "eu-west-2"
    access_key                    = ""
    secret_key                    = ""
    windows_server_admin_pwd      = "letmeintowindows"
    ec2_key_pair                  = ""
    ec2_key_name                  = "tools_key_2"
    domain                        = "tools.<<team-name>>.cloud"
    testdomain                    = "test.<<team-name>>.cloud"
    path_to_EC2_private_key       = ""
    create_secure_bucket          = 1
    google_dns_server             = "8.8.8.8"
    ec2ScheduleCfTemplateLocation = "templates/ec2-scheduler.template"

    # You must select one okd configuration, all-in-one or cluster setup.
    okd_aio     = 0 # boolean, 1 = true, 0 = false. Set = 1 for all-in-one OKD setup
    okd_cluster = 1 # boolean, 1 = true, 0 = false. Set = 1 for cluster (multiple-server) OKD setup. Current configuration: one master EC2 and one node EC2.
  }
}

variable "patchManager" {
  type = "map"

  default = {
    name                         = "<<team-name>>-instance-patch"
    IAMRoleName                  = "PatchManagerIAMRoleTFNew"
    PolicyName                   = "PatchManagerIAMPolicyTFNew"
    maintenanceWindowIAMRoleName = "MaintenanceWindowRoleTFNew"
  }
}

/******** Availability Zones ********* */
variable "availability_zone_2a" {
  default = "eu-west-2a"
}

variable "availability_zone_2b" {
  default = "eu-west-2b"
}

variable "workspace-vpc" {
  type = "map"

  default = {
    name = "vpc-eu-west-2-workspaces"
    cidr = "172.16.0.0/21"

    public_subnet_name = "sn-eu-west-2a-pub-workspaces"
    public_subnet_cidr = "172.16.0.0/24"

    private_subnet_name = "sn-eu-west-2a-priv-workspaces"
    private_subnet_cidr = "172.16.1.0/24"

    private_subnet_2_name = "sn-eu-west-2b-priv-workspaces"
    private_subnet_2_cidr = "172.16.2.0/24"
  }
}

variable "tools-vpc" {
  type = "map"

  default = {
    name = "vpc-eu-west-2-tools"
    cidr = "172.26.0.0/21"

    pub_tools_1_subnet_name = "sn-eu-west-2a-pub-tools"
    pub_tools_1_subnet_cidr = "172.26.0.0/24"

    priv_tools_atlassian_subnet_name = "sn-eu-west-2a-priv-tools-atlassian"
    priv_tools_atlassian_subnet_cidr = "172.26.1.0/24"

    priv_tools_ops_subnet_name = "sn-eu-west-2a-priv-tools-ops"
    priv_tools_ops_subnet_cidr = "172.26.2.0/24"

    priv_pipeline_subnet_name = "sn-eu-west-2b-priv-tools-pipeline"
    priv_pipeline_subnet_cidr = "172.26.3.0/24"
  }
}

variable "test-vpc" {
  type = "map"

  default = {
    name = "vpc-eu-west-2-test"
    cidr = "172.21.0.0/21"

    public_subnet_name = "sn-eu-west-2a-pub-test"
    public_subnet_cidr = "172.21.0.0/24"

    private_subnet_name = "sn-eu-west-2a-priv-test"
    private_subnet_cidr = "172.21.1.0/24"

    private_subnet_2_name = "sn-eu-west-2b-priv-test"
    private_subnet_2_cidr = "172.21.2.0/24"
  }
}

/********* AD details ******* */
variable "ad" {
  type = "map"

  default = {
    domain   = "ad.<<team-name>>.cloud"
    password = "<<password>>"
    size     = "Small"
    alias    = "<<team-name>>-cloud"    #need to be unique, used for access url
  }
}

variable "alarms" {
  type = "map"

  default = {
    email = "<<email>>"
  }
}
