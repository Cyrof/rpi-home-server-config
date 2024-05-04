# Coffee review website configurations ☕

This folder container Kubernetes configurations files for deploying and managing the [Coffee Review Website application](https://github.com/Cyrof/coffee-review).

## Files:
1. **coffee-deploy.yaml**
This YAML file defines a StatefulSet for deploying the Coffee Review Website backend. It specifies the Docker image to use, ports to expose, and other configurations.

2. **coffee-nodeport.yaml**
The `coffee-nodeport.yaml` file defines a Kubernetes Service of type NodePort to expose the backend of the Coffee Review Website. It specifies the port mappings and selector to route traffic to the backend pods.

3. **coffee-ingress.yaml**
The `coffee-ingress.yaml` file defines an ingress resoucre for the Coffee Review Website. It specifies routing rules to direct traffic from a specific hostname to the backend service.

## Usage: 
To deploy the Coffee Review Website application using these configurations files: 
```bash
$ kubectl apply -f <filename> 
```