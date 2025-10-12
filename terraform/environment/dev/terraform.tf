terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }

  cloud {
    organization = "my-remote-backend" # Your Terraform Cloud org

    workspaces {
      name = "first-remote-backend-workspace" # Your workspace name
    }
  }
}



provider "aws" {
  region = var.aws_region
}

