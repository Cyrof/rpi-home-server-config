# Nginx Deployment Configuration

## Additional Configuration (values.yaml)

This folder contains a customer 'values.yaml' file used to configure the Nginx deployment.

### Configuration Details: 

- **controller.service.loadBalancerIP:** Specifies the IP address for the load balancer associated with the Nginx controller service.

### Usage: 

To deploy Nginx with these custom configurations, use Helm and provide the 'values.yaml' file: 

```bash 
$ helm install nginx stable/nginx-ingress -f values.yaml
```

### Notes:

This README provides a simple overview of the purpose of the 'values.yaml' file and how it can be used to configure the Nginx deployment. Feel free to adjust it further to fit your needs!