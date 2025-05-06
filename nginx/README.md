# Nginx Deployment Configuration
This folder contains a custom `nginx-values.yaml` file to configure the NGINX Ingress Controller a bare-metal k3s cluster without MetalLB.

## Configuration Details 
- **controller.kind: DaemonSet**
    - Runs the Ingress Controller as a DaemonSet (one pod per node, including master).
- **controller.hostPort.enabled: true**
    - Enables binding of host ports 80/443 to each Ingress Controller pod.
- **controller.hostPort.http: 80 & controller.hostPort.https: 443**
    - Specific host ports to bind for HTTP and HTTPS traffic.
- **controller.affinity: {}
    - Clears any default affinity contrainsts (e.g., AMD64-only requirements).
- **controller.nodeSelector**
    - Ensures scheduling only on ARM64 Linux nodes:
        ``` yaml
        kubernetes.io/arch: "arm64"
        kubernetes.io/os: "linux"
        ```
- **controller.ingressClassResource**
    - Declares the `nginx` IngressClass and make it the default.
- **controller.tolerations**
    - Allows pods to schedule on master and control-plane nodes:
        ``` yaml
        - key: "node-role.kubernetes.io/master"
          operator: "Exists"
          effect: "NoSchedule"
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
        ```
- **controller.service.type: ClusterIP**
    - Uses a ClusterIP service with hostPort enabled.
- **admissionWebhooks.enabled: true**
    - Enabled webhook support for CRD validation.


## Installation
Add the ingress-nginx Helm repository and install (or upgrade) with your custom values:
``` bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx \
    --create-namespace \
    -f nginx-values.yaml \
    --set controller.kind=DaemonSet \
    --set controller.hostPort.enabled=true
```
> **Note**: If you named your file `nginx-value.yaml`, replace `-f nginx-values.yaml` accordingly.

## Usage
1. **DNS**: Point your domain (e.g., `portfolio.example.com`) A record to the IP of any cluster node.
2. **Ingress**: Create Ingress resources with the annotation:
```yaml 
kubernetes.io/ingress.class: nginx
```
3. **Test**: 
    ``` yaml
    curl http://portfolio.exmaple.com
    ```
    should return a `404 not found` or your default backend response.

## Notes
- This configuration uses `hostPort` and does not require MetalLB or a cloud LoadBalancer.
- To re-enabled a default backend, set `defaultBackend.enabled: true` and overrise `defaultBackend.image` to a multi-arch registry.
- For TLS, add a `tls:` section and reference a Kubernetes `Secret` containing your certificate and key.
