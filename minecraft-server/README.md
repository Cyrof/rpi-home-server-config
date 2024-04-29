# Minecraft Server Deployment Configuration

This folder contains configuration files for deploying and managing a Minecraft server on Kubernetes.

## Files Included:

1. [**mc-deploy.yaml**](https://github.com/Cyrof/rpi-home-server-config/blob/main/minecraft-server/mc-deploy.yaml): Deployment configuration for the Minecraft server.
2. [**mc-pvc.yaml**](https://github.com/Cyrof/rpi-home-server-config/blob/main/minecraft-server/mc-pvc.yaml): PersistentVolumeClaim (PVC) configuration for storing Minecraft server data.
3. [**nodeport.yaml**](https://github.com/Cyrof/rpi-home-server-config/blob/main/minecraft-server/nodeport.yaml): Service configuration for exposing the Minecraft server using NodePort.
4. [**test-pod.yaml**](https://github.com/Cyrof/rpi-home-server-config/blob/main/minecraft-server/test-pod.yaml): Pod configuration for accessing data in the PVC temporarily.
5. [**mc-pvc-backup.yaml**](https://github.com/Cyrof/rpi-home-server-config/blob/main/minecraft-server/mc-pvc-backup.yaml) PersistentVolumeClaim (PVC) configuration for Minecraft serverr backups

## Usage:

To deploy the Minecraft server and associated resources. Apply the files within this folder by substituting this the `<file_name>` with the name of the file to deploy.

```bash
$ kubectl apply -f <file_name> 
```

## Notes:

- Make suure to adjust the configurations values in the YAML files according to your requirements before applying them.
- Ensure that your have necessary permissions to create and manage resources in the specified namespace.
- Refer to the individual YAML files for detailed comments explaining each configuration.

For any issues or further assistance, please refer to the [Kubernetes documentaion](https://kubernetes.io/docs/home/) or consult with your Kubernetes adminstrator.