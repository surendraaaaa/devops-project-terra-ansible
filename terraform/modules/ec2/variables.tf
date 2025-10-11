variable "ami" {
  default = "ami-0cfde0ea8edd312d4"
}

variable "instance_name" {
  type    = string
  default = "devops_ec2"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "subnet_id" {

}

variable "security_group_id" {

}

