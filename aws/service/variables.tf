// main_configuration/variables.tf

variable "aws_keypair_name" {
  description = "Name for the AWS key pair"
  type        = string
  default     = "hink-keypair" // You can provide a default value if the environment variable is not set
}
