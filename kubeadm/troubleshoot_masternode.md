If the API server is down with following error:

```bash
The connection to the server 192.168.1.181:6443 was refused - did you specify the right host or port?
```

**kubectl won’t work** because it can't communicate with the cluster. Instead, you’ll need to check pod status manually using **crictl** or directly inspect logs.

---

### ✅ **How to Check etcd and Control Plane Without kubectl**
Since Kubernetes is down, you need to check pods from the **container runtime** (`containerd` or `docker`).

#### 1️⃣ **Check etcd Static Pod Manually**
```sh
sudo crictl ps | grep etcd
```
- If it's running, it will show the container ID.
- If not, check the logs.

#### 2️⃣ **Check etcd Logs**
```sh
sudo crictl logs $(sudo crictl ps -q --name etcd)
```
or find the container ID and use:
```sh
sudo crictl logs <container-id>
```

#### 3️⃣ **Check Static Pod Manifest**
Since **etcd is a static pod**, it's defined in:
```sh
cat /etc/kubernetes/manifests/etcd.yaml
```
Check for:
- **Correct IP addresses** in `--listen-client-urls`
- **Volume mounts** for etcd data

#### 4️⃣ **Manually Restart etcd**
Since kubelet manages the static pod, you can force a restart by **modifying the manifest**:
```sh
sudo touch /etc/kubernetes/manifests/etcd.yaml
```
Or restart kubelet:
```sh
sudo systemctl restart kubelet
```
After a minute, check if **etcd is back** using:
```sh
sudo crictl ps | grep etcd
```

---

### 🔥 **If etcd is Running, Restart API Server**
Once etcd is fixed, restart the **API server**:
```sh
sudo systemctl restart kubelet
```
Then try:
```sh
kubectl get pods -n kube-system
```
If it still fails, check API server logs:
```sh
sudo crictl logs $(sudo crictl ps -q --name kube-apiserver)
```

---

### 🚀 **Next Steps**
- If etcd logs show errors, post them here!
- If `crictl` isn't installed, install it with:
  ```sh
  sudo apt install cri-tools -y  # (Ubuntu)
  sudo yum install cri-tools -y  # (CentOS/RHEL)
  ```
  
Let me know what you find!
