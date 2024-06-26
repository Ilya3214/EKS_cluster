module "vpc" {
  source = "../../vpc-module"

  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  cluster_name       = var.cluster_name
  public_subnets     = var.public_subnets
  vpc_cidr           = var.vpc_cidr
}

module "eks-cluster" {
  source       = "../../eks-module"
  cluster_name = var.cluster_name

  # AWS Auth
  administrator_role_name = var.administrator_role_name

  # VPC
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  # EKS
  cluster_version  = var.cluster_version
  k8s_service_cidr = var.k8s_service_cidr

  # Worker
  desired_capacity = var.desired_capacity
  instance_type    = var.instance_type
  max_size         = var.max_size
  min_size         = var.min_size
}