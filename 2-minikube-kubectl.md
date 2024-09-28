#### using minikube with kubectl
You can deploy a simple Kubernetes application on Minikube. Here’s an example of deploying a `nginx` web server:

1. Create a deployment:

   ```bash
   kubectl create deployment nginx --image=nginx
   ```
**Note** It will take some time depending on the size of the image.

2. Check the deployments:

   ```bash
   kubectl get deployment nginx --type=NodePort --port=80
   ```

3. Check the deployments:

   ```bash
   kubectl get deployment
   ```

4. Check the pods:

   ```bash
   kubectl get deployment

5. Check the logs:

   ```bash
   kubectl logs [pod name]
   ```
   
6. Expose the deployment as a service:

   ```bash
   kubectl expose deployment nginx --type=NodePort --port=80
   ```

7. Access the service using Minikube's service URL:

   ```bash
   minikube service nginx
   ```

This will open your default web browser and display the running nginx service.

Alternatively, use kubectl to forward the port:
```
kubectl port-forward service/hello-minikube 7080:80
```
Tada! Your application is now available at http://localhost:7080/.
