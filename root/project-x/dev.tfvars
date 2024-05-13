cluster_name = "easy-dev"

# VPC module
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnets    = ["10.50.11.0/24", "10.50.12.0/24", "10.50.13.0/24"]
public_subnets     = ["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]
vpc_cidr           = "10.50.0.0/16"

## EKS Module
# AWS Auth
administrator_role_name = "Admin-dev"

# EKS
cluster_version  = "1.28"
k8s_service_cidr = "10.51.0.0/16"

# Worker
desired_capacity = 2
instance_type    = "t3.medium"
max_size         = 3
min_size         = 1