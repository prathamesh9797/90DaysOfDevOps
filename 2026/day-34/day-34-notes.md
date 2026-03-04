# Day 34 – Docker Compose: Real-World Multi-Container Apps

### Task 1: Build Your Own App Stack
Create a `docker-compose.yml` for a 3-service stack:

- A **web app** (use Python Flask, Node.js, or any language you know)
- A **database** (Postgres or MySQL)
- A **cache** (Redis)
Write a simple Dockerfile for the web app. The app doesn't need to be complex — even a "Hello World" that connects to the database is enough.

### _>> Below is a __**simple 3-service Docker stack**__ with:_
- **Web App:** Python Flask
- **Database:** PostgreSQL
- **Cache:** Redis
The Flask app will:

- connect to **Postgres**
- increment a counter in **Redis**
- return a simple response.
# Project Structure
```
docker-app/
│
├── docker-compose.yml
│
└── web/
    ├── Dockerfile
    ├── requirements.txt
    └── app.py
```
# docker-compose.yml
```
version: "3.9"
services:
  web:
    build: ./web
    container_name: flask_app
    ports:
      - "5000:5000"
    depends_on:
      - db
      - redis
    environment:
      - DB_HOST=db
      - DB_NAME=mydb
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - REDIS_HOST=redis
  db:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
  redis:
    image: redis:7
    container_name: redis_cache
    ports:
      - "6379:6379"
volumes:
  postgres_data:
```
# Dockerfile (Web App)
Create this inside **web/Dockerfile**

```
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
# requirements.txt
```
flask
psycopg2-binary
redis
```
# Flask App (app.py)
```
from flask import Flask
import psycopg2
import redis
import os

app = Flask(__name__)

db_host = os.getenv("DB_HOST")
db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_password = os.getenv("DB_PASSWORD")
redis_host = os.getenv("REDIS_HOST")

# Connect to Redis
cache = redis.Redis(host=redis_host, port=6379)

def get_db_connection():
    conn = psycopg2.connect(
        host=db_host,
        database=db_name,
        user=db_user,
        password=db_password
    )
    return conn

@app.route("/")
def hello():

    # Redis counter
    visits = cache.incr("counter")

    # DB test
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT NOW();")
    time = cur.fetchone()
    cur.close()
    conn.close()

    return f"""
    Hello from Flask!<br>
    Redis Visit Counter: {visits}<br>
    DB Time: {time}
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```
# Run the Stack
From the project folder:

```
docker compose up --build
```
Open in browser:

```
http://localhost:5000
```
Example output:

```
Hello from Flask!
Redis Visit Counter: 5
DB Time: 2026-03-04 12:35:22
```
# What Docker Compose Does
| Service | Role |
| ----- | ----- |
| web | Flask application |
| db | PostgreSQL database |
| redis | caching / counter |
| volume | persists DB data |
Docker automatically creates a **network**, so the web app can reach:

```
db:5432redis:6379
```
**This stack demonstrates:**

- Multi-container architecture
- Service networking
- Environment variables
- Persistent database storage


![Screenshot from 2026-03-04 14-36-19.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2014-36-19_N__G06Se6W4MyUQbnGgDs.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 14-36-19.png")

---

## Task 2: depends_on & Healthchecks
how Docker Compose stacks are made **more reliable**. The idea is:

- `depends_on`  → controls **startup order**
- `healthcheck`  → verifies a service is **actually ready**
- `condition: service_healthy`  → waits until healthcheck passes
So **Flask app won't start until Postgres is ready**.

## Add `depends_on`  to your compose file so the app starts **after** the database
## Add a **healthcheck** on the database service
## Use `depends_on`  with `condition: service_healthy`  so the app waits for the database to be truly ready, not just started
## **Test:** Bring everything down and up — does the app wait for the DB?
# Updated `docker-compose.yml`
```
version: "3.9"
services:
  web:
    build: ./web
    container_name: flask_app
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      DB_HOST: db
      DB_NAME: mydb
      DB_USER: postgres
      DB_PASSWORD: postgres
      REDIS_HOST: redis
  db:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
  redis:
    image: redis:7
    container_name: redis_cache
    ports:
      - "6379:6379"
volumes:
  postgres_data:
```
# What the Healthcheck Does
Docker will run:

```
pg_isready -U postgres
```
If Postgres is ready → **healthy**
 If not → **unhealthy**

Docker retries:

```
every 5 secondsmax 5 attempts
```
# What `depends_on` Now Means
Before:

```
web starts immediately
```
Now:

```
web waits until db is healthy
```
Startup order becomes:

```
Postgres container starts
Healthcheck verifies DB ready
Redis starts
Flask app starts
```
# Test the Behavior
First stop everything:

```
docker compose down
```
Then start again:

```
docker compose up
```
You should see something like:

```
postgres_db | database system is starting
postgres_db | database system is ready to accept connections
postgres_db | healthy
flask_app   | Starting Flask app
```
The **Flask container will wait** until the DB becomes healthy.

# Verify Health Status
Run:

```
docker ps
```
You should see:

```
postgres_db (healthy)
```
Or check details:

```
docker inspect postgres_db | grep Health -A 10
```
# What Happens Without Healthcheck
Without it:

```
DB container starts
DB still initializing
Flask tries connecting
Flask crashes 
```
With healthcheck:

```
DB container starts
DB initializes
DB healthy
Flask starts 
```
This shows real **container orchestration concepts**:

service dependency management
 health monitoring
 reliable startup order
 resilient microservice architecture

**Expected Result of the Test**

| Step | Result |
| ----- | ----- |
| docker compose down | stack stopped |
| docker compose up | DB starts first |
| healthcheck passes | DB becomes healthy |
| web starts | Flask launches afterward |
---

## **Task 3: Restart Policies**
## **Add **`**restart: always**`**  to your database service**
## **Manually kill the database container — does it come back?**
## **Try **`**restart: on-failure**`**  — how is it different?**
## **Write in your notes: When would you use each restart policy?**


Update the **db service** in `docker-compose.yml`.

```
services:
db:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
  volumes:
      - postgres_data:/var/lib/postgresql/data
  ports:
      - "5432:5432"
  healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
```
`restart: always` tells Docker:

```
If the container stops for ANY reason → restart it automatically
```
# Start the Stack
```
docker compose up -d
```
Check containers:

```
docker ps
```
# Kill the Database Container
Now simulate a crash.

```
docker kill postgres_db
```
# Check If It Restarts
Run:

```
docker ps
```
You should see **postgres_db running again**.

You can also check restart history:

```
docker ps -a
```
Example:

```
postgres_db   Up 5 seconds
```
Docker automatically restarted it.

# Test `restart: on-failure` 
Change the policy:

```
restart: on-failure
```
Then restart the stack:

```
docker compose downdocker compose up -d
```
Now kill the container again:

```
docker kill postgres_db
```
Check containers:

```
docker ps
```
You may notice **it does NOT restart** because `docker kill` exits with signal 137.

`on-failure` only restarts if the container **crashes with a non-zero exit code**.

# Difference Between Policies
| Policy | Behavior |
| ----- | ----- |
| `no`  | default, container never restarts |
| `always`  | container always restarts if it stops |
| `on-failure`  | restart only when container exits with error |
| `unless-stopped`  | restart always except when manually stopped |
**restart: always** is used for critical infrastructure services such as
databases, caches, and message queues where availability is required.
The container automatically restarts even after system reboot.

**restart: on-failure** is useful for batch jobs or worker containers
that should retry when they crash but should not restart if they are
manually stopped or intentionally terminated.



**Docker Restart Policies (In Short):**

- `**no**`  – Do not restart the container automatically.
 _Use for temporary containers or debugging._
- `**always**`  – Always restart the container if it stops or the system reboots.
 _Use for critical services like databases, APIs, Redis._
- `**on-failure**`  – Restart only if the container crashes with an error.
 _Use for batch jobs or worker processes._
- `**unless-stopped**`  – Restart automatically except when you manually stop it.
 _Use for long-running applications where manual stops should persist._
---

## **Task 4: Custom Dockerfiles in Compose**
This task is about using **Docker Compose to build your app image from a Dockerfile** and then **rebuilding it automatically when code changes**.

## **Instead of using a pre-built image for your app, use **`**build:**`**  in your compose file to build from a Dockerfile**
## **Make a code change in your app**
## **Rebuild and restart with one command**


# Use `build:` Instead of `image`
In `docker-compose.yml`, the **web service** look like this:

```
services:
web:
    build: ./web
    container_name: flask_app
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      DB_HOST: db
      DB_NAME: mydb
      DB_USER: postgres
      DB_PASSWORD: postgres
      REDIS_HOST: redis
```
Here:

```
build: ./web
```
means:

```
Compose will build the image using the Dockerfile inside the web folder
```
Project structure:

```
docker-app
│
├── docker-compose.yml
└── web    
     ├── Dockerfile    
     ├── app.py    
     └── requirements.txt
```
# Example Dockerfile (inside `/web`)
```
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```
# Make a Code Change
Open `**web/app.py**` 

Change the response.

Example:

Before:

```
return "Hello from Flask!"
```
After:

```
return "Hello from Flask - Updated Version!"
```
Save the file.

# Rebuild and Restart with One Command
Run:

```
docker compose up --build
```
This command will:

rebuild the image from the Dockerfile
recreate the container
start the updated app

# Verify the Change
Open:

```
http://<EC2-IP>:5000
```
Now you should see:

```
Hello from Flask - Updated Version!
```
# If Running in Background
You can also run:

```
docker compose up -d --build
```
This:

```
builds + restarts containers in background
```
This task proves that:

- Docker Compose can **build images from Dockerfiles**
- Code changes can be **rebuilt quickly**
- The stack can be **updated with one command**
**Short note :**

>  Instead of using a prebuilt image, the web service was configured with `build:` so Docker Compose builds the application image from a Dockerfile. After modifying the application code, the stack was rebuilt and restarted using `docker compose up --build`, which rebuilt the image and deployed the updated container automatically.

---

## Task 5: Named Networks & Volumes
This task improves your Compose file by adding **custom networks, named volumes, and labels**.

## Define **explicit networks** in your compose file instead of relying on the default
## Define **named volumes** for database data
## Add **labels** to your services for better organization


# Updated `docker-compose.yml`
```
version: "3.9"
services:
  web:
    build: ./web
    container_name: flask_app
    ports:
      - "5000:5000"
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      DB_HOST: db
      DB_NAME: mydb
      DB_USER: postgres
      DB_PASSWORD: postgres
      REDIS_HOST: redis
    networks:
      - app_network
    labels:
      project: "docker-assignment"
      service: "web-app"
  db:
    image: postgres:15
    container_name: postgres_db
    restart: always
    environment:
      POSTGRES_DB: mydb
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app_network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5
    labels:
      project: "docker-assignment"
      service: "database"
  redis:
    image: redis:7
    container_name: redis_cache
    networks:
      - app_network
    labels:
      project: "docker-assignment"
      service: "cache"
volumes:
  postgres_data:
networks:
  app_network:
    driver: bridge
```
# Named Volume (Database Storage)
```
volumes:  postgres_data:
```
This ensures:

- Database data **persists even if containers are removed**
- Docker manages the storage automatically.
Used in the DB service:

```
volumes:  - postgres_data:/var/lib/postgresql/data
```
# Custom Network
Instead of using Docker’s default network, we explicitly define:

```
networks:  app_network:    driver: bridge
```
Services connect using:

```
networks:  - app_network
```
Benefits:

- Better **service isolation**
- Easier **multi-stack networking**
- Clear architecture.
# Labels for Organization
Example:

```
labels:  project: "docker-assignment"  service: "web-app"
```
Labels help with:

- container management
- monitoring tools
- container filtering
- infrastructure documentation
Example command using labels:

```
docker ps --filter "label=project=docker-assignment"
```
# Test the Setup
Bring the stack down:

```
docker compose down
```
Start again:

```
docker compose up -d
```
Check networks:

```
docker network ls
```
Inspect your custom network:

```
docker network inspect docker-app_app_network
```
Check volumes:

```
docker volume ls
```
You should see:

```
postgres_data
```
# Short Note
>  Explicit networks were defined to isolate services and control container communication instead of relying on Docker’s default network. A named volume (`postgres_data`) was created to persist PostgreSQL data across container restarts. Labels were added to services to improve organization and make container management easier when filtering or monitoring containers.



