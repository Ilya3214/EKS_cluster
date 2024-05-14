resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = [var.instance_type]

  remote_access {
    ec2_ssh_key = "linuxkey"
  }

  tags = {
    "Name" = "${var.cluster_name}-node-group"

  instance_tags = {
    "Name" = "${var.cluster_name}-node"
  }

  }
}
