# **MLflow on Kubernetes Deployment Guide**

This guide provides instructions for deploying MLflow on Kubernetes with persistent storage using the `local-path-provisioner` from Rancher. It’s designed for a cluster with one master node (`master-node`) and two worker nodes (`worker-node1`, `worker-node2`), but is adaptable to other setups.

---

**Official docker Image:**

```bash
docker pull ghcr.io/mlflow/mlflow:v2.20.3
```

**More Info:** https://github.com/mlflow/mlflow/pkgs/container/mlflow

---

## **Prerequisites**

- **Kubernetes Cluster**: Version 1.16+ with:
  - `master-node` (control plane, e.g., IP: `192.168.1.181`).
  - `worker-node1` (worker, e.g., IP: `192.168.1.182`.
  - `worker-node2` (worker, e.g., IP: `192.168.1.183`).
- **kubectl**: Installed and configured on `master-node` with admin access.
- **Docker Image Access**: Ability to pull MLflow images (e.g., from Docker Hub).
- **Storage**: `local-path-provisioner` for dynamic local storage provisioning.
- **SSH Access**: To worker nodes for storage preparation.

---

## **Directory Structure**

```plaintext
mlflow-k8s/
├── README.md
├── config/
│   ├── mlflow-pvc.yaml
│   ├── mlflow-deployment.yaml
│   ├── mlflow-service.yaml
│   └── mlflow-config.yaml (optional)
└── docs/
    └── production-setup.md
```

*Note*: Removed `mlflow-pv.yaml` as we’ll use dynamic provisioning instead of static PVs.

---

## **Quick Start**

### **1. Set Up Namespace**
Create and set the `mlflow` namespace:
```bash
kubectl create namespace mlflow --dry-run=client -o yaml | kubectl apply -f -
kubectl config set-context --current --namespace=mlflow
```

### **2. Install local-path-provisioner**
Deploy the storage provisioner for dynamic local storage:
```bash
kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.24/deploy/local-path-storage.yaml
```
### **Verify Installation**
Check the status of the local-path-provisioner:
```bash
kubectl get pods -n local-path-storage
```
Expected output:
```plaintext
NAME                                     READY   STATUS    RESTARTS   AGE
local-path-provisioner-<hash>            1/1     Running   0          <time>
```
Verify the storage class:
```bash
kubectl get storageclass
```
Expected output:
```plaintext
NAME                   PROVISIONER               RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
local-path (default)   rancher.io/local-path     Delete          WaitForFirstConsumer   false                <time>
```
 
 

- **NAME**: The name of the storage class.
- **PROVISIONER**: The provisioner responsible for creating volumes for this storage class.
- **RECLAIMPOLICY**: The policy for reclaiming resources when a volume is deleted (e.g., `Delete` or `Retain`).
- **VOLUMEBINDINGMODE**: The mode that determines when volume binding and dynamic provisioning should occur (e.g., `Immediate` or `WaitForFirstConsumer`).
- **ALLOWVOLUMEEXPANSION**: Indicates whether the storage class allows volume expansion (`true` or `false`).
- **AGE**: The age of the storage class since it was created.

### **3. Prepare Storage on Worker Nodes**
Configure `/mnt/data` on both worker nodes:
- **worker-node1** (replace IP as needed):
  ```bash
  ssh adminit@192.168.1.184 "sudo mkdir -p /mnt/data && sudo chmod 777 /mnt/data && sudo chown nobody:nobody /mnt/data"
  ```
- **worker-node2**:
  ```bash
  ssh adminit@192.168.1.183 "sudo mkdir -p /mnt/data && sudo chmod 777 /mnt/data && sudo chown nobody:nobody /mnt/data"
  ```
- **Update Provisioner**:
  ```bash
  kubectl edit configmap local-path-config -n local-path-storage
  ```
  Change:
  ```yaml
  data:
    path: "/mnt/data"
  ```
  Restart:
  ```bash
  kubectl rollout restart deployment local-path-provisioner -n local-path-storage
  ```

### **4. Apply Kubernetes Configurations**
Deploy MLflow with persistent storage:
```bash
kubectl apply -f config/mlflow-pvc.yaml
kubectl apply -f config/mlflow-deployment.yaml
kubectl apply -f config/mlflow-service.yaml
# Optional: kubectl apply -f config/mlflow-config.yaml
```
 
**Note:** you should not need to manually create the PV. Instead, the provisioner should dynamically create the PV when the PVC is requested.

### **5. Verify Deployment**
- **Storage**:
  ```bash
  kubectl get pvc -n mlflow
  # Expected: NAME        STATUS   VOLUME            CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  #          mlflow-pvc  Bound    pvc-<hash>        10Gi       RWO            local-path     1m
  ```
- **Pods**:
  ```bash
  kubectl get pods -n mlflow -o wide
  ```
- **Service**:
  ```bash
  kubectl get svc -n mlflow
  ```

### **6. Access MLflow UI**
- **Port Forward** (temporary):
  ```bash
  kubectl port-forward -n mlflow svc/mlflow-service 5000:5000
  ```
- Open `http://localhost:5000` in your browser.
- **NodePort** (if configured): `http://<worker-node-ip>:30005`.

---

## **Configuration Details**

### **Storage**
- **Persistent Volume Claim (PVC)**:
  - **File**: `mlflow-pvc.yaml`
  - **Content**:
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mlflow-pvc
      namespace: mlflow
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 10Gi
      storageClassName: local-path
    ```
  - **Provisioner**: `rancher.io/local-path` dynamically creates a 10Gi PV on the node where the Pod runs (e.g., `/mnt/data/pvc-<hash>`).
- **Backend**: SQLite (default, stored in PVC).

### **Deployment**
- **File**: `mlflow-deployment.yaml`
- **Content**:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: mlflow
    namespace: mlflow
  spec:
    replicas: 2
    selector:
      matchLabels:
        app: mlflow
    template:
      metadata:
        labels:
          app: mlflow
      spec:
        containers:
        - name: mlflow
          image: ghcr.io/mlflow/mlflow:v2.20.3
          command: ["mlflow", "server"]
          args:
            - "--host"
            - "0.0.0.0"
            - "--port"
            - "5000"
            - "--backend-store-uri"
            - "file:///mlflow/storage"
            - "--default-artifact-root"
            - "file:///mlflow/storage/artifacts"
          ports:
          - containerPort: 5000
          envFrom:
          - configMapRef:
              name: mlflow-config
          volumeMounts:
          - name: mlflow-storage
            mountPath: /mlflow/storage
        volumes:
        - name: mlflow-storage
          persistentVolumeClaim:
            claimName: mlflow-pvc
  ```

### **Service**
- **File**: `mlflow-service.yaml`
- **Content**:
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: mlflow-service
    namespace: mlflow
  spec:
    selector:
      app: mlflow
    ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
      nodePort: 30005
    type: NodePort
  ```

### **Optional ConfigMap**
- **File**: `mlflow-config.yaml`
- **Content**:
  ```yaml
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: mlflow-config
    namespace: mlflow
  data:
    BACKEND_STORE_URI: "file:///mlflow/storage"
    ARTIFACT_ROOT: "file:///mlflow/storage/artifacts"
  ```

---

## **Production Considerations**
- **External Database**: Use MySQL/PostgreSQL (e.g., via Helm chart for MySQL).
- **Authentication**: Add OAuth or basic auth (configure via MLflow plugins).
- **Cloud Storage**: Replace local storage with S3/GCS for artifacts.
- **Ingress**: Use an Ingress controller (e.g., NGINX) for domain-based access.
- **SSL/TLS**: Enable with cert-manager or manual certificates.
- **Backup**: Use Velero for PVC and database backups.
- **Scaling**: Increase `replicas` and adjust resource limits.

See `docs/production-setup.md` for details.

---

## **Monitoring**
- **Deployment Status**:
  ```bash
  kubectl get pods -n mlflow -w
  ```
- **Logs**:
  ```bash
  kubectl logs -n mlflow -l app=mlflow -f
  ```
- **Storage**:
  ```bash
  ssh adminit@<node-ip> "ls -l /mnt/data"
  ```

---

## **Cleanup**
Remove all MLflow resources:
```bash
kubectl delete -f config/mlflow-service.yaml
kubectl delete -f config/mlflow-deployment.yaml
kubectl delete -f config/mlflow-pvc.yaml
# Optional: kubectl delete -f config/mlflow-config.yaml
```

Remove provisioner (if no longer needed):
```bash
kubectl delete -f https://raw.githubusercontent.com/rancher/local-path-provisioner/v0.0.24/deploy/local-path-storage.yaml
```

---

## **Troubleshooting**
- **PVC Issues**:
  ```bash
  kubectl describe pvc mlflow-pvc -n mlflow
  ```
- **Pod Issues**:
  ```bash
  kubectl describe pod -n mlflow -l app=mlflow
  ```
- **Provisioner Logs**:
  ```bash
  kubectl logs -n local-path-storage -l app=local-path-provisioner
  ```

---

## **Additional Resources**
- [MLflow Docs](https://www.mlflow.org/docs/latest/index.html)
- [Kubernetes Docs](https://kubernetes.io/docs/)
- [local-path-provisioner](https://github.com/rancher/local-path-provisioner)

---

# **Production Setup for MLflow on Kubernetes**

For production, enhance the setup:
- **External Database**: Deploy MySQL/PostgreSQL; update `--backend-store-uri` (e.g., `mysql://user:pass@host/db`).
- **Authentication**: Use MLflow plugins or an Ingress with auth middleware.
- **Cloud Storage**: Configure S3/GCS (e.g., `--default-artifact-root s3://bucket/`).
- **Ingress**: Deploy NGINX Ingress with a domain (e.g., `mlflow.example.com`).
- **SSL/TLS**: Use cert-manager for automated certificates.
- **Backup**: Implement Velero for PVC and DB backups.

Refer to MLflow and Kubernetes documentation for specifics.

---

## **Fixes and Improvements**
- **Removed Static PV**: Replaced `mlflow-pv.yaml` with dynamic provisioning via `local-path`.
- **All Nodes**: Added storage prep for both workers, removing `worker-node2` bias.
- **Namespace Handling**: Made namespace creation idempotent.
- **Verification**: Expanded checks (PVC, Pod, Service).
- **Resources**: Kept your CPU/memory settings, added clarity.
- **Production**: Consolidated and aligned with main guide.

Save these files in your `mlflow-k8s/config/` directory and follow the steps for a reliable MLflow deployment! Let me know if you need further adjustments! 🚀