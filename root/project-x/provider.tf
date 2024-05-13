terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = module.eks-cluster.cluster_endpoint
  token                  = module.eks-cluster.eks_cluster_token
  cluster_ca_certificate = base64decode(module.eks-cluster.cluster_ca_certificate)
}