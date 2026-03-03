# Day 31 – Dockerfile: Build Your Own Images

## **Task 1: Your First Dockerfile**
## **>>Create a folder called **`**my-first-image**`** **
1. Inside it, create a `Dockerfile`  that:
    - Uses `ubuntu`  as the base image
    - Installs `curl` 
    - Sets a default command to print `"Hello from my custom image!"` 

In terminal i did :

```
mkdir my-first-image
cd my-first-image
```
Inside the folder, create a file named:

```
touch dockerfile
```
open dockerfile and add below and save it :wq and close

```
# Use Ubuntu as base image
FROM ubuntu:latest

# Update package list and install curl
RUN apt update && apt install -y curl

# Default command
CMD ["echo", "Hello from my custom image!"]
```
## **>>Build the image and tag it **`**my-ubuntu:v1**`** **
Run this inside `my-first-image`:

```
docker build -t my-ubuntu:v1 .
```
What this does:

- `-t`  → tags the image
- `my-ubuntu:v1`  → image name and version
- `.`  → build using the current directory
If successful, you’ll see something like:

```
Successfully built <image-id>
Successfully tagged my-ubuntu:v1
```
You can verify it exists:

```
docker images
```
```
ubuntu@ip-172-31-24-207:~/my-first-image$ docker images
REPOSITORY    TAG       IMAGE ID       CREATED          SIZE
my-ubuntu     v1        78d8ca255b11   24 seconds ago   147MB
```
## **>>Run a container from your image**
```
docker run my-ubuntu:v1
```
You should see:

```
Hello from my custom image!
```
```
ubuntu@ip-172-31-24-207:~/my-first-image$ docker run my-ubuntu:v1
Hello from my custom image!
```
**Verify:** The message prints on `docker run` 

# What I Just Learned
- `FROM`  → sets base image
- `RUN`  → installs packages during build
- `CMD`  → defines default command at runtime
- `docker build`  → creates an image
- `docker run`  → starts a container
---

### Task 2: Dockerfile Instructions
Create a new Dockerfile that uses **all** of these instructions:

- `FROM`  — base image
- `RUN`  — execute commands during build
- `COPY`  — copy files from host to image
- `WORKDIR`  — set working directory
- `EXPOSE`  — document the port
- `CMD`  — default command
### **Step 1: Create Project Folder**
```
mkdir docker-task-2
cd docker-task-2
```
### Step 2: Create an App File
Create a file called `app.py`:

```
touch app.py
```
Add this inside `app.py`:

```
from http.server import SimpleHTTPRequestHandlerfrom socketserver import TCPServerPORT = 8000Handler = SimpleHTTPRequestHandlerwith TCPServer(("", PORT), Handler) as httpd:    print(f"Serving on port {PORT}")    httpd.serve_forever()
```
This creates a simple web server running on port 8000.

### **Step 3: Create the Dockerfile**
Create the Dockerfile:

```
touch dockerfile
```
Add this:

```
# 1️⃣ FROM — Base image
FROM python:3.11-slim

# 2️⃣ WORKDIR — Set working directory
WORKDIR /app

# 3️⃣ COPY — Copy files into image
COPY app.py .

# 4️⃣ RUN — Execute command during build
RUN echo "Building Docker Task 2 image..."

# 5️⃣ EXPOSE — Document port
EXPOSE 5000

# 6️⃣ CMD — Default command
CMD ["python", "app.py"]
```
Important concept:

- `RUN`  → happens while building image
- `CMD`  → happens when container starts
### **Step 4: Build the Image**
```
docker build -t docker-task2:v3 .
```
### **Step 5: Run the Container**
```
docker run -p 5000:5000 docker-task2:v3
```
Now open your browser and go to:

```
http://aws-ec2-public ip:5000
```
You should see a simple hello world page



![Screenshot from 2026-03-03 17-08-09.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-03%2017-08-09_MsE8VFV4nK47C3REFPg__.png?ixlib=js-3.8.0 "Screenshot from 2026-03-03 17-08-09.png")

# Big Picture: What Happens When You Build & Run
## When You Run `docker build` 
Docker:

1. Pulls base image (if not already downloaded)
2. Creates `/app` 
3. Copies `app.py` 
4. Executes the RUN command
5. Saves image layers
Now you have a reusable image.

## When You Run `docker run` 
Docker:

1. Creates a container from the image
2. Runs `python app.py` 
3. Your server starts
4. Port mapping connects it to your host
# Image vs Container (Very Important)
| Image | Container |
| ----- | ----- |
| Blueprint | Running instance |
| Static | Live process |
| Built once | Can run many times |
Think:

- Dockerfile → recipe
- Image → baked cake
- Container → slice you’re eating
# Why Dockerfiles Matter
They give you:

- Reproducibility
- Portability
- Same environment everywhere
- No “it works on my machine” problems
---



## **Task 3: CMD vs ENTRYPOINT**
## **Create an image with **`**CMD ["echo", "hello"]**`**  — run it, then run it with a custom command. What happens?**
## Dockerfile (CMD version)
Create a new folder:

```
mkdir docker-cmd
cd docker-cmd
```
Create a `Dockerfile`:

```
FROM ubuntu:latest
CMD ["echo", "hello"]
```
## Build It
```
docker build -t cmd-test:v1 .
```
## Run Normally
```
docker run cmd-test:v1
```
Output:

```
hello
```
Perfect.

## Run With Custom Command
```
docker run cmd-test:v1 echo "bye"
```
Output:

```
bye
```
### What Happened?
The new command **completely replaced** the CMD.

So:

```
CMD = defaultUser command = override
```
`CMD` is easily overridden.

```
ubuntu@ip-172-31-24-207:~$ mkdir docker-cmd

ubuntu@ip-172-31-24-207:~$ cd docker-cmd

ubuntu@ip-172-31-24-207:~/docker-cmd$ vim dockerfile
ubuntu@ip-172-31-24-207:~/docker-cmd$ docker build -t cmd-test:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  2.048kB
Step 1/2 : FROM ubuntu:latest
 ---> bbdabce66f1b
Step 2/2 : CMD ["echo", "hello"]
 ---> Running in 854b01f80aeb
 ---> Removed intermediate container 854b01f80aeb
 ---> 1a3154d201c6
Successfully built 1a3154d201c6
Successfully tagged cmd-test:v1

ubuntu@ip-172-31-24-207:~/docker-cmd$ docker run cmd-test:v1
hello
ubuntu@ip-172-31-24-207:~/docker-cmd$ docker run cmd-test:v1 echo "bye"
bye
```
## **Create an image with **`**ENTRYPOINT ["echo"]**`**  — run it, then run it with additional arguments. What happens?**
>>Now create another folder:

```
mkdir docker-entrypoint
cd docker-entrypoint
```
Create a `Dockerfile`:

```
FROM ubuntu:latest
ENTRYPOINT ["echo"]
```
## Build It
```
docker build -t entry-test:v1 .
```
## Run Normally
```
docker run entry-test:v1
```
Output:

(prints nothing — because echo has no argument)

## Run With Additional Arguments
```
docker run entry-test:v1 hello
```
Output:

```
hello
```
## Run With Multiple Arguments
```
docker run entry-test:v1 hello world
```
Output:

```
hello world
```
### What Happened?
With ENTRYPOINT:

- You cannot replace it easily
- Anything after image name becomes arguments
So Docker does:

```
ENTRYPOINT + your arguments
```
Internally it runs:

```
echo hello world
```
# The Real Difference
| CMD | ENTRYPOINT |
| ----- | ----- |
| Default command | Fixed main command |
| Easily overridden | Harder to override |
| Used for defaults | Used for main executable |
## **Write in your notes: When would you use CMD vs ENTRYPOINT?**
>>Simple Mental Model

Think of it like this:

- `ENTRYPOINT`  → The engine of the car
- `CMD`  → The default destination
You can change the destination easily.
 You don’t replace the engine.

### **remember just one thing:**
>  Use **CMD for defaults**, use **ENTRYPOINT for fixed behavior**.

## One Line Summary
CMD = replace
ENTRYPOINT = append

CMD = “If you don’t say anything, I’ll do this.”

ENTRYPOINT = “I will always do this. You can only add to it.”

```
Final = ENTRYPOINT + what you type
```
```
Final = what you type (if you type something)
Otherwise = CMD
```
## Use **CMD** when:
- You want to provide a **default command**
- You want users to be able to **replace the whole command**
- The container is flexible
- You’re okay with someone completely changing what runs
## Use **ENTRYPOINT** when:
- The container should always run a **specific main program**
- You want the container to behave like a **fixed tool**
- You want users to only pass arguments, not replace the command
Use **CMD** for defaults.

Use **ENTRYPOINT** for the main executable.

Use both together when you want structure + flexibility.

---

## **Task 4: Build a Simple Web App Image**
## **Create a small static HTML file (**`**index.html**`** ) with any content**
>> Created simple index.html

```
<!DOCTYPE html>
<html>
<head>
    <title>My Website</title>
</head>
<body>
    <h1>Hello from my Nginx Docker Container 🚀</h1>
    <p>This is my static website running inside Docker.</p>
</body>
</html>
```
## **Write a Dockerfile that:**
## **Uses **`**nginx:alpine**`**  as base**
## **Copies your **`**index.html**`**  to the Nginx web directory**
>> 

```
#Use lightweight Nginx image
FROM nginx:alpine
#Copy index.html to Nginx default web directory
COPY index.html /usr/share/nginx/html/
#Expose port 80
EXPOSE 80
```
Nginx serves files from:

```
/usr/share/nginx/html/
```
When we copy `index.html` there, Nginx automatically serves it.

The nginx image already contains:

- ENTRYPOINT
- CMD
- Nginx server startup command
So we don’t need to write CMD.

## **Build and tag it **`**my-website:v1**`** **
```
docker build -t my-website:v1 .
```
```
Successfully tagged my-website:v1
```
## **Run it with port mapping and access it in your browser**
```
docker run -d -p 8080:80 my-website:v1
```
This means:

```
Host 8080 → Container 80
```
### Running on EC2:
```
http://<your-public-ip>:8080
```


![Screenshot from 2026-03-03 19-04-05.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-03%2019-04-05_Vi8krs-qoDXnhQ-ki7iL_.png?ixlib=js-3.8.0 "Screenshot from 2026-03-03 19-04-05.png")

---



## Task 5: .dockerignore
## Create a `.dockerignore`  file in one of your project folders
## **Add entries for: **`**node_modules**`** , **`**.git**`** , **`***.md**`** , **`**.env**`** **
```
vim .dockerignore

Add below 

node_modules
.git
*.md
.env
```
Docker will NOT send these files to the build context:

- `node_modules/`  → huge folder, not needed
- `.git/`  → repo history, unnecessary
- `*.md`  → all markdown files
- `.env`  → sensitive environment variables
Very common best practice.

### Let’s Create Dummy Files to Test
Create test files so we can verify:

```
mkdir node_modules
touch README.md
touch .env
mkdir .git
```
## **Build the image — verify that ignored files are not included**


```
Sending build context to Docker daemon  4.096kB
```
That small size is your **first proof** that ignored files are not being sent.

Now let’s verify inside the image.

```
ubuntu@ip-172-31-24-207:~/my-website$ docker build -t test-ignore:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  4.096kB
Step 1/3 : FROM nginx:alpine
 ---> b76de378d572
Step 2/3 : COPY index.html /usr/share/nginx/html/
 ---> Using cache
 ---> 40dbf4199bc1
Step 3/3 : EXPOSE 80
 ---> Using cache
 ---> 6a40b78f795c
Successfully built 6a40b78f795c
Successfully tagged test-ignore:v1
```
# Step 3 — Verify Inside the Container
Run:

```
docker run -it test-ignore:v1 sh
```
Now inside the container, check:

```
ls -a /
```
Then check:

```
ls -a /usr/share/nginx/html
```
You should only see:

```
index.html
```
You should NOT see:

- `.git` 
- `.env` 
- `node_modules` 
- `README.md` 
If they are not there → SUCCESS 

Exit:

---

## Task 6: Build Optimization
## Build an image, then change one line and rebuild — notice how Docker uses **cache**
## Reorder your Dockerfile so that frequently changing lines come **last**
## Write in your notes: Why does layer order matter for build speed?
Use your `my-website` project.

## Current Dockerfile
```
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```
## First Build
```
docker build -t optimize-test:v1 .
```
You’ll see something like:

```
ubuntu@ip-172-31-24-207:~/my-website$ docker build -t optimize-test:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  4.096kB
Step 1/3 : FROM nginx:alpine
 ---> b76de378d572
Step 2/3 : COPY index.html /usr/share/nginx/html/
 ---> Using cache
 ---> 40dbf4199bc1
Step 3/3 : EXPOSE 80
 ---> Using cache
 ---> 6a40b78f795c
Successfully built 6a40b78f795c
Successfully tagged optimize-test:v1
```
Everything builds fresh.

## Build Again Without Changing Anything
```
docker build -t optimize-test:v1 .
```
Now you’ll see:

```
ubuntu@ip-172-31-24-207:~/my-website$ docker build -t optimize-test:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  4.096kB
Step 1/3 : FROM nginx:alpine
 ---> b76de378d572
Step 2/3 : COPY index.html /usr/share/nginx/html/
 ---> Using cache
 ---> 40dbf4199bc1
Step 3/3 : EXPOSE 80
 ---> Using cache
 ---> 6a40b78f795c
Successfully built 6a40b78f795c
Successfully tagged optimize-test:v1
```
Docker reused all layers.

That’s Docker cache.

## Now Change One Line
Open `index.html` and change one word:

```
<h1>Hello Optimized Docker </h1>
```
Save it.

Now rebuild:

```
docker build -t optimize-test:v1 .
```
You’ll see:

```
ubuntu@ip-172-31-24-207:~/my-website$ docker build -t optimize-test:v1 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  4.096kB
Step 1/3 : FROM nginx:alpine
 ---> b76de378d572
Step 2/3 : COPY index.html /usr/share/nginx/html/
 ---> 255101c44eb4
Step 3/3 : EXPOSE 80
 ---> Running in 8579cd4777c5
 ---> Removed intermediate container 8579cd4777c5
 ---> 446a0ec98626
Successfully built 446a0ec98626
Successfully tagged optimize-test:v1
```
Notice:

- FROM layer cached
- COPY rebuilt
- Everything after COPY rebuilt
This is the key.

# Why Did EXPOSE Rebuild?
Because Docker builds in layers.

If one layer changes:

All layers after it must rebuild.

# Part 2 — Reorder for Optimization
Imagine this Dockerfile (bad order):

```
FROM node:18
COPY . .
RUN npm install
CMD ["npm", "start"]
```
Problem:

If you change one small file → `COPY . .` changes → `npm install` runs again → slow build.

## Better Optimized Version
```
FROM node:18COPY package.json package-lock.json ./RUN npm installCOPY . .CMD ["npm", "start"]
```
Now:

- If you change app code → only last COPY rebuilds
- `npm install`  stays cached
- Build is much faster
This is real-world optimization.

# Part 3 — Important Notes
## Why Does Layer Order Matter for Build Speed?
- Docker builds images in layers.
- Each instruction creates a new layer.
- Docker caches layers if nothing changes.
- If a layer changes, all layers after it rebuild.
- Therefore, frequently changing instructions should be placed at the bottom.
- Stable instructions (like installing dependencies) should be placed at the top.
# Simple Rule to Remember
Stable stuff → top
Changing stuff → bottom

Because:

Change in top layer = everything rebuilds
Change in bottom layer = only bottom rebuilds

# Real-World Impact
In large projects:

Bad order → 5 minute rebuild
 Good order → 10 second rebuild

Huge difference.







