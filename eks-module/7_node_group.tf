# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name    = aws_eks_cluster.eks_cluster.name
#   node_group_name = "${var.cluster_name}-node-group"
#   node_role_arn   = aws_iam_role.eks_worker_role.arn
#   subnet_ids      = var.subnet_ids

#   scaling_config {
#     desired_size = var.desired_capacity
#     max_size     = var.max_size
#     min_size     = var.min_size
#   }

#   instance_types = [var.instance_type]

#   remote_access {
#     ec2_ssh_key = var.ec2_ssh_key_name
#   }

#   tags = {
#     "Name" = "${var.cluster_name}-node-group"
#   }
# }
