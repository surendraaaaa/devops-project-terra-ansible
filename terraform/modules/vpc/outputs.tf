output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_ids" {
  value = [for subnet in aws_subnet.my_subnet : subnet.id]
}

output "security_group_id" {
  value = aws_security_group.my_sg.id
}
