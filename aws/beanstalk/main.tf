resource "aws_elastic_beanstalk_application" "HinkWeb" {
  name        = "HinkWeb"
  description = "Personal Website powered by Terraform"
}

resource "aws_elastic_beanstalk_environment" "HinkWebEnv" {
  name                = "SampleEnvironment"
  application         = aws_elastic_beanstalk_application.HinkWeb.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.1.4 running Node.js 20" # Adjust this based on your application's requirements
  cname_prefix        = var.project_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro" # Change instance type as per your needs
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance" # Change this if you want to use a Load Balanced environment
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PARAM2"
    value     = "value2"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:nodejs"
    name      = "NodeCommand"
    value     = "npm start" # Command to start your Node.js application
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.aws_keypair_name # Replace with the name of your EC2 key pair
  }
  # You can also configure other settings like autoscaling, load balancer, etc. as needed
}
