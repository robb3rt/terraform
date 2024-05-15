variable "aws_region" {
  type        = string
  description = "The AWS Region"
  default     = "eu-central-1"
}

variable "app_name" {
  type        = string
  description = "Name of the Node.js application"
  default     = "hink"
}

variable "app_description" {
  type        = string
  description = "Description of the application"
  default     = "Sample Node.js application deployed with Terraform"
}

variable "instance_role" {
  type        = string
  description = "The name of the Instance role for the Beanstalk environment"
  default     = "elastic-beanstalk-service-role"
}
variable "instance_type" {
  type        = string
  description = "EC2 Instance type for the environment"
  default     = "t2.micro"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the environment will be deployed"
  default     = null # Replace with your VPC ID if applicable
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs within the VPC"
  default     = [] # Replace with your subnet IDs if using a VPC
}

variable "aws_keypair_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "hink-keypair" // You can provide a default value if the environment variable is not set
}

