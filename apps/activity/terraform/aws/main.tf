variable "role_name" {}
variable "profile_name" {}
variable "tags" {
  type = map(string)
  default = {}
}

resource "aws_iam_role" "cloud_activity_role" {
  name = "${var.role_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_instance_profile" "cloud_activity_profile" {
  name = "${var.profile_name}"
  role = "${var.role_name}"
}

output "cloud_activity_profile_arn" {
  value = aws_iam_instance_profile.cloud_activity_profile.name
  sensitive = true
}
