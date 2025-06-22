# Portfolio Deployment Configuration
This folder contains all the kubernetes manifests needed to deploy my full-stack portfolio app (`cyrof/kn-folio:latest`) on a k3s Raspberry Pi cluster under the `folio` namespace.

## Configuration Details 
- **controller.kind: StatefulSet**
    - Manages your portfolio pods with stable identities.
- **controller.spec.replicas: 1**
    - Runs a single instance of the app.
- **controller.spec.selector.matchLabels.app: knfolio**
    - Matches pods labled `app: knfolio`.
- **controller.containers.image: cyrof/kn-folio:latest**
    - the multi-arch porfolio image (must support `linux/arm/v7`).
- **controller.containers.ports.containerPort: 3000**
    - Exposes port 300 inside each pod.
- **controller.containers.env**
    Injects email credentials from `Secret/knfolio-secrets`:
    ```yaml
    - name: EMAIL_USER
      valueFrom:
            secretKeyRef:
                name: knfolio-secrets
                key: EMAIL_USER
    - name: EMAIL_PASS
      ...
    - name: RECIPIENT_EMAIL
      ...
    ```
- **Service type: ClusterIP**
    - Exposes the pods on `knfolio-service:3000` inside the cluster.
- **Service ports.port: 3000 -> targetPort: 3000**
    - Routes traffic from service port 3000 into the container port 3000.
- **Ingress ingressClassName: nginx**
    - Uses the nginx ingress controller to route external traffic.
- **Ingress annotations**
    - `cert-manager.io/cluster-issuer: letsencrypt-http01` (Let's Encrypt TLS)
    - `nginx.ingress.kubernetes.io/ssl-redirect: "true"` (force HTTPS)
- **Ingress tls**
    - Terminates TLS for `knfolio.dev` using `Secret/knfolio-tls`.
- **Ingress rules**
    - Routes `Host: knfolio.dev` and path `/` to `knfolio-service:3000`.
- **Secret type: Opaque**
    - Stores `EMAIL_USER`, `EMAIL_PASS`, and `RECIPIENT_EMAIL` for the app&ndash;see the [knfolio README.md](https://github.com/Cyrof/kn-folio) for why they're required.

## Installation
### 1. Create namespace
```bash
kubectl create namespace folio
```

### 2. Apply the Secret (replace values in portfolio-secret.yaml)
```bash
kubectl apply -f portfolio-secret.yaml
```

### 3. Deploy the app, Service and Ingress
```bash
kubectl apply -f portfolio-deploy.yaml
kubectl apply -f portfolio-service.yaml
kubectl apply -f portfolio-ingress.yaml
```

## Usage
- **Test internally:**
    ```bash
    kubectl port-forward svc/knfolio-service 3000:3000 -n folio
    curl http://localhost:3000
    ```
- **Access via domain (once DNS & TLS are set up):**
    ```bash
    curl https://knfolio.dev
    ```

## Updating the App
To update the portfolio (e.g., after pushing a new `:latest` image or updating secrets), simply trigger a restart:
```bash 
kubectl rollout restart statefullset knfolio -n folio
```
This will:
- Restart the `knfolio` pod
- Pull the updated image (if changed)
- Reload secrets and config
> Pro tip: You can also annotate the pod template or use GitOps to trigger automated redeploys.

## Notes
- Make sure your DNS A-record for `knfolio.dev` points to your cluster's external IP.
- cert-manager must be installed with a `letsencrypt-http01` ClusterIssuer for automatic TLS.
- The `knfolio-secrets` values come from the [knfolio README](https://github.com/Cyrof/kn-folio).
- You can scale `spec.replicas` in `porfolio-deployment.yaml` if you need more instances.
