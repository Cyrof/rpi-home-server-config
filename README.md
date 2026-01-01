# CyroStack

This repository documents and manages my **self-hosted Raspberry Pi Kubernetes (k3s) cluster**.
It serves as the **platform-level infrastructure repo**, covering cluster bootstrap, ingress, certificates, DNS updates, and deployed applications.

The goal of this repository is **clarity and reproducibility**:
- what runs in Kubernetes
- what runs directly on nodes 
- which Raspberry Pi handles what role 

## Cluster Overview
- **Orchestrator:** k3s
- **Hardware:** Raspberry Pi cluster
- **Networking:** Home LAN + external access via dynamic DNS
- **Ingress:** NGINX Ingress Controller
- **Certificates:** cert-manager (self-hosted)
- **Configuration Management:** Ansible 

This repository **does not** contain application source code unless it is infrastructure-related. Application logic lives in **separate repositories** and it referenced here when deployed.

## Node Layout & Roles
> IPs are partially masked intentionally.

| Node | IP Address | Role(s) |
| --- | --- | --- |
| 1 | `xxx.xxx.xxx.1` | **Control Plane (Master)** |
| 2 | `xxx.xxx.xxx.2` | **Edge / Ingress Node** |
| 3 | `xxx.xxx.xxx.3` | **DNS Node (Pi-hole)** |
| 4 | `xxx.xxx.xxx.4` | **VPN Node** |

### Role Notes 
- **Master**: runs control plane components only
- **Edge Node**: dedicated ingress & external traffic handling 
- **DNS Node**: reserved for Pi-hole / internal DNS
- **VPN Node**: Hosts WireGuard-based access into the cluster 

## Kubernetes-Deployed Components (Active)
These components are deployed **inside the k3s cluster**.

### `ansible-configs/`
- Ansible playbooks for:
    - node preparation
    - base OS configuration 
    - cluster-related automation

### `nginx`
- NGINX Ingress Controller 
- Handles all inbound HTTP/HTTPS traffic 
- Acts as the primary entry point for cluster services

### `cert-manager`
- Manages TLS certificates for internal and external services
- Used together with NGINX Ingress
- Self-hosted configuration (no cloud dependency)

### `portfolio`
- Dynamic DNS updater for Porkbun
- Automatically updates public IP when ISP/router changes IP
- Required because home IP changes frequently 

## Node-Local Services (Outside Kubernetes)

These services **run directly on specific nodes**, not as pods.

### VPN (WireGuard)
- Runs on the **VPN Node**
- Provides secure access into the home network and cluster
- Used by:
    - personal devices
    - remote access
    - cluster administrator

### DNS (Planned - Pi-hole)
- Runs  on the **DNS Node**
- Provides:
    - internal DNS resolution
    - ad-blocking
    - split-horizon DNS for cluster service

## GopherGate (WireGuard Management)

WireGuard management is handled by **GopherGate**, which is maintained in a **separate repository**.

- This repository may include GopherGate as a **git submodule**
- Helm charts and application logic live in the GopherGate repo
- This repo only documents its **integration into the cluster**

## Archived Components
Unused or paused stacks are moved into `archive/`.

This keeps the root clean while preserving history.

Example:
- Previous applications
- Experimental services
- One-off deployments

Nothing in `archive/` is considered active.

## Repository Structure
```bash
.
├── ansible-configs
├── archive
├── cert-manager
├── LICENSE
├── nginx
├── porkbun-dns-updater
├── portfolio
└── README.md
```

## Cloning This Repository 
This repository uses **git submodules**.

Clone with:
```bash
git clone --recurse-submodules https://github.com/Cyrof/CyroStack.git
```

If already cloned:
```bash
git submodule update --init --recursive
```

## Design Philosophy
- Infrastructure first, app second
- Clear separation of concerns
- Predictable node roles
- Minimal coupling between services
- Everything documented so future-me doesn't suffer
