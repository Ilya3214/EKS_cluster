#For vpc-module
variable "cluster_name" {
  description = "The name of a project"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones in which to create subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
}


# AWS AUTH
variable "administrator_role_name" {
  description = "The name of the IAM role for the administrator."
  type        = string
}


# EKS CLUSTER
variable "cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  type        = string
}

variable "k8s_service_cidr" {
  description = "The service IPv4 CIDR for the Kubernetes cluster"
  type        = string
}


# WORKER NODES
variable "instance_type" {
  description = "Instance type for the EKS worker nodes"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances in the EKS worker nodes auto-scaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the EKS worker nodes auto-scaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the EKS worker nodes auto-scaling group"
  type        = number
}

variable "eks_role_policy_arns" {
  description = "Policy ARNs for EKS Cluster Role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

variable "worker_role_policy_arns" {
  description = "Policy ARNs for EKS Worker Role"
  type        = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}