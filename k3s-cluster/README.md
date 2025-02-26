# K3s Cluster

This repository contains notes and configurations for setting up and managing a K3s cluster.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Introduction

K3s is a lightweight Kubernetes distribution designed for resource-constrained environments. It is easy to install and ideal for edge, IoT, and CI/CD environments.

## Prerequisites

Before setting up a K3s cluster, ensure you have the following:

- A Linux-based operating system (e.g., Ubuntu, CentOS)
- At least 1 GB of RAM and 1 CPU core per node
- Sudo or root access on all nodes
- Network connectivity between nodes

## Installation

Follow these steps to install K3s on your nodes:

1. **Download and install K3s:**
    ```sh
    curl -sfL https://get.k3s.io | sh -
    ```

2. **Verify the installation:**
    ```sh
    sudo k3s kubectl get nodes
    ```

3. **Join additional nodes to the cluster:**
    ```sh
    # On the master node, get the join token
    sudo cat /var/lib/rancher/k3s/server/node-token

    # On the worker nodes, run the following command
    curl -sfL https://get.k3s.io | K3S_URL=https://<MASTER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
    ```

## Configuration

Configuration files for K3s are located in `/etc/rancher/k3s/`. You can customize the cluster by editing these files.

## Usage

Use `kubectl` to interact with your K3s cluster. Here are some common commands:

- **Get cluster information:**
    ```sh
    sudo k3s kubectl cluster-info
    ```

- **List all nodes:**
    ```sh
    sudo k3s kubectl get nodes
    ```

- **Deploy an application:**
    ```sh
    sudo k3s kubectl apply -f <your-app.yaml>
    ```

## Troubleshooting

If you encounter issues, check the logs for more information:

- **K3s service logs:**
    ```sh
    sudo journalctl -u k3s
    ```

- **K3s agent logs:**
    ```sh
    sudo journalctl -u k3s-agent
    ```

## Resources

- [K3s Documentation](https://rancher.com/docs/k3s/latest/en/) https://rancher.com/docs/k3s/latest/en/
- [Kubernetes Documentation](https://kubernetes.io/docs/) https://kubernetes.io/docs/
