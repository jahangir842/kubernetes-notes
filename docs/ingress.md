### **Setting Up Ingress in Kubernetes**

#### **Overview**
- **Purpose**: Use Ingress to manage external HTTP/HTTPS access to pods via routing rules (e.g., paths or domains), providing a single entry point for multiple services.
- **Benefits**: Offers path-based routing (e.g., `/app1`), host-based routing (e.g., `app1.example.com`), TLS termination, and load balancing, improving on `NodePort` or `LoadBalancer` Services.
- **Components**:
  - **Ingress Resource**: Defines routing rules.
  - **Ingress Controller**: Implements the rules (e.g., NGINX, Traefik).
  - **Backend Service**: Targets the pods (usually `ClusterIP`).

#### **Prerequisites**
- A running Kubernetes cluster with pods you want to expose.
- `kubectl` configured on your workstation to manage the cluster.
- Network access from your client (e.g., workstation) to cluster nodes.

---

#### **Steps to Set Up Ingress**

##### **Step 1: Verify Your Pod and Labels**
- Ensure the pod(s) you want to expose have consistent labels (e.g., `app: my-app`).
- Check pod details:
  ```bash
  kubectl get pods -n <namespace> -o wide
  ```
  - Example output:
    ```
    NAME            READY   STATUS    AGE    IP           NODE
    my-app-abc123   1/1     Running   1d     10.244.1.5   node1
    ```
- Confirm labels:
  ```bash
  kubectl get pod <pod-name> -n <namespace> -o jsonpath='{.metadata.labels}'
  ```
  - If labels are missing, edit the Deployment:
    ```bash
    kubectl edit deployment <deployment-name> -n <namespace>
    ```
    Add under `spec.template.metadata`:
    ```yaml
    labels:
      app: my-app
    ```

##### **Step 2: Create a ClusterIP Service**
- Define a Service to target your pod(s):
  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
    name: my-app-service
    namespace: <namespace>
  spec:
    selector:
      app: my-app  # Matches pod labels
    ports:
    - protocol: TCP
      port: 80  # Service port (adjust to your app’s port, e.g., 5000)
      targetPort: 80  # Pod port
    type: ClusterIP
  ```
- Save as `service.yaml` and apply:
  ```bash
  kubectl apply -f service.yaml
  ```
- Verify:
  ```bash
  kubectl get svc -n <namespace>
  ```
  - Example:
    ```
    NAME             TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
    my-app-service   ClusterIP   10.96.123.45   <none>        80/TCP    2m
    ```

##### **Step 3: Install an Ingress Controller**
- Use NGINX Ingress Controller (common for bare-metal or cloud):
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
  ```
  - For cloud providers, use provider-specific manifests (e.g., AWS, GKE).
- Check the controller:
  ```bash
  kubectl get pods -n ingress-nginx
  ```
  - Example:
    ```
    NAME                                        READY   STATUS    AGE
    ingress-nginx-controller-5d8f7c6b8f-xyz    1/1     Running   5m
    ```
- Note the exposed ports:
  ```bash
  kubectl get svc -n ingress-nginx
  ```
  - Example:
    ```
    NAME                       TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
    ingress-nginx-controller   NodePort   10.96.123.46    <none>        80:30080/TCP,443:30443/TCP   5m
    ```
  - `30080` (HTTP) and `30443` (HTTPS) are `NodePort` values for bare-metal.

##### **Step 4: Create an Ingress Resource**
- Define routing rules for your Service:
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: my-app-ingress
    namespace: <namespace>
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /  # Optional: rewrite path
  spec:
    rules:
    - http:
        paths:
        - path: /my-app
          pathType: Prefix
          backend:
            service:
              name: my-app-service
              port:
                number: 80  # Match Service port
  ```
- Save as `ingress.yaml` and apply:
  ```bash
  kubectl apply -f ingress.yaml
  ```
- **Explanation**:
  - `/my-app` routes to `my-app-service:80`.
  - `rewrite-target: /` strips `/my-app` from the request (adjust based on your app’s needs).

##### **Step 5: Test Access**
- **Internal Test**:
  - From a pod:
    ```bash
    kubectl exec -it <other-pod> -n <namespace> -- curl http://my-app-service:80
    ```
    - Confirms Service connectivity.
- **External Test**:
  - Use a node IP and `NodePort`:
    ```bash
    curl http://<node-ip>:30080/my-app
    ```
    - Example: `http://192.168.1.101:30080/my-app`.
  - If using a `LoadBalancer` controller instead, check:
    ```bash
    kubectl get ingress -n <namespace>
    ```
    - Look for an `ADDRESS` (external IP).

##### **Step 6: Optional - Add Domain and TLS**
- **Domain**:
  - For testing, edit `/etc/hosts`:
    ```
    <node-ip> my-app.example.com
    ```
  - Update Ingress:
    ```yaml
    spec:
      rules:
      - host: my-app.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
    ```
  - Apply:
    ```bash
    kubectl apply -f ingress.yaml
    ```
  - Test:
    ```bash
    curl http://my-app.example.com:30080
    ```

- **TLS**:
  - Create a self-signed certificate:
    ```bash
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=my-app.example.com"
    kubectl create secret tls my-app-tls --cert=tls.crt --key=tls.key -n <namespace>
    ```
  - Update Ingress:
    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: my-app-ingress
      namespace: <namespace>
    spec:
      tls:
      - hosts:
        - my-app.example.com
        secretName: my-app-tls
      rules:
      - host: my-app.example.com
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app-service
                port:
                  number: 80
    ```
  - Apply and test:
    ```bash
    curl --insecure https://my-app.example.com:30443
    ```

---

#### **Troubleshooting**
- **404 or No Response**:
  - Check Ingress:
    ```bash
    kubectl describe ingress my-app-ingress -n <namespace>
    ```
  - Inspect controller logs:
    ```bash
    kubectl logs -n ingress-nginx <ingress-pod>
    ```
- **Service Issues**:
  - Verify endpoints:
    ```bash
    kubectl get endpoints my-app-service -n <namespace>
    ```
    - Should list pod IPs (e.g., `10.244.1.5:80`).
- **Firewall**:
  - Ensure node ports (e.g., `30080`, `30443`) are open:
    ```bash
    sudo firewall-cmd --add-port=30080/tcp --permanent
    sudo firewall-cmd --reload
    ```

---

#### **Key Notes**
- **Controller Choice**: NGINX is common, but Traefik or HAProxy work too (adjust manifests).
- **Bare-Metal**: Use `NodePort` or MetalLB for external access; cloud clusters can use `LoadBalancer`.
- **Scalability**: Add more paths (e.g., `/app2`) or hosts to the same Ingress for multiple apps.
- **Path Rewrites**: Use annotations (e.g., `rewrite-target`) if your app expects a different root path.

---

#### **Conclusion**
This guide sets up Ingress to expose any pod via a single entry point, enhancing over `NodePort` or `LoadBalancer` with routing and TLS. Deploy a controller, create a Service, define an Ingress, and test access—adapt ports and paths to your app (e.g., 5000 for MLflow). It’s reusable for any namespace or pod in your cluster.

Let me know if you need a specific tweak or another example!
