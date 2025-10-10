output "cluster_name" {
  value = aws_eks_cluster.my_eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.my_eks.endpoint
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.my_eks.vpc_config[0].cluster_security_group_id
}

output "node_group_name" {
  value = aws_eks_node_group.my_eks_node.node_group_name
}