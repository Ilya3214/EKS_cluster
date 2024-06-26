data "aws_ami" "eks_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.cluster_version}-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

resource "aws_launch_template" "eks_nodes_lt" {
  name_prefix            = "${var.cluster_name}-launch-template"
  instance_type          = var.instance_type
  image_id               = data.aws_ami.eks_ami.image_id
  vpc_security_group_ids = [aws_security_group.eks_nodes_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.eks_worker_instance_profile.name
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${aws_eks_cluster.eks_cluster.name}
    EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"                         = "true"
      Name                                                        = "${var.cluster_name}-worker-node"
    }
  }
}

resource "aws_autoscaling_group" "eks_asg" {
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.subnet_ids

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 50
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 3
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.eks_nodes_lt.id
      }

      override {
        instance_type     = "t3.medium"
        weighted_capacity = "2"
      }

      override {
        instance_type     = "t3.large"
        weighted_capacity = "1"
      }
    }
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}"
    value               = "owned"
    propagate_at_launch = false
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = false
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = false
  }
}

resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.cluster_name}-eks-worker-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name                                                        = "${var.cluster_name}-worker-node-sg"
    "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
  }
}

resource "aws_security_group_rule" "eks_node_egress" {
  type              = "egress"
  description       = "Allow all traffic from anywhere"
  security_group_id = aws_security_group.eks_nodes_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "node_ingress_self_aws_security_group_rule" {
  type                     = "ingress"
  description              = "Allow node to communicate with each other"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eks_nodes_sg.id
}

resource "aws_security_group_rule" "node_ingress_cluster_https_aws_security_group_rule" {
  type                     = "ingress"
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_sg.id
}

resource "aws_security_group_rule" "node_ingress_cluster_others_aws_security_group_rule" {
  type                     = "ingress"
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id        = aws_security_group.eks_nodes_sg.id
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_sg.id
}

#resource "aws_security_group" "eks_nodes_sg" {
#  name   = "${var.cluster_name}-eks-worker-sg"
#  vpc_id = var.vpc_id
#
#  ingress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["10.0.0.0/16"]
#  }
#
#  egress {
#    from_port        = 0
#    to_port          = 0
#    protocol         = "-1"
#    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
#  }
#
#  tags = {
#    "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
#    Name                                                        = "${var.cluster_name}-worker-node-sg"
#  }
#}