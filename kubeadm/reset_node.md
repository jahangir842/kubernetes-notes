## **How to Reset a Kubernetes Worker Node**  

If you need to **reset a worker node** in your Kubernetes cluster, follow these steps carefully.

---

#### **Step 1: Verify Node Status (On Control Plane)**
After the node joins, check its status:
```bash
kubectl get nodes
```
It should show as **Ready**.

---

#### **Step 2: Remove the Node from the Cluster (On Control Plane)**
Log into the **control plane node** and run:  
```bash
kubectl delete node worker-node1
```

- Replace "worker-node1" with the name of node that needs to be deleted.

---

### **🛠 Step 3: Run `kubeadm reset`** (On Worker Node)
This command resets the node, but it **does not remove CNI configuration, iptables rules, or kubeconfig files**.  
Run the following:  
```bash
sudo kubeadm reset
```
When prompted, type **`y`** to proceed.

---

### **🗑 Step 4: Remove CNI Configuration**
Since the reset **does not clean CNI**, remove the CNI network configurations manually:  
```bash
sudo rm -rf /etc/cni/net.d
```

---

### **🔄 Step 5: Reset iptables and IPVS (if applicable)**
Kubernetes modifies firewall rules, so you need to reset them.

#### **Flush iptables:**
```bash
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
```

#### **Clear IPVS rules (if used):**
```bash
sudo ipvsadm --clear
```
(If `ipvsadm` is not installed, you can skip this step.)

---

### **📂 Step 6: Remove Kubeconfig Files**
```bash
rm -rf $HOME/.kube/config
```

---

### **🔄 Step 7: Restart Required Services**
Restart container runtime and `kubelet`:

- **If using Docker:**
  ```bash
  sudo systemctl restart docker
  ```
- **If using Containerd:**
  ```bash
  sudo systemctl restart containerd
  ```
- **Restart `kubelet`:**
  ```bash
  sudo systemctl restart kubelet
  ```

---

### **🔗 Step 8: Rejoin the Cluster**
To rejoin the node, use the **join command** from the control plane:

```bash
sudo kubeadm join <master-ip>:6443 --token <your-token> --discovery-token-ca-cert-hash sha256:<your-ca-hash>
```
If you don’t have the command, retrieve it from the control plane node:
```bash
kubeadm token create --print-join-command
```

---

### **✅ Step 9: Verify Node Status**
Once rejoined, check if the node is in a **Ready** state:  
```bash
kubectl get nodes
```

---

💡 **That's it!** Your node has been reset and rejoined to the cluster. 🚀  
Let me know if you run into any issues!
