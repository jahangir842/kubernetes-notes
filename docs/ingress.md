Below are some detailed notes about **Ingress** in Kubernetes, tailored as a general guide that fits your cluster with one master and two worker nodes. These notes build on your understanding of Services (like `ClusterIP` and `NodePort`) and connect to your context (e.g., managing MLflow or Prometheus). I’ll explain what Ingress is, how it works, and how to use it effectively.

---

### **Notes on Kubernetes Ingress**

#### **What is Ingress?**
- **Ingress** is a Kubernetes resource that manages external access to Services, typically HTTP/HTTPS traffic, by defining routing rules.
- It acts as a **Layer 7 (application layer)** load balancer, providing features like URL path-based routing, host-based routing, and TLS termination.
- Unlike `NodePort` or `LoadBalancer` Services (Layer 4), Ingress offers advanced traffic management without exposing every node or requiring an external IP per Service.

#### **Why Use Ingress?**
- Expose multiple Services (e.g., MLflow, Grafana) under a single external IP or domain.
- Enable features like:
  - **Path-based routing**: `/mlflow` to MLflow, `/grafana` to Grafana.
  - **Host-based routing**: `mlflow.example.com` vs. `grafana.example.com`.
  - **TLS/SSL**: Secure traffic with certificates.
- Reduce complexity compared to multiple `NodePort` Services or cloud load balancers.

#### **How Ingress Works**
- **Components**:
  - **Ingress Resource**: Defines routing rules (e.g., paths, hosts).
  - **Ingress Controller**: A pod (e.g., NGINX, Traefik) that implements the rules, running as a Deployment or DaemonSet.
  - **Service**: Backend Services (e.g., `ClusterIP`) that Ingress routes traffic to.
- **Flow**:
  1. External traffic hits the Ingress Controller (via a `NodePort`, `LoadBalancer`, or host network).
  2. The controller interprets the Ingress resource rules.
  3. Traffic is routed to the appropriate Service (and its pods).

#### **Prerequisites**
- An **Ingress Controller** must be deployed (Kubernetes doesn’t provide one by default).
- A **Service** (usually `ClusterIP`) for each app you want to expose.

---

### **Key Concepts and Features**

#### **1. Ingress Resource**
- Defines how traffic is routed to Services.
- **Example**:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: app-ingress
    namespace: mlflow
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /$2  # Optional: rewrite paths
  spec:
    rules:
    - host: example.com
      http:
        paths:
        - path: /mlflow(/|$)(.*)  # Matches /mlflow or /mlflow/anything
          pathType: Prefix
          backend:
            service:
              name: mlflow-service
              port:
                number: 5000
    - host: grafana.example.com
      http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: grafana-service
              port:
                number: 3000
  ```
  - **Explanation**:
    - `example.com/mlflow` → `mlflow-service:5000`.
    - `grafana.example.com/` → `grafana-service:3000`.

#### **2. Ingress Controller**
- A reverse proxy (e.g., NGINX, Traefik, HAProxy) that enforces Ingress rules.
- **Popular Options**:
  - **NGINX Ingress Controller**: Widely used, feature-rich.
  - **Traefik**: Simple, modern, auto-discovers Services.
- **Deployment**:
  - Install NGINX Ingress Controller:
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
    ```
  - Runs as a pod, exposed via `NodePort` or `LoadBalancer`.

#### **3. TLS/SSL Support**
- Secures traffic with certificates.
- **Example with TLS**:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: secure-ingress
    namespace: mlflow
  spec:
    tls:
    - hosts:
      - example.com
      secretName: tls-secret  # Stores certificate
    rules:
    - host: example.com
      http:
        paths:
        - path: /mlflow
          pathType: Prefix
          backend:
            service:
              name: mlflow-service
              port:
                number: 5000
  ```
  - **Create Secret**:
    ```bash
    kubectl create secret tls tls-secret --cert=tls.crt --key=tls.key -n mlflow
    ```
  - Access: `https://example.com/mlflow`.

#### **4. Path Types**
- **Exact**: Matches the exact path (e.g., `/mlflow` only).
- **Prefix**: Matches paths starting with the value (e.g., `/mlflow/*`).
- **ImplementationSpecific**: Controller-specific (e.g., regex in NGINX).

---

### **How to Use Ingress in Your Cluster**

#### **Step 1: Deploy an Ingress Controller**
- For bare-metal (your setup), use NGINX Ingress with `NodePort`:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
  ```
- Check:
  ```bash
  kubectl get pods -n ingress-nginx
  NAME                                        READY   STATUS    AGE
  ingress-nginx-controller-5d8f7c6b8f-xyz    1/1     Running   5m
  ```
- Exposes on a `NodePort` (e.g., 30080):
  ```bash
  kubectl get svc -n ingress-nginx
  NAME                       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
  ingress-nginx-controller   NodePort   10.96.123.45    <none>        80:30080/TCP,443:30443/TCP   5m
  ```

#### **Step 2: Create Backend Services**
- MLflow Service:
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
    - port: 5000
      targetPort: 5000
  ```

#### **Step 3: Define Ingress Rules**
- Simple Ingress:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: mlflow-ingress
    namespace: mlflow
  spec:
    rules:
    - http:
        paths:
        - path: /mlflow
          pathType: Prefix
          backend:
            service:
              name: mlflow-service
              port:
                number: 5000
  ```
  Apply:
  ```bash
  kubectl apply -f mlflow-ingress.yaml
  ```

#### **Step 4: Access the Service**
- **Internal Test**:
  ```bash
  kubectl exec -it <pod> -n mlflow -- curl http://<ingress-controller-ip>:30080/mlflow
  ```
- **External Access**:
  - Use a node’s IP (e.g., `worker1:192.168.1.101`):
    ```bash
    curl http://192.168.1.101:30080/mlflow
    ```
  - For a proper domain (e.g., `example.com`), configure DNS or `/etc/hosts` to point to a node IP.

#### **Step 5: Add TLS (Optional)**
- Generate a self-signed cert:
  ```bash
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=example.com"
  kubectl create secret tls tls-secret --cert=tls.crt --key=tls.key -n mlflow
  ```
- Update Ingress with `tls` section.

---

### **Key Points**
- **Ingress vs. Services**:
  - `ClusterIP`: Internal, no external access.
  - `NodePort`: Exposes on node IPs, basic external access.
  - `LoadBalancer`: External IP, cloud-dependent.
  - `Ingress`: Advanced routing (paths, hosts) over one entry point.
- **Your Cluster**:
  - Bare-metal lacks a native `LoadBalancer`, so Ingress with `NodePort` (or MetalLB) is ideal.
  - Expose MLflow (`mlflow-57f4984454-k5cjv`) via `/mlflow` and Prometheus via `/metrics`.
- **Scalability**: Add more rules for other Services (e.g., Grafana).

---

### **Troubleshooting**
- **Ingress Not Working**:
  - Check controller logs:
    ```bash
    kubectl logs -n ingress-nginx <controller-pod>
    ```
  - Verify Service exists:
    ```bash
    kubectl get svc mlflow-service -n mlflow
    ```
- **404 Errors**: Ensure path and Service port match.
- **DNS**: Update `/etc/hosts` for testing (e.g., `192.168.1.101 example.com`).

---

### **Conclusion**
Ingress provides a powerful way to manage external access in your cluster, consolidating traffic through a single controller (e.g., NGINX) with flexible routing and TLS. For your setup, it’s a step up from `NodePort`, ideal for exposing MLflow or Prometheus cleanly. Start with a basic Ingress for MLflow, then expand as needed.

Need help setting up an Ingress for your MLflow pod? Let me know!
