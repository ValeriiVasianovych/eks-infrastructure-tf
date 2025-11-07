terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    key          = "aws-eks-automation/dev/stage-01/infra.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Owner       = "Valerii Vasianovych"
      Project     = "AWS EKS Kubernetes Infra Automation"
      Environment = var.env
      ManagedBy   = "Terraform"
      Stage       = "Stage 1 - Infra Setup and Kubernetes Cluster Provisioning"
    }
  }
}

module "vpc" {
  source = "../../../modules/stage_01/vpc"

  region      = var.region
  env         = var.env
  prefix_name = var.prefix_name
  account_id  = data.aws_caller_identity.current.account_id

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24"]
  private_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]
}

module "eks" {
  source             = "../../../modules/stage_01/eks"
  region             = var.region
  env                = var.env
  account_id         = data.aws_caller_identity.current.id
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  prefix_name     = var.prefix_name
  cluster_version = local.cluster_version
  desired_size    = local.desired_size
  max_size        = local.max_size
  min_size        = local.min_size
  max_unavailable = local.max_unavailable
  capacity_type   = local.capacity_type
  instance_types  = local.instance_types
  ingress_ports   = local.ingress_ports

  coredns_version        = local.coredns_version
  kube_proxy_version     = local.kube_proxy_version
  vpc_cni_version        = local.vpc_cni_version
  pod_identity_version   = local.pod_identity_version
  metrics_server_version = local.metrics_server_version

  depends_on = [module.vpc]
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = data.aws_eks_cluster_auth.eks.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

module "ebs-csi-driver" {
  source          = "../../../modules/stage_01/ebs-csi-driver"
  env             = var.env
  prefix_name     = var.prefix_name
  cluster_name    = module.eks.cluster_name
  ebs_csi_version = local.ebs_csi_version

  depends_on = [module.eks]
}

module "cluster-autoscaler" {
  source                     = "../../../modules/stage_01/cluster-autoscaler"
  env                        = var.env
  prefix_name                = var.prefix_name
  cluster_name               = module.eks.cluster_name
  cluster_autoscaler_version = local.cluster_autoscaler_version

  depends_on = [module.eks]
}

module "lb-controller" {
  source                = "../../../modules/stage_01/lb-controller"
  env                   = var.env
  prefix_name           = var.prefix_name
  cluster_name          = module.eks.cluster_name
  vpc_id                = module.vpc.vpc_id
  lb_controller_version = local.lb_controller_version
  nginx_ingress_version = local.nginx_ingress_version
  cert_manager_version  = local.cert_manager_version

  depends_on = [module.eks]
}
