variable "aws_region" {
  default = "us-east-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}



