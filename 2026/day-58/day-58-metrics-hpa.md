# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)

## Task
Yesterday you set resource requests and limits. Today you put that to work. Install the Metrics Server so Kubernetes can see actual resource usage, then set up a Horizontal Pod Autoscaler that scales your app up under load and back down when things calm down.

---

## Expected Output
- Metrics Server installed and `kubectl top` returning data
- An HPA that auto-scales pods under load
---

## Challenge Tasks

### Task 1: Install the Metrics Server
1. Check if it is already running: `kubectl get pods -n kube-system | grep metrics-server`
2. If not, install it:
   - Minikube: `minikube addons enable metrics-server`
   - Kind/kubeadm: apply the official manifest from the metrics-server GitHub releases
3. On local clusters, you may need the `--kubelet-insecure-tls` flag (never in production)
4. Wait 60 seconds, then verify: `kubectl top nodes` and `kubectl top pods -A`

![images](images/Screenshot%20from%202026-04-24%2018-38-54.png)

**Verify:** What is the current CPU and memory usage of your node?
- Current node utilization is low: CPU usage is 0% and memory usage is 0–4% across nodes.

---

### Task 2: Explore kubectl top
1. Run `kubectl top nodes`, `kubectl top pods -A`, `kubectl top pods -A --sort-by=cpu`
2. `kubectl top` shows real-time usage, not requests or limits — these are different things
3. Data comes from the Metrics Server, which polls kubelets every 15 seconds

![images](images/Screenshot%20from%202026-04-24%2021-03-14.png)

**Verify:** Which pod is using the most CPU right now?

- `kube-apiserver-devops-cluster-control-plane` Pod using the most CPU right now
---

### Task 3: Create a Deployment with CPU Requests
1. Write a Deployment manifest using the `registry.k8s.io/hpa-example` image (a CPU-intensive PHP-Apache server)
2. Set `resources.requests.cpu: 200m` — HPA needs this to calculate utilization percentages
3. Expose it as a Service: `kubectl expose deployment php-apache --port=80`

Without CPU requests, HPA cannot work — this is the most common HPA setup mistake.

![images](images/Screenshot%20from%202026-04-24%2021-31-33.png)

**Verify:** What is the current CPU usage of the Pod?
- current CPU usage is 1m (millicore)

| Value   | Meaning             |
| ------- | ------------------- |
| `1000m` | 1 full CPU core     |
| `500m`  | 0.5 CPU (half core) |
| `200m`  | 0.2 CPU             |
| `1m`    | 0.001 CPU           |

---

### Task 4: Create an HPA (Imperative)
1. Run: `kubectl autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10`
2. Check: `kubectl get hpa` and `kubectl describe hpa php-apache`
3. TARGETS may show `<unknown>` initially — wait 30 seconds for metrics to arrive

This scales up when average CPU exceeds 50% of requests, and down when it drops below.

![images](images/Screenshot%20from%202026-04-24%2021-38-55.png)

**Verify:** What does the TARGETS column show?
- `TARGETS` column shows current CPU utilization compared to the target utilization (50%).


---

### Task 5: Generate Load and Watch Autoscaling
1. Start a load generator: `kubectl run load-generator --image=busybox:1.36 --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://php-apache; done"`
2. Watch HPA: `kubectl get hpa php-apache --watch`
3. Over 1-3 minutes, CPU climbs above 50%, replicas increase, CPU stabilizes
4. Stop the load: `kubectl delete pod load-generator`
5. Scale-down is slow (5-minute stabilization window) — you do not need to wait

![images](images/Screenshot%20from%202026-04-24%2022-45-19.png)

### Image 1 - ( HPA Scaling UP)
- HPA detected high CPU utilization (up to ~479%) and automatically scaled the deployment from 1 to 10 replicas to handle increased load.
    - Demonstrates rapid scale-up behavior of HPA under heavy CPU load.


![images](images/Screenshot%20from%202026-04-24%2022-54-30.png)

### Image 2 - (HPA Scaling Down)
- After load was removed, CPU utilization dropped to 0% and HPA gradually scaled the deployment down from 10 replicas back to 1, respecting the stabilization window.
    - Demonstrates controlled scale-down behavior of HPA after load reduction.
#### HPA scaled up quickly but scaled down slowly due to the default stabilization window (~5 minutes), preventing rapid fluctuations.

**Verify:** How many replicas did HPA scale to under load?
- It scaled to max=10 replicas under load.

---

### Task 6: Create an HPA from YAML (Declarative)
1. Delete the imperative HPA: `kubectl delete hpa php-apache`
2. Write an HPA manifest using `autoscaling/v2` API with CPU target at 50% utilization
3. Add a `behavior` section to control scale-up speed (no stabilization) and scale-down speed (300 second window)
4. Apply and verify with `kubectl describe hpa`

`autoscaling/v2` supports multiple metrics and fine-grained scaling behavior that the imperative command cannot configure.

![images](images/Screenshot%20from%202026-04-24%2023-08-02.png)

**Verify:** What does the `behavior` section control?
- The behavior section controls how the HPA scales pods up and down.
- `Stabilization window`: how long to wait before scaling up or down
- `Policies`: limit how many pods can be added or removed
- `Percent`: scale based on percentage
- `Pods`: scale by a fixed number
- `periodSeconds`: minimum time between scaling actions

#### The behavior section controls how quickly the HPA scales up and how slowly it scales down, including stabilization delays and scaling limits.

### scaleUp
`stabilizationWindowSeconds: 0`

- No delay → scale immediately

`value: 100
periodSeconds: 15`

- Can double replicas every 15 seconds

### scaleDown
`stabilizationWindowSeconds: 300`

- Wait 5 minutes before scaling down

- Prevents instability
---

### Task 7: Clean Up
Delete the HPA, Service, Deployment, and load-generator pod. Leave the Metrics Server installed.

![images](images/Screenshot%20from%202026-04-24%2023-17-28.png)

- Successfully cleaned up all application resources including Deployment, Service, HPA, and load generator, while keeping the Metrics Server running for future autoscaling tasks.
---

## Documentation

### What the Metrics Server is and why HPA needs it

- The Metrics Server is a cluster-wide component that collects real-time CPU and memory usage from kubelets running on each node and exposes it through the Kubernetes Metrics API.

- The Horizontal Pod Autoscaler (HPA) depends on the Metrics Server to make scaling decisions. Without it, Kubernetes cannot determine actual resource usage, and HPA will show <unknown> for metrics and will not function.

### How HPA calculates desired replicas
- HPA calculates the number of required replicas based on the ratio of current resource usage to the target utilization.

- The formula used is:


desiredReplicas = ceil(currentReplicas * (currentUsage / targetUsage))
- Where:

    - currentUsage = current CPU usage of pods
    - targetUsage = desired CPU utilization (e.g., 50%)
    - currentReplicas = existing number of pods

If usage exceeds the target, HPA increases replicas. If usage falls below the target, HPA reduces replicas (with a stabilization delay).


### The difference between `autoscaling/v1` and `v2`

| Feature                  | autoscaling/v1  | autoscaling/v2           |
| ------------------------ | --------------- | ------------------------ |
| CPU-based scaling        | ✅ Supported     | ✅ Supported              |
| Memory scaling           | ❌ Not supported | ✅ Supported              |
| Custom metrics           | ❌ Not supported | ✅ Supported              |
| Multiple metrics         | ❌ No            | ✅ Yes                    |
| Scaling behavior control | ❌ No            | ✅ Yes (`behavior` field) |
| Production usage         | Limited         | Recommended              |

The autoscaling/v2 API is preferred in real-world environments because it supports multiple metrics and allows fine-grained control over scaling behavior, including scale-up and scale-down policies.

---
## Hints
- HPA requires `resources.requests` — without them TARGETS shows `<unknown>`
- `kubectl top` = actual usage. `kubectl describe pod` = configured requests/limits
- HPA checks every 15 seconds. Scale-up is fast, scale-down has a 5-minute stabilization window
- `autoscaling/v1` = CPU only. `autoscaling/v2` = CPU + memory + custom metrics
- Formula: `desiredReplicas = ceil(currentReplicas * (currentUsage / targetUsage))`
- HPA works with Deployments, StatefulSets, and ReplicaSets

---

## Documentation
Create `day-58-metrics-hpa.md` with:
- What the Metrics Server is and why HPA needs it
- How HPA calculates desired replicas
- The difference between `autoscaling/v1` and `v2`
