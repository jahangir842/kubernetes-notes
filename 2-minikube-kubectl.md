### Working with `kubectl`

After setting up Minikube and `kubectl`, you can start managing your Kubernetes cluster using `kubectl`. `kubectl` is the command-line tool that interacts with the Kubernetes API server, allowing you to deploy, manage, and troubleshoot applications on your cluster.

#### 1. **Verify Minikube Installation**
Before working with `kubectl`, ensure that Minikube is up and running:
```bash
minikube start
```

Once Minikube is running, you can verify the status:
```bash
minikube status
```

#### 2. **Set Up `kubectl`**
Minikube automatically configures `kubectl` to work with your local Kubernetes cluster. Verify that `kubectl` is connected to Minikube:
```bash
kubectl cluster-info
```

This will show details about the Kubernetes cluster and confirm that `kubectl` is configured correctly. like:
```
Kubernetes control plane is running at https://192.168.49.2:8443
CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
- The **control plane** is responsible for managing the Kubernetes cluster and is accessible via the API server.
- **CoreDNS** provides DNS resolution for services in the cluster, allowing pods to communicate using service names instead of IP addresses. It's running within the kube-system namespace and accessible via a proxy URL.



### CRUD Operations at the Deployment Level

In Kubernetes, CRUD (Create, Read, Update, Delete) operations primarily occur at the **Deployment** level. A **Deployment** defines the desired state for your application, such as the number of replicas and the container images used.

- **Create**: A deployment is created using YAML or a CLI command (`kubectl apply -f deployment.yaml`), defining the pods and containers Kubernetes should manage.
- **Read**: You can inspect the status of a deployment using `kubectl get deployments` or `kubectl describe deployment`.
- **Update**: Updates to a deployment, like changing container images or scaling replicas, are handled with `kubectl apply` or `kubectl set image`, and Kubernetes automatically applies the changes to the underlying resources (like Pods).
- **Delete**: When a deployment is deleted using `kubectl delete`, Kubernetes automatically removes the underlying Pods and resources.

Anything underneath a deployment (such as Pods, Replicasets, etc.) is managed automatically by Kubernetes as specified in the deployment.

#### 3. **Basic `kubectl` Commands**

- **Check Nodes in the Cluster**:
  A node represents a machine (physical or virtual) running Kubernetes. Since Minikube runs a single-node cluster, it will show just one node.
  ```bash
  kubectl get nodes
  ```

- **View Cluster Information**:
  Retrieve details about the cluster components:
  ```bash
  kubectl cluster-info
  ```

- **List Running Pods**:
  Pods are the smallest units in Kubernetes, containing one or more containers. You can view all running pods in your cluster.
  ```bash
  kubectl get pods
  ```
- **Get Detailed Pod Information**:
  To get detailed information about a specific pod, including its configuration, status, and events:
  ```bash
  kubectl describe pod <pod-name>
  ```
- **View Services**:
  Services in Kubernetes expose your pods to the network.
  ```bash
  kubectl get services
  ```
#### What is Service: 
Service is a method for exposing a network application that is running as one or more Pods in your cluster.
Each Service object defines a logical set of endpoints (usually these endpoints are Pods) along with a policy about how to make those pods accessible.

**More about Service:** 
- https://kubernetes.io/docs/concepts/services-networking/service/
- https://kubernetes.io/docs/tutorials/services/connect-applications-service/


#### 4. **Deploy an Application**
You can deploy applications in Kubernetes by creating a **deployment**. A deployment manages a set of identical pods to ensure availability.

- **Create a Deployment**:
  Deploy an example app using the `nginx` image:
  ```bash
  kubectl create deployment nginx-app --image=nginx
  ```

- **View the Deployment**:
  To verify the deployment is created successfully, use:
  ```bash
  kubectl get deployments
  ```

- **Expose the Deployment as a Service**:
  Once your application is deployed, you can expose it via a service to make it accessible from outside the cluster:
  ```bash
  kubectl expose deployment nginx-app --type=NodePort --port=80
  ```

- **Access the Application**:
  Use Minikube to get the URL of the service:
  ```bash
  minikube service nginx-app --url
  ```



### get pod in detail:

The following command is used in Kubernetes to retrieve detailed information about the Pods in a specific namespace or in the current context.

```
kubectl get pod -o wide`
```

  - **`-o wide`**: This flag changes the output format to include additional details, such as:
  - **Node**: The node on which the Pod is running.
  - **IP Address**: The Pod's IP address.
  - **Container Status**: Status of the containers within the Pod, including the number of restarts.
  - **Container Images**: The images used by the containers in the Pod.

The output might look like this:

```
NAME            READY   STATUS    RESTARTS   AGE     IP            NODE
nginx-pod      1/1     Running   0          5m      10.244.1.5    worker-node-1
app-pod        1/1     Running   2          10m     10.244.1.6    worker-node-2
```

#### 5. **Scaling the Application**
Kubernetes allows you to scale your application easily by increasing or decreasing the number of pods in a deployment.

- **Scale the Deployment**:
  To scale the number of replicas (pods) to 3:
  ```bash
  kubectl scale deployment nginx-app --replicas=3
  ```

- **Verify the Scaling**:
  Check the number of pods to ensure scaling worked:
  ```bash
  kubectl get pods
  ```

#### 6. **Updating Applications**
You can update your application by changing the container image used in the deployment.

- **Update the Image in a Deployment**:
  Update the nginx app to use version `1.19`:
  ```bash
  kubectl set image deployment/nginx-app nginx=nginx:1.19
  ```

- **Monitor the Update**:
  View the status of the rolling update:
  ```bash
  kubectl rollout status deployment/nginx-app
  ```

- **Rollback an Update**:
  If the update causes issues, you can easily roll back to the previous version:
  ```bash
  kubectl rollout undo deployment/nginx-app
  ```

#### 7. **Deleting Resources**
Once you're done with your deployments, services, or any other resources, you can delete them using `kubectl`.

- **Delete a Deployment**:
  To remove the nginx-app deployment:
  ```bash
  kubectl delete deployment nginx-app
  ```

- **Delete a Service**:
  Similarly, to remove the service:
  ```bash
  kubectl delete service nginx-app
  ```

#### 8. **Using Namespaces**
Namespaces are a way to divide cluster resources between multiple users or projects.

- **View All Namespaces**:
  ```bash
  kubectl get namespaces
  ```

- **Create a New Namespace**:
  ```bash
  kubectl create namespace dev
  ```

- **Use a Different Namespace**:
  To create resources within a specific namespace:
  ```bash
  kubectl create deployment nginx-app --image=nginx --namespace=dev
  ```

- **Switch Between Namespaces**:
  You can specify which namespace `kubectl` should interact with:
  ```bash
  kubectl config set-context --current --namespace=dev
  ```

#### 9. **Debugging with `kubectl`**

- **View Logs of a Pod**:
  You can troubleshoot issues by viewing the logs generated by a pod:
  ```bash
  kubectl logs <pod-name>
  ```

- **Get a Shell Inside a Pod**:
  For deeper debugging, you can connect to a running container within a pod:
  ```bash
  kubectl exec -it <pod-name> -- /bin/bash
  ```

- **Describe Resources for Troubleshooting**:
  To view detailed resource events and configurations, use:
  ```bash
  kubectl describe <resource-type> <resource-name>
  ```
  Example:
  ```bash
  kubectl describe pod nginx-app
  ```

#### 10. **Port Forwarding**
Expose an application running in a pod to your local machine via port forwarding:
```bash
kubectl port-forward deployment/nginx-app 8080:80
```
This will map port `8080` on your local machine to port `80` inside the pod.

#### 11. **Working with YAML Files**
You can also define resources in YAML configuration files and apply them using `kubectl`.

- **Apply a YAML File**:
  ```bash
  kubectl apply -f <filename>.yaml
  ```

- **View Resource Definitions in YAML**:
  You can output any resource's configuration in YAML:
  ```bash
  kubectl get <resource-type> <resource-name> -o yaml
  ```

#### 12. **Cleanup**

- **Delete All Resources**:
  To remove all resources (pods, services, deployments, etc.) in the default namespace:
  ```bash
  kubectl delete all --all
  ```

#### Conclusion:
With `kubectl`, you can manage your Kubernetes cluster, including deploying applications, scaling them, exposing services, and troubleshooting. It integrates seamlessly with Minikube for local development but also works with production Kubernetes clusters. The flexibility of `kubectl` and its wide range of commands make it a powerful tool for Kubernetes administrators and developers.
