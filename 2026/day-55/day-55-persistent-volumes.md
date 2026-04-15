# Day 55 – Persistent Volumes (PV) and Persistent Volume Claims (PVC)

## Task
Containers are ephemeral — when a Pod dies, everything inside it disappears. That is a serious problem for databases and anything that needs to survive a restart. Today you fix this with Persistent Volumes and Persistent Volume Claims.

---

## Expected Output
- Data loss demonstrated with an ephemeral Pod
- A PV and PVC created, bound, and data persisting across Pod deletions

---

## Challenge Tasks

### Task 1: See the Problem — Data Lost on Pod Deletion
1. Write a Pod manifest that uses an `emptyDir` volume and writes a timestamped message to `/data/message.txt`
2. Apply it, verify the data exists with `kubectl exec`
3. Delete the Pod, recreate it, check the file again — the old message is gone

**Verify:** Is the timestamp the same or different after recreation?
- Yes,timstamp is different after recreation


![images](images/Screenshot%20from%202026-04-15%2017-49-43.png)
---

### Task 2: Create a PersistentVolume (Static Provisioning)
1. Write a PV manifest with `capacity: 1Gi`, `accessModes: ReadWriteOnce`, `persistentVolumeReclaimPolicy: Retain`, and `hostPath` pointing to `/tmp/k8s-pv-data`
2. Apply it and check `kubectl get pv` — status should be `Available`

Access modes to know:
- `ReadWriteOnce (RWO)` — read-write by a single node
- `ReadOnlyMany (ROX)` — read-only by many nodes
- `ReadWriteMany (RWX)` — read-write by many nodes

`hostPath` is fine for learning, not for production.

**Verify:** What is the STATUS of the PV?
- Status of the PV is Available


![images](images/Screenshot%20from%202026-04-15%2017-54-06.png)

---

### Task 3: Create a PersistentVolumeClaim
1. Write a PVC manifest requesting `500Mi` of storage with `ReadWriteOnce` access
2. Apply it and check both `kubectl get pvc` and `kubectl get pv`
3. Both should show `Bound` — Kubernetes matched them by capacity and access mode

**Verify:** What does the VOLUME column in `kubectl get pvc` show?
- The VOLUME column in kubectl get pvc shows the name of the PersistentVolume (PV) that the PersistentVolumeClaim (PVC) is bound to.

![images](images/Screenshot%20from%202026-04-15%2018-02-13.png)
---

### Task 4: Use the PVC in a Pod — Data That Survives
1. Write a Pod manifest that mounts the PVC at `/data` using `persistentVolumeClaim.claimName`
2. Write data to `/data/message.txt`, then delete and recreate the Pod
3. Check the file — it should contain data from both Pods

**Verify:** Does the file contain data from both the first and second Pod?
- Yes, the file contains data from both the first and second pods.

![images](images/Screenshot%20from%202026-04-15%2018-09-08.png)

---

### Task 5: StorageClasses and Dynamic Provisioning
1. Run `kubectl get storageclass` and `kubectl describe storageclass`
2. Note the provisioner, reclaim policy, and volume binding mode
3. With dynamic provisioning, developers only create PVCs — the StorageClass handles PV creation automatically

**Verify:** What is the default StorageClass in your cluster?
- default StorageClass is Standard

![images](images/Screenshot%20from%202026-04-15%2018-13-13.png)

- #### Default StorageClass:
standard This is the automatically used storage when no class is specified in a PVC
- ####  Provisioner:
rancher.io/local-path Uses local node storage to create volumes
- #### Reclaim Policy:
Delete Storage is deleted automatically when the PVC is deleted
- #### Volume Binding Mode: 
WaitForFirstConsumer Volume is created only when a Pod actually uses it

---

### Task 6: Dynamic Provisioning
1. Write a PVC manifest that includes `storageClassName: standard` (or your cluster's default)
2. Apply it — a PV should appear automatically in `kubectl get pv`
3. Use this PVC in a Pod, write data, verify it works

**Verify:** How many PVs exist now? Which was manual, which was dynamic?

2 PVs exist now 

- Manual PV → pv-demo
You created this yourself in Task 2 (using hostPath)

- Dynamic PV → pvc-< random-id >
Automatically created by Kubernetes using the standard StorageClass (rancher.io/local-path)

![images](images/Screenshot%20from%202026-04-15%2018-28-59.png)

#### Quick Recognition Trick
- Named by you → Manual (pv-demo)
- Random long name → Dynamic (pvc-xxxxx)
---

### Task 7: Clean Up
1. Delete all pods first
2. Delete PVCs — check `kubectl get pv` to see what happened
3. The dynamic PV is gone (Delete reclaim policy). The manual PV shows `Released` (Retain policy).
4. Delete the remaining PV manually

**Verify:** Which PV was auto-deleted and which was retained? Why?
#### Auto-deleted PV: -  pvc-c38b41fd-2e97-4179-bf0b-bfe5dd2399a9

- Why:-    It was dynamically provisioned and had a Reclaim Policy = Delete, so Kubernetes automatically deletes the PV when the associated PVC is deleted.

#### Retained PV: pv-demo

- Why:-  It was manually created and had a Reclaim Policy = Retain, so Kubernetes keeps the PV even after the PVC is deleted to prevent accidental data loss.

## PersistentVolume Reclaim Policy Behavior

| PV Type    | Reclaim Policy | Behavior After PVC Delete |
|------------|----------------|---------------------------|
| Dynamic PV | Delete         | Automatically deleted     |
| Manual PV  | Retain         | Remains in `Released` state |

---

## Hints
- PVs are cluster-wide (not namespaced), PVCs are namespaced
- PV status: `Available` -> `Bound` -> `Released`
- If a PVC stays `Pending`, check for matching capacity and access modes
- `hostPath` data is lost if the Pod moves to a different node
- `storageClassName: ""` disables dynamic provisioning
- Reclaim policies: `Retain` (keep data) vs `Delete` (remove data)

---

## Documentation
### Why containers need persistent storage
Containers are **ephemeral by design**. When a container (or Pod) is deleted or restarted, any data stored inside it is lost.

This creates problems for:
- Databases (MySQL, PostgreSQL)
- Logs
- User uploads
- Application state

To solve this, Kubernetes provides **persistent storage** so data can:
- Survive Pod restarts
- Be reused by new Pods
- Be managed independently of container lifecycle
---
### What PVs and PVCs are and how they relate
Kubernetes separates **storage** from **consumption** using two objects:

#### PersistentVolume (PV)
- Represents actual storage (disk, cloud volume, etc.)
- Created by admins or dynamically provisioned
- Exists independently of Pods

#### PersistentVolumeClaim (PVC)
- A request for storage by a user/application
- Specifies:
  - Size (e.g., 1Gi)
  - Access mode (e.g., ReadWriteOnce)

#### Relationship

- PVC requests storage
- Kubernetes finds or creates a matching PV
- PV is **bound** to the PVC
- Pod uses the PVC (not the PV directly)

#### Think of it like:
- PV = storage resource
- PVC = storage request
- Pod = consumer

---
### Static vs dynamic provisioning
### Static Provisioning
- Admin manually creates PVs
- Users create PVCs that match existing PVs
- Requires pre-planning

**Flow:**
PV → PVC → Pod

**Pros:**
- Full control
- Simple for learning

**Cons:**
- Manual effort
- Not scalable

### Dynamic Provisioning
- No need to create PV manually
- PVC triggers automatic PV creation
- Controlled by a StorageClass

**Flow:**
PVC → StorageClass → PV (auto-created) → Pod

**Pros:**
- Scalable
- Less manual work
- Used in real-world clusters

**Important:**
- Requires a working provisioner
- May use `WaitForFirstConsumer` (PV created only when Pod starts)


---
### Access modes and reclaim policies
### Access Modes

Define how a volume can be mounted:

- **ReadWriteOnce (RWO)**  
  Mounted as read-write by a single node

- **ReadOnlyMany (ROX)**  
  Mounted as read-only by multiple nodes

- **ReadWriteMany (RWX)**  
  Mounted as read-write by multiple nodes


### Reclaim Policies

Define what happens to the PV after the PVC is deleted:

- **Delete**
  - PV and underlying storage are automatically removed
  - Common in dynamic provisioning

- **Retain**
  - PV is not deleted
  - Moves to `Released` state
  - Requires manual cleanup

  ### Key Takeaways

- Containers lose data → use persistent storage
- PVC requests storage, PV provides it
- Dynamic provisioning is preferred in real systems
- Reclaim policy controls cleanup behavior