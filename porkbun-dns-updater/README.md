# Porkbun DDNS Cronjob Configuration 
This folder contains the Kubernetes manifests to run the Porkbun dynamic-DNS updater in k3s. The actual updater script likes in the `porkbun-dns/` submodule&ndash;see [porkbun-dns/README.md](https://github.com/Cyrof/Porkbun-dns) for local usage, Docker builds, and script details.

## Configuration Details
- **CronJob.schedule: `"0 7 * * *"`**
    - Runs once a day at 07:00 (SGT).
- **successfulJobsHistoryLimit: `10`**
    - Keep the last 10 successful jobs for troubleshooting.
- **failedJobsHistoryLimit: `10`**
    - Keep the last 10 failed Jobs for debugging.
- **jobTemplate.spec.ttlSecondsAfterFinished: `604800`**
    - Automatically delete jobs (and their pods) 7 days (604 800 s) after they finish.
- **restartPolicy: `OnFailure`**
    - Only retry on failure&ndash;not on success.
- **containers[0].image: `cyrof/porkbun-ddns:latest`**
    Multi-arch Docker image built form the `porkbun-dns/` submodule.
- **envFrom: secretRef: `porkbun-cred`**
    - Loads all `PORKBUN_*` environment variables from the Secret.

## Secret Details (`secret.yaml`)

Create an Opaque Secret named `porkbun-creds` in the `porkbun-ddns` namespace. It must contain:

```yaml
data:
  PORKBUN_API_KEY:     <your-base64-encoded-api-key>
  PORKBUN_API_SECRET:  <your-base64-encoded-secret>
  PORKBUN_DOMAIN:      <your-base64-encoded-domain>
  PORKBUN_SUBDOMAIN:   <base64-of-empty-or-subdomain>
  PORKBUN_TTL:         <base64-of-ttl-in-seconds>
```
> **Tip:** To supply plaintext values instead, switch `data:` -> `stringData` and drop the base64 encoding.

For more on the upodater script and its requirementsm see the submodule's README:
[porkbun-dns/README](https://github.com/Cyrof/Porkbun-dns)
    
## Installation
### 1. Create the namespace (if missing):
```bash
kubectl create namespace porkbun-ddns
```

### 2. Apply the Secret (edit `secret.yaml` first):
```bash
kubectl apply -f secret.yaml
```

### 3. Deploy the CronJob:
```bash
kubectl apply -f cronjob-dns.yaml
```

### 4. Verify:
```bash
kubectl get cronjob porkbun-ddns -n porkbun-ddns
kubectl describe cronjob porkbun-ddns -n porkbun-ddns
```

## Manual Testing
Kick off a one-off job from the CronJob:
```bash
kubectl create job manual-ddns-test \
    --from=cronjob/porkbun-ddns \
    -n porkbun-ddns

# Stream its logs
kubectl logs -f job/manual-ddns-test -n porkbun-ddns
```

## Notes
- Make sure your cluster can reach the Porkbun API `api.porkbun.com` and `api.ipify.org`.
- DNS for `PORKBUN_DOMAIN` must already point at your external IP (or updaates won't be visible).
- Adjust `schedule`, history limits, or TTL to match your policy.
