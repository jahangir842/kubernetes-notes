### Minikube

**Geting Started:** https://minikube.sigs.k8s.io/docs/start/

**Official Docs:** https://minikube.sigs.k8s.io/docs/

minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment, and Kubernetes is a single command away: minikube start

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```


### Start Minikube:

```
minikube start
```



### If Fails to Start:

If minikube fails to start, see the drivers page for help setting up a compatible container or virtual-machine manager.

(https://minikube.sigs.k8s.io/docs/drivers/)

### Interact with your cluster






### How to Install and Use Minikube in Ubuntu

Minikube is a tool that allows you to run a single-node Kubernetes cluster on your local machine. It’s an excellent tool for development and testing. Here's a step-by-step guide to install and use Minikube on Ubuntu.

### 1. **System Requirements**
Before installing Minikube, ensure your system meets the following requirements:
- Ubuntu 18.04 or newer.
- At least 2 GB of free memory.
- 2 CPUs or more.
- Virtualization support enabled in your BIOS (if using a virtual driver like KVM).

### 2. **Prerequisites**
You'll need to install some required dependencies, including:
- Docker or another driver (e.g., KVM, VirtualBox).
- Kubernetes command-line tool (`kubectl`).

#### **Installing Dependencies**

1. **Install Docker (Preferred Driver)**
   Minikube works well with Docker as a driver. Install Docker using the following commands:

   ```bash
   sudo apt update
   sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   sudo apt update
   sudo apt install -y docker-ce
   ```

2. **Manage Docker as a Non-Root User** (optional but recommended)
   To run Docker without `sudo`, add your user to the Docker group:
   
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

3. **Install `kubectl`**
   Minikube requires `kubectl` to interact with the Kubernetes cluster:

   ```bash
   sudo apt update
   sudo apt install -y apt-transport-https
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
   echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
   sudo apt update
   sudo apt install -y kubectl
   ```

### 3. **Install Minikube**
Once you have Docker and `kubectl` set up, you can proceed to install Minikube:

1. Download and install Minikube:

   ```bash
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

2. Verify Minikube installation:

   ```bash
   minikube version
   ```

You should see the version output confirming Minikube is installed.

### 4. **Start Minikube**

Once Minikube is installed, you can start a Kubernetes cluster.

1. **Start Minikube** (with Docker driver):

   ```bash
   minikube start --driver=docker
   ```

it will show the following:
```
minikube v1.34.0 on Ubuntu 22.04
✨  Selected the docker driver. Other choices: none, ssh
📌  Using Docker driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.45 ...
💾  Downloading Kubernetes v1.31.0 preload ...
    > preloaded-images-k8s-v18-v1...:  326.69 MiB / 326.69 MiB  100.00% 3.25 Mi
    > gcr.io/k8s-minikube/kicbase...:  487.90 MiB / 487.90 MiB  100.00% 2.73 Mi
🔥  Creating docker container (CPUs=2, Memory=2200MB) ...
🐳  Preparing Kubernetes v1.31.0 on Docker 27.2.0 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
💡  kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

```
   

2. If you prefer to use a different driver like VirtualBox or KVM, install the necessary drivers and use the corresponding flag:

   - **VirtualBox**:
     ```bash
     sudo apt install -y virtualbox virtualbox-ext-pack
     minikube start --driver=virtualbox
     ```

   - **KVM** (requires KVM and libvirt installed):
     ```bash
     minikube start --driver=kvm2
     ```

3. After starting, check the status of Minikube:

   ```bash
   minikube status
   ```

### 5. **Use Minikube**

#### **Check Cluster Status**
You can check your Minikube Kubernetes cluster using `kubectl`:

```bash
kubectl get nodes
```

This will show the Minikube node running as part of the cluster.

#### **Open the Minikube Dashboard** (Optional)
Minikube provides a built-in Kubernetes dashboard to visualize cluster activities. You can access it by running:

```bash
minikube dashboard
```

#### **Deploy an Application on Minikube**
You can deploy a simple Kubernetes application on Minikube. Here’s an example of deploying a `nginx` web server:

1. Create a deployment:

   ```bash
   kubectl create deployment nginx --image=nginx
   ```

2. Expose the deployment as a service:

   ```bash
   kubectl expose deployment nginx --type=NodePort --port=80
   ```

3. Access the service using Minikube's service URL:

   ```bash
   minikube service nginx
   ```

This will open your default web browser and display the running nginx service.

### 6. **Stop and Delete Minikube Cluster**

To stop the Minikube cluster:

```bash
minikube stop
```

To delete the Minikube cluster:

```bash
minikube delete
```

### 7. **Additional Minikube Commands**

- **Check Minikube IP**:
  ```bash
  minikube ip
  ```

- **SSH into Minikube Node**:
  ```bash
  minikube ssh
  ```

- **View Logs**:
  ```bash
  minikube logs
  ```

### Troubleshooting

- If you encounter errors related to Docker permissions, ensure you’ve added your user to the Docker group and have logged out/logged back in.
- If Minikube can’t find a driver, ensure the selected driver (Docker, KVM, VirtualBox) is installed and healthy.

---

This should get you up and running with Minikube on your Ubuntu system. Let me know if you encounter any issues or need further guidance!
