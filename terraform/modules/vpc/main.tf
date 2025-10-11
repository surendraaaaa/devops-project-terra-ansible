##########################
#        VPC Setup       #
##########################

resource "aws_vpc" "my_vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

##########################
#        subnet Setup       #
##########################

resource "aws_subnet" "my_subnet" {
  count = length(var.subnet_cidr)

  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr[count.index]
  availability_zone       = var.az[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_name[count.index]
  }
}


##########################
#        SG Setup       #
##########################

resource "aws_security_group" "my_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = var.sg_name
  description = "this is my security group for the devops project"

  tags = {
    Name = var.sg_name
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 9000
    protocol    = "tcp"
    to_port     = 9000
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5000
    protocol    = "tcp"
    to_port     = 5000
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 27017
    protocol    = "tcp"
    to_port     = 27017
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 6443
    protocol    = "tcp"
    to_port     = 6443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 30000
    protocol    = "tcp"
    to_port     = 32767
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

##########################
#        IGW Setup       #
##########################
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.igw_name
  }
}

##########################
#        RT Setup       #
##########################

resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags   = { Name = var.rt_name }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(var.subnet_cidr)
  subnet_id      = aws_subnet.my_subnet[count.index].id
  route_table_id = aws_route_table.my_public_rt.id
}









