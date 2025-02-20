Let's create a Kubernetes cluster from scratch using kubeadm, Calico, and containerd on 3 Alma Linux virtual machines. I'll provide a detailed, step-by-step guide. We'll set up one control plane node and two worker nodes.

### Prerequisites
- 3 Alma Linux VMs (I'll assume they're freshly installed)
- Minimum recommended specs per VM:
  - 2 CPUs
  - 2GB RAM
  - 20GB disk space
- Network connectivity between VMs
- Root or sudo access
- VM hostnames (example):
  - k8s-master (control plane)
  - k8s-worker1
  - k8s-worker2

### Step 1: Prepare All Nodes
Perform these steps on all 3 VMs.

1. **Update the System**
```bash
sudo dnf update -y
sudo reboot
```

2. **Set Hostnames**
On k8s-master:
```bash
sudo hostnamectl set-hostname k8s-master
```
On k8s-worker1:
```bash
sudo hostnamectl set-hostname k8s-worker1
```
On k8s-worker2:
```bash
sudo hostnamectl set-hostname k8s-worker2
```

3. **Configure /etc/hosts**
On all nodes, edit `/etc/hosts`:
```bash
sudo vi /etc/hosts
```
Add (replace with your actual IPs):
```
192.168.1.10    k8s-master
192.168.1.11    k8s-worker1
192.168.1.12    k8s-worker2
```

4. **Disable Swap**
```bash
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
```

5. **Disable SELinux**
```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
```

6. **Configure Firewall**
```bash
sudo firewall-cmd --permanent --add-port=6443/tcp    # Kubernetes API Server
sudo firewall-cmd --permanent --add-port=2379-2380/tcp  # etcd
sudo firewall-cmd --permanent --add-port=10250/tcp   # Kubelet
sudo firewall-cmd --permanent --add-port=10251/tcp   # Scheduler
sudo firewall-cmd --permanent --add-port=10252/tcp   # Controller
sudo firewall-cmd --permanent --add-port=179/tcp     # Calico BGP
sudo firewall-cmd --reload
```

7. **Load Kernel Modules**
```bash
sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
```

### Step 2: Install Containerd
On all nodes:

1. **Install Containerd**
```bash
sudo dnf install -y containerd
```

2. **Configure Containerd**
```bash
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```

3. **Edit Containerd Config**
Edit `/etc/containerd/config.toml`:
```bash
sudo vi /etc/containerd/config.toml
```
Find and modify:
```toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```

4. **Start Containerd**
```bash
sudo systemctl enable containerd
sudo systemctl start containerd
```

### Step 3: Install Kubernetes Components
On all nodes:

1. **Add Kubernetes Repository**
```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
EOF
```

2. **Install kubeadm, kubelet, kubectl**
```bash
sudo dnf install -y kubelet-1.28.7 kubeadm-1.28.7 kubectl-1.28.7
sudo systemctl enable kubelet
```

### Step 4: Initialize Control Plane (k8s-master only)
On k8s-master:

1. **Initialize Cluster**
```bash
sudo kubeadm init \
  --pod-network-cidr=192.168.0.0/16 \
  --cri-socket unix:///var/run/containerd/containerd.sock
```

2. **Set up kubectl**
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

3. **Save the Join Command**
The output will include a `kubeadm join` command. Save it for worker nodes (looks like):
```
kubeadm join 192.168.1.10:6443 --token ... --discovery-token-ca-cert-hash ...
```

### Step 5: Install Calico Network
On k8s-master:

1. **Apply Calico Manifest**
```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml
```

2. **Verify Cluster**
```bash
kubectl get nodes
kubectl get pods -n kube-system
```

### Step 6: Join Worker Nodes
On k8s-worker1 and k8s-worker2:

1. **Join Cluster**
Run the `kubeadm join` command from Step 4 (add `--cri-socket unix:///var/run/containerd/containerd.sock`):
```bash
sudo kubeadm join 192.168.1.10:6443 --token ... --discovery-token-ca-cert-hash ... --cri-socket unix:///var/run/containerd/containerd.sock
```

### Step 7: Verify Cluster
On k8s-master:

1. **Check Nodes**
```bash
kubectl get nodes -o wide
```

2. **Check Pods**
```bash
kubectl get pods -A
```

### Troubleshooting Tips
- If a node doesn't join, reset with `kubeadm reset` and retry
- Check logs: `journalctl -u kubelet` or `journalctl -u containerd`
- Verify containerd: `ctr version`
- Ensure all pods in kube-system are Running

### Optional: Test Deployment
On k8s-master:
```bash
kubectl create deployment nginx --image=nginx
kubectl scale deployment nginx --replicas=3
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl get pods,svc
```

Your cluster should now be running with:
- containerd as the container runtime
- Calico as the CNI
- 1 control plane and 2 worker nodes

Let me know if you encounter any issues or need clarification!
