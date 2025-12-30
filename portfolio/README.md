# Portfolio Deployment Configuration
This folder contains all the kubernetes manifests needed to deploy my full-stack portfolio app (`cyrof/kn-folio:latest`) on a k3s Raspberry Pi cluster under the `folio` namespace.

The deployment uses:
- **Kubernetes Deployment** (stateless)
- **Multiple replicas** 
- **ClusterIP Service**
- **NGINX Ingress**
- **Externally managed Kuberntes Secret (CLI-Created)**

## Overview
- Application runs as a Deployment, not a StatefulSet
- Supports horizontal scaling via replicas
- Secrets are not stored in Git and are not managed by Helm
- Traffic is routed internally via ClusterIP Service
- External access is handled by NGINX Ingress + cert-manager

## Architecture Summary 
- **Deployment**
    - Runs the portfolio container (`cyrof/kn-folio:latest`)
    - Stateless, safe to scale
- **Service (ClusterIP)**
    - Exposes the app internally on port `3000`
- **Ingress (nginx)**
    - Routes `knfolio.dev` -> `knfolio-service:3000`
    - Terminates TLS using Let's Encrypt
- **Secret**
    - Manually created via `kubectl`
    - Injected into pods as environment variables

## Prerequisites
- k3s cluster running
- NGINX Ingress Controller installed
- cert-manager installed
- `letsencrypt-http01` ClusterIssuer available
- DNS A-record for `knfolio.dev` pointing to your ingress entrypoint

## Installation
### 1. Create namespace
```bash
kubectl create namespace folio
```

### 2. Create the Secret via CLI (no files saved)
> Values must be **plaintext**. Kubernetes will encode them automatically.
```bash
kubectl -n folio create secret generic knfolio-secrets \
  --from-literal=EMAIL_USER='abc@gmail.com' \
  --from-literal=EMAIL_PASS='YOUR_APP_PASSWORD' \
  --from-literal=RECIPIENT_EMAIL='hfg@gmail.com' \
  --dry-run=client -o yaml | kubectl apply -f -
```
This Secret is referenced by the Helm chart by not managed by Helm.

### 3. Deploy using Helm
From this directory:
```bash
helm upgrade --install knfolio ./knfolio-chart -n folio --create-namespace 
```

## Usage
### Verify deployment
```bash
kubectl get deploy,po,svc,ingress -n folio
```

### Test internally
    ```bash
    kubectl port-forward svc/knfolio-service 3000:3000 -n folio
    curl http://localhost:3000
    ```
### Access via domain (once DNS & TLS are set up):
    ```bash
    curl https://knfolio.dev
    ```

## Updating the App
### New image (`:latest`)
Simply restart the Deployment:
```bash
kubectl rollout restart deployment knfolio -n folio
```

### Update secrets
Re-run the secret creation command with new values:
```bash
kubectl -n folio create secret generic knfolio-secerts \
    --from-literal=EMAIL_USER='...' \
    --from-literal=EMAIL_PASS='...' \
    --from-literal=RECIPIENT_EMAIL='...' \
    --dry-run=client -o yaml | kubectl apply -f -
```
Then restart:
```bash
kubectl rollout restart deployment knfolio -n folio
```

## Scaling
To scale replicas:
```bash
kubectl scale deployment knfolio -n folio --replicas=3
```
(Replica count can also be managed via Helm values.)

## Notes
- Secrets are intentionally **excluded from Helm** and **not committed**
- TLS is handled by cert-manager using `knfolio-tls`
- Ingress routing depends on the `nginx` ingress class
- This setup is compatible with future migration to HPA or MetalLB
