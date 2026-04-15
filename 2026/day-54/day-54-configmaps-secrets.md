# Day 54 – Kubernetes ConfigMaps and Secrets

## Task
Your application needs configuration — database URLs, feature flags, API keys. Hardcoding these into container images means rebuilding every time a value changes. Kubernetes solves this with ConfigMaps for non-sensitive config and Secrets for sensitive data.

---

## Expected Output
- ConfigMaps created from literals and from a file
- Secrets created and consumed in a Pod
---

## Challenge Tasks

### Task 1: Create a ConfigMap from Literals
1. Use `kubectl create configmap` with `--from-literal` to create a ConfigMap called `app-config` with keys `APP_ENV=production`, `APP_DEBUG=false`, and `APP_PORT=8080`
2. Inspect it with `kubectl describe configmap app-config` and `kubectl get configmap app-config -o yaml`
3. Notice the data is stored as plain text — no encoding, no encryption

**Verify:** Can you see all three key-value pairs?

- Yes,all 3 key-value pairs are       visible in plain text
- No encoding, no encryption

![images](images/Screenshot%20from%202026-04-15%2009-10-36.png)
---

### Task 2: Create a ConfigMap from a File
1. Write a custom Nginx config file that adds a `/health` endpoint returning "healthy"
2. Create a ConfigMap from this file using `kubectl create configmap nginx-config --from-file=default.conf=<your-file>`
3. The key name (`default.conf`) becomes the filename when mounted into a Pod

**Verify:** Does `kubectl get configmap nginx-config -o yaml` show the file contents?

- Yes file contents are fully visible in YAML

![images](images/Screenshot%20from%202026-04-15%2009-27-41.png)
---

### Task 3: Use ConfigMaps in a Pod
1. Write a Pod manifest that uses `envFrom` with `configMapRef` to inject all keys from `app-config` as environment variables. Use a busybox container that prints the values.
2. Write a second Pod manifest that mounts `nginx-config` as a volume at `/etc/nginx/conf.d`. Use the nginx image.
3. Test that the mounted config works: `kubectl exec <pod> -- curl -s http://localhost/health`

Use environment variables for simple key-value settings. Use volume mounts for full config files.

**Verify:** Does the `/health` endpoint respond?
- Yes,/health endpoint respond

![images](images/Screenshot%20from%202026-04-15%2010-09-17.png)
---

### Task 4: Create a Secret
1. Use `kubectl create secret generic db-credentials` with `--from-literal` to store `DB_USER=admin` and `DB_PASSWORD=s3cureP@ssw0rd`
2. Inspect with `kubectl get secret db-credentials -o yaml` — the values are base64-encoded
3. Decode a value: `echo '<base64-value>' | base64 --decode`

**base64 is encoding, not encryption.** Anyone with cluster access can decode Secrets. The real advantages are RBAC separation, tmpfs storage on nodes, and optional encryption at rest.

**Verify:** Can you decode the password back to plaintext?
- Yes, decode the password back to plaintext

![images](images/Screenshot%20from%202026-04-15%2010-17-04.png)
---

### Task 5: Use Secrets in a Pod
1. Write a Pod manifest that injects `DB_USER` as an environment variable using `secretKeyRef`
2. In the same Pod, mount the entire `db-credentials` Secret as a volume at `/etc/db-credentials` with `readOnly: true`
3. Verify: each Secret key becomes a file, and the content is the decoded plaintext value

**Verify:** Are the mounted file values plaintext or base64?
- Mounted file values planintext


![images](images/Screenshot%20from%202026-04-15%2014-23-01.png)
---

### Task 6: Update a ConfigMap and Observe Propagation
1. Create a ConfigMap `live-config` with a key `message=hello`
2. Write a Pod that mounts this ConfigMap as a volume and reads the file in a loop every 5 seconds
3. Update the ConfigMap: `kubectl patch configmap live-config --type merge -p '{"data":{"message":"world"}}'`
4. Wait 30-60 seconds — the volume-mounted value updates automatically
5. Environment variables from earlier tasks do NOT update — they are set at pod startup only

**Verify:** Did the volume-mounted value change without a pod restart?
- Yes, the volume-mounted value does change without restarting the Pod.

![images](images/Screenshot%20from%202026-04-15%2014-48-10.png)

#### What just happened (THIS is the concept)

- Your Pod was NOT restarted
- But the file inside container changed automatically

Because:

-  ConfigMap is mounted as a volume
- Kubernetes refreshes mounted files periodically
- Your loop keeps reading the file every 5 seconds

---

## Hints
- `--from-literal=KEY=VALUE` for command-line values, `--from-file=key=filename` for file contents
- `envFrom` injects all keys; `env` with `valueFrom` injects individual keys
- `echo -n 'value' | base64` — always use `-n` to avoid encoding a trailing newline
- Volume-mounted ConfigMaps/Secrets auto-update; environment variables do not
- `kubectl get secret <name> -o jsonpath='{.data.KEY}' | base64 --decode` extracts and decodes a value

---

## Documentation

###  What ConfigMaps and Secrets are and when to use each
- ConfigMaps

ConfigMaps are used to store non-sensitive configuration data in key-value format.

- When to use:

    - Environment variables (e.g., APP_ENV, PORT)
    - Feature flags

    - Application configuration files (e.g., Nginx config)

- Example:

    - APP_ENV=production
    - APP_DEBUG=false

### Secrets

- Secrets are used to store sensitive data such as:

    - Passwords
    - API keys
    - Tokens

- When to use:
    - Database credentials
    - Authentication tokens
    - Private keys

- Example:

    - DB_USER=admin
    - DB_PASSWORD=s3cureP@ssw0rd
### The difference between environment variables and volume mounts



### Why base64 is encoding, not encryption

- Kubernetes stores Secrets in base64 encoded format.

- Example:

    - admin → YWRtaW4=

- Important:
    - Base64 is NOT secure
    - It is easily reversible:

    - echo 'YWRtaW4=' | base64 --decode
→ admin

- Meaning:

    - Base64 is just encoding (like formatting), not protection
### How ConfigMap updates propagate to volumes but not env vars


#### Volume-mounted ConfigMaps
- Automatically updated inside the container
- Takes ~30–60 seconds
- No pod restart required

    - Example:
hello → world (updated live)

#### Environment Variables
- Set only at pod startup
- Do NOT change automatically
- Require pod restart to update

#### Final Takeaways
- Use ConfigMaps for non-sensitive data
- Use Secrets for sensitive data
- Secrets are base64 encoded, not encrypted
- Use env vars for simple configs
- Use volume mounts for dynamic configs
- ConfigMap updates:
    - Work with volumes
    - Do NOT work with env variables

    One-line Summary

#### ConfigMaps and Secrets separate configuration from code, making applications flexible, secure, and easier to manage in Kubernetes.
---
