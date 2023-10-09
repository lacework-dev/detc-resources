resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

locals {
  policy_name = "allow-manage-stack-${random_string.random.result}"
}


resource "aws_iam_policy" "allow-manage-stack" {
  name        = local.policy_name
  description = "Allow managing the entire stack"

  policy = <<EOT
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "allowManageStack",
			"Effect": "Allow",
			"Action": [
				"rds:*",
				"kms:*",
				"ec2:*",
        "s3:*",
				"sts:GetAccessKeyInfo",
				"sts:GetCallerIdentity",
				"sts:GetSessionToken"
			],
			"Resource": "*"
		}
	]
}
EOT
}

resource "aws_iam_role" "eks-node-group" {
  name = "EKSNodeGroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_EBS_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.eks-node-group.name
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_Allow_Manage_Stack" {
  policy_arn = aws_iam_policy.allow-manage-stack.arn
  role       = aws_iam_role.eks-node-group.name
}

### TODO: remove - just for testing
resource "aws_iam_policy" "AmazonEKSNodeGroup_Admin_Debug" { // ec2 policy
  name = "eksnodegroup_admin_debug"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "AmazonEKS_Admin_Policy" {
  policy_arn = aws_iam_policy.AmazonEKSNodeGroup_Admin_Debug.arn
  role       = aws_iam_role.eks-node-group.name
}


output "role_arn" {
  value = aws_iam_role.eks-node-group.arn
}
