# Nginx Deployment Configuration
This folder contains a custom `nginx-values.yaml` file to configure the NGINX Ingress Controller a bare-metal k3s cluster without MetalLB.

## Configuration Details 
- **controller.daemonset.enabled: true**
    - Runs the Ingress Cibtrikker as a DaemonSet (one pod per node).
- **controller.ingressClassResource**
    - Declares the `nginx` IngressClass and makes it the default.
- **controller.hostPort.http: 80 & controller.hostPort.https:443**
    - Binds host ports 80 and 443 to each Ingress Controller pod, allowing direct traffic without an external LoadBalancer.
- **controller.service.type: ClusterIP**
    - Uses a ClusterIP service when hostPort is enabled.
- **admissionWebhooks.enabled: true**
    - Enables webhook support for CRD validation.

## Installation
Add the ingress-nginx Helm repository and install (or upgrade) with your custom values:
``` bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx --create-namespace -f nginx-values.yaml
```
> **Note**: If you named your file `nginx-value.yaml`, replaces `-f nginx-values.yaml` accordingly.

## Usage
1. **DNS**: Point your domain (e.g., `portfolio.example.com`) A record to the IP of any cluster node.
2. **Ingress**: Create Ingress resources with the annotation:
```yaml 
kubernetes.io/ingress.class: nginx
```
3. **Test**: `curl http://portfolio.exmaple.com` should reach your service through NGINX.

## Notes
- This configuration uses `hostPort` and does not require MetalLB or a cloud LoadBalancer.
- For TLS, add a tls: section and reference a Kubernetes `Secret` containing your certificate and key.
