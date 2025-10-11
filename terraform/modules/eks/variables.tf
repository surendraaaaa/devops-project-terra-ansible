variable "cluster_name" {
  description = "EKS cluster name"
  default     = "dev-eks-cluster"
}

variable "k8s_version" {
  description = "Kubernetes version"
  default     = "1.29"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "cluster_sg_id" {
  description = "Security group ID for EKS cluster control plane"
}

variable "cluster_role_arn" {
  description = "IAM role ARN for EKS cluster"
  default     = ""
}

variable "node_role_arn" {
  description = "IAM role ARN for EKS worker nodes"
  default     = ""
}

variable "node_instance_type" {
  default = "t3.micro"
}

variable "node_desired_capacity" {
  default = 2
}

variable "node_max_size" {
  default = 2
}

variable "node_min_size" {
  default = 1
}

variable "ssh_key_name" {
  description = "EC2 key pair for node SSH access"
}
