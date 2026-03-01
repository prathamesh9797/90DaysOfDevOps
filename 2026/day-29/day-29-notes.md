# Day 29 – Introduction to Docker

## **Task 1: What is Docker?**
Docker is a containerization platform that allows you to package an application and its dependencies into a lightweight, portable container so it runs consistently across different environments.

## **Research and write short notes on:**
## **What is a container and why do we need them?**
### >> A **container** is a lightweight, portable unit that packages:
- Application code
- Runtime
- System libraries
- Dependencies
- Configuration
All bundled together so the application runs the same everywhere.

### **Think of it as:**
### ** “Application + Everything it needs to run” **
### Why Do We Need Containers?
### **Before containers:**
- “It works on my machine” problem
- Dependency conflicts
- Different OS environments
- Hard deployments
### **Containers solve this by:**
- Ensuring consistency across dev, test, and production
- Making applications portable
- Isolating applications
- Using fewer resources than virtual machines
- Containers vs Virtual Machines — what's the real difference?
- What is the Docker architecture? (daemon, client, images, containers, registry)
In simple words:

>  I give a command using the Docker client.
 The client talks to the Docker daemon.
 The daemon pulls or builds an image.
 The daemon then creates a container from that image.
 The container runs as an isolated process on the host machine.



## **Containers vs Virtual Machines — what's the real difference?**
>>  

| Virtual Machines | Containers |
| ----- | ----- |
| Full OS per VM | Share host OS |
| Heavy (GBs) | Lightweight (MBs) |
| Slower startup | Fast startup |
| Strong hardware isolation | Process-level isolation |
| More resource usage | Efficient resource usage |
> The main difference is that virtual machines include a full operating system and virtualize hardware, while containers share the host OS kernel and only package the application and its dependencies, making them more lightweight and faster to start. 

## **What is the Docker architecture? (daemon, client, images, containers, registry)**
>> Docker architecture follows a client-server model where the Docker client communicates with the Docker daemon to build images and run containers, with images stored in registries and containers running as isolated processes on the host. 



Docker uses a **client-server architecture**.

It mainly consists of:

- Docker Client
- Docker Daemon
- Docker Images
- Docker Containers
- Docker Registry
```
Docker Architecture


Developer
   ↓
Docker Client
   ↓
Docker Daemon
   ↓
Images  ↔  Registry
   ↓
Containers (Running Applications)
```
## Docker Client
The Docker Client is what you interact with.

When you run commands like:

```
docker builddocker rundocker pull
```
The client sends these commands to the Docker daemon using a REST API.

It does NOT create containers directly — it communicates with the daemon.

## Docker Daemon (`dockerd`)
The Docker Daemon is the core engine running in the background.

It is responsible for:

- Building images
- Pulling and pushing images
- Creating and running containers
- Managing networks
- Managing volumes
In short:

>  The daemon does the actual work. 

## Docker Images
A Docker Image is:

- A read-only template
- A blueprint for containers
It contains:

- Application code
- Runtime
- Libraries
- Dependencies
Images are built using a `Dockerfile`.

Example:

```
docker build -t myapp .
```
## Docker Containers
A Docker Container is:

- A running instance of an image
If:

- Image = blueprint
- Container = running application
Containers:

- Share the host OS kernel
- Run as isolated processes
- Are lightweight
## Docker Registry
A Docker Registry is a storage location for images.

Example:

- Docker Hub
You can:

- Push images to a registry
- Pull images from a registry
Example:

```
docker pull nginx
```
Docker pulls the image from the registry to your local system.

---

## **Task 2: Install Docker**
## **Install Docker on your machine (or use a cloud instance)**
```
apt install docker.io    (The Docker package from Ubuntu’s default repository)
docker --version               (verify installation )
sudo systemctl status docker   ( check service)
```
## **Verify the installation**
>> after installing docker.io

```
docker --version    (check and verify installation and docker version)
```
```
prathamesh@localhost:~$ docker --version
Docker version 27.5.1, build 27.5.1-0ubuntu3~24.04.2
```
## **Run the **`**hello-world**`**  container**
>> docker run hello-world

```
prathamesh@localhost:~$ docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
To generate this message, Docker took the following steps:
The Docker client contacted the Docker daemon.
The Docker daemon pulled the "hello-world" image from the Docker Hub.
(amd64)
The Docker daemon created a new container from that image which runs the
executable that produces the output you are currently reading.
The Docker daemon streamed that output to the Docker client, which sent it
to your terminal.
To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash
Share images, automate workflows, and more with a free Docker ID:
 [﻿https://hub.docker.com/](https://hub.docker.com/) 
For more examples and ideas, visit:
 [﻿https://docs.docker.com/get-started/](https://docs.docker.com/get-started/) 
```
## **Read the output carefully — it explains what just happened**
Docker did the following internally:

1. The Docker client sent a request to the Docker daemon.
2. The daemon checked if the `hello-world`  image existed locally.
3. It did not find it.
4. It pulled the image from Docker Hub.
5. It created a container from that image.
6. It ran the container.
7. The container printed a message.
8. The container exited.
**What happens when you run docker run hello-world?**

Interview Answer

>  Docker checks for the image locally, pulls it from Docker Hub if not found, creates a container from the image, executes it, prints the output, and then stops the container.

---

## Task 3: Run Real Containers
## Run an **Nginx** container and access it in your browser
>>Step 1: Pull the Nginx Image (Optional)

You can pull manually:

```
docker pull nginx
```
Or Docker will pull it automatically when you run it.

## Step 2: Run the Nginx Container
```
docker run -d -p 8080:80 --name my-nginx nginx
```
### What This Means:
- `-d`  → Run in detached mode (background)
- `-p 8080:80`  → Map: Port Mapping
    - Host port **8080**
    - To container port **80**

- `--name my-nginx`  → Give the container a name
- `nginx`  → Image name
### ** Interview-Level One-Liner**
>  Port mapping using `-p 8080:80` forwards traffic from port 8080 on the host machine to port 80 inside the container, allowing external access to services running inside isolated containers.

## **Step 3: Access It in Your Browser**
Open your browser and go to:

```
http://localhost:8080
```
If you're using a cloud server (EC2, VM, etc.):

```
http://<your-server-public-ip>:8080
```
Make sure:

- Port 8080 is open in firewall/security group
- Docker container is running
![Screenshot from 2026-03-02 00-41-46.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-02%2000-41-46_RV70mExJ74Gu5-mtzFu9I.png?ixlib=js-3.8.0 "Screenshot from 2026-03-02 00-41-46.png")



```
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES
c46b339ba217   nginx     "/docker-entrypoint.…"   13 minutes ago   Up 13 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-nginx
```
### **Stop and Remove Container (Optional Cleanup)**
```
docker stop my-nginx
docker rm my-nginx
```
---

## Run an **Ubuntu** container in interactive mode — explore it like a mini Linux machine
>> Run Ubuntu Container

```
docker run -it ubuntu
```
### What the flags mean:
- `-i`  → Interactive (keeps STDIN open)
- `-t`  → Allocates a terminal
- `ubuntu`  → Image name
If the image isn’t downloaded, Docker will pull it automatically.

```
ubuntu@ip-172-31-24-207:~$ docker run -it ubuntu
Unable to find image 'ubuntu:latest' locally
latest: Pulling from library/ubuntu
01d7766a2e4a: Pull complete 
Digest: sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9
Status: Downloaded newer image for ubuntu:latest
root@065b469e2d31:/#
```
### **What You’ll See**
Your prompt will change to something like:

```
root@065b469e2d31:/#
```
That means:

- You are now **inside the container**
- Logged in as **root**
- Inside a minimal Ubuntu environment
You are no longer in your host machine.

---

## **List all running containers**
```
docker ps
```
```
buntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES
c46b339ba217   nginx     "/docker-entrypoint.…"   25 minutes ago   Up 25 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-nginx
```
### What it shows:
- Container ID
- Image
- Command
- Created time
- Status
- Ports
- Container name
Only containers that are **currently running** will appear.

## **List all containers (including stopped ones)**
```
docker ps -a
```
```
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                       PORTS                                     NAMES
065b469e2d31   ubuntu        "/bin/bash"              6 minutes ago    Exited (130) 2 minutes ago                                             determined_grothendieck
c46b339ba217   nginx         "/docker-entrypoint.…"   26 minutes ago   Up 26 minutes                0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-nginx
9f0e6728bade   hello-world   "/hello"                 27 minutes ago   Exited (0) 27 minutes ago
```
This shows:

- Running containers
- Exited containers
- Failed containers
If a container stopped after you exited it (like Ubuntu), you’ll see:

```
STATUS: Exited (0)
```
---

## **Stop and remove a container**
### **Step 1: Stop the Container**
First, list running containers:

```
docker ps
```
Then stop the container using either the **container name** or **container ID**:

```
docker stop <container_name>
```
Example:

```
docker stop my-nginx
```
What this does:

- Sends a **SIGTERM**
- Gracefully stops the container
```
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES
c46b339ba217   nginx     "/docker-entrypoint.…"   32 minutes ago   Up 32 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-nginx
ubuntu@ip-172-31-24-207:~$ docker stop c46b339ba217
c46b339ba217
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS                       PORTS     NAMES
065b469e2d31   ubuntu        "/bin/bash"              12 minutes ago   Exited (130) 9 minutes ago             determined_grothendieck
c46b339ba217   nginx         "/docker-entrypoint.…"   33 minutes ago   Exited (0) 27 seconds ago              my-nginx
9f0e6728bade   hello-world   "/hello"                 34 minutes ago   Exited (0) 34 minutes ago              great_shamir
ubuntu@ip-172-31-24-207:~$
```
## Step 2: Remove the Container
After stopping it:

```
docker rm <container_name>
```
Example:

```
docker rm my-nginx
```
Now the container is completely deleted.

```
ubuntu@ip-172-31-24-207:~$ docker rm 065b469e2d31
065b469e2d31
ubuntu@ip-172-31-24-207:~$ docker rm c46b339ba217
c46b339ba217
ubuntu@ip-172-31-24-207:~$ docker rm 9f0e6728bade
9f0e6728bade
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-24-207:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-24-207:~$
```
If you want to force stop and remove immediately:

```
docker rm -f <container_name>
```
The `-f` flag:

- Stops the container
- Removes it in one step
---

# **Task 4: Explore**
### Run a container in **detached mode** — what's different?
```
docker run -d nginx
```
### What’s Different?
- `-d`  = detached mode
- The container runs **in the background**
- Your terminal is free immediately
- You don’t see logs directly
Check it:

```
docker ps
```
```
ubuntu@ip-172-31-24-207:~$ docker run -d nginx
6305f5c02aa196c8f83b5e7cfd30f018de9c6c8a25e50e57f8530575de83bd54
```
You’ll see the container running.

You ran:

```
docker run -d nginx
```
But you did NOT map any ports.

That means:

- Nginx is running inside the container
- But it is NOT accessible from your browser
Because you did not use:

```
-p 8080:80
```
### Give a container a custom **name or rename a container**
#### Use `docker rename` 
```
docker rename <old_name_or_id> <new_name>
```
```
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
0087cf0b2af9   nginx     "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   80/tcp    my-web
4c0e0aa5d80f   nginx     "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   80/tcp    practical_goldwasser
6305f5c02aa1   nginx     "/docker-entrypoint.…"   4 minutes ago   Up 4 minutes   80/tcp    silly_dhawan

buntu@ip-172-31-24-207:~$ docker rename silly_dhawan virat_kohli
ubuntu@ip-172-31-24-207:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
0087cf0b2af9   nginx     "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   80/tcp    my-web
4c0e0aa5d80f   nginx     "/docker-entrypoint.…"   6 minutes ago   Up 6 minutes   80/tcp    practical_goldwasser
6305f5c02aa1   nginx     "/docker-entrypoint.…"   7 minutes ago   Up 7 minutes   80/tcp    virat_kohli

```
### Map a **port** from the container to your host
#### Basic Syntax
```
docker run -d -p <host_port>:<container_port> <image_name>
```
Format:

```
-p host_port:container_port
```
### Example: Run Nginx and Map Port
```
docker run -d -p 8080:80 --name my-web nginx
```
### What This Means:
- `8080`  → Port on your **host machine**
- `80`  → Port inside the **container**
- `nginx`  → Nginx listens on port 80 inside container
So Docker creates a bridge like this:

```
Browser → Host:8080 → Docker → Container:80 → Nginx
```
####  How to Access It
#### On your local machine:
```
http://localhost:8080
```
#### On EC2 / Cloud server:
```
http://<public-ip>:8080
```
⚠ Make sure:

- Port 8080 is open in your security group / firewall.
### Why We Need Port Mapping
Containers have their own internal network.

If you don’t use `-p`, the service:

- Runs inside the container
- Is NOT accessible from outside
For example:

```
docker run -d nginx
```
Nginx is running…
But you cannot access it in the browser.

Because no port is exposed to the host.

## Check **logs** of a running container
>> Basic Command

```
docker logs <container_name_or_id>
```
## Run a command **inside** a running container
>>If you want to run a command **inside a running container**, you use:

```
docker exec < container ID or Name>
```
#### Step 1: Check Running Containers
```
docker ps
```
You’ll see something like:

```
CONTAINER ID   IMAGE    NAMESa1b2c3d4e5f6   nginx    my-nginx
```
### Run a single command:
```
docker exec my-nginx ls /
```
This runs `ls /` inside the container.

```
ubuntu@ip-172-31-24-207:~$ docker exec my-web ls
bin
boot
dev
docker-entrypoint.d
docker-entrypoint.sh
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
```
To open a terminal inside the container:

```
docker exec -it my-nginx bash
```
### What the flags mean:
- `-i`  → Interactive
- `-t`  → Allocate terminal
- `bash`  → Run bash shell
```
ubuntu@ip-172-31-24-207:~$ docker exec -it my-web bash
root@0087cf0b2af9:/#
```


