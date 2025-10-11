variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "az" {
  type    = list(string)
  default = ["us-east-2a", "us-east-2b"]
}

variable "vpc_name" {
  default = "dev_vpc"
}

variable "subnet_name" {
  type    = list(string)
  default = ["dev_subnet_a", "dev_subnet_b"]
}

variable "sg_name" {
  default = "dev_sg"
}

variable "igw_name" {
  default = "dev_igw"
}

variable "rt_name" {
  default = "dev_public_rt"
}
