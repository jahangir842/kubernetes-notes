To completely **reset a Kubernetes worker node** so it can rejoin a cluster, follow these steps:

---

## **🛠 Step 1: Reset Kubernetes Components**
Run the following command:  
```bash
sudo kubeadm reset
```
- This will **remove** all Kubernetes configurations from the node.
- If prompted, type **"y"** to confirm.

If you get an error about `iptables`, reset them manually:
```bash
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
```

---

## **🗑 Step 2: Remove Old Kubernetes Files**
Manually clean up leftover directories:
```bash
sudo rm -rf /etc/kubernetes/ /var/lib/kubelet /var/lib/etcd /var/lib/cni /var/run/kubernetes ~/.kube
```
---

## **🔍 Step 3: Stop Running Services**
Ensure that Kubernetes-related services are stopped:
```bash
sudo systemctl stop kubelet
sudo systemctl stop docker  # or containerd
```
Then restart Docker/Containerd:
```bash
sudo systemctl start docker
```
If you use `containerd`, restart it instead:
```bash
sudo systemctl start containerd
```

---

## **🔎 Step 4: Verify That Ports Are Free**
Check if Kubernetes-related ports (6443, 10250) are still being used:
```bash
sudo netstat -tulnp | grep -E '6443|10250'
```
If a process is using a port, find its PID and kill it:
```bash
sudo kill -9 <PID>
```

---

## **🔄 Step 5: Rejoin the Cluster**
Once the node is reset, you need to **rejoin the cluster**.  
Run the `kubeadm join` command again (you can get this from the control plane using `kubeadm token create --print-join-command`):
```bash
sudo kubeadm join <master-ip>:6443 --token <your-token> --discovery-token-ca-cert-hash sha256:<your-ca-hash>
```

---

After running this, the worker node should successfully join the cluster.  
You can check the status from the control plane:
```bash
kubectl get nodes
```
