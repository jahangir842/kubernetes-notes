## **How to Reset a Kubernetes Worker Node**  

If you need to **reset a worker node** in your Kubernetes cluster, follow these steps carefully.

---

### **🛠 Step 1: Run `kubeadm reset`**
This command resets the node, but it **does not remove CNI configuration, iptables rules, or kubeconfig files**.  
Run the following:  
```bash
sudo kubeadm reset
```
When prompted, type **`y`** to proceed.

---

### **🗑 Step 2: Remove CNI Configuration**
Since the reset **does not clean CNI**, remove the CNI network configurations manually:  
```bash
sudo rm -rf /etc/cni/net.d
```

---

### **🔄 Step 3: Reset iptables and IPVS (if applicable)**
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

### **📂 Step 4: Remove Kubeconfig Files**
```bash
rm -rf $HOME/.kube/config
```

---

### **🔄 Step 5: Restart Required Services**
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

### **🔗 Step 6: Rejoin the Cluster**
To rejoin the node, use the **join command** from the control plane:

```bash
sudo kubeadm join <master-ip>:6443 --token <your-token> --discovery-token-ca-cert-hash sha256:<your-ca-hash>
```
If you don’t have the command, retrieve it from the control plane node:
```bash
kubeadm token create --print-join-command
```

---

### **✅ Step 7: Verify Node Status**
Once rejoined, check if the node is in a **Ready** state:  
```bash
kubectl get nodes
```

---

💡 **That's it!** Your node has been reset and rejoined to the cluster. 🚀  
Let me know if you run into any issues!
