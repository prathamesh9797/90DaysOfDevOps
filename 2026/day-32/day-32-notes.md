# Day 32 – Docker Volumes & Networking

## **Task 1: The Problem**
## **>> Run a MySQL container**
```
ubuntu@ip-172-31-17-9:~$ docker run --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -d mysql:8
Unable to find image 'mysql:8' locally
8: Pulling from library/mysql
74a8e4bbd9fe: Pull complete 
3f7842d0a781: Pull complete 
4e4b15845406: Pull complete 
dbf0818490ad: Pull complete 
6f9c4bee9463: Pull complete 
8166b6846f27: Pull complete 
c6cc6c694e6c: Pull complete 
3cd5d964ef58: Pull complete 
eb385f68403e: Pull complete 
afb8ea084562: Pull complete 
Digest: sha256:a2d126916bc2ba79a890a4bf62d305eb8b68fcbdd35c6e582d529df18faf5ebb
Status: Downloaded newer image for mysql:8
99a6bb4247db38add6a5b8d5d9a30e7c3a199ae30fa207a3aceae09a09265551
```
## **>> Create some data inside it (a table, a few rows — anything)**


```
ubuntu@ip-172-31-17-9:~$ docker exec -it my-mysql mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.8 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE testdb;
Query OK, 1 row affected (0.02 sec)

mysql> USE testdb;
Database changed
mysql> CREATE TABLE users ( id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(50));
Query OK, 0 rows affected (0.03 sec)

mysql> INSERT INTO users (name) VALUES ('Alice'), ('Bob');
Query OK, 2 rows affected (0.01 sec)
Records: 2  Duplicates: 0  Warnings: 0

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testdb             |
+--------------------+
5 rows in set (0.00 sec)

mysql> SHOW TABLES;
+------------------+
| Tables_in_testdb |
+------------------+
| users            |
+------------------+
1 row in set (0.00 sec)

mysql> SELECT * FROM users;
+----+-------+
| id | name  |
+----+-------+
|  1 | Alice |
|  2 | Bob   |
+----+-------+
2 rows in set (0.00 sec)
```
## **Stop and remove the container**
```
ubuntu@ip-172-31-17-9:~$ docker stop my-mysql
my-mysql
ubuntu@ip-172-31-17-9:~$ docker rm my-mysql
my-mysql
ubuntu@ip-172-31-17-9:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-17-9:~$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-17-9:~$
```
## **>> Run a new one — is your data still there?**
testdb database that we created in first task got deleted

Docker containers are **ephemeral**.

If you:

- Remove container ❌
- Recreate container ❌
- Don’t use a volume ❌
→ All data inside `/var/lib/mysql` disappears.

```
ubuntu@ip-172-31-17-9:$ docker run --name my-mysql 
 -e MYSQL_ROOT_PASSWORD=secret 
 -d mysql:8
98b731bdd9818bc169c364d4ac6eecc846cfad8ba485b216896a941e2c9ea102
ubuntu@ip-172-31-17-9:$ docker exec -it my-mysql mysql -uroot -p
Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.8 MySQL Community Server - GPL
Copyright (c) 2000, 2026, Oracle and/or its affiliates.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> SHOW DATABASES;
+--------------------+
| Database |
+--------------------+
| information_schema |
| mysql |
| performance_schema |
| sys |
+--------------------+
4 rows in set (0.01 sec)
```
## **>> Write what happened and why.**
When the container was removed, the database disappeared because MySQL stored its data inside the container’s writable filesystem layer. Docker deletes that layer when the container is removed. Containers are ephemeral by design, so data is not persisted unless a volume or bind mount is used.

# Key Concept
There’s a difference between:

| Image | Container |
| ----- | ----- |
| Blueprint | Running instance |
| Read-only | Has writable layer |
| Persistent | Ephemeral by default |
When you remove a container, its data goes with it — unless you use **volumes**.

---

## Task 2: Named Volumes
## >> Create a named volume
```
ubuntu@ip-172-31-17-9:~$ docker volume create my-mysql-data
my-mysql-data
ubuntu@ip-172-31-17-9:~$ docker volume ls
DRIVER    VOLUME NAME
local     8a062c3c3c89466fdf035bd6fe3d715fd138a9c0aa058778ffeb8a1c372255e6
local     30498394c4d21736a1aadccbcf82ad40f8512a5d9ffe6d8bfa08b6f27657ff37
local     my-mysql-data
```
## >> Run the same database container, but this time **attach the volume** to it
```
ubuntu@ip-172-31-17-9:~$ docker run --name my-mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -v my-mysql-data:/var/lib/mysql \
  -d mysql:8
021bae0b7c8c8cca8b4e976d60270288b555f442549a76bdee4eab7bc239a582
```
What this does:

- `my-mysql-data`  → persistent Docker volume
- `/var/lib/mysql`  → MySQL’s internal data directory
- The volume is mounted into the container
So now MySQL stores its database files inside the volume instead of the container layer.

## >> Add some data, stop and remove the container
```
ubuntu@ip-172-31-17-9:~$ docker exec -it my-mysql mysql -uroot -p
Enter password:
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.8 MySQL Community Server - GPL
Copyright (c) 2000, 2026, Oracle and/or its affiliates.
Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> CREATE DATABASE testdb;
Query OK, 1 row affected (0.01 sec)
mysql> USE testdb;
Database changed
mysql>
mysql> CREATE TABLE users (
 -> id INT PRIMARY KEY AUTO_INCREMENT,
 -> name VARCHAR(50)
 -> );
Query OK, 0 rows affected (0.03 sec)
mysql>
mysql> INSERT INTO users (name) VALUES ('Alice'), ('Bob');
Query OK, 2 rows affected (0.02 sec)
Records: 2 Duplicates: 0 Warnings: 0
mysql> SHOW DATABASES;
+--------------------+
| Database |
+--------------------+
| information_schema |
| mysql |
| performance_schema |
| sys |
| testdb |
+--------------------+
5 rows in set (0.00 sec)
mysql> \q
Bye
```
Now the data is stored inside the volume.

```
ubuntu@ip-172-31-17-9:~$ docker stop my-mysql
my-mysql
ubuntu@ip-172-31-17-9:~$ docker rm my-mysql
my-mysql
ubuntu@ip-172-31-17-9:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-17-9:~$
```
At this point:

- Container is gone ❌
- Volume still exists 
Verify:

```
docker volume ls
```
You should still see:

```
ubuntu@ip-172-31-17-9:~$ docker volume ls
DRIVER    VOLUME NAME
local     8a062c3c3c89466fdf035bd6fe3d715fd138a9c0aa058778ffeb8a1c372255e6
local     30498394c4d21736a1aadccbcf82ad40f8512a5d9ffe6d8bfa08b6f27657ff37
local     my-mysql-data
```
## >> Run a brand new container with the **same volume**
```
ubuntu@ip-172-31-17-9:~$ docker run --name my-mysql-new \
  -e MYSQL_ROOT_PASSWORD=secret \
  -v my-mysql-data:/var/lib/mysql \
  -d mysql:8
ff988043cdfda4aaf0e88d091192174ab519856916da7d5bbd30261ad0870caa
ubuntu@ip-172-31-17-9:~$ docker exec -it my-mysql-new mysql -uroot -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.4.8 MySQL Community Server - GPL

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testdb             |
+--------------------+
5 rows in set (0.01 sec)

mysql> USE testdb;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM users;
+----+-------+
| id | name  |
+----+-------+
|  1 | Alice |
|  2 | Bob   |
+----+-------+
2 rows in set (0.00 sec)
```
## Is the data still there?
Yes data is still there

```
mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| testdb             |
+--------------------+
5 rows in set (0.01 sec)

mysql> USE testdb;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> SELECT * FROM users;
+----+-------+
| id | name  |
+----+-------+
|  1 | Alice |
|  2 | Bob   |
+----+-------+
2 rows in set (0.00 sec)
```
## **>> Verify:** `docker volume ls`, `docker volume inspect` 
```
ubuntu@ip-172-31-17-9:~$ docker volume ls
DRIVER    VOLUME NAME
local     8a062c3c3c89466fdf035bd6fe3d715fd138a9c0aa058778ffeb8a1c372255e6
local     30498394c4d21736a1aadccbcf82ad40f8512a5d9ffe6d8bfa08b6f27657ff37
local     my-mysql-data

ubuntu@ip-172-31-17-9:~$ docker volume inspect my-mysql-data
[
    {
        "CreatedAt": "2026-03-03T19:40:47Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/my-mysql-data/_data",
        "Name": "my-mysql-data",
        "Options": null,
        "Scope": "local"
    }
]
```
# What Happened (The Key Insight)
When I used:

```
-v my-mysql-data:/var/lib/mysql
```
You told Docker:

>  “Store MySQL’s database files inside this persistent volume instead of the container.” 

So when the container was deleted:

- Only the container filesystem was removed
- The volume remained untouched
- The new container mounted the same volume
- MySQL reused the existing data files
#  Final Answer
Yes — the data is still there.

Because named volumes are managed outside the container lifecycle, removing a container does not delete the volume. When a new container mounts the same volume, it accesses the same database files.

---

## Task 3: Bind Mounts
## >> Create a folder on your host machine with an `index.html`  file
```
ubuntu@ip-172-31-17-9:~$ mkdir my-website
ubuntu@ip-172-31-17-9:~$ cd my-website
ubuntu@ip-172-31-17-9:~/my-website$ vim index.html
ubuntu@ip-172-31-17-9:~/my-website$
```
## >> Run an Nginx container and **bind mount** your folder to the Nginx web directory
We’ll mount your host folder into Nginx’s default web directory.

```
docker run --name my-nginx \
-p 8080:80 \
-v $(pwd):/usr/share/nginx/html \
-d nginx
```
What this does:

- `$(pwd)`  → your current host directory
- `/usr/share/nginx/html`  → Nginx web root inside container
- `-p 8080:80`  → expose container port 80 to host port 8080
```
ubuntu@ip-172-31-17-9:~/my-website$ docker run --name my-nginx \
-p 8080:80 \
-v $(pwd):/usr/share/nginx/html \
-d nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
206356c42440: Pull complete 
b47f187216b6: Pull complete 
1ad233904a11: Pull complete 
eedda9fd8786: Pull complete 
35ff83c394d6: Pull complete 
17d0911eaf62: Pull complete 
df0b66c867e4: Pull complete 
Digest: sha256:0236ee02dcbce00b9bd83e0f5fbc51069e7e1161bd59d99885b3ae1734f3392e
Status: Downloaded newer image for nginx:latest
b6726c566443a24266a0010a46e7cc015480a1f96073e0d13239bcecd4790257
```
# What’s Happening Internally
## Bind Mount Architecture
![Screenshot from 2026-03-04 01-34-16.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-34-16_gKJbgA23VsTb0D_WdYfvC.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-34-16.png")

![Screenshot from 2026-03-04 01-33-56.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-33-56_pEcoGNPDjcZRWBXzVdwMw.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-33-56.png")

![Screenshot from 2026-03-04 01-35-05.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-35-05_Y5jxa_1SUCSpnsm5YvOEe.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-35-05.png")

![Screenshot from 2026-03-04 01-34-40.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-34-40_4f0WXilnp8-wVi-jyWE6-.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-34-40.png")

### **The container is directly reading files from your host filesystem.**
### **There is no Docker-managed storage layer in between.**
## >> Access the page in your browser
![Screenshot from 2026-03-04 01-40-06.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-40-06__kFFcvJkDkjQze1iVQSZR.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-40-06.png")

## >> Edit the `index.html`  on your host — refresh the browser
Edit `index.html`:

```
echo "<h1>UPDATED LIVE</h1>"
```
Refresh the browser.

The page updates instantly.

No container restart needed.

Why? Because Nginx is directly serving files from your host directory.

![Screenshot from 2026-03-04 01-41-48.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2001-41-48_4n2YY8rC_5h8jtKPgSwYt.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 01-41-48.png")



## **>> Write in your notes: What is the difference between a named volume and a bind mount?**
Here’s the clean comparison: 

## Named Volume
```
-v my-volume:/container/path
```
- Managed by Docker
- Stored in `/var/lib/docker/volumes/...` 
- Portable and safer
- Decoupled from specific host folder structure
- Best for databases and persistent app data
- Docker controls lifecycle
## Bind Mount
```
-v /host/path:/container/path
```
- Direct mapping to a specific host directory
- Host controls the files
- Changes reflect instantly
- Great for development
- Less portable (depends on host path)
- Can override container filesystem
# Core Difference (Conceptually)
| Named Volume | Bind Mount |
| ----- | ----- |
| Docker-managed storage | Host-managed storage |
| Abstracted location | Explicit host path |
| Good for production data | Great for development |
| More portable | Tied to host filesystem |
---

# What I Observed
When you edited `index.html` on your host and refreshed the browser, the changes appeared immediately because the container was using your host directory directly.

That’s the key behavior of bind mounts.



---

## Task 4: Docker Networking Basics
## >> List all Docker networks on your machine
```
ubuntu@ip-172-31-17-9:~/my-website$ docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
2a77ebde5b9f   bridge    bridge    local
bfe71b8cf78a   host      host      local
4dbc9856267f   none      null      local
```
The important one here is:

- `bridge`  → the **default Docker network**
## >> Inspect the default `bridge`  network
```
docker network inspect bridge
```
### **You’ll see a big JSON output. Look for:**
- `"Driver": "bridge"` 
- `"Subnet": "172.17.0.0/16"`  (usually)
- `"Gateway": "172.17.0.1"` 
### **This tells you:**
- Docker created a virtual network
- Containers attached to it get IP addresses like `172.17.0.x` 
### **How Default Bridge Works**
Think of it like:

A virtual switch

Containers plug into it

Each gets its own IP 

## >> Run two containers on the default bridge — can they ping each other by **name**?
### Let’s use lightweight Alpine containers:
`alpine` is a **very small Linux distribution** (only ~5MB).
 It’s commonly used for lightweight containers.

If you don’t already have it locally, Docker will automatically download it.

```
docker run -dit --name container1 alpine sh
docker run -dit --name container2 alpine sh
```
## `-d`
Runs the container in **detached mode** (in the background).

## `-i`
Keeps STDIN open (interactive mode).

## `-t`
Allocates a terminal (TTY).

Together `-dit` means:

>  Run it in background but allow interactive terminal usage. 

## What Actually Happens
When you run the first command:

```
docker run -dit --name container1 alpine sh
```
### Docker:
1. Pulls `alpine`  image (if not present)
2. Creates a container
3. Starts it
4. Runs `sh`  inside it
5. Keeps it running in the background
Then you do the same again for `container2`.

Now you have:

```
container1  → running alpine + shcontainer2  → running alpine + sh
```
### They are:
- Completely separate
- Same base image
- Independent filesystems
- Independent processes


### Now exec into container1:
```
docker exec -it container1 sh
```
### Install ping (Alpine doesn’t always include it):
```
apk add iputils
```
You’re probably inside an **Alpine container**, and you saw:

```
apk add iputils
```
Let’s break it down simply.

## What is `apk`?
`apk` is the **package manager** for Alpine Linux.

Think of it like:

- `apt`  → Ubuntu/Debian
- `yum`  / `dnf`  → CentOS/RHEL
- `apk`  → Alpine
It installs software inside Alpine.

## What does `add` mean?
```
apk add <package-name>
```
It means:

>  Install this package. 

## What is `iputils`?
`iputils` is a package that contains basic networking tools like:

- `ping` 
- `arping` 
- `clockdiff` 
Alpine images are **very minimal**, so `ping` is NOT installed by default.

That’s why you often need:

```
apk add iputils
```
## Example (Inside Alpine Container)
If you try:

```
ping google.com
```
You’ll probably see:

```
sh: ping: not found
```
Now install it:

```
apk updateapk add iputils
```
Then:

```
ping google.com
```
It works 

```
ubuntu@ip-172-31-17-9:~/my-website$ docker run -dit --name container1 alpine sh
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
589002ba0eae: Pull complete 
Digest: sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659
Status: Downloaded newer image for alpine:latest
3a82970e64db5c5a5e8237adfcf634d5187c60d446cd787cb368369a17187f55
ubuntu@ip-172-31-17-9:~/my-website$ docker run -dit --name container2 alpine sh
01e8c0946e053194eb7988ddaf919b2da0ce56dff997a90922995ba16184271e
ubuntu@ip-172-31-17-9:~/my-website$ docker exec -it container1 sh
/ # apk add iputils
(1/6) Installing libcap2 (2.77-r0)
(2/6) Installing iputils-arping (20250605-r0)
(3/6) Installing iputils-clockdiff (20250605-r0)
(4/6) Installing iputils-ping (20250605-r0)
(5/6) Installing iputils-tracepath (20250605-r0)
(6/6) Installing iputils (20250605-r0)
Executing busybox-1.37.0-r30.trigger
OK: 8475 KiB in 22 packages
/ # apk add iputils
OK: 8475 KiB in 22 packages
/ # ping google.com
PING google.com (142.250.69.174) 56(84) bytes of data.
64 bytes from pnseaa-ap-in-f14.1e100.net (142.250.69.174): icmp_seq=1 ttl=115 time=5.66 ms
64 bytes from pnseaa-ap-in-f14.1e100.net (142.250.69.174): icmp_seq=2 ttl=115 time=5.72 ms
64 bytes from pnseaa-ap-in-f14.1e100.net (142.250.69.174): icmp_seq=3 ttl=115 time=5.69 ms
64 bytes from pnseaa-ap-in-f14.1e100.net (142.250.69.174): icmp_seq=4 ttl=115 time=5.70 ms
64 bytes from pnseaa-ap-in-f14.1e100.net (142.250.69.174): icmp_seq=5 ttl=115 time=5.76 ms
^C
--- google.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 5.663/5.706/5.763/0.033 ms
/ #
```
```
PING google.com (142.250.69.174) 56(84) bytes of data.
```
This means:

- `google.com`  was converted to IP → `142.250.69.174` 
- 56 bytes of data were sent
- 84 bytes total including headers
So:
 DNS is working
 Internet connectivity exists

Then:

```
64 bytes from ... time=5.66 ms
```
This means:

- Google replied
- Response time ≈ 5.6 milliseconds
- That’s very fast 
### At The End
```
5 packets transmitted, 5 received, 0% packet loss
```
This tells us:

- 5 requests sent
- 5 replies received
- 0% packet loss → perfect connection
## What This Proves
From inside `container1`:

- The container has internet access
- Docker networking is working
- DNS resolution works
- Outbound traffic is allowed
- No firewall blocking ICMP
That’s a healthy Docker setup 

### **CONCEPTUALLY**
```
container1
   ↓
Docker virtual network
   ↓
EC2 instance (Ubuntu)
   ↓
AWS network
   ↓
Internet
   ↓
Google server
```
# can they ping each other by **name**?
> **Not by default**
**Yes, if they’re on a user-defined network** 

Let me explain clearly.

### Default Behavior (Why It Usually Fails)
When you run:

```
docker run -dit --name container1 alpine sh
docker run -dit --name container2 alpine sh
```
They are attached to Docker’s default `bridge` network.

On the default bridge network:

- Containers **can reach each other by IP**
- ❌ But **NOT by container name**
So this will likely fail:

```
ping container2
```
Because there’s no automatic DNS for names on the default bridge.

There are **two types of bridge networks**:

| Network Type | Name Resolution |
| ----- | ----- |
| Default `bridge`  | No |
| User-defined bridge | Yes |
### Final Answers (What You Should Write)
### List networks
`docker network ls` shows bridge, host, none.

### Inspect default bridge
It’s a virtual network (usually 172.17.0.0/16) created automatically by Docker.

### Can two containers on default bridge ping by name?
❌ No — name resolution does not work.

### Can they ping by IP?
Yes — they can communicate using IP addresses.

---

## Task 5: Custom Networks
## >>  Create a custom bridge network called `my-app-net` 
```
docker network create my-app-net
```
```
ubuntu@ip-172-31-17-9:~/my-website$ docker network ls
NETWORK ID     NAME         DRIVER    SCOPE
2a77ebde5b9f   bridge       bridge    local
bfe71b8cf78a   host         host      local
2dcdb1d5de2c   my-app-net   bridge    local
4dbc9856267f   none         null      local
```
### What I Just Created
I just create another “bridge”.

I created a **user-defined bridge network** — and that changes everything.

Unlike the default `bridge`, user-defined networks include:

- Automatic DNS resolution
- Better isolation
- Cleaner service-to-service communication
## >> Run two containers on `my-app-net` 
Let’s use Alpine again:

```
docker run -dit --name app1 --network my-app-net alpine sh
docker run -dit --name app2 --network my-app-net alpine sh
```
Enter the first container:

```
docker exec -it app1 sh
```
Install ping if needed:

```
apk add iputils
```
```
ubuntu@ip-172-31-17-9:~$ docker run -dit --name app1 --network my-app-net alpine sh
f114417ab4900e5506b42079309ee9a025b21c879faf616b64afe070cf030ba0
ubuntu@ip-172-31-17-9:~$ docker run -dit --name app2 --network my-app-net alpine sh
110607d073856911e71e0d5d1ed78d03817e8689c65b5bd7d98481e64f6ee9af
ubuntu@ip-172-31-17-9:~$ docker exec -it app1 sh
/ # apk add iputils
(1/6) Installing libcap2 (2.77-r0)
(2/6) Installing iputils-arping (20250605-r0)
(3/6) Installing iputils-clockdiff (20250605-r0)
(4/6) Installing iputils-ping (20250605-r0)
(5/6) Installing iputils-tracepath (20250605-r0)
(6/6) Installing iputils (20250605-r0)
Executing busybox-1.37.0-r30.trigger
OK: 8475 KiB in 22 packages
```
## >> Can they ping each other by **name** now?
inside app one run command - ping app2

```
/ # ping app2
PING app2 (172.18.0.3) 56(84) bytes of data.
64 bytes from app2.my-app-net (172.18.0.3): icmp_seq=1 ttl=64 time=0.070 ms
64 bytes from app2.my-app-net (172.18.0.3): icmp_seq=2 ttl=64 time=0.052 ms
64 bytes from app2.my-app-net (172.18.0.3): icmp_seq=3 ttl=64 time=0.050 ms
64 bytes from app2.my-app-net (172.18.0.3): icmp_seq=4 ttl=64 time=0.046 ms
^C
--- app2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3069ms
rtt min/avg/max/mdev = 0.046/0.054/0.070/0.009 ms
/ # 
```
### Yes — it works.
You’ll see replies coming back.

### Why Does This Work?
Because Docker automatically runs an **embedded DNS server** for user-defined bridge networks.

When:

```
app1 → tries to resolve app2
```
Docker’s internal DNS:

- Looks up container name
- Resolves it to its IP
- Routes traffic correctly
This does NOT exist on the default `bridge`.

## >> Write in your notes: Why does custom networking allow name-based communication but the default bridge doesn't?
###  Why does custom networking allow name-based communication but the default bridge doesn’t?
Because user-defined bridge networks include Docker’s built-in DNS service, which automatically resolves container names to IP addresses. The default bridge network is a legacy network and does not provide automatic name resolution between containers.

# The Real Concept
| Feature | Default Bridge | Custom Bridge |
| ----- | ----- | ----- |
| Auto DNS | No | Yes |
| Name-based communication | No | Yes |
| Recommended for apps | No | Yes |
| Isolation control | Basic | Better |
# The Big Mental Model
Default bridge = old-school, manual IP communication
Custom bridge = modern, service-style networking

This is why in real applications (microservices, backend + database, etc.) we **always** use custom networks.

You just unlocked the key to container-to-container communication the right way.
If you want next, we can connect:

- an app container to a database container
- simulate a mini production setup
- or explore Docker Compose networking
---

## Task 6: Put It Together
## >> Create a custom network
```
docker network create my-app-net1
```
Verify:

```
docker network ls
```
```
You should see `my-app-net1` listed.

ubuntu@ip-172-31-17-9:~$ docker network create my-app-net1
817e055a49969b6ab82bf7a23dd306a0211e6c77d7f0d188778ed77f37b5b0e7
ubuntu@ip-172-31-17-9:~$ docker network ls
NETWORK ID     NAME          DRIVER    SCOPE
f16052910388   bridge        bridge    local
bfe71b8cf78a   host          host      local
2dcdb1d5de2c   my-app-net    bridge    local
817e055a4996   my-app-net1   bridge    local
4dbc9856267f   none          null      local
```
## >> Run a database container (MySQL/Postgres) on that network with a volume for data
```
ubuntu@ip-172-31-17-9:~$ docker volume create mysql-data1
mysql-data1
ubuntu@ip-172-31-17-9:~$ docker volume ls
DRIVER    VOLUME NAME
local     8a062c3c3c89466fdf035bd6fe3d715fd138a9c0aa058778ffeb8a1c372255e6
local     30498394c4d21736a1aadccbcf82ad40f8512a5d9ffe6d8bfa08b6f27657ff37
local     my-mysql-data
local     mysql-data1
```


## >> Run an app container (use any image) on the same network
```
docker run -d \
--name db \
--network my-app-net1 \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=myapp \
-v mysql-data:/var/lib/mysql \
mysql:8
```
What this does:

- `--network my-app-net1`  → attaches to custom network
- `--name db`  → DNS hostname will be `db` 
- `-v mysql-data:/var/lib/mysql`  → persistent storage
Now the database is:

- On custom network
- Persisting data
- Reachable by name `db` 
```
ubuntu@ip-172-31-17-9:~$ docker run -d \
  --name db \
  --network my-app-net1 \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=myapp \
  -v mysql-data:/var/lib/mysql \
  mysql:8
44e6770b961d194cac61c15b95dd8d31d23a9953be7bddb19b62b1ab2e38f4e5
```
### **We’ll use Alpine as a simple “app” container.**
```
docker run -dit \
--name app \
--network my-app-net1 \
alpine sh
```
### **Enter it:**
```
docker exec -it app sh
```
### Install tools:
```
apk add mysql-client iputils
```
```
ubuntu@ip-172-31-17-9:~$ docker run -dit \
  --name app \
  --network my-app-net \
  alpine sh
89fa4586d31531cafbcc5fe6ed3adc9296a9af8b71624ea986029fc7413258cd
ubuntu@ip-172-31-17-9:~$ docker exec -it app sh
/ # apk add mysql-client iputils
( 1/13) Installing libcap2 (2.77-r0)
( 2/13) Installing iputils-arping (20250605-r0)
( 3/13) Installing iputils-clockdiff (20250605-r0)
( 4/13) Installing iputils-ping (20250605-r0)
( 5/13) Installing iputils-tracepath (20250605-r0)
( 6/13) Installing iputils (20250605-r0)
( 7/13) Installing mariadb-common (11.4.9-r0)
( 8/13) Installing libgcc (15.2.0-r2)
( 9/13) Installing ncurses-terminfo-base (6.5_p20251123-r0)
(10/13) Installing libncursesw (6.5_p20251123-r0)
(11/13) Installing libstdc++ (15.2.0-r2)
(12/13) Installing mariadb-client (11.4.9-r0)
(13/13) Installing mysql-client (11.4.9-r0)
Executing busybox-1.37.0-r30.trigger
OK: 50.2 MiB in 29 packages
```
## >> Verify the app container can reach the database by container name
### First test DNS resolution:
```
ping db
```
### It should resolve and respond.
### Now test actual database connectivity:
```
mysql -h db -u root -p
```
### Enter password:
```
secret
```
### If you get a MySQL prompt — success 
### You’ve just connected:
```
ubuntu@ip-172-31-17-9:~$ docker exec -it app sh
/ # ping db
PING db (172.18.0.5) 56(84) bytes of data.
64 bytes from db.my-app-net (172.18.0.5): icmp_seq=1 ttl=64 time=0.085 ms
64 bytes from db.my-app-net (172.18.0.5): icmp_seq=2 ttl=64 time=0.046 ms
64 bytes from db.my-app-net (172.18.0.5): icmp_seq=3 ttl=64 time=0.048 ms
64 bytes from db.my-app-net (172.18.0.5): icmp_seq=4 ttl=64 time=0.058 ms
64 bytes from db.my-app-net (172.18.0.5): icmp_seq=5 ttl=64 time=0.050 ms
^C
--- db ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4125ms
rtt min/avg/max/mdev = 0.046/0.057/0.085/0.014 ms
/ #
```
## Database Connectivity Test
The second part of the task says:

```
mysql -h db -u root -p
```
In your case, because Alpine uses the MariaDB client, you hit an authentication plugin mismatch (`caching_sha2_password`).

That is **not a networking failure**.

It’s a client compatibility issue.

If you want to fully demonstrate DB connectivity cleanly, use the matching MySQL client container:

```
docker run -it --rm \
--network my-app-net \
ysql:8.0 \
mysql -h db -u root -p
```
Password:

```
secret
```
If you see:

```
mysql>
```
Then you've verified full database connectivity as well.



## Hints
- Volumes: `docker volume create` , `-v volume_name:/path` 
- Bind mount: `-v /host/path:/container/path` 
- Networking: `docker network create` , `--network` 
- Ping: `docker exec container1 ping container2` 


