# Day 36 – Docker Project: Dockerize a Full Application

# Day 36 – Docker Project
## 1. Application Chosen
For this project, I created a **static web application served by Nginx with a Node.js backend API and a PostgreSQL database**.

### Architecture
Browser → Nginx (Frontend) → Node.js Backend API → PostgreSQL Database

### Why I Chose This App
I selected this architecture because:

- It demonstrates a **multi-container application**
- It includes **frontend, backend, and database services**
- It reflects a **real-world microservice style deployment**
- It allowed me to practice **Dockerfile creation, Docker Compose, networking, and volumes**
The frontend contains a simple webpage with a **"Get Message" button** that sends a request to the backend API.
The backend returns a JSON message that is displayed on the webpage.

---

# 2. Dockerfile
Below is the Dockerfile used to containerize the Node.js backend API.

```dockerfile
# Use a lightweight Node.js base image
FROM node:18-alpine

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json first
# This allows Docker to cache dependency installation
COPY backend/package*.json ./

# Install required Node.js dependencies
RUN npm install

# Copy the rest of the backend source code
COPY backend .

# Create a non-root user for better security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Switch to the non-root user
USER appuser

# Expose the port used by the Node.js API
EXPOSE 3000

# Command to start the backend server
CMD ["node", "server.js"]
```
### Explanation
- **FROM node:18-alpine**
Uses a lightweight Alpine-based Node.js image to keep the image size small.
- **WORKDIR /app**
Sets the working directory inside the container.
- *_COPY backend/package_.json ./ **
Copies dependency files first so Docker can cache the `npm install`  layer.
- **RUN npm install**
Installs Node.js dependencies.
- **COPY backend .**
Copies the application source code.
- **Create non-root user**
Improves container security.
- **USER appuser**
Runs the container using a non-root user.
- **EXPOSE 3000**
Exposes the port used by the backend API.
- **CMD**
Starts the Node.js server.
---

# 3. Challenges Faced
### Challenge 1 – Frontend Not Communicating With Backend
**Problem:**
Initially, the frontend webpage could not retrieve data from the backend API.

**Solution:**
I ensured that:

- The backend server was running on port **3000**
- The frontend fetch request pointed to the correct API endpoint.
---

### Challenge 2 – Docker Image Size Optimization
**Problem:**
Using large base images can create unnecessarily large Docker images.

**Solution:**
I used the **node:18-alpine** base image to keep the image lightweight.

---

### Challenge 3 – Running Containers with Docker Compose
**Problem:**
Ensuring all services (Nginx, backend, PostgreSQL) started correctly.

**Solution:**
I configured:

- service dependencies
- environment variables
- database volumes
- custom network
in the `docker-compose.yml` file.

---

# 4. Final Docker Image Size
Final Docker image size:

**45.09 MB**

This was achieved by using the **Alpine Linux base image** and minimizing unnecessary files using `.dockerignore`.

---

# 5. Docker Hub Repository
Docker image is available at:

[﻿https://hub.docker.com/r/prathamesh97/docker-webapp-api](https://hub.docker.com/r/prathamesh97/docker-webapp-api) 

Pull command:

docker pull prathamesh97/docker-webapp-api:v1

---

# 6. Conclusion
This project demonstrated how to containerize a multi-service application using Docker.
I learned how to:

- Write an optimized Dockerfile
- Use non-root users for security
- Manage multiple containers using Docker Compose
- Configure environment variables and volumes
- Push images to Docker Hub
- Run the system from scratch using only Docker Compose
This project helped me understand the complete workflow of **building, packaging, and deploying containerized applications using Docker**.

