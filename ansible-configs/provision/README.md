# Provisioning Playbooks

Operational provisioning utilities for Raspberry Pi / k3s nodes.

## Usage

```bash
# Check OS/arch/kernel info on all nodes
ansible-playbook -i inventory.ini provision/main.yaml --tags check

# Join new nodes to the k3s cluster
ansible-playbook -i inventory.ini provision/main.yaml --tags join
```

## Inventory groups

- `k3s_master`: control-plane nodes(s)
- `new_nodes`: machines to join as k3s agents
