output "instance_id" {
  value = aws_instance.my_ec2.id
}

output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "private_ip" {
  value = aws_instance.my_ec2.private_ip
}

output "public_dns" {
  value = aws_instance.my_ec2.public_dns
}

output "ssh_key_name" {
     value = aws_key_pair.my_key.key_name
}