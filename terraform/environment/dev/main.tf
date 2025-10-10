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
