# Cert-Manager Deployment Configuration 
This folder contains everything you need to install cert-mangaer into your k3s cluster (with nginx-ingress) and provision a Let's Encrypt **ClusterIssuer** (`letsencrypt-html01`) via HTTP-01.

## Configuration Details
- **cert-manager version**: v1.11.3
- **CRDs**
    - Deploys all cert-manager CustomResourceDefinitions (Certificates, Issuer, ClusterIssuer, Challenge, Order, etc.)
- **ClusterIssuer** (`letsencrypt-html01`)
    - **ACME server**: `https://acme-v02.api.letsencrypt.ord/directory` (production)
    - **Email**: Your contact for expiration notices
    - **Private key secret**: stored in `letsencrypt-html01-account-key`
    - **Solver**: HTTP-01 via your nginx ingress (uses `ingressClassName: nginx`)

## Installation 
1. **Apply cert-manager CRDs**
    ```bash 
    kubectl apply \
        --validation=false \
        -f https://github.com/cert-manager/cert-manager/releases/download/v1.11.3/cert-manager.crds.yaml
    ```
2. **Add the Jetstack Helm repo & update**
    ```bash
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    ```
3. **Install cert-manager**
    ```bash 
    helm install cert-manager jetstack/cert-manager \
        --namespace cert-manager --create-namespace \
        --version v1.11.3
    ```
    > **Verify** pods are running: 
    ```bash 
    kubectl get pods -n cert-manager
    ```
4. **Deploy your ClusterIssuer**
    - Ensure `cluster-issuer.yaml` (in this folder) is configured with your email.
    - Apply it **into** the cert-manager namespace (namespace field in a ClusterIssuer is ignored, but helps keep things organised):
    ```bash
    kubectl apply -f cluster-issuer.yaml -n cert-manager
    ```
    - Confirm it's ready: 
    ```bash
    kubectl get clusterissuer letsencrypt-http01
    ```

## Usage
1. **Annotate your Ingress**
    ```bash
    metadata:
        annotations:
            cert-manager.io/cluster-issuer: letsencrypt-http01
    spec:
        tls:
            - hosts:
                - your.domain.tld
              secretName: your-tls-secret
        rules:
            - host: your.domain.tld
              http: ...
    ```
2. **Apply** the Ingress and watch cert-manager spin up a Certificate & Secret:
    ```bash 
    kubectl describe certificate your-tls-secret -n <your-namespace>
    ```
3. **Test** via HTTPS:
    ```bash 
    curl -v https://your.domain.tld
    ```

## Notes
- You can swap the ACME **server** to the staging endpoint (https://acme-staging-v02.api.letsencrypt.org/directory) during testing &ndash; just update your `cluster-issuer.yaml`.
- For wildcard certificates or DNS-01 challenges, you'd configure a DNS-01 solver (e.g., Porkbun API) instead of HTTP-01.
- cert-manager will automatically renew certificates before expiry &ndash; no manual interventions needed once set up.
