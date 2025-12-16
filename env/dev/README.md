# Development Environment

This directory contains the Terraform configuration for the development environment, organized into two stages that must be applied sequentially.

## Stages

### Stage 01 - Infrastructure & Cluster Setup
Creates the foundational infrastructure including VPC, EKS cluster, and essential Kubernetes addons.

**Location:** `stage-01/`

**What it provisions:**
- VPC with public and private subnets
- EKS cluster with managed node groups
- EBS CSI driver for persistent volumes
- Cluster autoscaler for automatic node scaling
- AWS Load Balancer Controller for ingress

### Stage 02 - Monitoring & Observability
Deploys monitoring stack on top of the cluster created in Stage 01.

**Location:** `stage-02/`

**What it provisions:**
- Prometheus for metrics collection
- Grafana for visualization
- Ingress resources with Route53 integration

## Usage

1. **Apply Stage 01 first:**
   ```bash
   cd stage-01
   terraform init
   terraform plan
   terraform apply
   ```

2. **Then apply Stage 02:**
   ```bash
   cd ../stage-02
   terraform init
   terraform plan
   terraform apply
   ```

## State Management

Both stages use remote state stored in S3:
- **Stage 01:** `s3://terraform-states-vv/aws-eks-automation/dev/stage-01/infra.tfstate`
- **Stage 02:** `s3://terraform-states-vv/aws-eks-automation/dev/stage-02/infra.tfstate`

Stage 02 reads outputs from Stage 01 via remote state data source.

## Required Variables

### Stage 01
- `region` - AWS region (e.g., `us-east-1`)
- `env` - Environment name (e.g., `development`)
- `prefix_name` - Name prefix for resources
- `automation_role_arn` - ARN of the automation IAM role

### Stage 02
- `hosted_zone_name` - Route53 hosted zone name for ingress domains
