# Nginx Deployment Configuration
This folder contains a custom `nginx-values.yaml` used to deploy `ingress-nginx` on a bare-metal k3s cluster without **MetalLB**, using a single edge node + NodePort + router port-forwarding.

This setup is designed to be robust, predictable, and Kubernetes-aligned, while working within home / bare-metal networking contraints.

## Design Summary
- Ingress controller runs as a single instance
- Scheduled on a dedicated edge node using labels
- Exposed externally via NodePort
- Router forwards ports 80 / 443 to the edge node
- Other workloads remain free to schedule on any node

## Node Preparation 
Label the chosen edge node:
```bash
kubectl label node knode1 role=edge --overwrite
```
This lable is used only to place the ingress controller and does not restrict other workloads from running on the node.

## Installation
Add the ingress-nginx Helm repository and install (or upgrade) with your custom values:
``` bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx \
    --create-namespace \
    -f nginx-values.yaml \
```
> **Note**: If you named your file `nginx-value.yaml`, replace `-f nginx-values.yaml` accordingly.

## Router Configuration
Configure router port forwarding to the edge node:
| WAN Port | Target Node | Target Port |
| --- | --- | --- |
| 80 | knode1 | NodePort (HTTP) |
|  443 | knode1 | NodePort (HTTPS) |

## DNS 
Point your domain to your public address:
```cpp
<domain.name> -> <public-ip>
```

## Usage
Ingress resources should reference the `nginx` ingress class:
```yaml
spec:
  ingressClassName: nginx
```
Once deployed, applications can be accessed via their configured hostnames.

## Notes
- This setup avoids `hostNetwork` and `hostPort`
- No cloud load balancer or MetalLB is required
- The edge node remains schedulable for other workloads
- The configuration can be migrated to MetalLB in the future without changing application manifests
