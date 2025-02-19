### Ensure `kubectl` is Using the Correct Configuration  

Verify that `kubectl` is using the correct kubeconfig file:  

```bash
echo $KUBECONFIG
```  

If the output is empty, manually specify the kubeconfig path:  

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```  

Restart the `kubelet` service:  

```bash
sudo systemctl restart kubelet
```  

### (Optional) Check File Permissions  

Ensure your user has the necessary permissions to access the kubeconfig file:  

```bash
ls -l /etc/kubernetes/admin.conf
```  

If the file is only accessible by root, update its permissions:  

```bash
sudo chmod 644 /etc/kubernetes/admin.conf
```  

If you are not running commands as root, adjust ownership:  

```bash
sudo chown $(id -u):$(id -g) /etc/kubernetes/admin.conf
```  

Restart the `containerd` service to apply changes:  

```bash
sudo systemctl restart containerd
```
