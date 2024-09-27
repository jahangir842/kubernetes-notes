### Minikube

**Geting Started:** https://minikube.sigs.k8s.io/docs/start/

minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment, and Kubernetes is a single command away: minikube start

```
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

Start Minikube:
```
minikube start
```

it will show the following:
```
minikube start
😄  minikube v1.34.0 on Ubuntu 24.04
✨  Automatically selected the docker driver. Other choices: virtualbox, vmware, none, ssh
📌  Using Docker driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.45 ...
💾  Downloading Kubernetes v1.31.0 preload ...
```

