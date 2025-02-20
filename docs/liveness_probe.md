### **What is `livenessProbe` in Kubernetes?**
A **`livenessProbe`** in Kubernetes is a way to check whether a container inside a Pod is still running and responsive. If the container becomes unresponsive or hangs, Kubernetes automatically restarts it to maintain application availability.

---

### **Why Use `livenessProbe`?**
- Prevents stuck or frozen containers.
- Ensures high availability of applications.
- Helps recover from unexpected application failures.
- Reduces manual intervention for unhealthy pods.

---

### **Types of `livenessProbe`**
Kubernetes provides three types of `livenessProbe` checks:

1. **HTTP Request Probe (`httpGet`)**
   - Sends an HTTP request to the container.
   - If the response is successful (HTTP 2xx or 3xx), the container is healthy.
   - If it fails, Kubernetes restarts the container.

   **Example:**
   ```yaml
   livenessProbe:
     httpGet:
       path: /health
       port: 8080
     initialDelaySeconds: 3
     periodSeconds: 5
   ```
   - **`path: /health`** → Endpoint checked for health.
   - **`port: 8080`** → Port used for the request.
   - **`initialDelaySeconds: 3`** → Wait 3 seconds before first check.
   - **`periodSeconds: 5`** → Run the check every 5 seconds.

---

2. **Command Probe (`exec`)**
   - Runs a command inside the container.
   - If the command exits with `0`, the container is healthy.
   - Any non-zero exit code means failure, and Kubernetes restarts the container.

   **Example:**
   ```yaml
   livenessProbe:
     exec:
       command:
       - cat
       - /tmp/healthy
     initialDelaySeconds: 5
     periodSeconds: 10
   ```
   - Kubernetes will restart the container if `/tmp/healthy` does not exist.

---

3. **TCP Socket Probe (`tcpSocket`)**
   - Checks if a TCP connection to the container is successful.
   - If the port is open, the container is healthy.
   - If not, Kubernetes restarts the container.

   **Example:**
   ```yaml
   livenessProbe:
     tcpSocket:
       port: 8080
     initialDelaySeconds: 10
     periodSeconds: 15
   ```
   - If port `8080` is unreachable, Kubernetes restarts the container.

---

### **Common Parameters in `livenessProbe`**
| Parameter | Description |
|-----------|------------|
| `initialDelaySeconds` | Time to wait before the first probe (seconds). |
| `periodSeconds` | How often to perform the probe (seconds). |
| `timeoutSeconds` | Time to wait for a response before marking failure. |
| `failureThreshold` | Number of failed attempts before restart. |
| `successThreshold` | Number of successful checks needed to mark as healthy (default: 1). |

---

### **Example: Full Kubernetes Pod with `livenessProbe`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: my-container
    image: my-app-image
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
      initialDelaySeconds: 3
      periodSeconds: 5
```
- This will **restart** the container if `/health` endpoint does not respond correctly.

---

### **Difference Between `livenessProbe` and `readinessProbe`**
| Feature | `livenessProbe` | `readinessProbe` |
|---------|----------------|------------------|
| Purpose | Checks if the container is still running. | Checks if the container is ready to serve traffic. |
| Action on Failure | Kubernetes **restarts** the container. | Kubernetes **removes** the pod from the service. |
| Use Case | Prevents stuck or frozen applications. | Ensures traffic is only sent to healthy instances. |

---

### **Conclusion**
- Use `livenessProbe` to **detect unresponsive containers** and restart them.
- Choose between **HTTP, Command, or TCP probes** based on your application.
- Configure **initial delay and failure thresholds** to avoid unnecessary restarts.

Would you like help setting up `livenessProbe` for a specific application? 🚀
