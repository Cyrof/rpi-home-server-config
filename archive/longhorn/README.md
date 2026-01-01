# Longhorn Configuration 

This folder contains YAML configuration files for deploying Longhorn components in a Kubernetes cluster.

## Files

### `fix.yaml`

- **Description:** Defines a Longhorn Setting object for managing deletion confirmation flag.
- **Purpose:** Controls whether a confirmation prompt is required before deleting resources in Longhorn.

### `ingress.yaml`

- **Description:** Defines an Ingress resource for exposing the Longhorn frontend.
- **Purpose:** Routes incoming traffic to the Longhorn UI frontend.

### `nodeport.yaml`

- **Description:** Defines a Kubernetes Service for exposing the Longhorn UI via a NodePort.
- **Purpose:** Exposes the Longhorn UI externally through a NodePort for access from outside the Kubernestes cluster.

## Usage

1. Apply the YAML files using `kubectl apply -f <filename>` to deploy Longhorn components in your kubernetes cluster.
2. Ensure that the necessary configurations and annotations are correctly set before applying the files.
3. Monitor the deployment using `kubectl get <resource>` commands to ensure successful deployment and access to Longhorn components

## Additional Notes

- Make sure to update any placeholder values (such as namespaces, hostnames, etc.) in the YAML files according to your specific environment.
- Refer to the official [Longhorn Documentation](https://longhorn.io) for more information on configuring and managing Longhorn in Kubernetes.