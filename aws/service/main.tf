provider "aws" {
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

module "keypair" {
  source = "../../security/aws_keypair"
}

resource "aws_iam_role" "elastic_beanstalk_service_role" {
  name               = "elastic-beanstalk-service-role"
  assume_role_policy = data.aws_iam_policy_document.elastic_beanstalk_service_assume_role.json
}

# IAM Role for Elastic Beanstalk service access
data "aws_iam_policy_document" "elastic_beanstalk_service_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }
  }
}

# IAM Policy for Elastic Beanstalk environment permissions
resource "aws_iam_policy" "elastic_beanstalk_policy" {
  name        = "elastic-beanstalk-policy"
  description = "IAM policy for Elastic Beanstalk environment permissions"
  policy      = data.aws_iam_policy_document.elastic_beanstalk_policy.json
}

data "aws_iam_policy_document" "elastic_beanstalk_policy" {
  statement {
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "s3:*", # Add more permissions as needed
    ]
    resources = ["*"]
  }
}

# IAM Role Policy Attachment
resource "aws_iam_role_policy_attachment" "elastic_beanstalk_policy_attachment" {
  role       = aws_iam_role.elastic_beanstalk_service_role.name
  policy_arn = aws_iam_policy.elastic_beanstalk_policy.arn
}

# Create the AWS Key Pair
resource "aws_key_pair" "keypair" {
  key_name   = var.aws_keypair_name      # Specify the name of the key pair
  public_key = module.keypair.public_key # Specify the path to the public key file
}
