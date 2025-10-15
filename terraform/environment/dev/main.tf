module "vpc" {
  source      = "../../modules/vpc"
  cidr_block  = "10.0.0.0/16"
  subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  az          = ["us-east-2a", "us-east-2b"]
  vpc_name    = "dev-vpc"
  subnet_name = ["dev_subnet_a", "dev_subnet_b"]
  sg_name     = "dev-sg"
  igw_name    = "dev-igw"
  rt_name     = "dev-rt"
}

module "ec2" {
  source            = "../../modules/ec2"
  ami               = "ami-0cfde0ea8edd312d4"
  instance_name     = "devops-ec2"
  instance_type     = "t3.micro"
  subnet_id         = module.vpc.subnet_ids[0]
  security_group_id = module.vpc.security_group_id

}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "my-eks-cluster-${var.environment}"
  kubernetes_version = "1.28"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids

  node_desired_size   = 2
  node_max_size       = 4
  node_min_size       = 1
  node_instance_types = ["t3.medium"]

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
  

