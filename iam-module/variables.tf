variable "administrator_role_name" {
  description = "The name of the IAM role for the administrator."
  type        = string
}

variable "admin_role_policy_arn_to_eks_cluster" {
  description = "Admin policy for the Admin role to the cluster"
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

variable "specific_user_arn" {
  description = "Add permissions to the specific users"
  type = list(string)
}