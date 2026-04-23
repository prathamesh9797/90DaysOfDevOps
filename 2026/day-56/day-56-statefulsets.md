# Day 56 – Kubernetes StatefulSets

## Task
Deployments work great for stateless apps, but what about databases? You need stable pod names, ordered startup, and persistent storage per replica. Today you learn StatefulSets — the workload designed for stateful applications like MySQL, PostgreSQL, and Kafka.

---

## Expected Output
- A StatefulSet with 3 replicas and stable pod names
- DNS resolution tested for individual pods
- Data persistence verified across pod deletion
---

## Challenge Tasks

### Task 1: Understand the Problem
1. Create a Deployment with 3 replicas using nginx
2. Check the pod names — they are random (`app-xyz-abc`)
3. Delete a pod and notice the replacement gets a different random name

This is fine for web servers but not for databases where you need stable identity.

| Feature | Deployment | StatefulSet |
|---|---|---|
| Pod names | Random | Stable, ordered (`app-0`, `app-1`) |
| Startup order | All at once | Ordered: pod-0, then pod-1, then pod-2 |
| Storage | Shared PVC | Each pod gets its own PVC |
| Network identity | No stable hostname | Stable DNS per pod |

Delete the Deployment before moving on.

![images](images/Screenshot%20from%202026-04-23%2017-05-23.png)

**Verify:** Why would random pod names be a problem for a database cluster?
- Random pod names break database clusters because nodes need stable names for connections, replication, and storage.


---

### Task 2: Create a Headless Service
1. Write a Service manifest with `clusterIP: None` — this is a Headless Service
2. Set the selector to match the labels you will use on your StatefulSet pods
3. Apply it and confirm CLUSTER-IP shows `None`

A Headless Service creates individual DNS entries for each pod instead of load-balancing to one IP. StatefulSets require this.

![images](images/Screenshot%20from%202026-04-23%2017-13-47.png)

**Verify:** What does the CLUSTER-IP column show?
- CLUSTER_IP Column Show : None


---

### Task 3: Create a StatefulSet
1. Write a StatefulSet manifest with `serviceName` pointing to your Headless Service
2. Set replicas to 3, use the nginx image
3. Add a `volumeClaimTemplates` section requesting 100Mi of ReadWriteOnce storage
4. Apply and watch: `kubectl get pods -l <your-label> -w`

Observe ordered creation — `web-0` first, then `web-1` after `web-0` is Ready, then `web-2`.

Check the PVCs: `kubectl get pvc` — you should see `web-data-web-0`, `web-data-web-1`, `web-data-web-2` (names follow the pattern `<template-name>-<pod-name>`).

![images](images/Screenshot%20from%202026-04-23%2022-47-47.png)

**Verify:** What are the exact pod names and PVC names?

- Pod names : web-0 web-1 web-2
- PVC names : web-data-web-0 web-data-web-1 web-data-web-2
---

### Task 4: Stable Network Identity
Each StatefulSet pod gets a DNS name: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`

1. Run a temporary busybox pod and use `nslookup` to resolve `web-0.<your-headless-service>.default.svc.cluster.local`
2. Do the same for `web-1` and `web-2`
3. Confirm the IPs match `kubectl get pods -o wide`

![images](images/Screenshot%20from%202026-04-23%2023-10-35.png)

**Verify:** Does the nslookup IP match the pod IP?
- Yes,nslookup IP match the Pod IP


#### StatefulSet gives:
  → stable pod name (web-0)

#### Headless Service gives:
  → DNS for that name

#### Together:
  → stable identity system

---

### Task 5: Stable Storage — Data Survives Pod Deletion
1. Write unique data to each pod: `kubectl exec web-0 -- sh -c "echo 'Data from web-0' > /usr/share/nginx/html/index.html"`
2. Delete `web-0`: `kubectl delete pod web-0`
3. Wait for it to come back, then check the data — it should still be "Data from web-0"

The new pod reconnected to the same PVC.

![images](images/Screenshot%20from%202026-04-23%2023-19-00.png)

**Verify:** Is the data identical after pod recreation?

Yes,exactly the same

#### When POD Died
- Pod -  deleted
- PVC - still exists

#### When POD Restarted 
- New web-0 pod → reattached to SAME PVC

#### Real-world meaning

#### This is exactly how databases survive:

- MySQL pod crashes → comes back → still has data
- MongoDB restarts → still has replica data
- Kafka broker restarts → keeps logs

| Thing     | Behavior              |
| --------- | --------------------- |
| Container | destroyed & recreated |
| Pod       | recreated             |
| PVC       | **NOT deleted**       |
| Data      | **survives**          |

---

### Task 6: Ordered Scaling
1. Scale up to 5: `kubectl scale statefulset web --replicas=5` — pods create in order (web-3, then web-4)
2. Scale down to 3 — pods terminate in reverse order (web-4, then web-3)
3. Check `kubectl get pvc` — all five PVCs still exist. Kubernetes keeps them on scale-down so data is preserved if you scale back up.

![images](images/Screenshot%20from%202026-04-23%2023-30-42.png)

**Verify:** After scaling down, how many PVCs exist?
- After scaling down,5 PVCs exits

### Pods scale - up/down 
### Storage NEVER auto-deletes 

---

### Task 7: Clean Up
1. Delete the StatefulSet and the Headless Service
2. Check `kubectl get pvc` — PVCs are still there (safety feature)
3. Delete PVCs manually

![images](images/Screenshot%20from%202026-04-23%2023-45-43.png)

**Verify:** Were PVCs auto-deleted with the StatefulSet?
- PVCs are NOT auto-deleted when a StatefulSet is deleted
You must delete them manually

StatefulSet deletes compute, not data.

#### Why this happens (very important)

Kubernetes is being intentionally cautious.

Imagine:

You delete a database by mistake
If storage was auto-deleted → data loss forever

So Kubernetes says:

I will NOT delete your data unless you explicitly tell me to.

---
## Documentation
### What StatefulSets are and when to use them vs Deployments

A StatefulSet is a Kubernetes workload used for applications that require:

- Stable identity (fixed pod names)
- Persistent storage (data survives restarts)
    Ordered deployment and scaling

#### Unlike Deployments, StatefulSets are designed for stateful applications like:

Databases (MySQL, MongoDB)
Distributed systems (Kafka, Zookeeper)


### The comparison table
| Feature       | Deployment         | StatefulSet               |
| ------------- | ------------------ | ------------------------- |
| Pod names     | Random (`app-xyz`) | Stable (`web-0`, `web-1`) |
| Identity      | No fixed identity  | Fixed identity            |
| Startup order | Parallel           | Ordered                   |
| Scaling       | Parallel           | Ordered                   |
| Storage       | Shared / ephemeral | Dedicated PVC per pod     |
| DNS           | Single service IP  | Per-pod DNS               |
| Use case      | Stateless apps     | Stateful apps             |

#### When to use what?
- Use Deployment when:

1- App is stateless (e.g., nginx, frontend)

2- Pods are interchangeable

3- No need for persistent identity

- Use StatefulSet when:

1- Each pod needs a unique identity

2- Data must persist across restarts

3- Pods must start/stop in order

### How Headless Services, stable DNS, and volumeClaimTemplates work


1- StatefulSet

- Creates pods: web-0, web-1, web-2
- Each pod has a fixed identity

2- Storage (volumeClaimTemplates)

- Each pod gets its own PVC:
- web-0 -> web-data-0
- web-1 -> web-data-1
- web-2 -> web-data-2

3- Headless Service

- Exposes each pod individually

4- DNS

- Each pod gets a stable DNS:

    - web-0.web-headless -> Pod IP
    - web-1.web-headless -> Pod IP
    - web-2.web-headless -> Pod IP

#### How it works

StatefulSet creates pods with fixed names

Headless Service creates DNS entries

DNS maps → pod name → pod IP

---

## Hints

- `kubectl get sts` is the short name for StatefulSets
- `serviceName` must match an existing Headless Service
- Pod DNS: `<pod-name>.<service-name>.<namespace>.svc.cluster.local`
- PVC naming: `<template-name>-<statefulset-name>-<ordinal>`
- Pods create in order (0, 1, 2) and terminate in reverse (2, 1, 0)
- Scaling down does not delete PVCs — data is preserved
- Deleting a StatefulSet does not delete PVCs — clean up separately
