output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}
 
output "cluster_ca_certificate" {
  value = data.aws_eks_cluster.cluster.certificate_authority.0.data
}
 
output "cluster_name" {
  value = data.aws_eks_cluster.cluster.name
}
 
output "cluster_version" {
  value = data.aws_eks_cluster.cluster.version
}
 
# output "cluster_token" {
#   value = data.aws_eks_cluster_auth.cluster.token
#   sensitive = true
# }
