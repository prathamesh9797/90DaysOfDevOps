# Day 35 – Multi-Stage Builds & Docker Hub

### Task 1: The Problem with Large Images
1. Write a simple Go, Java, or Node.js app (even a "Hello World" is fine)
2. Create a Dockerfile that builds and runs it in a **single stage**
3. Build the image and check its **size**
Note down the size — you'll compare it later.

## Create a Simple Node.js App
Create a folder:

```
mkdir docker-large-image-demo
cd docker-large-image-demo
```
Create a file **app.js**

```
console.log("Hello from Docker!");
```
## Create a Dockerfile (Single Stage)
Create a file named **Dockerfile**

```
FROM node:18
WORKDIR /app
COPY app.js .
CMD ["node", "app.js"]
```
Explanation:

- `FROM node:18`  → pulls the full Node.js image
- `WORKDIR /app`  → working directory inside container
- `COPY app.js .`  → copy app file
- `CMD`  → runs the program
This **uses the full Node image**, which is intentionally large.

## Build the Docker Image
Run:

```
docker build -t large-image-demo .
```
Example output will end with something like:

```
Successfully built <image-id>Successfully tagged large-image-demo:latest
```
## Check the Image Size
Run:

```
docker images
```
output:

```
ubuntu@ip-172-31-17-9:~/docker-large-image-demo$ docker images
REPOSITORY         TAG         IMAGE ID       CREATED          SIZE
large-image-demo   latest      4b5afcbf951e   31 seconds ago   1.09GB
docker-app_web     latest      0b7fa487d7a6   2 hours ago      156MB
python             3.11-slim   7c68b5683872   14 hours ago     124MB
postgres           15          d743cd41504b   5 days ago       445MB
wordpress          latest      6fe8e9457b10   7 days ago       752MB
redis              7           a7f6d19aede6   7 days ago       117MB
nginx              latest      fd204fe2f750   7 days ago       161MB
mysql              8.0         b3197d59eb3b   12 days ago      786MB
mysql              8           82da5e68017f   12 days ago      790MB
alpine             latest      a40c03cbb81c   5 weeks ago      8.44MB
node               18          b50082bc3670   11 months ago    1.09GB
mysql              5.7         5107333e08a8   2 years ago      501MB
```
result:

| Image | Size |
| ----- | ----- |
| Node Full Image | **~900MB – 1.2GB** |
**recorded size look like**:

```
large-image-demo   latest   ~1.09GB
```
Write it down for comparison later.

## Why Is It So Large?
Because `node:18` includes:

- Full Debian Linux
- Package manager
- Build tools
- Documentation
- Extra libraries
Even though our app is **1 line of code**, the image is **~1GB**.

---

### Task 2: Multi-Stage Build
1. Rewrite the Dockerfile using **multi-stage build**:
    - Stage 1: Build the app (install dependencies, compile)
    - Stage 2: Copy only the built artifact into a minimal base image (`alpine` , `distroless` , or `scratch` )

2. Build the image and check its size again
3. Compare the two sizes
Write in your notes: Why is the multi-stage image so much smaller?

##  Multi-Stage Dockerfile
Replace your previous Dockerfile with this one.

```
# Stage 1: Build stage
FROM node:18 AS builder

WORKDIR /app

COPY app.js .

# Stage 2: Runtime stage (minimal image)
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/app.js .

CMD ["node", "app.js"]
```
### What happens here
**Stage 1 – builder**

- Uses full **node:18** image
- Installs tools and prepares the application
- Produces the built artifact (here: `app.js` )
**Stage 2 – runtime**

- Uses **node:18-alpine**, a much smaller image
- Copies only the required files from the builder stage
- Excludes build tools and unnecessary files
# Build the Multi-Stage Image
Run:

```
docker build -t multi-stage-demo .
```
# Check the Image Size
Run:

```
docker images
```
output:

```
ubuntu@ip-172-31-17-9:~/docker-large-image-demo$ docker images
REPOSITORY         TAG         IMAGE ID       CREATED              SIZE
multi-stage-demo   latest      8a0306db9fd8   About a minute ago   127MB
large-image-demo   latest      4b5afcbf951e   28 minutes ago       1.09GB
docker-app_web     latest      0b7fa487d7a6   2 hours ago          156MB
python             3.11-slim   7c68b5683872   15 hours ago         124MB
postgres           15          d743cd41504b   5 days ago           445MB
wordpress          latest      6fe8e9457b10   7 days ago           752MB
redis              7           a7f6d19aede6   7 days ago           117MB
nginx              latest      fd204fe2f750   7 days ago           161MB
mysql              8.0         b3197d59eb3b   12 days ago          786MB
mysql              8           82da5e68017f   12 days ago          790MB
alpine             latest      a40c03cbb81c   5 weeks ago          8.44MB
node               18-alpine   ee77c6cd7c18   11 months ago        127MB
node               18          b50082bc3670   11 months ago        1.09GB
mysql              5.7         5107333e08a8   2 years ago          501MB
```
Typical sizes:

| Image Type | Size |
| ----- | ----- |
| Single-stage (node:18) | ~1GB |
| Multi-stage (node:18-alpine) | ~100–150MB |
# Size Comparison
Example comparison you can write in your notes:

```
Single-stage image size: ~1.1GB
Multi-stage image size: ~120MB

Size reduction: ~90%
```
# Why Is the Multi-Stage Image Much Smaller?
Write something like this in your notes:

**Reason:**

Multi-stage builds reduce the final Docker image size because the build environment and unnecessary dependencies are not included in the final runtime image.

**Explanation:**

1. The first stage contains build tools, package managers, and development dependencies.
2. The second stage starts from a minimal base image (like Alpine).
3. Only the required compiled artifacts or application files are copied into the final image.
4. Everything else from the build stage is discarded.
**Result:**

- Smaller image size
- Faster downloads and deployments
- Reduced security vulnerabilities
- Less storage usage


**Example final notes**

```
Single-stage Docker image: ~1.1GB
Multi-stage Docker image: ~120MB

Multi-stage builds reduce size because the final image only contains the runtime environment and application files. Build tools and unnecessary dependencies remain in the builder stage and are not included in the final image.
```
---

### Task 3: Push to Docker Hub
1. Create a free account on [﻿Docker Hub](https://hub.docker.com/)  (if you don't have one)
2. Log in from your terminal
3. Tag your image properly: `yourusername/image-name:tag` 
4. Push it to Docker Hub
5. Pull it on a different machine (or after removing locally) to verify
## Create a Docker Hub Account
Go to:

 [﻿https://hub.docker.com](https://hub.docker.com/) 

Create a **free account** and note your **Docker Hub username**.

Example:

```
username: prathamesh9797
```
```
ubuntu@ip-172-31-17-9:~$ docker login -u prathamesh97

i Info → A Personal Access Token (PAT) can be used instead.
         To create a PAT, visit https://app.docker.com/settings
         
         
Password: 

WARNING! Your credentials are stored unencrypted in '/home/ubuntu/.docker/config.json'.
Configure a credential helper to remove this warning. See
https://docs.docker.com/go/credential-store/

Login Succeeded
ubuntu@ip-172-31-17-9:~$ docker push prathamesh97/multi-stage-demo:v1
The push refers to repository [docker.io/prathamesh97/multi-stage-demo]
fda96b2dbaab: Pushed 
580a7386eb04: Pushed 
82140d9a70a7: Pushed 
f3b40b0cdb1c: Pushed 
0b1f26057bd0: Pushed 
08000c18d16d: Pushed 
v1: digest: sha256:65b070b91265cbe5e2a9591194f2667971743d1ceca13ea222b9828ad6e9b565 size: 1571
```
---

### Task 4: Docker Hub Repository
1. Go to Docker Hub and check your pushed image
2. Add a **description** to the repository
3. Explore the **tags** tab — understand how versioning works
4. Pull a specific tag vs `latest`  — what happens?


![Screenshot from 2026-03-04 17-15-49.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2017-15-49_Hiy74Fo2K0OSyoRptjWRV.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 17-15-49.png")



![Screenshot from 2026-03-04 17-15-33.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2017-15-33_ZYVs8n4JCc3ZMpcw5e_rz.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 17-15-33.png")

![Screenshot from 2026-03-04 17-23-47.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2017-23-47_Gj4ji-yaJzTyWJi2qXX_2.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 17-23-47.png")

| Tag | Image Size | Last Updated |
| ----- | ----- | ----- |
| v1 | 127MB | recently |
### What Tags Mean
A **tag** represents a **version of a Docker image**.



#### **PULLING TAG **
```
ubuntu@ip-172-31-17-9:$ docker pull prathamesh97/multi-stage-demo:v1
v1: Pulling from prathamesh97/multi-stage-demo
Digest: sha256:65b070b91265cbe5e2a9591194f2667971743d1ceca13ea222b9828ad6e9b565
Status: Image is up to date for prathamesh97/multi-stage-demo:v1
docker.io/prathamesh97/multi-stage-demo:v1
ubuntu@ip-172-31-17-9:$ docker run prathamesh97/multi-stage-demo:v1
Hello from Docker!
```
---

### Task 5: Image Best Practices
Apply these to one of your images and rebuild:

1. Use a **minimal base image** (alpine vs ubuntu — compare sizes)
2. **Don't run as root** — add a non-root USER in your Dockerfile
3. Combine `RUN`  commands to **reduce layers**
4. Use **specific tags** for base images (not `latest` )
Check the size before and after.

# Improved Dockerfile (Best Practices)
Edit your **Dockerfile**:

```
# Use specific minimal base image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy application
COPY app.js .

# Change ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Run application
CMD ["node", "app.js"]
```
# Best Practices Applied
### Minimal Base Image
We used:

```
node:18-alpine
```
instead of

```
node:18
```
Size difference:

| Base Image | Size |
| ----- | ----- |
| node:18 | ~1.09GB |
| node:18-alpine | ~127MB |
Alpine is a **very lightweight Linux distribution**.

###  Run as Non-Root User
Added:

```
RUN addgroup -S appgroup && adduser -S appuser -G appgroupUSER appuser
```
Why?

- Containers running as **root are a security risk**
- Best practice is running applications as **non-root users**
### Combine RUN Commands
Instead of multiple layers like:

```
RUN addgroupRUN adduserRUN chown
```
we could combine them:

```
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup && \
    chown -R appuser:appgroup /app
```
This reduces the number of **Docker layers**.

### Use Specific Image Tags
Instead of:

```
node:latest
```
we used:

```
node:18-alpine
```
Why?

- Prevents unexpected updates
- Ensures consistent builds
# Build the Optimized Image
Run:

```
docker build -t best-practice-demo .
```
# Check Image Size
Run:

```
docker images
```
Example output:

| Image | Size |
| ----- | ----- |
| large-image-demo | 1.09GB |
| multi-stage-demo | 127MB |
| best-practice-demo | ~120MB |
# Before vs After Comparison
| Build Type | Base Image | Size |
| ----- | ----- | ----- |
| Single Stage | node:18 | **1.09GB** |
| Multi Stage | node:18-alpine | **127MB** |
| Best Practice | node:18-alpine + non-root | **~120MB** |
# Example Answer
```
Docker image best practices were applied to optimize the container.

Improvements made:
1. Used a minimal base image (node:18-alpine) instead of node:18.
2. Created and used a non-root user for security.
3. Combined RUN commands to reduce image layers.
4. Used a specific base image tag instead of 'latest'.

Image size comparison:
Single-stage image: 1.09GB
Multi-stage image: 127MB
Optimized image: ~120MB

Using Alpine and best practices significantly reduced image size and improved security.
```


