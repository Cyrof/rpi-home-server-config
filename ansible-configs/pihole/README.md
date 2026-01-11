# Pi-hole (Node DNS) via Ansible

This folder deploys **Pi-hole** on a **specific node** as a **node-level DNS service** using **Docker + Docker Compose**.

Purpose (current phase):

- Provide **local DNS overrides** (e.g. `gophergate.knfolio.dev -> <ip>`) for LAN routing via Ingress
- Keep DHCP on the router (Deco). Pi-hole is **DNS-only**.

> Why node-level (not inside k3s)?
> DNS should remain available even if k3s is unhealthy, and avoids CoreDNS/port-53 complications.

---

## What it deploys

On the target host:

- Installs Docker Engine + `docker compose` plugin
- Creates `/opt/pihole/` with persistent volumes
- Starts Pi-hole using `docker compose up -d`
- Exposes:
    - DNS: `53/tcp`, `53/udp`
    - Admin UI: `80/tcp` (`http://<node-ip>/admin`)

---

## Prerequisites

- Ansible controller can SSH into the target node
- Target node has internet access to install Docker packages (Docker apt repo)
- Port **53** is not already bound to `0.0.0.0:53` by another service

---

## Quick start

### 1) Set inventory

Edit `inventory.ini`:

```ini
[pihole]
knode2 ansible_host=<ip> ansible_user=ubuntu
```

### 2) Run playbook

From this folder:

```bash
ansible-playbook -i inventory main.yaml
```

### 3) Access Pi-hole

- Admin UI: `http://<node_ip>/admin`
  If you don't know the password or it doesn't match what's in default:

```bash
sudo docker exec -it pihole pihole setpassword '<password>'
```

## Configure LAN DNS

In you router, set

- Primary DNS: `node_ip` (Pi-hole)
- Secondary DNS: `1.1.1.1` (fallback)
  Then reconnect a client (Wi-fi off/on) and verify queries appear in the Pi-hole dashboard

## Add local domain routes

In Pi-hole UI:

- `Local DNS -> DNS Records`
  Add records like:
- `gophergate.knfolio.dev` -> `<ingress reachable IP>` (often the edge node IP)
  Validate:

```bash
nslookup gophergate.knfolio.dev <node_ip>
```

## Variables

Defaults live in `roles/pihole/defaults/main.yaml`:

- `pihole_dir`
- `pihole_tz`
- `pihole_webpassword` (only applies on first init; prefer `pihole setpassword`)
- `pihole_upstream_dns`
- `pihole_container_dns`

## Uninstall / rollback

Stop and remove Pi-hole (on the node):

```bash
cd /opt/pihole
sudo docker compose down
sudo rm -rf /opt/pihole
```

To rollback network-wide DNS, revert router DNS to automatic/default
