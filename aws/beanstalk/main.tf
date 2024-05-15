variable "app_name" {}
variable "app_description" {}
variable "instance_role" {}
variable "vpc_id" {
  default = null
}
variable "subnet_ids" {
  default = []
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = var.app_name
  description = var.app_description
}

resource "aws_elastic_beanstalk_environment" "app_env" {
  name                = var.app_name
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.4 running Node.js 20"
  tier                = "WebServer"
  cname_prefix        = var.app_name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro" # Free tier eligible instance type
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.instance_role
  }

  dynamic "setting" {
    for_each = var.vpc_id != null && length(var.subnet_ids) > 0 ? [1] : []
    content {
      namespace = "aws:ec2:vpc"
      name      = "VPCId"
      value     = var.vpc_id
    }
  }

  dynamic "setting" {
    for_each = var.vpc_id != null && length(var.subnet_ids) > 0 ? var.subnet_ids : []
    content {
      namespace = "aws:ec2:vpc"
      name      = "Subnets"
      value     = join(",", var.subnet_ids)
    }
  }
}

