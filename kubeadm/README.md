## Install Kubernetes Cluster with Kubeadm

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

### **1.2 Create Three Virtual Machines**
1. Open VirtualBox and create **three VMs** with the following specs:
   - **VM Name:** `master-node`, `worker-node1`, `worker-node2`
   - **OS:** AlmaLinux 9
   - **CPU:** At least 2 vCPUs
   - **RAM:** 4GB minimum (8GB recommended)
   - **Storage:** 30GB (Dynamically allocated)
   - **Network:** **Bridged Adapter** (or Host-Only Adapter for local testing)

**Attach ISO & Install AlmaLinux 9** on all VMs.

---

### **Set Hostnames & Static IPs**  
   Modify `/etc/hostname` on each VM:
   ```bash
   echo "master-node" | sudo tee /etc/hostname
   ```

---
### **enable **port 22** (SSH)**

To enable **port 22** (SSH) with **firewalld**, use the following guide:

https://github.com/jahangir842/linux-notes/blob/main/firewall/firewalld.md

---
### Static IPs

To Set static IP addresses, use the following guide:

https://github.com/jahangir842/linux-notes/blob/main/networking/configure_static_ip_in_RHEL_based_new.md

   ```
   Master-Node:   192.168.1.181
   Worker-Node 1: 192.168.1.182
   Worker-Node 2: 192.168.1.183

   NETMASK=255.255.255.0
   GATEWAY=192.168.1.1
   DNS=8.8.8.8
   ```

---

### **Disable Swap on all nodes:**

   ```bash
   sudo swapoff -a
   sudo sed -i '/swap/d' /etc/fstab
   ```

---

Here’s the **modified version** of Step 2 with **improvements**, explanations, and best practices.

---

## **Step 2: Install Required Dependencies**
Perform the following steps on **all three nodes** to set up a stable Kubernetes environment.


### **1. Update System Packages**
Keeping the system updated ensures that you have the latest security patches and bug fixes.
```bash
sudo dnf update -y
```

### **2. Configure SELinux (Set to Permissive Mode)**
Kubernetes does not work well with SELinux in **Enforcing** mode by default, so we set it to **Permissive**.

#### **Temporarily Disable SELinux (Immediate Effect)**
```bash
sudo setenforce 0
```
- This command **temporarily** sets SELinux to **Permissive mode** until the next reboot.

#### **Permanently Disable SELinux (After Reboot)**
```bash
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
```
- This modifies `/etc/selinux/config` to ensure SELinux remains **Permissive** even after a reboot.

### **3. Enable IP Forwarding**
IP forwarding is essential for Kubernetes networking to function correctly.

#### **Create a Configuration File**
```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
```
- **`net.bridge.bridge-nf-call-iptables = 1`** → Ensures traffic passes through `iptables` rules for filtering.
- **`net.bridge.bridge-nf-call-ip6tables = 1`** → Same as above but for IPv6.
- **`net.ipv4.ip_forward = 1`** → Enables packet forwarding for Kubernetes networking.

#### **Apply the Changes Immediately**
```bash
sudo sysctl --system
```
- This reloads system kernel parameters from all config files (`/etc/sysctl.d/`).

### **4. Install Container Runtime (containerd)**
Kubernetes requires a **container runtime** to run its workloads. We will use **containerd**.

#### **Install containerd**

**Official Link:** https://docs.docker.com/engine/install/centos/

**Note:** The containerd is provided to linux package managers from Docker.

```bash
sudo dnf install -y containerd
```
- Installs the **container runtime**.

#### **Configure containerd**
```bash
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```
- Creates the necessary **configuration directory** (`/etc/containerd`).
- Generates and saves the default **containerd configuration**.

#### **Restart and Enable containerd**
```bash
sudo systemctl restart containerd
sudo systemctl enable containerd
```
- **Restart** containerd to apply the configuration.
- **Enable** it to start automatically at boot.

---

### **Step 3: Install Kubernetes Components**

- **Install Kubeadm:** https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- **Creating a cluster with kubeadm:** https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

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

2. **Enable CRI Plugin**

Edit the following config file of containerd:

```bash
sudo nano /etc/containerd/config.toml
```

Verify the following plugin is not disabled.

```bash
#disabled_plugins = ["cri"]
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
