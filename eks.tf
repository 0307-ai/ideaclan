locals {
  cluster_name    = "${local.region}-${var.environment}-${var.cluster_name}"
  cluster_version = var.cluster_version
  region          = data.aws_region.current.name
  environment     = var.environment
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
    "${var.karpenter_tag_key}" = local.cluster_name
  }
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

# data "aws_eks_cluster" "cluster" {
#   name = local.cluster_name
# }

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--role-arn", var.JenkinsTerraformDeploymentAdminRole]
#   }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.cluster.token

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--role-arn", var.JenkinsTerraformDeploymentAdminRole]
#   }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token

    # exec {
    #   api_version = "client.authentication.k8s.io/v1beta1"
    #   command     = "aws"
    #   # This requires the awscli to be installed locally where Terraform is executed
    #   args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name, "--role-arn", var.JenkinsTerraformDeploymentAdminRole]
    # }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws" 
  version = "~> 19.0"

  cluster_name                    = local.cluster_name
  cluster_version                 = local.cluster_version
  cluster_endpoint_private_access = true

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description = "ingress from shared services" 
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/16"]
    }
  }

  # EKS Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    # adot = {
    #   most_recent = true
    # }
    # tetrate-io_istio-distro = {
    #   most_recent = true
    # }
    # aws-guardduty-agent = {
    #   most_recent = true
    # }
  }

  manage_aws_auth_configmap = true
  create_aws_auth_configmap = false

  aws_auth_users = var.aws_auth_users
  aws_auth_roles = var.aws_auth_roles

  vpc_id = var.vpc_id

  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids
  eks_managed_node_groups  = var.eks_managed_node_groups

  tags = local.tags
}


