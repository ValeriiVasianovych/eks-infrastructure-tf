terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    key          = "aws-eks-automation/dev/stage-02/infra.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = local.vpc_region

  default_tags {
    tags = {
      Owner       = "Valerii Vasianovych"
      Project     = "AWS EKS Kubernetes Infra Automation"
      Environment = local.vpc_env
      ManagedBy   = "Terraform"
      Stage       = "Stage 2 - Setup Resources Provisioning"
    }
  }
}

provider "kubernetes" {
  host                   = local.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host                   = local.cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "time" {}

module "monitoring" {
  source = "../../../modules/stage_02/monitoring"

  region           = local.vpc_region
  env              = local.vpc_env
  cluster_name     = local.cluster_name
  cluster_iam_arn  = local.cluster_iam_role_arn
  hosted_zone_name = var.hosted_zone_name
  account_id       = data.aws_caller_identity.current.account_id
}
