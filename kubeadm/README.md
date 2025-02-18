That sounds like a solid setup for a Kubernetes cluster on VirtualBox using AlmaLinux. Here's how we can structure this guide:

---

## **Architecture Overview**
You will set up a Kubernetes cluster using `kubeadm` with the following architecture:

- **Host Machine:** Ubuntu (High-End System)
- **Virtual Machines:**  
  - **1 Control Plane Node (Master)**
  - **2 Worker Nodes**
- **Operating System on VMs:** AlmaLinux 9
- **Networking:** Flannel (or Calico for network policies)
- **Container Runtime:** Containerd
- **Pod Network CIDR:** `192.168.1.0/16`
- **Kubernetes Version:** Latest stable

---

## **Step-by-Step Guide to Deploy Kubernetes on AlmaLinux using kubeadm**

### **Step 1: Install VirtualBox and Create Virtual Machines**
#### **1.1 Install VirtualBox (if not installed)**
If VirtualBox is not installed, run:
```bash
sudo apt update
sudo apt install virtualbox virtualbox-ext-pack -y
```

#### **1.2 Create Three Virtual Machines**
1. Open VirtualBox and create **three VMs** with the following specs:
   - **VM Name:** `master-node`, `worker-node1`, `worker-node2`
   - **OS:** AlmaLinux 9
   - **CPU:** At least 2 vCPUs
   - **RAM:** 4GB minimum (8GB recommended)
   - **Storage:** 30GB (Dynamically allocated)
   - **Network:** **Bridged Adapter** (or Host-Only Adapter for local testing)

2. **Attach ISO & Install AlmaLinux 9** on all VMs.

3. **Set Hostnames & Static IPs**  
   Modify `/etc/hostname` on each VM:
   ```bash
   echo "master-node" | sudo tee /etc/hostname
   ```

   Set static IP addresses in [configure_static_ip_in_RHEL_based:](https://github.com/jahangir842/linux-notes/blob/main/networking/configure_static_ip_in_RHEL_based_new.md)
   ```
   BOOTPROTO=static
   IPADDR=192.168.56.100
   NETMASK=255.255.255.0
   GATEWAY=192.168.56.1
   DNS1=8.8.8.8
   ```

4. **Disable Swap on all nodes:**
   ```bash
   sudo swapoff -a
   sudo sed -i '/swap/d' /etc/fstab
   ```

---

### **Step 2: Install Required Dependencies**
Perform the following steps **on all three nodes**:

1. **Update System**
   ```bash
   sudo dnf update -y
   ```

2. **Set SELinux to Permissive Mode**
   ```bash
   sudo setenforce 0
   sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
   ```

3. **Enable IP Forwarding**
   ```bash
   cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
   net.bridge.bridge-nf-call-iptables  = 1
   net.bridge.bridge-nf-call-ip6tables = 1
   net.ipv4.ip_forward                 = 1
   EOF
   sudo sysctl --system
   ```

4. **Install Container Runtime (containerd)**
   ```bash
   sudo dnf install -y containerd
   sudo mkdir -p /etc/containerd
   containerd config default | sudo tee /etc/containerd/config.toml
   sudo systemctl restart containerd
   sudo systemctl enable containerd
   ```

---

### **Step 3: Install Kubernetes Components**
1. **Add Kubernetes Repository**
   ```bash
   cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
   [kubernetes]
   name=Kubernetes
   baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
   enabled=1
   gpgcheck=1
   repo_gpgcheck=1
   gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
   EOF
   ```

2. **Install Kubernetes Components**
   ```bash
   sudo dnf install -y kubeadm kubelet kubectl
   sudo systemctl enable kubelet
   ```

---

### **Step 4: Initialize the Kubernetes Control Plane**
**Run this only on the `master-node`:**
```bash
sudo kubeadm init --pod-network-cidr=192.168.1.0/16
```

**After initialization, configure `kubectl`:**
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

### **Step 5: Set Up Networking (Flannel)**
```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

---

### **Step 6: Join Worker Nodes to the Cluster**
On `worker-node1` and `worker-node2`, run the join command provided by `kubeadm init`.  
If you lost it, get the command from the master node:
```bash
kubeadm token create --print-join-command
```
Run the output command on each worker node.

---

### **Step 7: Verify the Cluster**
1. On the master node, check nodes:
   ```bash
   kubectl get nodes
   ```

2. Check pods:
   ```bash
   kubectl get pods -A
   ```

---

## **Summary**
- Installed VirtualBox and created 3 VMs.
- Configured AlmaLinux with static IPs and disabled swap.
- Installed `containerd`, `kubeadm`, `kubectl`, and `kubelet`.
- Initialized Kubernetes on the master node.
- Deployed a Flannel network and joined worker nodes.

Now you have a **fully functional Kubernetes cluster** running on AlmaLinux VMs in VirtualBox! 🚀
