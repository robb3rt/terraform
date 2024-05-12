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
      "iam:CreateRole",
      "iam:CreatePolicy",
      "iam:AttachUserPolicy",
      "iam:AttachRolePolicy",
      "iam:PassRole",
      "ec2:ImportKeyPair",
      "elasticbeanstalk:*",
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

resource "local_file" "aws_credentials_vars" {
  filename = "../../main_configuration/credentials.tfvars" # Update with your desired file path
  content  = <<-EOT
    access_key = "${aws_iam_access_key.IAM_access_key.id}"
    secret_key = "${aws_iam_access_key.IAM_access_key.secret}"
  EOT
}

resource "local_file" "aws_credentials_file" {
  filename = "../../tmp/aws_credentials.txt" # Update with your desired file path
  content  = <<-EOT
    [default]
    aws_access_key_id = ${aws_iam_access_key.IAM_access_key.id}
    aws_secret_access_key = ${aws_iam_access_key.IAM_access_key.secret}
  EOT
}
