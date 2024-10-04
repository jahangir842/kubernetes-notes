Great! You have one dedicated Ubuntu machine for the **Kubernetes control plane** and two Windows systems with **WSL2 running Ubuntu** for worker nodes. This setup allows you to create a multi-node Kubernetes cluster. Here's a step-by-step guide for this mixed environment.

### Overview of Setup

- **Control Plane (Master Node)**: Your dedicated Ubuntu machine.
- **Worker Nodes**: Your Windows systems with WSL2 running Ubuntu.

### Step 1: Set Up Control Plane (Master Node)

#### 1.1. Update and Install Dependencies
Run the following commands on your **Ubuntu control plane** machine to install the necessary dependencies:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

#### 1.2. Install Docker
Docker is required for container runtime:

```bash
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

#### 1.3. Enable Kernel Modules and Sysctl Settings
```bash
sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system
```

#### 1.4. Disable Swap

Kubernetes requires that swap be disabled.

check if swap is enabled Using the `free` Command

The `free` command provides a summary of memory usage, including swap space.

If enable, disable with this command:
```bash
free -h
```
```bash
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```
verify again.
#### 1.5. Install kubeadm, kubelet, and kubectl
Add the Kubernetes APT repository and install the necessary components:

```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

#### 1.6. Initialize Kubernetes Control Plane
On the **Ubuntu control plane**, initialize the Kubernetes cluster:

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

This will output the necessary commands for you to set up `kubectl` and join worker nodes. Follow the instructions it provides, which typically include these steps:

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### 1.7. Install the Pod Network Add-On
To allow communication between your pods, install a network add-on like **Flannel**:

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

---

### Step 2: Prepare Worker Nodes (Windows with WSL2)

Now we need to configure the two Windows machines (running Ubuntu on WSL2) to act as Kubernetes worker nodes.

#### 2.1. Install WSL2 on Windows
Make sure WSL2 is installed on your Windows systems and that Ubuntu is running properly. If WSL2 is not installed, follow these steps:

1. Open **PowerShell** as Administrator and run:
   ```powershell
   wsl --install
   ```

2. Install **Ubuntu** from the **Microsoft Store**.

3. Launch Ubuntu from the Start Menu and complete the setup.

#### 2.2. Install Docker on WSL2 Ubuntu
Since Kubernetes requires a container runtime, install Docker on each WSL2 Ubuntu:

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
```

#### 2.3. Install kubeadm, kubelet, and kubectl
You need the same Kubernetes components on the worker nodes:

```bash
sudo apt update && sudo apt install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

#### 2.4. Disable Swap on WSL2
Even though WSL2 doesn’t use swap by default, run the command to disable it just in case:

```bash
sudo swapoff -a
```

#### 2.5. Configure WSL2 Networking (Optional)
By default, WSL2 instances may not be able to communicate with each other over the network. You may need to configure port forwarding from Windows to allow WSL2 Ubuntu instances to communicate with the master node. You can do this by forwarding traffic through Windows’ firewall using PowerShell.

For example:

```powershell
netsh interface portproxy add v4tov4 listenport=6443 listenaddress=<Your Windows IP> connectport=6443 connectaddress=<WSL2 IP>
```

Replace `<Your Windows IP>` and `<WSL2 IP>` with the actual addresses.

---

### Step 3: Join Worker Nodes to the Cluster

Once your worker nodes (WSL2 Ubuntu instances) are ready, join them to the cluster. From the **control plane**, the `kubeadm init` command will have output a join command. It looks something like this:

```bash
kubeadm join <MASTER_IP>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

Run this `kubeadm join` command on each **WSL2 Ubuntu worker node**.

Example:

```bash
sudo kubeadm join 192.168.1.100:6443 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890
```

Make sure to replace the `192.168.1.100` with the **IP address of your control plane node** and provide the correct `token` and `hash` values.

---

### Step 4: Verify the Cluster

Now that you’ve joined the worker nodes, you can verify the cluster from the **Ubuntu control plane**.

```bash
kubectl get nodes
```

You should see output listing all your nodes (the control plane and the two worker nodes from WSL2):

```bash
NAME              STATUS   ROLES    AGE   VERSION
control-plane     Ready    master   10m   v1.25.0
worker-node-1     Ready    <none>   3m    v1.25.0
worker-node-2     Ready    <none>   3m    v1.25.0
```

---

### Step 5: Deploy a Test Application

Now that your cluster is up and running, deploy a test application to confirm everything works. For example, deploy an NGINX server:

```bash
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=NodePort
```

Check the status:

```bash
kubectl get pods
kubectl get svc
```

You can access the NGINX application by navigating to the **Node IP and NodePort** in your browser:

```bash
http://<NODE_IP>:<NodePort>
```

---

### Next Steps

- **Scaling**: You can add more WSL2 worker nodes or even additional VMs to your setup.
- **Monitoring**: Set up **Prometheus** and **Grafana** for monitoring the cluster.
- **Storage**: Configure persistent storage with **NFS**, **Ceph**, or **Rook** for real-world use cases.

Let me know if you need further guidance on any part of the setup!
