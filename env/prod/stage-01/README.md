# Stage 01 - Infrastructure Setup & Kubernetes Cluster Provisioning

This stage is responsible for setting up the foundational infrastructure and provisioning the Kubernetes cluster with essential addons for the **production environment**.

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
  - Instance type: `t3.medium` (production-grade)
  - Capacity type: `ON_DEMAND`
  - Desired size: 4 nodes
  - Min size: 4 nodes
  - Max size: 12 nodes
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
- Includes GP3 storage class for cost-effective storage

### 4. Cluster Autoscaler
- Automatically scales node groups based on pod scheduling needs
- Helm chart version: `9.52.1`
- Configured to work with the EKS node group
- Scales between 4-12 nodes based on workload demand

### 5. AWS Load Balancer Controller
- Manages AWS Application/Network Load Balancers for Kubernetes services
- Helm chart version: `1.7.2`
- Integrates with AWS ALB/NLB for ingress resources
- Supports both internal and external load balancers

## Production Configuration

This stage uses production-optimized settings:

- **Larger Instance Size**: t3.medium (2 vCPU, 4 GB RAM) for better performance
- **Higher Node Count**: Minimum 4 nodes for improved availability and fault tolerance
- **Larger Scaling Range**: Up to 12 nodes to handle production traffic spikes
- **Same Security Standards**: All security best practices from development apply

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
- **Key:** `aws-eks-automation/prod/stage-01/infra.tfstate`
- **Region:** `us-east-1`
- **Encryption:** Enabled
- **Locking:** Enabled

## Required Variables

```hcl
variable "region" {
  description = "The AWS region"
  type        = string
  # Example: "us-east-1"
}

variable "env" {
  description = "The environment"
  type        = string
  # Example: "production"
}

variable "prefix_name" {
  description = "The name prefix of the EKS cluster"
  type        = string
  # Example: "prod-eks-cluster"
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

After successful apply, the production cluster will be ready for Stage 02 deployment.

## Post-Deployment

After applying this stage:

1. **Verify Cluster Access:**
   ```bash
   aws eks update-kubeconfig --name <cluster-name> --region <region>
   kubectl get nodes
   ```

2. **Check Addons:**
   ```bash
   kubectl get pods -n kube-system
   ```

3. **Verify Storage Class:**
   ```bash
   kubectl get storageclass
   ```

4. **Check Autoscaler:**
   ```bash
   kubectl get pods -n kube-system | grep cluster-autoscaler
   ```

## Cost Considerations

Production environment uses:
- t3.medium instances (higher cost than dev)
- Minimum 4 nodes (always running)
- ON_DEMAND capacity type (no spot instances for production stability)

Estimated monthly cost (excluding data transfer and storage):
- 4x t3.medium instances: ~$120/month
- EKS control plane: ~$72/month
- Load balancers: Variable based on usage
