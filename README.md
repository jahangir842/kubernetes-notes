## Cloud Native Computing Foundation (CNCF)

- **Cloud Native Computing Foundation (CNCF)**: A major project under the Linux Foundation, CNCF accelerates the adoption of containers, microservices, and cloud-native apps.

- **Project Categories**: Projects are categorized by maturity levels—**Sandbox**, **Incubating**, and **Graduated**. Over a dozen projects have achieved Graduated status, including **Kubernetes**, **Helm**, and **Prometheus**.

- **Popular Graduated Projects**: Examples include **Kubernetes**, **Argo**, **CoreDNS**, **Fluentd**, **Linkerd**, and **Envoy**.

- **Key Incubating Projects**: Notable incubating projects include **Buildpacks.io**, **Knative**, **KubeVirt**, and **Contour**.

- **Dynamic Sandbox Projects**: New projects in areas like metrics, monitoring, and serverless are progressing toward higher maturity levels, while some, like **rkt** and **Brigade**, have been archived.

- **Full Lifecycle Support**: CNCF projects cover the entire cloud-native app lifecycle, from container runtimes to monitoring and logging.

---

## CNCF and Kubernetes

The Cloud Native Computing Foundation (CNCF) supports Kubernetes in several key ways:

- Provides a neutral home for the Kubernetes trademark and ensures proper usage.
- Conducts license scanning for both core and vendor code.
- Offers legal guidance on patent and copyright matters.
- Develops and maintains open-source learning materials, training, and certifications, such as KCNA, CKA, CKAD, and CKS.
- Oversees a software conformance working group to ensure standards.
- Actively promotes Kubernetes through marketing.
- Supports ad hoc initiatives and events.
- Sponsors Kubernetes-related conferences and meetups.

---

## CNCF Landscape

Explore the Cloud Native Computing Foundation (CNCF) landscape:  
[https://landscape.cncf.io](https://landscape.cncf.io/)

---

## Roots of Kubernetes

The evolution of Kubernetes started from **Borg**, Google's very own distributed workload manager.

**Cloud Native Computing Foundation (CNCF)** currently hosts the Kubernetes project, along with other popular cloud native projects, such as Argo, Cilium, Prometheus, Fluentd, etcd, CoreDNS, cri-o, containerd, Helm, Envoy, Istio, and Linkerd, just to name a few.

---

### What Is Kubernetes?

According to the Kubernetes website,

`Kubernetes is an open-source system for automating deployment, scaling, and management of containerized applications`

Kubernetes comes from the Greek word κυβερνήτης, which means **helmsman** or **ship pilot**. With this analogy in mind, we can think of Kubernetes as the pilot on a ship of containers.

Kubernetes is also referred to as **k8s** (pronounced Kate's), as there are 8 characters between k and s.

Kubernetes is highly inspired by the **Google Borg** system, a container and workload orchestrator for its global operations, Google has been using for more than a decade. It is an open source project written in the **Go** language and licensed under the License, Version 2.0.

Kubernetes was started by Google and, with its v1.0 release in July 2015, Google **donated** it to the Cloud Native Computing Foundation (CNCF), one of the largest **sub-foundations** of the **Linux Foundation**.

New Kubernetes versions are released in 4 month cycles. The current stable version is 1.29 (as of December 2023). https://kubernetes.io/releases/

---

### Kubernetes Features

Kubernetes provides a comprehensive set of features for container orchestration, including:

- **Automatic Bin Packing**: Automatically schedules containers based on resource needs and constraints, maximizing resource utilization without compromising availability.

- **Extensibility**: Allows extending a Kubernetes cluster with custom features without altering the core code.

- **Self-Healing**: Detects and replaces failed containers, reschedules them from failed nodes, and restarts unresponsive containers according to health checks and policies. Prevents routing traffic to unhealthy containers.

- **Horizontal Scaling**: Offers manual or automatic scaling of applications based on CPU usage or custom metrics.

- **Service Discovery & Load Balancing**: Assigns IP addresses to containers and provides a DNS name for a set of containers to facilitate load balancing across them.

#### Additional Features

- **Automated Rollouts & Rollbacks**: Seamlessly handles application updates and configuration changes, monitoring the application’s health to avoid downtime.

- **Secret & Configuration Management**: Manages sensitive information (like credentials) separately from container images, ensuring secure handling without embedding secrets in code repositories.

- **Storage Orchestration**: Automates the mounting of storage solutions, including local, cloud, distributed, and network storage, to containers.

- **Batch Execution**: Supports batch processing, long-running jobs, and automatic replacement of failed containers.

- **IPv4/IPv6 Dual-Stack**: Supports both IPv4 and IPv6 addressing for network communication.

Kubernetes also integrates common Platform as a Service (PaaS) features such as deployment, scaling, and load balancing, with flexible options for adding monitoring, logging, and alerting via plugins.

Additionally, many Kubernetes features evolve through alpha or beta phases, such as stable support for **Role-Based Access Control (RBAC)** since version 1.8 and **cronjobs** since version 1.21. These features bring even more value as they mature in stability.


---

#### Why Use Kubernetes?

- **Portability**: Kubernetes can be deployed in various environments, including local or remote VMs, bare metal, and public/private/hybrid/multi-cloud setups.

- **Extensibility**: Kubernetes supports integration with 3rd-party open-source tools and has a modular, pluggable architecture. It can orchestrate microservices-based applications and extend functionality through custom resources, operators, APIs, scheduling rules, or plugins.

- **Thriving Community**: Kubernetes has a large and active community, with over 3,500 contributors and 120,000+ commits. It is supported by Special Interest Groups (SIGs) focusing on different topics like scaling, networking, and storage.

---

## Container Orchestrators

Most container orchestrators can be deployed on the infrastructure of our choice - on bare metal, Virtual Machines, on-premises, on public and hybrid clouds. Kubernetes, for example, can be deployed on a workstation, with or without an isolation layer such as a local hypervisor or container runtime, inside a company's data center, in the cloud on AWS Elastic Compute Cloud (EC2) instances, Google Compute Engine (GCE) VMs, DigitalOcean Droplets, IBM Virtual Servers, OpenStack, etc.

In addition, there are turnkey cloud solutions which allow production Kubernetes clusters to be installed, with only a few commands, on top of cloud Infrastructures-as-a-Service. These solutions paved the way for the managed container orchestration as-a-Service, more specifically the managed Kubernetes as-a-Service (KaaS) solution, offered and hosted by the major cloud providers. Examples of KaaS solutions are Amazon Elastic Kubernetes Service (Amazon EKS), Azure Kubernetes Service (AKS), DigitalOcean Kubernetes, Google Kubernetes Engine (GKE), IBM Cloud Kubernetes Service, Oracle Container Engine for Kubernetes, or VMware Tanzu Kubernetes Grid.

---

## Orchestration Tools:

Below is a list of popular container orchestration tools and services available today, though it’s not exhaustive:

1. **Amazon Elastic Container Service (ECS)**  
   - A hosted service from Amazon Web Services (AWS) that allows running containers at scale on AWS infrastructure.
   
2. **Azure Container Instances (ACI)**  
   - A basic container orchestration service provided by Microsoft Azure for simple container deployments.

3. **Azure Service Fabric**  
   - An open-source container orchestrator by Microsoft Azure, designed for distributed applications and microservices.

4. **Kubernetes**  
   - An open-source container orchestration platform originally developed by Google and now managed by CNCF.

5. **Marathon**  
   - A container orchestration framework built on Apache Mesos and DC/OS for running containers at scale.

6. **Nomad**  
   - A flexible container and workload orchestrator provided by HashiCorp, designed for multi-cloud environments.

7. **Docker Swarm**  
   - A native container orchestrator built into Docker Engine, enabling clustering and scaling of Docker containers.

---

## Kubernetes Cloud Solutions

If you're considering **Kubernetes cloud solutions**, several managed services are available that take care of infrastructure management, scaling, and operations, allowing you to focus on deploying and managing your applications. Here's a breakdown of the major **cloud-based Kubernetes solutions**:

### 1. **Amazon EKS (Elastic Kubernetes Service)**
   - **Provider**: Amazon Web Services (AWS)
   - **Description**: A managed Kubernetes service that makes it easy to run Kubernetes on AWS without needing to manage the Kubernetes control plane. AWS handles the control plane, scaling, and availability.
   - **Features**:
     - Fully managed control plane with automatic upgrades.
     - Integrated with AWS services like IAM, VPC, and ALB.
     - Supports Fargate (serverless) for running pods without managing EC2 instances.
   - **Pros**: 
     - Deep integration with AWS services.
     - Flexible scaling with support for auto-scaling groups and spot instances.
   - **Cons**: 
     - Tightly coupled with AWS ecosystem, which may increase lock-in.
   - **Use Case**: Best for those already using AWS or looking for a tightly integrated solution with other AWS services.

   **Getting Started**:
   - Create a Kubernetes cluster using the AWS CLI:
     ```bash
     eksctl create cluster --name my-cluster
     ```
     
### 2. **Google Kubernetes Engine (GKE)**
   - **Provider**: Google Cloud Platform (GCP)
   - **Description**: GKE is a fully managed Kubernetes service on GCP, offering strong integration with Google’s cloud services, including networking, security, and AI/ML tools.
   - **Features**:
     - Automated operations like upgrades, scaling, and backups.
     - Integration with Google Cloud services (e.g., Cloud Run, Cloud Functions).
     - Support for Anthos, a multi-cloud Kubernetes platform.
   - **Pros**: 
     - Leading-edge Kubernetes service with early access to new features.
     - Excellent security and scalability features.
     - Efficient cluster management tools like GKE Autopilot for a more hands-off experience.
   - **Cons**: 
     - Pricing can get complex depending on usage.
   - **Use Case**: Ideal for users leveraging Google Cloud services or looking for an advanced Kubernetes service with the latest features.

   **Getting Started**:
   - Create a GKE cluster using the GCloud CLI:
     ```bash
     gcloud container clusters create my-cluster
     ```

### 3. **Azure Kubernetes Service (AKS)**
   - **Provider**: Microsoft Azure
   - **Description**: AKS is Microsoft Azure’s managed Kubernetes service. It offers deep integration with Azure services, making it easier to deploy Kubernetes clusters and integrate with Azure’s cloud resources like storage, networking, and identity.
   - **Features**:
     - Built-in monitoring and log collection with Azure Monitor.
     - Integration with Azure Active Directory (AAD) for authentication.
     - Support for both Linux and Windows containers.
   - **Pros**: 
     - Great for hybrid cloud setups with on-premise and cloud integration.
     - Excellent integration with Azure DevOps and pipelines.
   - **Cons**: 
     - Azure pricing can be complex.
   - **Use Case**: Best for organizations already leveraging the Microsoft Azure ecosystem or looking to integrate with Azure’s DevOps tools and enterprise features.

   **Getting Started**:
   - Create a Kubernetes cluster using Azure CLI:
     ```bash
     az aks create --resource-group myResourceGroup --name myCluster
     ```

### 4. **IBM Cloud Kubernetes Service**
   - **Provider**: IBM Cloud
   - **Description**: A managed Kubernetes service by IBM, designed for hybrid cloud deployments and built with enterprise-grade security and scalability features.
   - **Features**:
     - Full lifecycle management of Kubernetes clusters.
     - Integration with IBM’s AI, blockchain, and analytics services.
     - Compliance with enterprise security standards (e.g., GDPR, HIPAA).
   - **Pros**: 
     - Great for hybrid and multi-cloud environments.
     - Strong enterprise security features and compliance support.
   - **Cons**: 
     - Fewer integrations compared to AWS or GCP.
   - **Use Case**: Ideal for enterprises focused on hybrid cloud environments and using IBM services like AI and analytics.

   **Getting Started**:
   - Create a cluster using the IBM Cloud CLI:
     ```bash
     ibmcloud ks cluster-create --name myCluster
     ```

### 5. **Oracle Container Engine for Kubernetes (OKE)**
   - **Provider**: Oracle Cloud Infrastructure (OCI)
   - **Description**: A fully managed Kubernetes service from Oracle, designed for running enterprise workloads on Oracle Cloud. OKE focuses on high performance and security, making it suitable for business-critical applications.
   - **Features**:
     - Fully integrated with Oracle Cloud’s compute, networking, and storage.
     - Built-in security features like Oracle Cloud Guard.
     - Autoscaling, monitoring, and automated upgrades.
   - **Pros**: 
     - Strong for Oracle-based applications and databases.
     - Good for performance and low-latency use cases.
   - **Cons**: 
     - Smaller ecosystem compared to AWS or GCP.
   - **Use Case**: Best for enterprises using Oracle databases or applications in production.

   **Getting Started**:
   - Deploy a cluster using OCI CLI:
     ```bash
     oci ce cluster create --name myCluster
     ```

### 6. **DigitalOcean Kubernetes**
   - **Provider**: DigitalOcean
   - **Description**: A simple, affordable managed Kubernetes service targeted toward developers and small businesses. It offers a straightforward experience for deploying Kubernetes with minimal setup complexity.
   - **Features**:
     - Simple interface with one-click cluster creation.
     - Easy integration with DigitalOcean services like databases, storage, and load balancers.
     - Cost-effective for small and medium-sized businesses.
   - **Pros**: 
     - Easy to set up and manage, ideal for smaller teams and projects.
     - Affordable pricing compared to other providers.
   - **Cons**: 
     - Not as feature-rich as larger cloud providers like AWS or GCP.
   - **Use Case**: Best for startups, small businesses, or developers who want a simple, cost-effective way to run Kubernetes in production.

   **Getting Started**:
   - Deploy a cluster via the DigitalOcean CLI:
     ```bash
     doctl kubernetes cluster create my-cluster
     ```

### 7. **Linode Kubernetes Engine (LKE)**
   - **Provider**: Linode (now part of Akamai)
   - **Description**: A managed Kubernetes service by Linode, designed for developers and small businesses. It provides a cost-effective, simple-to-use platform for Kubernetes.
   - **Features**:
     - Fast setup and cluster deployment with Linode infrastructure.
     - Simple and affordable pricing with no hidden fees.
     - Integration with Linode services like Block Storage and NodeBalancers.
   - **Pros**: 
     - Budget-friendly.
     - Easy to use for small-scale deployments.
   - **Cons**: 
     - Limited advanced features compared to AWS or GCP.
   - **Use Case**: Ideal for developers and small businesses looking for a straightforward Kubernetes deployment with transparent pricing.

   **Getting Started**:
   - Create a cluster using the Linode CLI:
     ```bash
     linode-cli lke cluster-create --name my-cluster
     ```

### 8. **Alibaba Cloud Container Service for Kubernetes (ACK)**
   - **Provider**: Alibaba Cloud
   - **Description**: A fully managed Kubernetes service that runs on Alibaba Cloud, offering comprehensive integration with Alibaba’s services and designed for running containerized workloads in China and globally.
   - **Features**:
     - Support for enterprise-grade security and compliance.
     - Deep integration with Alibaba Cloud services like Object Storage Service (OSS) and Elastic Compute Service (ECS).
     - Flexible scaling and management of clusters.
   - **Pros**: 
     - Ideal for businesses operating in China or using Alibaba’s global infrastructure.
     - Great for scaling workloads across multiple regions.
   - **Cons**: 
     - Less documentation and community support compared to AWS or GCP.
   - **Use Case**: Ideal for companies operating in China or leveraging Alibaba Cloud for international expansion.

   **Getting Started**:
   - Create a Kubernetes cluster using Alibaba CLI:
     ```bash
     aliyun cs CREATE-KUBERNETES-CLUSTER --name my-cluster
     ```

---

### Summary of Cloud Kubernetes Options:
- **For AWS integration**: Use **Amazon EKS**.
- **For Google Cloud services**: Use **Google GKE**.
- **For Azure environments**: Use **Azure AKS**.
- **For hybrid and enterprise environments**: Consider **IBM Cloud Kubernetes** or **Oracle OKE**.
- **For simpler, cost-effective options**: Use **DigitalOcean Kubernetes** or **Linode Kubernetes**.
- **For scaling in China**: Consider **Alibaba Cloud ACK**.

Each of these managed services handles much of the operational overhead, letting you focus on deploying and scaling applications without having to manage the control plane or underlying infrastructure manually.

---

## Kubernetes On-Prem Solutions:

If you want to run Kubernetes in production without relying on cloud providers, there are several **on-premise** and **self-managed** options that allow you to deploy and manage Kubernetes clusters. Below are some alternatives you can consider:

### 1. **Kubeadm**
   - **Description**: A tool that helps you bootstrap a secure Kubernetes cluster on bare-metal or virtual machines. It's part of Kubernetes and is widely used for setting up production clusters.
   - **How it works**: Kubeadm initializes the control plane and joins worker nodes to the cluster.
   - **Pros**: 
     - Direct control over configuration and infrastructure.
     - Highly customizable.
     - Lightweight and uses native Kubernetes components.
   - **Cons**: 
     - Requires you to manage infrastructure, networking, and storage manually.
     - No built-in monitoring or dashboards (these need to be set up separately).
   - **Use Case**: Best for those who want to self-manage Kubernetes on their own hardware or VMs.

   **Getting Started**:
   - Install Kubernetes using `kubeadm` on multiple nodes:
     ```bash
     kubeadm init
     kubeadm join <control-plane-node>
     ```

### 2. **Rancher**
   - **Description**: Rancher is a complete container management platform built on Kubernetes. It provides an intuitive UI for managing Kubernetes clusters and also simplifies multi-cluster deployments.
   - **How it works**: You can deploy Rancher on any bare-metal or virtualized infrastructure, and it helps you set up and manage Kubernetes clusters.
   - **Pros**: 
     - Offers a user-friendly UI and multi-cluster management.
     - Integrates monitoring, logging, and storage solutions out of the box.
     - Support for HA deployments.
   - **Cons**: 
     - Requires some learning to manage large, production-level clusters.
     - Adds an extra layer of complexity on top of Kubernetes.
   - **Use Case**: Ideal for teams that want a Kubernetes management platform and need features like multi-cluster management and a visual UI.

   **Getting Started**:
   - Install Rancher on a node:
     ```bash
     docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher
     ```

### 3. **K3s (Lightweight Kubernetes)**
   - **Description**: K3s is a lightweight Kubernetes distribution designed for IoT, edge, and resource-constrained environments. It’s a production-ready Kubernetes distribution from Rancher but uses less memory and has fewer dependencies.
   - **How it works**: K3s simplifies Kubernetes installation by packaging it into a single binary and includes built-in components like a local storage provider and simplified networking.
   - **Pros**: 
     - Lightweight and easy to set up.
     - Ideal for resource-limited environments or small-scale deployments.
     - Simplified version of Kubernetes, making it easier to manage.
   - **Cons**: 
     - Limited functionality for large-scale, complex deployments.
     - Doesn’t have all the advanced features of full Kubernetes distributions.
   - **Use Case**: Great for small clusters, edge computing, or environments with fewer resources.

   **Getting Started**:
   - Install K3s on your system:
     ```bash
     curl -sfL https://get.k3s.io | sh -
     ```

### 4. **MicroK8s**
   - **Description**: A lightweight, single-package Kubernetes distribution maintained by Canonical (the makers of Ubuntu). It's ideal for both local development and small production environments.
   - **How it works**: MicroK8s installs Kubernetes with a minimal footprint and includes optional add-ons (e.g., Istio, Knative, and Prometheus).
   - **Pros**: 
     - Fast and simple to install.
     - Minimal system requirements, ideal for development or small production clusters.
     - Managed by Canonical, with official Ubuntu support.
   - **Cons**: 
     - Not suitable for very large production environments.
     - Lacks some features present in larger distributions.
   - **Use Case**: Best for small-scale Kubernetes clusters or single-node setups that need to be easy to manage.

   **Getting Started**:
   - Install MicroK8s:
     ```bash
     sudo snap install microk8s --classic
     ```

### 5. **OpenShift (OKD)**
   - **Description**: OKD (OpenShift Kubernetes Distribution) is the open-source version of Red Hat’s OpenShift. It's a Kubernetes distribution with enterprise features such as integrated CI/CD pipelines, developer tools, and security enhancements.
   - **How it works**: OKD adds extra management tools and features on top of Kubernetes, providing a more enterprise-friendly solution.
   - **Pros**: 
     - Provides a rich set of built-in features (e.g., monitoring, CI/CD).
     - Enhanced security features like multi-tenancy and advanced RBAC.
     - Managed through a user-friendly web interface.
   - **Cons**: 
     - Complex to set up and maintain.
     - Resource-heavy and overkill for smaller clusters.
   - **Use Case**: Suited for enterprise environments needing a robust Kubernetes distribution with built-in tools for development and security.

   **Getting Started**:
   - Deploy OKD via the official [OKD documentation](https://www.okd.io/).

### 6. **Tanzu Kubernetes Grid (VMware)**
   - **Description**: VMware’s Kubernetes distribution, integrated with vSphere, designed for on-premise and hybrid cloud Kubernetes environments.
   - **How it works**: Tanzu manages Kubernetes clusters and provides lifecycle management, monitoring, and scaling, all tightly integrated with VMware's vSphere.
   - **Pros**: 
     - Seamless integration with VMware environments.
     - Built for enterprise use with advanced management tools.
     - Lifecycle management and enterprise-grade support.
   - **Cons**: 
     - Primarily focused on VMware environments.
     - Complex to set up for non-VMware users.
   - **Use Case**: Perfect for enterprises already using VMware that want to integrate Kubernetes into their infrastructure.

   **Getting Started**:
   - More information can be found on [VMware Tanzu](https://tanzu.vmware.com/kubernetes-grid).

### 7. **Bare Metal Kubernetes**
   - **Description**: Deploying Kubernetes directly on physical servers (bare metal) gives you full control over your infrastructure. You'll have to manage everything manually, from the underlying hardware to networking and storage.
   - **How it works**: You can use tools like **Kubeadm**, **Kuberspray**, or **MetalLB** to manage load balancing, networking, and other components.
   - **Pros**: 
     - Full control over hardware and configurations.
     - No abstraction layers like VMs, resulting in better performance.
   - **Cons**: 
     - Requires in-depth knowledge of infrastructure, networking, and storage.
     - Complex to manage, monitor, and maintain.
   - **Use Case**: Ideal for performance-critical applications where you want full control over the environment and hardware.

### 8. **Kuberspray (Kubernetes the Hard Way)**
   - **Description**: **Kuberspray** is an open-source project that uses Ansible to deploy production-ready Kubernetes clusters on any environment (bare metal, VMs, or cloud).
   - **How it works**: You use Ansible playbooks to automate the installation and configuration of Kubernetes, networking, and security.
   - **Pros**: 
     - Automates Kubernetes deployments across various platforms.
     - Can be used for both small and large-scale production environments.
   - **Cons**: 
     - More complex than tools like K3s or MicroK8s.
     - Requires knowledge of Ansible for configuration.
   - **Use Case**: Suitable for production environments where you need flexible, automated Kubernetes deployments.

   **Getting Started**:
   - Follow Kuberspray installation guide from the official [GitHub repository](https://github.com/kubernetes-sigs/kubespray).

### Conclusion:
If you prefer **self-managed** Kubernetes environments without cloud dependencies, the best choices include **Kubeadm**, **Rancher**, **K3s**, or **MicroK8s**. For large, enterprise-level setups, consider **OpenShift (OKD)** or **Tanzu Kubernetes Grid**. For complete control and performance, **Bare Metal Kubernetes** or **Kuberspray** are great options.

Each solution offers a different level of complexity and feature set depending on your production needs.

