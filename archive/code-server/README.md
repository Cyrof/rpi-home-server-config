# Code-Server Deployment 
This folder contains the configuration files for deploying **code-server** on my k3s cluster using Helm. The code-server allows developers to run VS Code in the browser, enabling remote development environment. 

## Deployment Overview
The **code-server** is deployed using Helm, based on the official [code-server documentation](#https://coder.com/docs/code-server/helm), but the custom modifications to use NodePort for external access.

## Deployment Instructions 
### 1. Helm Installation
To install or upgrade the code-server deployment, use the following Helm command:

``` bash
helm upgrade --install code-server ci/helm-chart -n code-server --create-namespace -f code-server/coder-nodeport.yaml
```
- **Namespace:** A new namespace `code-server` will be created during the installation. 
- **Configuration:** The deployment uses the custom `coder-nodeport.yaml` to set the service type as NodePort.

### 2. Accessing Code-Server
After deployment, retrive the code-server access password using this command: 
```bash 
echo $(kubectl get secret --namespace code-server code-server -o jsonpath="{.data.password}" | base64 --decode)
```

### 3. External Access via NodePort
The `coder-nodeport.yaml` changes the service type from ClusterIP to NodePort. There are a few ways to access the code-server externally:
- **Port Forwarding:** In this setup, port forwarding is configured through the router, allowing external access using the node's public IP and specified NodePort (`30005` in this case).
- **Ingress:** Alternatively, you can set up an ingress controller like NGINX to handle external traffic. However, this guide uses direct port forwarding for simplicity.

## Configuration File 
### 1. `coder-nodeport.yaml`
- **Purpose:** This file modifies the service configuration to use NodePort, allowing external access to code-server via a specified port. 
- **Action Required:**
    - Ensure the NodePort (`30005` or another available port) is forwarded through your router for external access.

## Additional Information
- Refer to the [code-server official documentation](https://coder.com/docs/code-server) for more information on available Helm chart configurations.
- After making any necessary changes, apply the configuration with `kubectl apply -f <filename>`.
- If you prefer using an ingress for external access, refer to the ingress documentation of your chosen controller (e.g., NGINX).