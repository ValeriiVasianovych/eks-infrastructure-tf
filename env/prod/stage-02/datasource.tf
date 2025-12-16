data "terraform_remote_state" "terraform-states-vv" {
  backend = "s3"
  config = {
    bucket  = "terraform-states-vv"
    encrypt = true
    key     = "aws-eks-automation/prod/stage-01/infra.tfstate"
    region  = "us-east-1"
  }
}

locals {
  # VPC values
  vpc_id         = data.terraform_remote_state.terraform-states-vv.outputs.vpc_id
  vpc_region     = data.terraform_remote_state.terraform-states-vv.outputs.vpc_region
  vpc_env        = data.terraform_remote_state.terraform-states-vv.outputs.vpc_env
  vpc_cidr_block = data.terraform_remote_state.terraform-states-vv.outputs.vpc_cidr_block

  # Subnet values
  public_subnet_ids          = data.terraform_remote_state.terraform-states-vv.outputs.public_subnet_ids
  public_subnet_cidr_blocks  = data.terraform_remote_state.terraform-states-vv.outputs.public_subnet_cidr_blocks
  private_subnet_ids         = data.terraform_remote_state.terraform-states-vv.outputs.private_subnet_ids
  private_subnet_cidr_blocks = data.terraform_remote_state.terraform-states-vv.outputs.private_subnet_cidr_blocks

  # EKS Cluster values
  cluster_name              = data.terraform_remote_state.terraform-states-vv.outputs.cluster_name
  cluster_endpoint          = data.terraform_remote_state.terraform-states-vv.outputs.cluster_endpoint
  eks_oidc_issuer           = data.terraform_remote_state.terraform-states-vv.outputs.eks_oidc_issuer
  cluster_security_group_id = data.terraform_remote_state.terraform-states-vv.outputs.cluster_security_group_id
  cluster_iam_role_name     = data.terraform_remote_state.terraform-states-vv.outputs.cluster_iam_role_name
  cluster_iam_role_arn      = data.terraform_remote_state.terraform-states-vv.outputs.cluster_iam_role_arn

  # Node Group values
  node_group_name           = data.terraform_remote_state.terraform-states-vv.outputs.node_group_name
  node_group_iam_role_name  = data.terraform_remote_state.terraform-states-vv.outputs.node_group_iam_role_name
  node_group_iam_role_arn   = data.terraform_remote_state.terraform-states-vv.outputs.node_group_iam_role_arn
  node_group_status         = data.terraform_remote_state.terraform-states-vv.outputs.node_group_status
  node_group_ami_type       = data.terraform_remote_state.terraform-states-vv.outputs.node_group_ami_type
  node_group_disk_size      = data.terraform_remote_state.terraform-states-vv.outputs.node_group_disk_size
  node_group_instance_types = data.terraform_remote_state.terraform-states-vv.outputs.node_group_instance_types
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "eks" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = local.cluster_name
}