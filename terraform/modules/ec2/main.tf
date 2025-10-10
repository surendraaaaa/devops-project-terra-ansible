##########################
#       key pair Setup        #
##########################

resource "aws_key_pair" "my_key" {
  key_name   = "my-module-key"
  public_key = file("${path.module}/my_key.pub")
}


##########################
#       EC2 Setup        #
##########################

resource aws_instance "my_ec2" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = [var.security_group_id]
    key_name = aws_key_pair.my_key.key_name
    associate_public_ip_address = true

    tags = {

        Name = var.instance_name

    }

}