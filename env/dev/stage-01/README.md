# Stage 01 - Infrastructure Setup & Kubernetes Cluster Provisioning

This stage is responsible for setting up the foundational infrastructure and provisioning the Kubernetes cluster with essential addons.

## What This Stage Creates

### 1. VPC Infrastructure
- **VPC** with CIDR `10.0.0.0/16`
- **Public Subnets:** `10.0.10.0/24`, `10.0.11.0/24` (across 2 AZs)
- **Private Subnets:** `10.0.20.0/24`, `10.0.21.0/24` (across 2 AZs)
- Internet Gateway and route tables
- Security groups for cluster and node communication

### 2. EKS Cluster
- **Kubernetes Version:** 1.33
- **Node Group Configuration:**
  - Instance type: `t3.small`
  - Capacity type: `ON_DEMAND`
  - Desired size: 2 nodes
  - Min size: 2 nodes
  - Max size: 10 nodes
  - Max unavailable: 1 node
- **EKS Addons:**
  - CoreDNS (`v1.12.4-eksbuild.1`)
  - kube-proxy (`v1.33.3-eksbuild.6`)
  - VPC CNI (`v1.20.2-eksbuild.1`)
  - Pod Identity (`v1.3.8-eksbuild.2`)
  - Metrics Server (`v0.8.0-eksbuild.2`)

### 3. EBS CSI Driver
- Enables dynamic provisioning of EBS volumes
- Version: `v1.50.1-eksbuild.1`
- Creates IAM role with necessary permissions for EBS operations

### 4. Cluster Autoscaler
- Automatically scales node groups based on pod scheduling needs
- Helm chart version: `9.52.1`
- Configured to work with the EKS node group

### 5. AWS Load Balancer Controller
- Manages AWS Application/Network Load Balancers for Kubernetes services
- Helm chart version: `1.7.2`
- Integrates with AWS ALB/NLB for ingress resources

## Dependencies

This stage has no dependencies on other Terraform stages. It must be applied before Stage 02.

## Outputs

This stage outputs critical information used by Stage 02:
- VPC details (ID, CIDR, subnets)
- EKS cluster details (name, endpoint, OIDC issuer, IAM roles)
- Node group information
- IAM role ARNs for various components

## State Backend

Terraform state is stored remotely in S3:
- **Bucket:** `terraform-states-vv`
- **Key:** `aws-eks-automation/dev/stage-01/infra.tfstate`
- **Region:** `us-east-1`

## Required Variables

```hcl
variable "region" {
  description = "The AWS region"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
}

variable "prefix_name" {
  description = "The name prefix of the EKS cluster"
  type        = string
}

variable "automation_role_arn" {
  description = "The ARN of the automation role"
  type        = string
}
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

After successful apply, the cluster will be ready for Stage 02 deployment.
