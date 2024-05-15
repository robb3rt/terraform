#this file will contain all relevant permissions needed to manage all instances, based on CloudTrail events made from the events
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_user" "IAM_user" {
  name = var.IAM_user_name
}

resource "aws_iam_access_key" "IAM_access_key" {
  user = aws_iam_user.IAM_user.name
}

data "aws_iam_policy_document" "IAM_policy" {
  statement {
    actions = [
      "iam:GetPolicy",
      "iam:GetRole",
      "iam:GetPolicyVersion",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:PassRole",
      "ec2:ImportKeyPair",
      "ec2:DescribeKeyPairs",
      "elasticbeanstalk:CreateApplication",
      "elasticbeanstalk:CreateApplicationVersion",
      "elasticbeanstalk:CreateEnvironment",
      "elasticbeanstalk:UpdateApplication",
      "elasticbeanstalk:UpdateApplicationVersion",
      "elasticbeanstalk:UpdateEnvironment"
    ]

    resources = ["*"] # Allow actions on all resources
  }
}

resource "aws_iam_policy" "IAM_policy" {
  name        = "IAM-policy"
  description = "policy for required permissions for this terraform script"
  policy      = data.aws_iam_policy_document.IAM_policy.json
}

resource "aws_iam_user_policy_attachment" "IAM_policy_attachment" {
  user       = aws_iam_user.IAM_user.name
  policy_arn = aws_iam_policy.IAM_policy.arn
}

output "access_key_id" {
  value = aws_iam_access_key.IAM_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.IAM_access_key.secret
  sensitive = true
}

#File to replace ~/.aws/credentials with
resource "local_file" "aws_credentials_file" {
  filename = "../../tmp/aws_credentials.txt" # Update with your desired file path
  content  = <<-EOT
    [default]
    aws_access_key_id = ${aws_iam_access_key.IAM_access_key.id}
    aws_secret_access_key = ${aws_iam_access_key.IAM_access_key.secret}
  EOT
}
