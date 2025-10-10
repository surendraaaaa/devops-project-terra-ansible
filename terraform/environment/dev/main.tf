module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  az          = "us-east-2a"
  vpc_name    = "dev-vpc"
  subnet_name = "dev-subnet"
  sg_name     = "dev-sg"
  igw_name    = "dev-igw"
  rt_name     = "dev-rt"
}

module "ec2" {
  source                = "../../modules/ec2"
  ami                   = "ami-0cfde0ea8edd312d4"
  instance_name         = "devops-ec2"
  instance_type         = "t3.micro"
  subnet_id             = module.vpc.subnet_id
  vpc_security_group_ids     = module.vpc.security_group_id
}
