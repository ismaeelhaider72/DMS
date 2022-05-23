# Roles defined as per official documentation:
# https://www.terraform.io/docs/providers/aws/r/dms_replication_instance.html

# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.APIRole.html
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role

#Get the DMS Assume Role Policy document
data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

#Create DMS role for CloudWatch Logging
resource "aws_iam_role" "dms-cloudwatch-logs-role" { 
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

#Attach DMSCloudWatchLogsRole Policy to the DMS role for CloudWatch
resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

#Create DMS VPC role for allowing creation of DMS replication instance and its network interface, policy is attached inline 
#There local provisioner with sleep is for helping with bug: https://github.com/hashicorp/terraform-provider-aws/issues/11025
#This is caused because during creation/deletion DMS VPC role with appropriate permissions is required, and currently there is no
#mechanism inside Terraform resources to either delete role after deletion of network interfaces etc which causes hung/undeleted ENI's
#or during creation tries to create DMS replication instance before the role is created and registered within AWS.
#The error may still hit, in which case, let it timeout and simply run another terraform apply

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy  = data.aws_iam_policy_document.dms_assume_role.json
  name                = "dms-vpc-role"
  # managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"]
  inline_policy {
    name   = "dms-vpc-role-policy"
    policy = file("${path.module}/dms_policy.json")
  }
}


resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
  # It takes some time for these attachments to work, and creating the aws_dms_replication_subnet_group fails if this attachment hasn't completed.
  provisioner "local-exec" {
    command = "sleep 30"
  }
}