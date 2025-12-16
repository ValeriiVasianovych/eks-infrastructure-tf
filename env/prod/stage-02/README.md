# Stage 02 - Monitoring & Observability Setup

This stage deploys the monitoring and observability stack on top of the EKS cluster created in Stage 01 for the **production environment**.

## What This Stage Creates

### 1. Monitoring Namespace
- Creates a dedicated `monitoring` namespace for all monitoring components
- Isolated from other workloads for better organization

### 2. Prometheus Stack
- **Helm Chart:** `kube-prometheus-stack` (version `75.15.0`)
- **Components:**
  - Prometheus server for metrics collection and storage
  - Prometheus Operator for managing Prometheus resources
  - ServiceMonitors and PodMonitors for automatic metric discovery
  - Alertmanager for alerting (if configured)
  - Node Exporter for node-level metrics
  - Kube State Metrics for Kubernetes object metrics
  - Grafana Operator for Grafana management

### 3. Grafana
- Pre-configured Grafana instance with dashboards
- Integrated with Prometheus as data source
- Accessible via ingress with Route53 DNS
- Production-ready configuration with persistence

### 4. Ingress Resources
- **Grafana Ingress:** Exposes Grafana UI via ingress controller
- **Prometheus Ingress:** Exposes Prometheus UI via ingress controller
- Both ingresses are configured with Route53 DNS records
- Uses AWS Load Balancer Controller from Stage 01

### 5. Route53 Integration
- Automatically creates DNS records for Grafana and Prometheus ingress hosts
- Uses the provided hosted zone name
- Enables easy access to monitoring dashboards

## Dependencies

**This stage REQUIRES Stage 01 to be applied first.**

Stage 02 reads the following from Stage 01's remote state:
- VPC information (region, ID, CIDR, subnets)
- EKS cluster details (name, endpoint, IAM roles, OIDC issuer)
- Node group information
- Load Balancer Controller availability

## State Backend

Terraform state is stored remotely in S3:
- **Bucket:** `terraform-states-vv`
- **Key:** `aws-eks-automation/prod/stage-02/infra.tfstate`
- **Region:** `us-east-1`
- **Encryption:** Enabled
- **Locking:** Enabled

## Remote State Data Source

Stage 02 reads Stage 01's state from:
- **Bucket:** `terraform-states-vv`
- **Key:** `aws-eks-automation/prod/stage-01/infra.tfstate`
- **Region:** `us-east-1`

## Required Variables

```hcl
variable "hosted_zone_name" {
  description = "The hosted zone name for Route53 DNS records"
  type        = string
  # Example: "example.com"
}
```

Optional:
```hcl
variable "kube_prometheus_stack_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
  default     = "75.15.0"
}
```

## Outputs

- `grafana_ingress_host` - The hostname for accessing Grafana
- `prometheus_ingress_host` - The hostname for accessing Prometheus

## Usage

**Important:** Ensure Stage 01 is applied and its state is available before running this stage.

```bash
terraform init
terraform plan
terraform apply
```

After successful apply, you can access:
- Grafana at the hostname provided in outputs
- Prometheus at the hostname provided in outputs

## Configuration

The Prometheus stack configuration is defined in:
`modules/stage_02/monitoring/conf/values.yaml`

This file contains Helm values for customizing:
- Prometheus retention and storage
- Grafana dashboards and data sources
- Alertmanager configuration
- Resource limits and requests
- Service monitor configurations

## Production Considerations

- **High Availability**: Prometheus and Grafana are configured for production workloads
- **Data Retention**: Configure retention policies based on your needs
- **Resource Limits**: Ensure adequate resources for monitoring stack
- **Access Control**: Consider implementing authentication/authorization for Grafana
- **Backup**: Plan for backing up Prometheus data and Grafana dashboards

## Post-Deployment

After applying this stage:

1. **Verify Monitoring Stack:**
   ```bash
   kubectl get pods -n monitoring
   ```

2. **Check Ingress:**
   ```bash
   kubectl get ingress -n monitoring
   ```

3. **Verify DNS Records:**
   ```bash
   aws route53 list-resource-record-sets --hosted-zone-id <zone-id>
   ```

4. **Access Dashboards:**
   - Grafana: `https://<grafana-ingress-host>`
   - Prometheus: `https://<prometheus-ingress-host>`

## Monitoring Resources

The monitoring stack will collect metrics from:
- Kubernetes cluster components
- Node resources (CPU, memory, disk, network)
- Pod and container metrics
- Application metrics (if ServiceMonitors are configured)
- Custom metrics via Prometheus exporters

## Cost Considerations

Production monitoring stack includes:
- Persistent storage for Prometheus data
- Persistent storage for Grafana dashboards
- Additional load balancer for ingress
- Route53 DNS records

Estimated additional monthly cost:
- EBS volumes for persistence: ~$10-50/month (depending on retention)
- Load balancer: ~$20/month
- Route53: ~$0.50/month per hosted zone
