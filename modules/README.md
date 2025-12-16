# Terraform Modules

This directory contains reusable Terraform modules organized by deployment stage. Each module encapsulates a specific infrastructure component and can be used across different environments.

## Module Structure

```
modules/
├── stage_01/          # Infrastructure and cluster modules
│   ├── vpc/           # VPC and networking components
│   ├── eks/           # EKS cluster and node groups
│   ├── ebs-csi-driver/ # EBS storage driver
│   ├── cluster-autoscaler/ # Auto-scaling component
│   └── lb-controller/ # Load balancer controller
└── stage_02/          # Application-level modules
    └── monitoring/    # Prometheus & Grafana stack
```

## Stage 01 Modules

### VPC Module (`stage_01/vpc/`)

Creates the foundational networking infrastructure.

**What it creates:**
- VPC with custom CIDR
- Public subnets across multiple availability zones
- Private subnets across multiple availability zones
- Internet Gateway
- Route tables for public and private subnets
- Security groups for cluster and node communication

**Key Features:**
- Multi-AZ deployment for high availability
- Separate public/private subnet architecture
- Configurable CIDR blocks
- Security group rules for EKS requirements

**Outputs:**
- VPC ID, CIDR, and subnet IDs
- Security group IDs

### EKS Module (`stage_01/eks/`)

Provisions the EKS cluster and managed node groups.

**What it creates:**
- EKS control plane
- Managed node groups with auto-scaling
- EKS addons (CoreDNS, kube-proxy, VPC CNI, Pod Identity, Metrics Server)
- IAM roles for cluster and nodes
- OIDC provider for service account integration

**Key Features:**
- Configurable Kubernetes version
- Flexible node group configuration
- Multiple instance type support
- IRSA (IAM Roles for Service Accounts) support
- Security group integration

**Outputs:**
- Cluster name, endpoint, and certificate
- OIDC issuer URL
- IAM role ARNs
- Node group information

### EBS CSI Driver Module (`stage_01/ebs-csi-driver/`)

Deploys the EBS Container Storage Interface driver for dynamic volume provisioning.

**What it creates:**
- EBS CSI driver deployment
- IAM role with EBS permissions
- Service account with IRSA
- GP3 storage class for cost-effective storage

**Key Features:**
- Dynamic volume provisioning
- Support for multiple volume types
- GP3 storage class (cheaper than GP2)
- IRSA-based authentication

**Outputs:**
- Storage class name
- IAM role ARN

### Cluster Autoscaler Module (`stage_01/cluster-autoscaler/`)

Deploys the Kubernetes cluster autoscaler for automatic node scaling.

**What it creates:**
- Cluster autoscaler Helm release
- Service account with IRSA
- IAM role with autoscaling permissions
- Configuration for node group scaling

**Key Features:**
- Automatic node scaling based on pod scheduling
- Respects node group min/max limits
- Integrates with EKS managed node groups
- Configurable scaling policies

**Outputs:**
- Helm release name
- IAM role ARN

### Load Balancer Controller Module (`stage_01/lb-controller/`)

Deploys the AWS Load Balancer Controller for managing ALB/NLB resources.

**What it creates:**
- AWS Load Balancer Controller Helm release
- Service account with IRSA
- IAM role with ELB permissions
- Integration with VPC and cluster

**Key Features:**
- Manages Application Load Balancers (ALB)
- Manages Network Load Balancers (NLB)
- Supports both internal and external load balancers
- Integrates with Kubernetes Ingress resources

**Outputs:**
- Helm release name
- IAM role ARN

## Stage 02 Modules

### Monitoring Module (`stage_02/monitoring/`)

Deploys the complete Prometheus and Grafana observability stack.

**What it creates:**
- Kubernetes namespace for monitoring
- Prometheus stack (Prometheus, Alertmanager, Node Exporter, Kube State Metrics)
- Grafana instance with pre-configured dashboards
- Ingress resources for Grafana and Prometheus
- Route53 DNS records for ingress hosts

**Key Features:**
- Complete observability stack
- Automatic metric discovery via ServiceMonitors
- Pre-configured Grafana dashboards
- Ingress integration with Route53
- Configurable via Helm values

**Outputs:**
- Grafana ingress hostname
- Prometheus ingress hostname
- Namespace name

## Module Design Principles

1. **Reusability**: Modules are designed to be used across multiple environments
2. **Modularity**: Each module has a single, well-defined responsibility
3. **Configurability**: All modules accept variables for customization
4. **Outputs**: Modules expose necessary outputs for integration with other modules
5. **Dependencies**: Clear dependency management between modules
6. **State Management**: Modules don't manage state; that's handled at the environment level

## Using Modules

Modules are used in environment configurations like this:

```hcl
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
```

## Module Dependencies

```
Stage 01:
  vpc
    └── eks (depends on vpc)
        ├── ebs-csi-driver (depends on eks)
        ├── cluster-autoscaler (depends on eks)
        └── lb-controller (depends on eks, vpc)

Stage 02:
  monitoring (depends on Stage 01 outputs via remote state)
```

## Versioning

Module versions are managed through:
- Git tags for module versions
- Pinned Helm chart versions in module code
- Explicit addon versions in EKS module

## Maintenance

When updating modules:
1. Test changes in development environment first
2. Update version numbers if making breaking changes
3. Update documentation for any new variables or outputs
4. Ensure backward compatibility when possible

## Module Variables

Each module defines its required and optional variables. Common patterns:
- `env` - Environment name (dev/prod)
- `prefix_name` - Resource naming prefix
- `region` - AWS region
- `cluster_name` - EKS cluster name (for Stage 02 modules)

## Module Outputs

Modules expose outputs that are consumed by:
- Other modules in the same stage
- Remote state data sources in subsequent stages
- Environment-level outputs

Common outputs include:
- Resource IDs (VPC ID, cluster name, etc.)
- IAM role ARNs
- Endpoint URLs
- Configuration values needed by other modules
