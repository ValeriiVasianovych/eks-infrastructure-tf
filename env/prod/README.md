# Production Environment

This directory contains the Terraform configuration for the production environment, organized into two stages that must be applied sequentially.

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

**Production Configuration:**
- **Cluster Version:** 1.33
- **Node Instance Type:** t3.medium
- **Initial Node Count:** 4 nodes
- **Scaling Range:** 4-12 nodes
- **Capacity Type:** ON_DEMAND

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
- **Stage 01:** `s3://terraform-states-vv/aws-eks-automation/prod/stage-01/infra.tfstate`
- **Stage 02:** `s3://terraform-states-vv/aws-eks-automation/prod/stage-02/infra.tfstate`

Stage 02 reads outputs from Stage 01 via remote state data source.

## Required Variables

### Stage 01
- `region` - AWS region (e.g., `us-east-1`)
- `env` - Environment name (e.g., `production`)
- `prefix_name` - Name prefix for resources
- `automation_role_arn` - ARN of the automation IAM role

### Stage 02
- `hosted_zone_name` - Route53 hosted zone name for ingress domains

## Production Considerations

- **Higher Resource Allocation**: Production uses t3.medium instances (vs t3.small in dev)
- **More Nodes**: Minimum 4 nodes for better availability (vs 2 in dev)
- **Larger Scaling Range**: Up to 12 nodes for handling production workloads
- **Same Security Standards**: All security best practices apply
- **Monitoring**: Full observability stack for production workloads

## Differences from Development

| Aspect | Development | Production |
|--------|------------|------------|
| Instance Type | t3.small | t3.medium |
| Min Nodes | 2 | 4 |
| Max Nodes | 10 | 12 |
| Desired Nodes | 2 | 4 |

All other configurations (VPC CIDR, addon versions, etc.) remain the same for consistency.
