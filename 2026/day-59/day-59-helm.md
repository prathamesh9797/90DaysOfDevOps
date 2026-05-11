# Day 59 – Helm — Kubernetes Package Manager

## Task
Over the past eight days you have written Deployments, Services, ConfigMaps, Secrets, PVCs, and more — all as individual YAML files. For a real application you might have dozens of these. Helm is the package manager for Kubernetes, like apt for Ubuntu. Today you install charts, customize them, and create your own.

---

## Expected Output
- Helm installed and a chart deployed from Bitnami
- A release customized, upgraded, and rolled back
- A custom chart created and installed
---

## Challenge Tasks

### Task 1: Install Helm
1. Install Helm (brew, curl script, or chocolatey depending on your OS)
2. Verify with `helm version` and `helm env`

Three core concepts:
- **Chart** — a package of Kubernetes manifest templates
- **Release** — a specific installation of a chart in your cluster
- **Repository** — a collection of charts (like a package repo)

**Verify:** What version of Helm is installed?
- Version : v4.1.3

![images](images/Screenshot%20from%202026-05-08%2009-22-06.png)
---

### Task 2: Add a Repository and Search
1. Add the Bitnami repository: `helm repo add bitnami https://charts.bitnami.com/bitnami`
2. Update: `helm repo update`
3. Search: `helm search repo nginx` and `helm search repo bitnami`

**Verify:** How many charts does Bitnami have?

![images](images/Screenshot%20from%202026-05-08%2009-57-43.png)


![images](images/Screenshot%20from%202026-05-08%2009-58-56.png)
---

### Task 3: Install a Chart
1. Deploy nginx: `helm install my-nginx bitnami/nginx`

![images](images/Screenshot%20from%202026-05-08%2010-01-28.png)

2. Check what was created: `kubectl get all`

![images](images/Screenshot%20from%202026-05-08%2010-02-49.png)

3. Inspect the release: `helm list`, `helm status my-nginx`, `helm get manifest my-nginx`

- `helm list` :- Lists all Helm releases in the current namespace

![images](images/Screenshot%20from%202026-05-08%2010-04-09.png)

- `helm status my-nginx ` Shows the current status (deployed, failed, etc.) of the my-nginx

![images](images/Screenshot%20from%202026-05-08%2010-10-33.png)

`helm get manifest my-nginx` Displays the Kubernetes YAML manifests generated for the my-nginx release

![images](images/Screenshot%20from%202026-05-08%2010-12-36.png)


One command replaced writing a Deployment, Service, and ConfigMap by hand.

**Verify:** How many Pods are running? What Service type was created?
- One pod is running, LoadBalancer service type is created.
---

### Task 4: Customize with Values
1. View defaults: `helm show values bitnami/nginx`
2. Install a custom release with `--set replicaCount=3 --set service.type=NodePort`

![images](images/Screenshot%20from%202026-05-10%2010-14-36.png)

![images](images/Screenshot%20from%202026-05-10%2010-15-37.png)

3. Create a `custom-values.yaml` file with replicaCount, service type, and resource limits
4. Install another release using `-f custom-values.yaml`

![images](images/Screenshot%20from%202026-05-10%2010-20-07.png)

![images](images/Screenshot%20from%202026-05-10%2010-23-24.png)

5. Check overrides: `helm get values <release-name>`

![images](images/Screenshot%20from%202026-05-10%2010-26-02.png)

**Verify:** Does the values file release have the correct replicas and service type?
- Yes
---

### Task 5: Upgrade and Rollback
1. Upgrade: `helm upgrade my-nginx bitnami/nginx --set replicaCount=5`

![images](images/Screenshot%20from%202026-05-10%2010-33-54.png)

2. Check history: `helm history my-nginx`
3. Rollback: `helm rollback my-nginx 1`
4. Check history again — rollback creates a new revision (3), not overwriting revision 2

![images](images/Screenshot%20from%202026-05-10%2010-39-40.png)

Same concept as Deployment rollouts from Day 52, but at the full stack level.

Helm maintains a revision history for every release, allowing safe upgrades and instant rollbacks without losing previous configurations.

**Verify:** How many revisions after the rollback?
- 3 revisions
---

### Task 6: Create Your Own Chart
1. Scaffold: `helm create my-app`
2. Explore the directory: `Chart.yaml`, `values.yaml`, `templates/deployment.yaml`

![images](images/Screenshot%20from%202026-05-10%2010-45-07.png)

![images](images/Screenshot%20from%202026-05-10%2010-47-35.png)

3. Look at the Go template syntax in templates: `{{ .Values.replicaCount }}`, `{{ .Chart.Name }}`

![images](images/Screenshot%20from%202026-05-10%2010-51-36.png)

4. Edit `values.yaml` — set replicaCount to 3 and image to nginx:1.25
5. Validate: `helm lint my-app`

![images](images/Screenshot%20from%202026-05-10%2010-56-59.png)

![images](images/Screenshot%20from%202026-05-10%2010-59-55.png)

6. Preview: `helm template my-release ./my-app`
7. Install: `helm install my-release ./my-app`
8. Upgrade: `helm upgrade my-release ./my-app --set replicaCount=5`

![images](images/Screenshot%20from%202026-05-10%2011-27-24.png)

![images](images/Screenshot%20from%202026-05-10%2011-28-17.png)

**Verify:** After installing, 3 replicas? After upgrading, 5?
- yes

A Helm chart is a reusable, parameterized Kubernetes application that can be installed, customized, and upgraded dynamically.
---

### Task 7: Clean Up
1. Uninstall all releases: `helm uninstall <name>` for each
2. Remove chart directory and values file
3. Use `--keep-history` if you want to retain release history for auditing

**Verify:** Does `helm list` show zero releases?
- yes

![images](images/Screenshot%20from%202026-05-10%2011-34-41.png)
---
## Documentation

#### What Helm is and the three core concepts
- Helm package manager for Kubernetes applications includes templating and lifecycle management functionality.
- It is a package manager for Kubernetes manifests (such as Deployments, ConfigMaps, Services, etc.)
- `Three core concepts:`
    - `Chart` — a package of Kubernetes manifest templates
    - `Release` — a specific installation of a chart in your cluster
    - `Repository` — a collection of charts (like a package repo)
    
#### How to install, customize, upgrade, and rollback
1. `Install`

helm install my-app ./my-chart

`With Custom Values`

helm install my-app ./my-chart -f values.yaml

2. `Customize`

`Method 1: values.yaml`

```yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.25"
```

`Method 2: CLI Override`

```bash
helm install my-app ./my-chart \
  --set replicaCount=5 \
  --set image.tag=latest
```

3. `upgrade`

```helm upgrade my-app ./my-chart -f values.yaml```

Helm tracks changes and applies only diffs.

4. `Rollback`

```helm rollback my-app 1```

`Check revisions:`

```helm history my-app```

#### The structure of a Helm chart and how Go templating works

```text
nginx-chart/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── _helpers.tpl
│   └── ingress.yaml
└── .helmignore
```
`Chart.yaml` metadata

`values.yaml` (default config) This is where all configurable variables live.

`templates/` Contains Kubernetes manifests with Go templating

`charts/` Used for dependencies (subcharts)

`Go templating in Helm`
- Helm uses Go-based templates to turn parameterized files into valid Kubernetes YAML.

- Placeholders inside {{ ... }} are replaced with actual values during rendering.

- Configuration values are sourced from:

    - Default values.yaml
    - User-provided files via -f
    - Command-line overrides using --set
- This allows the same chart to be reused across environments with different configurations.


#### Your `custom-values.yaml` with explanations
```yaml
# Number of pod replicas to run (scaling)
replicaCount: 3 

service:
  type: NodePort  # Exposes service externally via <NodeIP>:<NodePort>
  port: 80        # Internal service port inside the cluster

resources:
  requests:
    cpu: "100m"     # Minimum CPU guaranteed
    memory: "128Mi" # Minimum memory guaranteed
  limits:
    cpu: "250m"     # Max CPU allowed
    memory: "256Mi" # Max memory allowed
```
---

## Hints
- `helm show values <chart>` — see what you can customize
- `--set key=value` for single overrides, `-f values.yaml` for files
- Nested values use dots: `--set service.type=NodePort`
- `helm get values <release>` shows overrides, `--all` for everything
- `helm template` renders without installing — great for debugging
- `helm lint` validates chart structure before installing
- Templates: `{{ .Values.key }}`, `{{ .Chart.Name }}`, `{{ .Release.Name }}`

---
