# Day 30 – Docker Images & Container Lifecycle

## **Task 1: Docker Images**
## **>> Pull the **`**nginx**`** , **`**ubuntu**`** , and **`**alpine**`**  images from Docker Hub**
```
docker pull nginx
docker pull ubuntu
docker pull alpine
```
```
ubuntu@ip-172-31-24-207:~$ docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
Digest: sha256:0236ee02dcbce00b9bd83e0f5fbc51069e7e1161bd59d99885b3ae1734f3392e
Status: Image is up to date for nginx:latest
docker.io/library/nginx:latest
ubuntu@ip-172-31-24-207:~$ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
Digest: sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9
Status: Image is up to date for ubuntu:latest
docker.io/library/ubuntu:latest
ubuntu@ip-172-31-24-207:~$ docker pull alpine
Using default tag: latest
latest: Pulling from library/alpine
589002ba0eae: Pull complete 
Digest: sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
Status: Downloaded newer image for alpine:latest
docker.io/library/alpine:latest
```
## **>> List all images on your machine — note the sizes**
```
>> docker images
```
```
ubuntu@ip-172-31-24-207:~$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         latest    fd204fe2f750   6 days ago     161MB
ubuntu        latest    bbdabce66f1b   2 weeks ago    78.1MB
alpine        latest    a40c03cbb81c   4 weeks ago    8.44MB
hello-world   latest    1b44b5a3e06a   6 months ago   10.1kB
```
## **>> Compare **`**ubuntu**`**  vs **`**alpine**`**  — why is one much smaller?**
## Ubuntu
- Full Linux distribution
- Includes many libraries and tools
- Uses **glibc**
- Designed to be general-purpose
## Alpine
- Minimal Linux distribution
- Designed specifically for containers
- Uses **musl libc** instead of glibc
- Very few pre-installed packages
### Why Alpine Is So Small:
- No unnecessary packages
- Lightweight package manager (apk)
- Minimal system utilities
- Optimized for containers
In short: **Ubuntu is a full operating system. Alpine is a tiny container-focused OS.**

That’s why Alpine is often used for:

- Microservices
- Production container images
- Reducing attack surface
- Faster deployments
## **>> Inspect an image — what information can you see?**
```
>>docker inspect ubuntu
```
You’ll see a large JSON output.

### What Information Can You See?
Some useful fields:

- **Id** – unique image ID
- **Created** – when it was built
- **Architecture** – amd64, arm64, etc.
- **OS** – linux
- **Layers** – filesystem layers
- **Env** – environment variables
- **Cmd** – default command
- **Entrypoint**
- **WorkingDir**
- **ExposedPorts**
## **>> Remove an image you no longer need**
```
>>docker rmi alpine
```
```
ubuntu@ip-172-31-24-207:~$ docker rmi alpine
Untagged: alpine:latest
Untagged: alpine@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
Deleted: sha256:a40c03cbb81c59bfb0e0887ab0b1859727075da7b9cc576a1cec2c771f38c5fb
Deleted: sha256:989e799e634906e94dc9a5ee2ee26fc92ad260522990f26e707861a5f52bf64e
```
If Docker says the image is in use:

```
Stop containers using it:
  
docker ps -a
docker stop <container_id>
docker rm <container_id>
```
Then remove the image again:

```
docker rmi alpine
```
To remove all unused images:

```
docker image prune
```
| Image | Typical Size | Why |
| ----- | ----- | ----- |
| nginx | ~180MB | Includes OS + nginx server |
| ubuntu | ~70MB | Full Linux distro |
| alpine | ~7MB | Minimal container OS |
---

## Task 2: Image Layers
## >> Run `docker image history nginx`  — what do you see?
###  What this means:
- Each row = **one image layer**
- The bottom layer = base OS (Debian in this case)
- The large `RUN`  layer = installing nginx and dependencies
- `COPY`  layers = small config scripts
- `CMD` , `ENV` , `ENTRYPOINT`  = metadata only (0B)
```
ubuntu@ip-172-31-24-207:~$ docker image history nginx
IMAGE          CREATED      CREATED BY                                      SIZE      COMMENT
fd204fe2f750   6 days ago   CMD ["nginx" "-g" "daemon off;"]                0B        buildkit.dockerfile.v0
<missing>      6 days ago   STOPSIGNAL SIGQUIT                              0B        buildkit.dockerfile.v0
<missing>      6 days ago   EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENTRYPOINT ["/docker-entrypoint.sh"]            0B        buildkit.dockerfile.v0
<missing>      6 days ago   COPY 30-tune-worker-processes.sh /docker-ent…   4.62kB    buildkit.dockerfile.v0
<missing>      6 days ago   COPY 20-envsubst-on-templates.sh /docker-ent…   3.02kB    buildkit.dockerfile.v0
<missing>      6 days ago   COPY 15-local-resolvers.envsh /docker-entryp…   389B      buildkit.dockerfile.v0
<missing>      6 days ago   COPY 10-listen-on-ipv6-by-default.sh /docker…   2.12kB    buildkit.dockerfile.v0
<missing>      6 days ago   COPY docker-entrypoint.sh / # buildkit          1.62kB    buildkit.dockerfile.v0
<missing>      6 days ago   RUN /bin/sh -c set -x     && groupadd --syst…   82.2MB    buildkit.dockerfile.v0
<missing>      6 days ago   ENV DYNPKG_RELEASE=1~trixie                     0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENV PKG_RELEASE=1~trixie                        0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENV ACME_VERSION=0.3.1                          0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENV NJS_RELEASE=1~trixie                        0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENV NJS_VERSION=0.9.5                           0B        buildkit.dockerfile.v0
<missing>      6 days ago   ENV NGINX_VERSION=1.29.5                        0B        buildkit.dockerfile.v0
<missing>      6 days ago   LABEL maintainer=NGINX Docker Maintainers <d…   0B        buildkit.dockerfile.v0
<missing>      8 days ago   # debian.sh --arch 'amd64' out/ 'trixie' '@1…   78.6MB    debuerreotype 0.17
```
## Each line is a **layer**. Note how some layers show sizes and some show 0B
### Layers with size (e.g., 82MB, 78MB)
These layers:

- Add files
- Install packages
- Modify the filesystem
They physically change the image.

### Layers with 0B
These layers:

- Set metadata (CMD, ENV, ENTRYPOINT)
- Don’t change the filesystem
They modify configuration, not files.

## Write in your notes: What are layers and why does Docker use them?
### **What Are Layers? **
>  Docker images are built in layers. Each instruction in a Dockerfile (such as RUN, COPY, or ENV) creates a new read-only layer. Layers are stacked on top of each other to form the final image. Only instructions that modify the filesystem add size; metadata instructions show 0B.

### **Why Does Docker Use Layers?**
>  Docker uses layers to make images efficient, reusable, and faster to build. Since layers are cached and shared between images, Docker does not need to rebuild or re-download unchanged layers. This reduces build time, saves disk space, and improves performance.

### **Why Layers Are Powerful**
Layers allow:

### 1. Caching
If only the last instruction changes, Docker rebuilds only that layer.

### 2. Sharing
If two images use the same base (like Debian), they share that layer.

### 3. Faster Pulls
When pulling images, Docker downloads only layers you don’t already have.

### 4. Smaller Storage Usage
Common layers are stored once on disk.

### **Think of layers like transparent sheets stacked on top of each other:**
Base OS

- Install nginx
- Add config scripts
- Set startup command
Together they form the final image.

---

### Task 3: Container Lifecycle
Practice the full lifecycle on one container:

1. **Create** a container (without starting it)
2. **Start** the container
3. **Pause** it and check status
4. **Unpause** it
5. **Stop** it
6. **Restart** it
7. **Kill** it
8. **Remove** it
Check `docker ps -a` after each step — observe the state changes.



**We’ll use a container named **`**mynginx**`**.**

**Create a container (without starting it)**

```
docker create --name mynginx nginx
```
Now check:

```
docker ps -a
```
### You should see:
- STATUS → `Created` 
The container exists, but it is **not running yet**.

## Start the container
```
docker start mynginx
```
Check again:

```
docker ps -a
```
### STATUS:
- `Up X seconds` 
Now it is **running**.

If you want to see only running containers:

```
docker ps
```
## Pause the container
```
docker pause mynginx
```
Check status:

```
docker ps -a
```
### STATUS:
- `Up X seconds (Paused)` 
The container is frozen.
 CPU processes are suspended, but memory state is preserved.

##  Unpause the container
```
docker unpause mynginx
```
Check:

```
docker ps -a
```
### STATUS:
- `Up X seconds` 
Back to normal running state.

## Stop the container
```
docker stop mynginx
```
Check:

```
docker ps -a
```
### STATUS:
- `Exited (0) X seconds ago` 
Docker sends SIGTERM and allows graceful shutdown.

##  Restart the container
```
docker restart mynginx
```
Check:

```
docker ps -a
```
### STATUS:
- `Up X seconds` 
Docker performs:

1. Stop
2. Start
## Kill the container
```
docker kill mynginx
```
Check:

```
docker ps -a
```
### STATUS:
- `Exited (137) X seconds ago` 
`docker kill` sends SIGKILL (force stop immediately).
 Exit code **137** usually indicates forced termination.

## Remove the container
Container must be stopped first.

```
docker rm mynginx
```
Now check:

```
docker ps -a
```
The container should be gone.

# Lifecycle State Summary
| Command | State |
| ----- | ----- |
| create | Created |
| start | Running |
| pause | Paused |
| unpause | Running |
| stop | Exited |
| restart | Running |
| kill | Exited (forcefully) |
| rm | Removed |


# What I Observed
>  A Docker container moves through several states: created, running, paused, stopped (exited), and removed. Commands like start, stop, pause, and kill control its lifecycle. Docker keeps containers in a stopped state until they are manually removed. 



If you ever want to see live state transitions:

```
watch docker ps -a
```
```
ubuntu@ip-172-31-24-207:~$ docker create --name mynginx nginx
76891399c2c1d530e80e8c55738644665e477e406718ca35f1b0347d72ba9d55

ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS    PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   About a minute ago   Created             mynginx

ubuntu@ip-172-31-24-207:~$ docker start mynginx
mynginx

ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS          PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   7 minutes ago   Up 11 seconds   80/tcp    mynginx

ubuntu@ip-172-31-24-207:~$ docker pause mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS                  PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   9 minutes ago   Up 2 minutes (Paused)   80/tcp    mynginx

ubuntu@ip-172-31-24-207:~$ docker unpause mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS         PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   11 minutes ago   Up 4 minutes   80/tcp    mynginx

ubuntu@ip-172-31-24-207:~$ docker stop mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                      PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   13 minutes ago   Exited (0) 10 seconds ago             mynginx

ubuntu@ip-172-31-24-207:~$ docker restart mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS         PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   14 minutes ago   Up 4 seconds   80/tcp    mynginx

ubuntu@ip-172-31-24-207:~$ docker kill mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                       PORTS     NAMES
76891399c2c1   nginx     "/docker-entrypoint.…"   15 minutes ago   Exited (137) 4 seconds ago             mynginx

ubuntu@ip-172-31-24-207:~$ docker rm mynginx
mynginx
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
---

## **Task 4: Working with Running Containers**
## **>> Run an Nginx container in detached mode**
```
docker run -d --name mynginx -p 8080:80 nginx
```
```
ubuntu@ip-172-31-24-207:~$ docker run -d --name mynginx -p 8080:80 nginx
ccbc16b1dca0104ade0c360e11f280ffcf88e97cd862f80e974db6e056381eba
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                     NAMES
ccbc16b1dca0   nginx     "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   mynginx
```
### What this does:
- `-d`  → Detached mode (runs in background)
- `--name mynginx`  → Custom container name
- `-p 8080:80`  → Maps:
    - Host port 8080
    - To container port 80

- `nginx`  → Image
Check it’s running:

```
docker ps
```
You should see STATUS → `Up ...` 

You can test it in browser:

```
http://<your-ec2-ip>:8080
```
## View its **logs**
```
docker logs mynginx
```
You’ll see:

- Nginx startup messages
- Access logs if someone hits the server
## View **real-time logs** (follow mode)
```
docker logs -f mynginx
```
```
ubuntu@ip-172-31-24-207:~$ docker logs mynginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
```
Now open the browser and refresh the page.

You’ll see access logs appear live 

To exit follow mode:

```
CTRL + C
```
## **Exec** into the container and look around the filesystem
```
docker exec -it mynginx /bin/bash
```
```
ubuntu@ip-172-31-24-207:~$ docker exec -it mynginx /bin/sh
```
If bash isn’t available:

```
docker exec -it mynginx /bin/sh
```
```
ubuntu@ip-172-31-24-207:~$ docker exec -it mynginx /bin/sh
```
Now you are **inside the container**.

Try:

```
ls /
ls /usr/share/nginx/html
cat /etc/nginx/nginx.conf
```
```
# ls -lrt
total 64
lrwxrwxrwx   1 root root    8 Jan  2 12:35 sbin -> usr/sbin
lrwxrwxrwx   1 root root    9 Jan  2 12:35 lib64 -> usr/lib64
lrwxrwxrwx   1 root root    7 Jan  2 12:35 lib -> usr/lib
drwxr-xr-x   2 root root 4096 Jan  2 12:35 home
drwxr-xr-x   2 root root 4096 Jan  2 12:35 boot
lrwxrwxrwx   1 root root    7 Jan  2 12:35 bin -> usr/bin
drwxr-xr-x   1 root root 4096 Feb 23 00:00 var
drwxr-xr-x   1 root root 4096 Feb 23 00:00 usr
drwxrwxrwt   2 root root 4096 Feb 23 00:00 tmp
drwxr-xr-x   2 root root 4096 Feb 23 00:00 srv
drwx------   2 root root 4096 Feb 23 00:00 root
drwxr-xr-x   2 root root 4096 Feb 23 00:00 opt
drwxr-xr-x   2 root root 4096 Feb 23 00:00 mnt
drwxr-xr-x   2 root root 4096 Feb 23 00:00 media
-rwxr-xr-x   1 root root 1620 Feb 24 19:04 docker-entrypoint.sh
drwxr-xr-x   1 root root 4096 Feb 24 19:05 docker-entrypoint.d
drwxr-xr-x   1 root root 4096 Mar  3 08:53 etc
dr-xr-xr-x 179 root root    0 Mar  3 08:53 proc
dr-xr-xr-x  13 root root    0 Mar  3 08:53 sys
drwxr-xr-x   5 root root  340 Mar  3 08:53 dev
drwxr-xr-x   1 root root 4096 Mar  3 08:53 run
```
You’re now exploring the container’s filesystem.

To exit:

```
exit
```
## **Run a single command inside the container without entering it**
Instead of interactive mode:

```
docker exec mynginx ls /usr/share/nginx/html
```
Or:

```
docker exec mynginx cat /etc/os-release
```
```
ubuntu@ip-172-31-24-207:~$ docker exec mynginx cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.3
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```
This runs one command and returns you to your host shell.

Very useful in production.

## **Inspect** the container — find its IP address, port mappings, and mounts
```
docker inspect mynginx
```
It prints a large JSON output.

## Find the IP Address
Look for:

```
"IPAddress":
```
Or use cleaner format:

```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mynginx
```
## Find Port Mappings
Look for:

```
"Ports":
```
You’ll see something like:

```
"80/tcp": [  {    "HostIp": "0.0.0.0",    "HostPort": "8080"  }]
```
That means:
 Host 8080 → Container 80

## Find Mounts
Look for:

```
"Mounts":
```
If you didn’t add volumes, it may be empty.

If you had used:

```
-v /host/path:/container/path
```
It would appear here.

You worked with:

| Action | Command |
| ----- | ----- |
| Run container | `docker run -d`  |
| View logs | `docker logs`  |
| Live logs | `docker logs -f`  |
| Enter container | `docker exec -it`  |
| Run single command | `docker exec`  |
| Inspect details | `docker inspect`  |
# Big Picture Understanding
- `run`  → start container
- `logs`  → view output from main process
- `exec`  → run additional commands inside running container
- `inspect`  → view full configuration & metadata
---

## **Task 5: Cleanup**
## **Stop all running containers in one command**
```
docker stop $(docker ps -q)
```
### What this means:
- `docker ps -q`  → returns only container IDs of **running** containers
- `$(...)`  → passes those IDs into the `docker stop`  command
- `docker stop`  → gracefully stops them
If no containers are running, nothing happens (which is fine).

Check:

```
docker ps
```
```
ubuntu@ip-172-31-24-207:~$ docker stop $(docker ps -q)
ccbc16b1dca0
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
You should see no running containers

## **Remove all stopped containers in one command**
```
 docker rm $(docker ps -aq)
```
```
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                          PORTS     NAMES
ccbc16b1dca0   nginx     "/docker-entrypoint.…"   18 minutes ago   Exited (0) About a minute ago             mynginx
ubuntu@ip-172-31-24-207:~$  docker rm $(docker ps -aq)
ccbc16b1dca0
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
### What this means:
- `docker ps -aq`  → returns IDs of **all containers** (running + stopped)
- Since you already stopped them, this removes them
If you only want to remove _stopped_ containers:

```
docker container prune
```
It will ask for confirmation.

## **Remove unused images**
To remove dangling images (unused layers):

```
docker image prune
```
```
ubuntu@ip-172-31-24-207:~$ docker image prune
WARNING! This will remove all dangling images.
Are you sure you want to continue? [y/N] y
Total reclaimed space: 0B
```
To remove **all unused images** (not used by any container):

```
docker image prune -a
```
Be careful with `-a` — it removes all images not currently in use.

If you want to clean everything unused:

```
docker system prune -a
```
This removes:

- Stopped containers
- Unused networks
- Dangling images
- Build cache
Docker will ask for confirmation.

## **Check how much disk space Docker is using**
```
docker system df
```
```
ubuntu@ip-172-31-24-207:~$ docker system df
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          3         0         239MB     239MB (100%)
Containers      0         0         0B        0B
Local Volumes   0         0         0B        0B
Build Cache     0         0         0B        0B
```
This shows:

- Total images
- Active images
- Total space used
- How much can be reclaimed
For detailed view:

```
docker system df -v
```
```
ubuntu@ip-172-31-24-207:~$ docker system df -v
Images space usage:

REPOSITORY    TAG       IMAGE ID       CREATED        SIZE      SHARED SIZE   UNIQUE SIZE   CONTAINERS
nginx         latest    fd204fe2f750   6 days ago     161MB     0B            160.9MB       0
ubuntu        latest    bbdabce66f1b   2 weeks ago    78.1MB    0B            78.13MB       0
hello-world   latest    1b44b5a3e06a   6 months ago   10.1kB    0B            10.07kB       0

Containers space usage:

CONTAINER ID   IMAGE     COMMAND   LOCAL VOLUMES   SIZE      CREATED   STATUS    NAMES

Local Volumes space usage:

VOLUME NAME   LINKS     SIZE

Build cache usage: 0B

CACHE ID   CACHE TYPE   SIZE      CREATED   LAST USED   USAGE     SHARED
```
# What I Learned From Cleanup
I now know how to:

- Stop multiple containers at once
- Remove containers in bulk
- Free image storage
- Check disk usage
- Reclaim unused Docker resources
This is real-world important — especially on EC2 or cloud VMs with limited storage.

---



