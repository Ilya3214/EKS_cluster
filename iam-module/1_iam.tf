# EKS cluster IAM
resource "aws_iam_role" "iam_role_access_to_eks_cluster" {
  name        = var.administrator_role_name
  description = "Access to the EKS cluster"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Condition = {},
        Principal = {
          AWS = toset(var.specific_user_arn)
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy_attachment_to_eks_cluster" {
  for_each   = toset(var.admin_role_policy_arn_to_eks_cluster)
  policy_arn = each.value
  role       = aws_iam_role.iam_role_access_to_eks_cluster.name
}