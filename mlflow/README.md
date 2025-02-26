# MLflow on Kubernetes Deployment Guide

This repository contains configuration files and instructions for deploying MLflow on Kubernetes.

## Prerequisites

- Kubernetes cluster (v1.16+)
- kubectl CLI tool
- Access to pull MLflow Docker image
- Storage provisioner for PersistentVolumeClaims

## Directory Structure

```plaintext
mlflow-k8s/
├── README.md
├── config/
│   ├── mlflow-config.yaml
│   ├── mlflow-pvc.yaml
│   ├── mlflow-deployment.yaml
│   ├── mlflow-service.yaml
│   └── mlflow-pv.yaml
└── docs/
    └── production-setup.md
```

## Quick Start

1. Create namespace for MLflow:
```bash
kubectl create namespace mlflow
kubectl config set-context --current --namespace=mlflow
```

2. Create PersistentVolume (PV):
```bash
kubectl apply -f config/mlflow-pv.yaml
```

3. Apply Kubernetes configurations:
```bash
kubectl apply -f config/mlflow-config.yaml
kubectl apply -f config/mlflow-pvc.yaml
kubectl apply -f config/mlflow-deployment.yaml
kubectl apply -f config/mlflow-service.yaml
```

4. Verify deployment:
```bash
kubectl get pods -n mlflow
kubectl get svc -n mlflow
```

5. Access MLflow UI:
- URL: `http://<node-ip>:30005`

## Configuration Details

### Storage
- Default artifact storage: Local PVC (10GB)
  - `mlflow-pv.yaml`: Defines the PersistentVolume for MLflow artifact storage.
  - `mlflow-pvc.yaml`: Defines the PersistentVolumeClaim for MLflow artifact storage.
- Database backend: SQLite (default)

### Resources
- CPU Request: 250m
- CPU Limit: 500m
- Memory Request: 512Mi
- Memory Limit: 1Gi

### Network
- Service Type: NodePort
- Port: 5000
- NodePort: 30005

## Production Considerations

For production deployments, consider:
- Using external database (MySQL/PostgreSQL)
- Implementing authentication
- Setting up cloud storage for artifacts
- Configuring Ingress
- Enabling SSL/TLS
- Implementing backup strategy

## Monitoring

Check deployment status:
```bash
kubectl get pods -n mlflow -w
```

View logs:
```bash
kubectl logs -l app=mlflow -n mlflow -f
```

## Cleanup

Remove all MLflow resources:
```bash
kubectl delete namespace mlflow
```

## Additional Resources

- [MLflow Documentation](https://www.mlflow.org/docs/latest/index.html)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [MLflow Docker Image](https://github.com/mlflow/mlflow/pkgs/container/mlflow)

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.



---

# Production Setup for MLflow on Kubernetes

For production deployments, consider the following:

## External Database

Use an external database like MySQL or PostgreSQL instead of the default SQLite.

## Authentication

Implement authentication to secure access to the MLflow UI and API.

## Cloud Storage

Configure cloud storage (e.g., AWS S3, Google Cloud Storage) for storing artifacts.

## Ingress

Set up an Ingress resource to manage external access to the MLflow service.

## SSL/TLS

Enable SSL/TLS to encrypt data in transit.

## Backup Strategy

Implement a backup strategy for the database and artifacts to prevent data loss.

Refer to the official MLflow and Kubernetes documentation for detailed instructions on these configurations.