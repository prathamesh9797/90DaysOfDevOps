# Day 37 – Docker Revision & Cheat Sheet

# Docker Cheat Sheet
## Container Commands
```
docker run IMAGE                # Create and start a new container from an image
docker ps                       # List running containers
docker ps -a                    # List all containers (running + stopped)
docker stop CONTAINER           # Stop a running container
docker rm CONTAINER             # Remove a stopped container
docker exec -it CONTAINER CMD   # Run a command inside a running container
docker logs CONTAINER           # Show logs from a container
```
# Image Commands
```
docker build -t NAME:TAG .      # Build an image from a Dockerfile
docker pull IMAGE               # Download an image from a registry
docker push IMAGE               # Upload an image to a registry
docker tag IMAGE NEW_IMAGE      # Create a new tag for an image
docker image ls                 # List local Docker images
docker rmi IMAGE                # Remove a Docker image
```
# Volume Commands
```
docker volume create NAME       # Create a Docker volume
docker volume ls                # List all volumes
docker volume inspect NAME      # Show detailed info about a volume
docker volume rm NAME           # Delete a volume
```
# Network Commands
```
docker network create NAME      # Create a custom Docker network
docker network ls               # List Docker networks
docker network inspect NAME     # Show network details
docker network connect NET CONT # Connect a container to a network
```
# Docker Compose Commands
```
docker compose up               # Create and start services
docker compose up -d            # Start services in background
docker compose down             # Stop and remove services
docker compose ps               # List running compose containers
docker compose logs             # Show logs from services
docker compose build            # Build images defined in compose file
```
# Cleanup Commands
```
docker system df                # Show Docker disk usage
docker system prune             # Remove unused containers, networks, images
docker system prune -a          # Remove all unused images and resources
```
# Dockerfile Instructions
```
FROM IMAGE          # Base image for the build
RUN COMMAND         # Execute command during image build
COPY SRC DEST       # Copy files into the image
WORKDIR PATH        # Set working directory inside container
EXPOSE PORT         # Document container port
CMD ["command"]     # Default command when container starts
ENTRYPOINT ["cmd"]  # Fixed startup command for container
```
Tip: The **6 commands DevOps engineers use most daily** are:

```
docker ps
docker logs
docker exec -it
docker build
docker compose up -d
docker system prune
```
## **What is the difference between an image and a container?**
>>A **Docker image** is a read-only template used to create containers, while a **container** is a running instance of that image.

**Explanation:**

- An **image** contains the application code, dependencies, libraries, and configuration needed to run an application.
- A **container** is the runtime environment where that image executes.


## What happens to data inside a container when you remove it?
>> By default, data inside a container is **lost when the container is removed**.

**Explanation:**
 Containers are **ephemeral**. When a container is deleted, its filesystem is also removed unless the data is stored in:

- **Docker volumes**
- **Bind mounts**


## **How do two containers on the same custom network communicate?**
>>**Short Answer:**
 Containers on the same Docker network communicate using **container names as hostnames**.

**Explanation:**
 Docker provides **internal DNS resolution** inside custom networks. Containers can directly access each other using their service name.



## **What does **`**docker compose down -v**`**  do differently from **`**docker compose down**`** ?**
`docker compose down` removes containers and networks, while
 `docker compose down -v` also removes **volumes**.

**Explanation:**

| Command | What it Removes |
| ----- | ----- |
| docker compose down | containers, networks |
| docker compose down -v | containers, networks, volumes |
**Important:**
 Removing volumes deletes **persistent data like databases**.

## **Why are multi-stage builds useful?**
>>Multi-stage builds help create **smaller and more secure Docker images**.

**Explanation:**
 They allow you to use multiple build stages:

1. **Build stage** – compile or install dependencies
2. **Final stage** – copy only necessary files
This removes unnecessary build tools and reduces image size.



## **What is the difference between **`**COPY**`**  and **`**ADD**`** ?**
>>Both copy files into a Docker image, but `ADD` has additional features.

| Command | Behavior |
| ----- | ----- |
| COPY | Simply copies files/folders |
| ADD | Can extract archives and download URLs |
**Best Practice:**
 Use **COPY** unless you specifically need `ADD` features.



## **What does **`**-p 8080:80**`**  mean?**
>> It maps **port 8080 on the host** to **port 80 inside the container**.

**Format:**

```
host_port:container_port
```
Example:

```
docker run -p 8080:80 nginx
```
## **How do you check how much disk space Docker is using?**
>>docker system df

**Explanation:**
 This command shows disk usage by:

- images
- containers
- volumes
- build cache


