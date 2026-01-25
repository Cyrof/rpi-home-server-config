# Wake-on-Lan (WOL) Service

This directory contains the Helm chart and deployment configuration for the Wake-onLAN (WOL) service running on the Cyrostack k3s cluster.

The service exposes a small HTTP UI and API that allows you to wake devices on the local network by sending a Wake-on-LAN magic packet.

It is designed for internal access only (LAN/VPN) and is exposed through the cluster's NGINX Ingress Controller.

## Key Design Decisions

- Helm-based deployment (no raw manifests)
- Ingress + NodePort (no public exposure)
- DNS handled by Pi-hole
- No secrets committed to Git
- MAC addresses are OK
- Optional token auth exiists in code but is disabled in Helm by default

## DNS Configuration (Pi-hole)

The WOL service is accessed via the cluster ingress node.

### Required Pi-hole entry:

```bash
wol.cyrostack.arpa -> <ingress-node-ip>
```

**Notes**:

- `<ingress-node-ip>` must be a node running the NGINX ingress controller
- The service is accessed via the NodePort (default: `32080`)
- This setup is intended for LAN / VPN access only

## Accessing the Service

Once deployed,access the UI at:

```bash
http://wol.cyrostack.arpa:32080
```

Health check endpoint:

```bash
http://wol.cyrostack.arpa:32080/healthz
```

## Helm deployment

### Install / Upgrade

```bash
helm upgrade --install wol ./wol-server -n wol --create-namespace
```

### Verify

```bash
kubectl get all -n wol
kubectl  get ingress -n wol
```

## Authentication Token (Optional)

The application supports an optional auth token via the `X-Auth-Token` header.

### Current setup:

- Token exists in code
- Token not enabled via Helm
- Access is restricted by:
    - LAN access
    - VPN access
    - Np public exposure

If you later want to enable it:

- Inject `TOKEN` via:
    - Kubernetes Secret
    - `values.yaml` -> `env`
    - External secret manager
