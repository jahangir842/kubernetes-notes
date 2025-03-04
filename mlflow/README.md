# MLflow on Kubernetes

This setup provides an MLflow tracking server with PostgreSQL backend running on Kubernetes.

## Prerequisites

- Kubernetes cluster
- kubectl configured
- MLflow image (mlflow-with-psycopg2:v2.20.3) available in your registry

## Deployment Steps

1. Create and activate namespace:
```bash
kubectl create namespace mlflow
kubectl config set-context --current --namespace=mlflow

# Verify active namespace
kubectl config get-contexts
# The active context should show mlflow as the namespace
```

2. Create storage:
```bash
kubectl apply -f k8s/postgres-pv-pvc.yaml
kubectl apply -f k8s/mlflow-pv-pvc.yaml
```

3. Create secrets and deployments:
```bash
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/postgres.yaml
kubectl apply -f k8s/mlflow.yaml
```

## Accessing MLflow

MLflow UI will be available at: `http://<node-ip>:30500`

## Connection Details

- MLflow UI: http://<node-ip>:30500
- PostgreSQL (internal):
  - Host: postgres
  - Port: 5432
  - Database: mlflowdb
  - Username: admin
  - Password: pakistan

## Environment Variables

To connect to this MLflow server in your ML projects:

```bash
export MLFLOW_TRACKING_URI=http://<node-ip>:30500
```

## Useful Commands

Check active namespace:
```bash
kubectl config view --minify | grep namespace
```

Check deployment status:
```bash
kubectl get all
# Note: After setting active namespace, you don't need -n mlflow flag
```

View logs:
```bash
kubectl logs -f deployment/mlflow
kubectl logs -f deployment/postgres
```

## Cleanup

To remove all resources:
```bash
kubectl delete namespace mlflow
```

## Troubleshooting

Test PostgreSQL connectivity:
```bash
# Get Postgres pod name
export PG_POD=$(kubectl get pods -l app=postgres -o jsonpath='{.items[0].metadata.name}')

# List databases
kubectl exec -it $PG_POD -- psql -U admin -d mlflowdb -c "\l"

# Test connection from MLflow pod
export MLFLOW_POD=$(kubectl get pods -l app=mlflow -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $MLFLOW_POD -- psql -U admin -h postgres -d mlflowdb -c "SELECT 1"

# Check MLflow logs
kubectl logs -f deployment/mlflow

# Check PostgreSQL logs
kubectl logs -f deployment/postgres
```
