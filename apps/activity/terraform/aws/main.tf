variable "user_name" {}

resource "aws_iam_user" "aws_user" {
  name = "${var.user_name}-user"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.aws_user.name
}

output "secret_key" {
  value = aws_iam_access_key.access_key.secret
  sensitive = true
}

output "access_key" {
  value = aws_iam_access_key.access_key.id
}