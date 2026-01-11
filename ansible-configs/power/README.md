# k3s Power & Maintenance Playbook

This playbook provides **operational lifecycle control** for a k3s cluster.
It is intended for **day-to-day maintenance**, not initial provisioning.

All actions are controlled via **tags** and executed through a single entrypoint.

## What this playbook does

- **start**
  Starts the k3s server and agents, waits for readiness, and uncordons nodes.

- **shutdown**
  Gracefully cordons and drains nodes, stops k3s services, and powers off
  workers first, then the control-place

- **update**
  Performs rolling OS package updates (`apt upgrade`) with reboots where needed,
  ensuring nodes are drained and re-added safely to the cluster.

## Inventory assumptions

- Control-plane nodes: `k3s_master`
- Worker nodes: `k3s_workers`

These can be adjusted via role defaults if needed.

## Usage

From the repository root:

```bash
# Start the cluster
ansible-playbook main.yaml --tags start

# Gracefully shut down the cluster
ansible-playbook main.yaml --tags shutdown

# Rolling OS update + reboot
ansible-playbook main.yaml --tags update
```
