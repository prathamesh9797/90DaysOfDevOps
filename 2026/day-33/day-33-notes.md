# Day 33 – Docker Compose: Multi-Container Basics

## **Task 1: Install & Verify**
## **Check if Docker Compose is available on your machine**
## **Verify the version**
```
ubuntu@ip-172-31-17-9:~$ docker-compose --version
docker-compose version 1.29.2, build unknown
```
---

## Task 2: Your First Compose File
## >> Create a folder `compose-basics` 
```
mkdir compose-basics
cd compose-basics
```
## Write a `docker-compose.yml`  that runs a single **Nginx** container with port mapping
```
vim docker-compose.yml
```
```
version: '3.8'
services:
  nginx:
    image: nginx:latest
    container_name: my-nginx
    ports:
      - "8080:80"
```
### What this does
- **image:** Uses the official Nginx image
- **container_name:** Names the container `my-nginx` 
- **ports:** Maps
    - **8080 (host)** → **80 (container)**

## >> Start it with `docker compose up` 
Run:

```
docker compose up
```
Or run it in the background:

```
docker compose up -d
```
Docker will:

- Pull the **nginx image**
- Create the container
- Start the web server
## >> Access it in your browser


![Screenshot from 2026-03-04 10-47-34.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2010-47-34_AclJ647JZi328Sw5A8Abu.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 10-47-34.png")



## >> Stop it with `docker compose down` 
```
ubuntu@ip-172-31-17-9:~/compose-basics$ docker-compose down
Stopping my-nginx ... done
Removing my-nginx ... done
Removing network compose-basics_default
```
---

# **>>Task 3: Two-Container Setup**
Write a `docker-compose.yml` that runs:

- A **WordPress** container
- A **MySQL** container
They should:

- Be on the same network (Compose does this automatically)
- MySQL should have a named volume for data persistence
- WordPress should connect to MySQL using the service name
Start it, access WordPress in your browser, and set it up.

**Verify:** Stop and restart with `docker compose down` and `docker compose up` — is your WordPress data still there?

## 1. Create Project Folder
```
mkdir wordpress-composecd wordpress-compose
```
## 2. Create `docker-compose.yml` 
```
nano docker-compose.yml
```
Paste this configuration:

```
version: "3.8"
services:
  db:
    image: mysql:5.7
    container_name: wordpress-db
    restart: always
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wpuser
      MYSQL_PASSWORD: wppassword
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    image: wordpress:latest
    container_name: wordpress-app
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wpuser
      WORDPRESS_DB_PASSWORD: wppassword
      WORDPRESS_DB_NAME: wordpress
    depends_on:
      - db
volumes:
  db_data:
```
## 3. How This Works
### Services
- **db** → MySQL database container
- **wordpress** → WordPress web container
### Automatic Networking
Docker Compose automatically creates a network like:

```
wordpress-compose_default
```
WordPress connects to MySQL using:

```
WORDPRESS_DB_HOST=db
```
because `**db**`** is the service name**.

# 4. Start the Containers
Run:

```
docker compose up -d
```
Check containers:

```
docker ps
```
Expected:

```
wordpress-appwordpress-db
```
```
ubuntu@ip-172-31-17-9:~$ mkdir wordpress-compose
ubuntu@ip-172-31-17-9:~$ cd wordpress-compose
ubuntu@ip-172-31-17-9:~/wordpress-compose$ vim docker-compose.yml
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d
Creating network "wordpress-compose_default" with the default driver
Creating volume "wordpress-compose_db_data" with default driver
Pulling db (mysql:5.7)...
5.7: Pulling from library/mysql
20e4dcae4c69: Pull complete
1c56c3d4ce74: Pull complete
e9f03a1c24ce: Pull complete
68c3898c2015: Pull complete
6b95a940e7b6: Pull complete
90986bb8de6e: Pull complete
ae71319cb779: Pull complete
ffc89e9dfd88: Pull complete
43d05e938198: Pull complete
064b2d298fba: Pull complete
df9a4d85569b: Pull complete
Digest: sha256:4bc6bc963e6d8443453676cae56536f4b8156d78bae03c0145cbe47c2aad73bb
Status: Downloaded newer image for mysql:5.7
Pulling wordpress (wordpress:latest)...
latest: Pulling from library/wordpress
206356c42440: Already exists
d966da89514a: Pull complete
35b6b15c3457: Pull complete
70e74fa77754: Pull complete
6c9a88b46c71: Pull complete
effb68688d83: Pull complete
b2dd0a7d6055: Pull complete
07f40ee734f4: Pull complete
23f1b0890dbe: Pull complete
27442454b736: Pull complete
6f532b20dce6: Pull complete
1f6480a7139c: Pull complete
7197481443d5: Pull complete
735e906fddd9: Pull complete
4f4fb700ef54: Pull complete
27f7f8943872: Pull complete
02d56b37ab46: Pull complete
1485ae5717f8: Pull complete
cc1849e0eb99: Pull complete
1628c6306dd2: Pull complete
8b8a3e92544a: Pull complete
2dc2490fa9d6: Pull complete
1be32700eac1: Pull complete
5bc812efea42: Pull complete
Digest: sha256:ffef0dca1f0fc4357bfef3856ebd1ba18f7b394378277122eaa4524ca2619d43
Status: Downloaded newer image for wordpress:latest
Creating wordpress-db ... done
Creating wordpress-app ... done


```
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d
wordpress-db is up-to-date
wordpress-app is up-to-date
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS         PORTS                                     NAMES
cd7ae1872b9d   wordpress:latest   "docker-entrypoint.s…"   11 minutes ago   Up 2 minutes   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   wordpress-app
d565c1ac7715   mysql:5.7          "docker-entrypoint.s…"   11 minutes ago   Up 2 minutes   3306/tcp, 33060/tcp                       wordpress-db
```
## 5. Access WordPress 
Open browser:

```
http://<EC2-PUBLIC-IP>:8080
```
Example:

```
http://3.xx.xxx.xxx:8080
```
You will see the **WordPress setup page**.

Complete:

1. Select language
2. Site title
3. Username
4. Password
5. Email
Then click **Install WordPress**.



![Screenshot from 2026-03-04 11-34-14.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2011-34-14__ZJMXVpJWNzWTk_HUNsfu.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 11-34-14.png")

![Screenshot from 2026-03-04 11-42-22.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2011-42-22_1YtvmH7zFRg-1wMBMDWyt.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 11-42-22.png")

## Verify Data Persistence (Important Part)
Stop containers:

```
docker compose down
```
Start again:

```
docker compose up -d
```
Open again:

```
http://<EC2-IP>:8080
```
Your **WordPress site and login should still exist**.

![Screenshot from 2026-03-04 12-29-11.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-04%2012-29-11_WWDuaemykUgqPD-6CoXqs.png?ixlib=js-3.8.0 "Screenshot from 2026-03-04 12-29-11.png")

## Verification: Data Persistence Test
### Step 1: Stop the Containers
Run the following command to stop and remove the containers and network:

```
docker-compose down
```
Result:

- The **WordPress** and **MySQL** containers are stopped and removed.
- The website becomes **inaccessible** because the WordPress container is no longer running.
When accessing the site in the browser:

```
http://<EC2-PUBLIC-IP>:8080
```
The browser shows:

```
ERR_CONNECTION_REFUSED
```
This happens because no container is listening on port **8080**.

### Step 2: Start the Containers Again
Start the containers again using:

```
docker-compose up -d
```
Docker recreates and starts the containers.

### Step 3: Access WordPress Again
Open the site again in the browser:

```
http://<EC2-PUBLIC-IP>:8080
```
Result:

- The **WordPress site loads successfully**.
- The **previously configured site, login, and settings remain unchanged**.
### Step 4: Explanation
The WordPress data persists because MySQL stores its database files in a **named Docker volume**.

In the `docker-compose.yml` file:

```
volumes:  - db_data:/var/lib/mysql
```
This volume stores database data **outside the container**, so even if containers are removed using `docker-compose down`, the data remains.

### Conclusion
The test confirms that:

- Docker Compose successfully runs **WordPress and MySQL in separate containers**.
- Containers communicate through the **default Docker Compose network**.
- The **named volume (**`**db_data**` **) ensures data persistence** even after containers are stopped and recreated.
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose down -v
Stopping wordpress-app ... done
Stopping wordpress-db  ... done
Removing wordpress-app ... done
Removing wordpress-db  ... done
Removing network wordpress-compose_default
Removing volume wordpress-compose_db_data
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d
Creating network "wordpress-compose_default" with the default driver
Creating volume "wordpress-compose_db_data" with default driver
Creating wordpress-db ... done
Creating wordpress-app ... done
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose down
Stopping wordpress-app ... done
Stopping wordpress-db  ... done
Removing wordpress-app ... done
Removing wordpress-db  ... done
Removing network wordpress-compose_default
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d
Creating network "wordpress-compose_default" with the default driver
Creating wordpress-db ... done
Creating wordpress-app ... done
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                                     NAMES
b4d33bd02ebb   wordpress:latest   "docker-entrypoint.s…"   14 seconds ago   Up 13 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   wordpress-app
0a4b5396426a   mysql:5.7          "docker-entrypoint.s…"   14 seconds ago   Up 13 seconds   3306/tcp, 33060/tcp                       wordpress-db
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose ps
    Name                   Command               State                  Ports                
---------------------------------------------------------------------------------------------
wordpress-app   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
wordpress-db    docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
```
---

# Task 4: Compose Commands
#### Practice and document these:
# >> Start services in **detached mode**
```
docker-compose up -d
```
### Explanation
- Starts all services defined in the `docker-compose.yml`  file.
- The `-d`  flag runs containers in **detached mode** (background).
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d
Creating network "wordpress-compose_default" with the default driver
Creating wordpress-db ... done
Creating wordpress-app ... done
```
# >> View running services
```
docker-compose ps
```
### Explanation
Displays the **status of services** defined in the Compose file.

### Example Output
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose ps
    Name                   Command               State                  Ports                
---------------------------------------------------------------------------------------------
wordpress-app   docker-entrypoint.sh apach ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
wordpress-db    docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
```
# >> View **logs** of all services
```
docker-compose logs
```
### Explanation
Shows logs from **all containers** in the Compose project.

This helps debug issues such as:

- container startup errors
- database connection issues
- application errors
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose logs
Attaching to wordpress-app, wordpress-db
wordpress-app | WordPress not found in /var/www/html - copying now...
wordpress-app | Complete! WordPress has been successfully copied to /var/www/html
wordpress-app | No 'wp-config.php' found in /var/www/html, but 'WORDPRESS_...' variables supplied; copying 'wp-config-docker.php' (WORDPRESS_DB_HOST WORDPRESS_DB_NAME WORDPRESS_DB_PASSWORD WORDPRESS_DB_USER)
```
# >> View logs of a **specific** service
```
docker-compose logs db
```
### Explanation
Displays logs only for the **specified service**.

Example:

Shows logs only from the db** container**.

```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose logs
Attaching to wordpress-app, wordpress-db
wordpress-app | WordPress not found in /var/www/html - copying now...
wordpress-app | Complete! WordPress has been successfully copied to /var/www/html
```
# **>> Stop** services without removing
```
docker-compose stop
```
### Explanation
- Stops running containers.
- Containers are **not removed**.
- They can be restarted later.
Restart them using:

```
docker-compose start
```
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose stop
Stopping wordpress-app ... done
Stopping wordpress-db  ... done
```
# **>> Remove** everything (containers, networks)
```
docker-compose down
```
### Explanation
This command:

- Stops containers
- Removes containers
- Removes networks created by Compose
However, **volumes are not removed by default**.

To remove volumes as well:

```
docker-compose down -v
```
```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose down
Removing wordpress-app ... done
Removing wordpress-db  ... done
Removing network wordpress-compose_default

ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose down -v
Removing network wordpress-compose_default
WARNING: Network wordpress-compose_default not found.
Removing volume wordpress-compose_db_data
```
# **>>Rebuild** images if you make a change
```
docker-compose up --build
```
### Explanation
Rebuilds container images before starting the services.

This is useful when:

- Dockerfile changes
- Application code changes
- New dependencies are added
Example:

```
docker-compose up -d --build
```
This rebuilds images and runs containers in the background.

```
ubuntu@ip-172-31-17-9:~/wordpress-compose$ docker-compose up -d --build
Creating network "wordpress-compose_default" with the default driver
Creating volume "wordpress-compose_db_data" with default driver
Creating wordpress-db ... done
Creating wordpress-app ... done
```
# Summary of Important Commands
| Command | Purpose |
| ----- | ----- |
| `docker-compose up -d`  | Start services in background |
| `docker-compose ps`  | Show running services |
| `docker-compose logs`  | View logs of all services |
| `docker-compose logs <service>`  | View logs of specific service |
| `docker-compose stop`  | Stop containers without removing |
| `docker-compose down`  | Stop and remove containers and networks |
| `docker-compose down -v`  | Remove containers, networks, and volumes |
| `docker-compose up --build`  | Rebuild images and start containers |
---

# **Task 5: Environment Variables**
Docker Compose allows environment variables to be defined **directly in the **`**docker-compose.yml**`** file** or loaded from a `**.env**`** file**.

Using a `.env` file helps keep configuration **separate from code** and improves security and maintainability.

# **>>Add environment variables directly in your **`**docker-compose.yml**`** **
```
version: "3.8"
services:
  app:
    image: nginx
    environment:
      APP_ENV: production
      APP_VERSION: 1.0
```
### Explanation
The `environment` section defines variables inside the container.

In this example:

```
APP_ENV=production
APP_VERSION=1.0
```
These variables will be available inside the container.

# **>> Create a **`**.env**`**  file and reference variables from it in your compose file**
Create the `.env` file in the **same directory as **`**docker-compose.yml**`.

```
touch .env
```
Edit the file:

```
nano .env
```
Add variables:

```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppassword
MYSQL_ROOT_PASSWORD=rootpassword
```
Save and exit.

# Reference Variables in `docker-compose.yml`
Modify the compose file to use variables from `.env`.

Example:

```
version: "3.8"
services:
  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
  wordpress:
    image: wordpress:latest
    restart: always
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: ${MYSQL_USER}
      WORDPRESS_DB_PASSWORD: ${MYSQL_PASSWORD}
      WORDPRESS_DB_NAME: ${MYSQL_DATABASE}
    depends_on:
      - db
volumes:
  db_data:
```
### Explanation
Docker Compose automatically loads variables from the `.env` file and substitutes them in the compose file using:

```
${VARIABLE_NAME}
```
# Start the Containers
Run:

```
docker-compose up -d
```
Docker Compose reads variables from the `.env` file and injects them into the containers.

# **>> Verify the variables are being picked up**
You can verify the variables inside the container.

### Step 1: Enter the container
```
docker exec -it wordpress-app bash
```
### Step 2: Print environment variables
```
printenv
```
or

```
env
```
Example output:

```
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=wppassword
```
This confirms the environment variables are being loaded correctly.

Exit the container:

```
exit
```
# Benefits of Using `.env` Files
Using `.env` files provides several advantages:

- Keeps sensitive data **separate from configuration files**
- Makes the compose file **more reusable**
- Allows different configurations for **development, testing, and production**
- Simplifies **environment management**
# Conclusion
In this task:

- Environment variables were defined **directly in the compose file**
- A `.env`  file was created to store configuration values
- Variables from the `.env`  file were referenced in `docker-compose.yml` 
- The variables were verified inside the running container
This approach helps manage container configurations **efficiently and securely**.

