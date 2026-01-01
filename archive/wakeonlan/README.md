# Wake-on-LAN Configuration 

This folder contains the configurtion files for setting up Wake-on-LAN functionality on the Raspberry Pi home server. Wake-on-LAN allows users to remotely wake up their main PC from a low-power state using a network packet.

## Configuration Files

1. **`wol-secrets.yaml`**
   - **Purpose:** This file contains sensitive information such as MAC address and broadcast IP used for Wake-on-LAN.
   - **Action Required:**
     - Users should update the encoded variables in the `MAC` and `BROADCAST` fields with their specific values.
     - Refer to the [Secrets](https://github.com/Cyrof/rpi-home-server-config/blob/main/wakeonlan/wol-secrets.yaml) folder for guidance on updating encoded variables.
2. **`wol-nodeport.yaml`**
   - **Purpose:** This file configures the NodePort for accessing the Wake-on-LAN service externally.
   - **Action Required:**
     - Users should update the port numbers as needed for their setup.
3. **`wol-deploy.yaml`**
   - **Purpose:** This file contains the deployment configuration for the Wak-on-LAN service.
   - **Action Required:**
     - Users shoud Update the port number as needed for their setup.

## Additional Information 

- For more details on the image used for Wake-on-LAN, refer to [RemoteWakeServer](https://github.com/Cyrof/RemoteWakeServer) on GitHub.
- Ensure that all configurations are applied correctly using `kubectl apply -f <filename>` command after making the necessary changes.
- For further assistance or troubleshooting, please refer to the official documentation or open an issues stating the issue.
