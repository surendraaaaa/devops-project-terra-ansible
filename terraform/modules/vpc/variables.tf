variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "az" {
  default = "us-east-2a"
}

variable "vpc_name" {
  default = "dev_vpc"
}

variable "subnet_name" {
  default = "dev_subnet"
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