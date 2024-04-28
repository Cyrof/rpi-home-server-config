# Raspberry Pi Home Server Configurations

This repository contains YAML configuration files for setting up services on a Raspberry Pi-based home server. These configuration are tailored for a Kubernetes cluster manage by k3s on Raspberry Pi.

## Configurations 

### Longhorn 

- **Description:** YAML configuration files for deploying Longhorn, a distributed block storage system for Kubernetes.
- **Purpose:** Provides persistent storage solutions for stateful applications running on the Kubernetes cluster.

### Nginx Ingress
- **Description:** Yaml Configuration files for deploygin NGINX Ingress Controller, which manages external access to services in the Kubernetes cluster.
- **Purpose:** Routes incoming traffic to various services deployed on the Kubernetes cluster.

### PaperMC Server 
- **Description:** Customer configurations and YAML files for deploying a PaperMC Minecraft server using the [itzy-minecraft](https://github.com/itzg/docker-minecraft-server) docker image.
- **Purpose:** Hosts a Minecraft server on the Raspberry Pi home server for gaming and entertainment purposes.

## Usage

1. Clone this repository to your local machine: 
    ```bash
    git clone https://github.com/Cyrof/rpi-home-server-config.git
    ```
2. Navigate to the desired configuration folder (e.g., 'longhorn', 'nginx', 'minecraft-server').
3. Apply the YAML files using `kubectl apply -f <filename>` to deploy the corresponding services on your kubernetes cluster.
4. Monitor the deployment using `kubectl get <resource>` commands to ensure successful deployment and access to the services.

## Additional Notes

- Ensure that your Raspberry Pi is properly configured with k3s before deploying these configurations.
- Make any necessary adjustments to the YAML files (e.g., namespaces, hostnames) to fit your specific environment.
- Refer to the offical documentaion for each service for detailed configuration options and troubleshooting.