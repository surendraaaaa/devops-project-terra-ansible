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
  source                = "../../modules/eks"
  cluster_name          = "dev-eks-cluster"
  k8s_version           = "1.29"
  subnet_ids            = module.vpc.subnet_ids
  cluster_sg_id         = module.vpc.security_group_id
  node_instance_type    = "t3.micro"
  node_desired_capacity = 1
  node_max_size         = 2
  node_min_size         = 1
  ssh_key_name          = module.ec2.ssh_key_name

  depends_on = [
    module.vpc,
    module.ec2
  ]

}
