resource "aws_iam_user" "jenkins_sa" {
  name = "jenkins_sa"
  path = "/"
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "jenkins-sa"
  user = aws_iam_user.jenkins_sa.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_access_key" "jenkins_sa_access_key" {
  user = aws_iam_user.jenkins_sa.name
}

output "aws_secret_key" {
  value     = aws_iam_access_key.jenkins_sa_access_key.secret
  sensitive = true
}

output "aws_access_key" {
  value     = aws_iam_access_key.jenkins_sa_access_key.id
  sensitive = true
}
