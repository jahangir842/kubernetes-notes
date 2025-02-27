# Kubernetes Monitoring Stack

A comprehensive guide to setting up production-grade monitoring for Kubernetes clusters.

## Components Overview

- **Prometheus**: Open-source systems monitoring and alerting toolkit
  - Metrics collection and storage
  - PromQL query language
  - Service discovery for Kubernetes
  
- **Grafana**: Visualization and analytics platform
  - Customizable dashboards
  - Support for multiple data sources
  - Alert notifications
  
- **AlertManager**: Handling alerts from Prometheus
  - Alert grouping and routing
  - Deduplication
  - Silencing and inhibition

## Prerequisites

- Kubernetes cluster (v1.16+)
- kubectl configured and working
- Storage provisioner for PersistentVolumes
- Helm v3 (optional)
- Admin access to the cluster

## Storage Configuration

The monitoring stack uses persistent storage for:
- Prometheus data retention
- Grafana dashboards and settings

Storage requirements:
- Prometheus: 50Gi (configurable)
- Grafana: 10Gi (configurable)
- StorageClass: standard (modify based on your cluster)

## Directory Structure

```plaintext
monitoring/
├── storage/
│   └── monitoring-storage.yaml
├── prometheus/
│   ├── rules/
│   │   ├── node-alerts.yaml
│   │   └── recording-rules/
│   ├── prometheus-configmap.yaml
│   ├── prometheus-deployment.yaml
│   ├── prometheus-service.yaml
│   └── prometheus-rbac.yaml
├── grafana/
│   ├── grafana-configmap.yaml
│   ├── grafana-deployment.yaml
│   ├── grafana-service.yaml
│   └── grafana-datasource.yaml
├── alertmanager/
│   ├── alertmanager-configmap.yaml
│   ├── alertmanager-deployment.yaml
│   └── alertmanager-service.yaml
└── docs/
    └── setup-guide.md
```

## Getting Started

### Implementation Checklist
- [ ] Verify cluster prerequisites
- [ ] Check storage class availability
- [ ] Create monitoring namespace
- [ ] Apply storage configurations
- [ ] Deploy Prometheus stack
- [ ] Deploy Grafana
- [ ] Configure alerting (optional)
- [ ] Import dashboards
- [ ] Verify metrics collection

### Deployment Order
```bash
# 1. Create namespace
kubectl create namespace monitoring
kubectl config set-context --current --namespace=monitoring


# 2. Create storage resources
kubectl apply -f storage/monitoring-storage.yaml

# 3. Deploy Prometheus stack in order
kubectl apply -f prometheus/prometheus-rbac.yaml
kubectl apply -f prometheus/rules/
kubectl apply -f prometheus/prometheus-configmap.yaml
kubectl apply -f prometheus/prometheus-deployment.yaml
kubectl apply -f prometheus/prometheus-service.yaml

# 4. Deploy Grafana
kubectl apply -f grafana/

# 5. Verify all deployments
kubectl get all -n monitoring
```

### Verification Steps
1. Check PVC status:
   ```bash
   kubectl get pvc -n monitoring
   ```

2. Verify pod status:
   ```bash
   kubectl get pods -n monitoring
   kubectl describe pods -n monitoring
   ```

3. Check service endpoints:
   ```bash
   kubectl get endpoints -n monitoring
   ```

4. Test service access:
   ```bash
   # Get node IP
   kubectl get nodes -o wide
   
   # Test endpoints
   curl http://<node-ip>:30090 # Prometheus
   curl http://<node-ip>:30300 # Grafana
   ```

### Post-Installation Tasks
1. Change default Grafana password
2. Import essential dashboards
3. Configure alerting rules
4. Test metric collection
5. Setup backup schedules

## Installation Guide

### 1. Create Storage Resources

```bash
# Create persistent volume claims
kubectl apply -f storage/monitoring-storage.yaml
```

### 2. Create Namespace and RBAC

```bash
# Create monitoring namespace
kubectl create namespace monitoring
kubectl config set-context --current --namespace=monitoring

# Apply RBAC rules
kubectl apply -f prometheus/prometheus-rbac.yaml
```

### 3. Deploy Prometheus

```bash
# Deploy rules first
kubectl apply -f prometheus/rules/

# Deploy Prometheus components
kubectl apply -f prometheus/prometheus-configmap.yaml
kubectl apply -f prometheus/prometheus-deployment.yaml
kubectl apply -f prometheus/prometheus-service.yaml
```

### 4. Deploy Grafana

```bash
kubectl apply -f grafana/
```

### 5. Deploy AlertManager

```bash
kubectl apply -f alertmanager/
```

## Accessing the Services

- Prometheus: `http://<node-ip>:30090`
- Grafana: `http://<node-ip>:30300`
  - Default credentials: admin/admin
  - Change password on first login
- AlertManager: `http://<node-ip>:30093`

## Configuration Guide

### Prometheus Configuration

- Update scrape configs in `prometheus-configmap.yaml`
- Recording rules in `prometheus/rules/`
- Alert rules in `prometheus/alerting-rules/`

### Grafana Setup

1. Add Prometheus data source:
   - URL: `http://prometheus:9090`
   - Access: Server (default)

2. Import dashboards:
   - Node Exporter: 1860
   - Kubernetes cluster: 315
   - Pod metrics: 6417

### AlertManager Configuration

Edit `alertmanager/alertmanager-configmap.yaml` for:
- Email notifications
- Slack integration
- PagerDuty integration
- Custom routing rules

## Monitoring Stack Features

1. **Metrics Collection**
   - Node metrics
   - Pod metrics
   - Service metrics
   - API server metrics

2. **Pre-configured Alerts**
   - Node health
   - Pod health
   - Storage warnings
   - Network issues

3. **Default Dashboards**
   - Cluster overview
   - Node resources
   - Pod resources
   - Network metrics

## Troubleshooting

Common issues and solutions:

1. **Prometheus Not Scraping**
   ```bash
   kubectl logs -n monitoring deploy/prometheus
   kubectl get ep -n monitoring
   ```

2. **Grafana Can't Connect**
   - Verify Prometheus service
   - Check data source configuration

3. **AlertManager Not Sending Alerts**
   - Verify smtp/slack configurations
   - Check AlertManager logs

### Storage Issues

1. **PVC Binding Failed**
   ```bash
   kubectl get pvc -n monitoring
   kubectl describe pvc prometheus-pvc -n monitoring
   ```

2. **Storage Performance Issues**
   ```bash
   kubectl top pod -n monitoring
   kubectl logs -n monitoring deploy/prometheus
   ```

## Maintenance

### Backup

```bash
# Backup Prometheus data
kubectl exec -n monitoring $(kubectl get pods -n monitoring -l app=prometheus -o jsonpath='{.items[0].metadata.name}') -- tar czf - /prometheus | cat > prometheus-backup-$(date +%Y%m%d).tar.gz

# Backup Grafana data
kubectl exec -n monitoring $(kubectl get pods -n monitoring -l app=grafana -o jsonpath='{.items[0].metadata.name}') -- tar czf - /var/lib/grafana | cat > grafana-backup-$(date +%Y%m%d).tar.gz
```

### Updates

```bash
# Update Prometheus
kubectl set image -n monitoring deployment/prometheus \
  prometheus=prom/prometheus:v2.45.0

# Update Grafana
kubectl set image -n monitoring deployment/grafana \
  grafana=grafana/grafana:9.5.3
```

## Storage Management

### Storage Best Practices

1. **Sizing Guidelines**
   - Prometheus: Calculate based on retention period and metrics volume
   - Grafana: Depends on number of dashboards and users

2. **Performance Considerations**
   - Use SSDs for better query performance
   - Consider using local storage for high-performance requirements
   - Monitor storage usage and set up alerts

3. **Retention Management**
   - Configure Prometheus retention period in deployment
   - Set up storage alerts (included in node-alerts.yaml)
   - Regular cleanup of unused data

## Best Practices

1. Use persistent storage for Prometheus
2. Configure retention policies
3. Implement alerting with redundancy
4. Regular backup of configurations
5. Monitor the monitoring stack itself

## Additional Resources

- [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
- [Grafana Documentation](https://grafana.com/docs/)
- [AlertManager Documentation](https://prometheus.io/docs/alerting/latest/alertmanager/)
