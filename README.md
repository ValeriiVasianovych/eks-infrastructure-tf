# AWS EKS Kubernetes Infrastructure Automation

This project provides a complete, production-ready infrastructure automation solution for deploying Amazon EKS (Elastic Kubernetes Service) clusters on AWS using Terraform. The infrastructure is organized into modular, reusable components that can be deployed across multiple environments (development and production).

## Project Overview

This infrastructure automation project creates a fully functional Kubernetes cluster on AWS with:

- **Networking**: VPC with public and private subnets across multiple availability zones
- **Kubernetes Cluster**: Managed EKS cluster with essential addons
- **Storage**: EBS CSI driver for dynamic volume provisioning
- **Scaling**: Cluster autoscaler for automatic node scaling
- **Load Balancing**: AWS Load Balancer Controller for ingress management
- **Monitoring**: Complete Prometheus and Grafana observability stack

## Architecture

The project follows a **two-stage deployment model**:

1. **Stage 01**: Core infrastructure and Kubernetes cluster provisioning
2. **Stage 02**: Application-level services (monitoring, observability)

This separation allows for:
- Independent lifecycle management of infrastructure vs applications
- Better state management and rollback capabilities
- Clearer dependency boundaries

## Directory Structure

```
.
├── env/                    # Environment-specific configurations
│   ├── dev/               # Development environment
│   │   ├── stage-01/      # Dev infrastructure setup
│   │   └── stage-02/      # Dev monitoring stack
│   └── prod/              # Production environment
│       ├── stage-01/      # Prod infrastructure setup
│       └── stage-02/      # Prod monitoring stack
└── modules/               # Reusable Terraform modules
    ├── stage_01/          # Stage 01 modules
    │   ├── vpc/           # VPC and networking
    │   ├── eks/           # EKS cluster and node groups
    │   ├── ebs-csi-driver/ # EBS storage driver
    │   ├── cluster-autoscaler/ # Auto-scaling
    │   └── lb-controller/ # Load balancer controller
    └── stage_02/          # Stage 02 modules
        └── monitoring/    # Prometheus & Grafana stack
```

## Environments

### Development (`env/dev/`)
- Smaller cluster size (2-10 nodes, t3.small instances)
- Lower resource allocation
- Same feature set as production for testing

### Production (`env/prod/`)
- Larger cluster size (4-12 nodes, t3.medium instances)
- Higher availability and redundancy
- Production-grade configurations

## Key Features

### Infrastructure Components

- **VPC**: Custom VPC with public/private subnet architecture
- **EKS Cluster**: Managed Kubernetes cluster with version 1.33
- **Node Groups**: Managed node groups with auto-scaling capabilities
- **EKS Addons**: CoreDNS, kube-proxy, VPC CNI, Pod Identity, Metrics Server

### Kubernetes Addons

- **EBS CSI Driver**: Dynamic provisioning of EBS volumes with GP3 storage class
- **Cluster Autoscaler**: Automatically scales nodes based on pod scheduling needs
- **AWS Load Balancer Controller**: Manages ALB/NLB for Kubernetes ingress

### Observability

- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Ingress Integration**: Route53 DNS records for monitoring UIs

## State Management

All Terraform states are stored remotely in S3:
- **Bucket**: `terraform-states-vv`
- **Region**: `us-east-1`
- **Encryption**: Enabled
- **Locking**: Enabled

State paths:
- Dev Stage 01: `aws-eks-automation/dev/stage-01/infra.tfstate`
- Dev Stage 02: `aws-eks-automation/dev/stage-02/infra.tfstate`
- Prod Stage 01: `aws-eks-automation/prod/stage-01/infra.tfstate`
- Prod Stage 02: `aws-eks-automation/prod/stage-02/infra.tfstate`

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- kubectl installed
- helm installed (for Stage 02)
- IAM role with permissions to create EKS clusters, VPCs, and related resources
- Route53 hosted zone (for Stage 02 monitoring ingress)

## Quick Start

### Development Environment

1. **Deploy Stage 01:**
   ```bash
   cd env/dev/stage-01
   terraform init
   terraform plan
   terraform apply
   ```

2. **Deploy Stage 02:**
   ```bash
   cd ../stage-02
   terraform init
   terraform plan
   terraform apply
   ```

### Production Environment

1. **Deploy Stage 01:**
   ```bash
   cd env/prod/stage-01
   terraform init
   terraform plan
   terraform apply
   ```

2. **Deploy Stage 02:**
   ```bash
   cd ../stage-02
   terraform init
   terraform plan
   terraform apply
   ```

## Module Reusability

All infrastructure components are organized as reusable Terraform modules in the `modules/` directory. This allows for:
- Consistent configurations across environments
- Easy maintenance and updates
- Clear separation of concerns
- Version-controlled infrastructure components

## Security

- Private subnets for worker nodes
- Security groups with least-privilege access
- IAM roles with service account integration (IRSA)
- Encrypted state storage
- Network isolation between public and private subnets

## Maintenance

- All resources are tagged with environment, project, and owner information
- State files are versioned in S3
- Module versions are pinned for stability
- Kubernetes addon versions are explicitly specified

## Documentation

Each environment and stage has detailed README files:
- `env/dev/README.md` - Development environment overview
- `env/prod/README.md` - Production environment overview
- `env/*/stage-01/README.md` - Infrastructure setup details
- `env/*/stage-02/README.md` - Monitoring stack details
- `modules/README.md` - Module documentation

## Author

Valerii Vasianovych

## License

This project is part of an AWS EKS automation infrastructure setup.
