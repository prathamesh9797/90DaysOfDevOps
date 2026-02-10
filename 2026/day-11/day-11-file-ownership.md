# 

# File Ownership Challenge (chown & chgrp)
## Task
Master file and directory ownership in Linux.

- Understand file ownership (user and group)
- Change file owner using `chown` 
- Change file group using `chgrp` 
- Apply ownership changes recursively
## Challenge Tasks
### Task 1: Understanding Ownership (10 minutes)
1. Run `ls -l`  in your home directory
2. Identify the **owner** and **group** columns
3. Check who owns your files
**Format:** `-rw-r--r-- 1 owner group size date filename` 

Document: What's the difference between owner and group?

>> Owner is one user who owns the file. Group is a set of users who can access the file. Linux uses owner, group, and others to control permissions

```
prathamesh@localhost:~$ pwd
/home/prathamesh
prathamesh@localhost:~$ ls -l
total 48
drwxr-xr-x 2 prathamesh prathamesh 4096 Feb  6 00:03 Desktop
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb  8 16:52 devops
drwxr-xr-x 4 prathamesh prathamesh 4096 Jan 30 08:46 Documents
drwxr-xr-x 5 prathamesh prathamesh 4096 Feb  7 00:09 Downloads
drwxr-xr-x 2 prathamesh prathamesh 4096 Feb 23  2025 Music
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb  6 00:06 Personal
drwxr-xr-x 3 prathamesh prathamesh 4096 Mar  3  2025 Pictures
drwxr-xr-x 2 prathamesh prathamesh 4096 Feb 23  2025 Public
drwxrwxr-x 3 prathamesh prathamesh 4096 Jan  4 23:24 Python
drwx------ 7 prathamesh prathamesh 4096 Feb 26  2025 snap
drwxr-xr-x 2 prathamesh prathamesh 4096 Feb 23  2025 Templates
drwxr-xr-x 2 prathamesh prathamesh 4096 Feb 23  2025 Videos
prathamesh@localhost:~$
```
### Task 2: Basic chown Operations (20 minutes)
1. Create file `devops-file.txt` 
2. Check current owner: `ls -l devops-file.txt` 
3. Change owner to `tokyo`  (create user if needed)
4. Change owner to `berlin` 
5. Verify the changes
```
prathamesh@localhost:~/practice$ touch devops-file.txt
prathamesh@localhost:~/practice$ ls -l devops-file.txt
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb  9 10:08 devops-file.txt
prathamesh@localhost:~/practice$ sudo chown tokyo devops-file.txt
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 tokyo prathamesh 0 Feb  9 10:08 devops-file.txt
prathamesh@localhost:~/practice$ sudo chown berlin devops-file.txt
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 berlin prathamesh 0 Feb  9 10:08 devops-file.txt
prathamesh@localhost:~/practice$
```
### Task 3: Basic chgrp Operations (15 minutes)
1. Create file `team-notes.txt` 
2. Check current group: `ls -l team-notes.txt` 
3. Create group: `sudo groupadd heist-team` 
4. Change file group to `heist-team` 
5. Verify the change
```
prathamesh@localhost:~/practice$ touch team-notes.txt
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 berlin     prathamesh 0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$ sudo groupadd heist-team
prathamesh@localhost:~/practice$ sudo chgrp heist-team team.notes.txt
chgrp: cannot access 'team.notes.txt': No such file or directory
prathamesh@localhost:~/practice$ sudo chgrp heist-team team-notes.txt
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 berlin     prathamesh 0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 prathamesh heist-team 0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$
```
### Task 4: Combined Owner & Group Change (15 minutes)
Using `chown` you can change both owner and group together:

1. Create file `project-config.yaml` 
2. Change owner to `professor`  AND group to `heist-team`  (one command)
3. Create directory `app-logs/` 
4. Change its owner to `berlin`  and group to `heist-team` 
5. **Syntax:** `sudo chown owner:group filename` 
```
prathamesh@localhost:~/practice$ touch project-config.yaml
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 berlin     prathamesh 0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb  9 10:42 project-config.yaml
-rw-rw-r-- 1 prathamesh heist-team 0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$ sudo chown professor:heist-team project-config.yaml
prathamesh@localhost:~/practice$ ls -l
total 0
-rw-rw-r-- 1 berlin     prathamesh 0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 professor  heist-team 0 Feb  9 10:42 project-config.yaml
-rw-rw-r-- 1 prathamesh heist-team 0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$ mkdir app-logs
prathamesh@localhost:~/practice$ ls -l
total 4
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb  9 10:56 app-logs
-rw-rw-r-- 1 berlin     prathamesh    0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 professor  heist-team    0 Feb  9 10:42 project-config.yaml
-rw-rw-r-- 1 prathamesh heist-team    0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$ sudo chown berlin:heist-team app-logs
prathamesh@localhost:~/practice$ ls -l
total 4
drwxrwxr-x 2 berlin     heist-team 4096 Feb  9 10:56 app-logs
-rw-rw-r-- 1 berlin     prathamesh    0 Feb  9 10:08 devops-file.txt
-rw-rw-r-- 1 professor  heist-team    0 Feb  9 10:42 project-config.yaml
-rw-rw-r-- 1 prathamesh heist-team    0 Feb  9 10:18 team-notes.txt
prathamesh@localhost:~/practice$
```
### Task 5: Recursive Ownership (20 minutes)
1. Create directory structure:mkdir -p heist-project/vault
mkdir -p heist-project/plans
touch heist-project/vault/gold.txt
touch heist-project/plans/strategy.conf
2. Create group `planners` : `sudo groupadd planners` 
3. Change ownership of entire `heist-project/`  directory:
    - Owner: `professor` 
    - Group: `planners` 
    - Use recursive flag (`-R` )

4. Verify all files and subdirectories changed: `ls -lR heist-project/` 
```
prathamesh@localhost:~/practice$ mkdir -p heist-project/vault
prathamesh@localhost:~/practice$ ls -l
total 8
drwxrwxr-x 2 berlin     heist-team 4096 Feb  9 10:56 app-logs
-rw-rw-r-- 1 berlin     prathamesh    0 Feb  9 10:08 devops-file.txt
drwxrwxr-x 3 prathamesh prathamesh 4096 Feb 10 08:13 heist-project

prathamesh@localhost:~/practice$ mkdir -p heist-project/plans
prathamesh@localhost:~/practice$ cd heist-project
prathamesh@localhost:~/practice/heist-project$ ls -l
total 8
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb 10 08:14 plans
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb 10 08:13 vault

prathamesh@localhost:~/practice$ touch heist-project/vault/gold.txt
prathamesh@localhost:~/practice/heist-project$ cd vault
prathamesh@localhost:~/practice/heist-project/vault$ ls -l
total 0
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb 10 08:15 gold.txt

prathamesh@localhost:~/practice/heist-project/plans$ touch strategy.conf
prathamesh@localhost:~/practice/heist-project/plans$ ls -l
total 0
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb 10 08:17 strategy.conf

prathamesh@localhost:~/practice/heist-project/plans$ sudo groupadd planners

prathamesh@localhost:~/practice$ sudo chown -R professor:planners heist-project/
prathamesh@localhost:~/practice$ ls -lR heist-project
heist-project:
total 8
drwxrwxr-x 2 professor planners 4096 Feb 10 08:17 plans
drwxrwxr-x 2 professor planners 4096 Feb 10 08:15 vault

heist-project/plans:
total 0
-rw-rw-r-- 1 professor planners 0 Feb 10 08:17 strategy.conf

heist-project/vault:
total 0
-rw-rw-r-- 1 professor planners 0 Feb 10 08:15 gold.txt

```
### Task 6: Practice Challenge (20 minutes)
1. Create users: `tokyo` , `berlin` , `nairobi`  (if not already created)
2. Create groups: `vault-team` , `tech-team` 
3. Create directory: `bank-heist/` 
4. Create 3 files inside:touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt
5. Set different ownership:
    - `access-codes.txt`  → owner: `tokyo` , group: `vault-team` 
    - `blueprints.pdf`  → owner: `berlin` , group: `tech-team` 
    - `escape-plan.txt`  → owner: `nairobi` , group: `vault-team` 

**Verify:** `ls -l bank-heist/` 

```
prathamesh@localhost:~$ sudo useradd nairobi
prathamesh@localhost:~$ cat /etc/passwd
nairobi:x:1004:1006::/home/nairobi:/bin/sh

prathamesh@localhost:~$ sudo groupadd vault-team
prathamesh@localhost:~$ sudo groupadd tech-team

rathamesh@localhost:~/practice$ mkdir bank-heist
prathamesh@localhost:~/practice$ ls -l
total 12
drwxrwxr-x 2 berlin     heist-team 4096 Feb  9 10:56 app-logs
drwxrwxr-x 2 prathamesh prathamesh 4096 Feb 10 08:39 bank-heist

prathamesh@localhost:~/practice$ touch bank-heist/access-codes.txt bank-heist/blueprints.pdf bank-heist/escape-plan.txt
prathamesh@localhost:~/practice$ cd bank-heist 
prathamesh@localhost:~/practice/bank-heist$ ls -l
total 0
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb 10 08:44 access-codes.txt
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb 10 08:47 blueprints.pdf
-rw-rw-r-- 1 prathamesh prathamesh 0 Feb 10 08:47 escape-plan.txt

prathamesh@localhost:~/practice/bank-heist$ sudo chown tokyo:vault-team access-codes.txt
prathamesh@localhost:~/practice/bank-heist$ ls -l
total 0
-rw-rw-r-- 1 tokyo      vault-team 0 Feb 10 08:44 access-codes.txt

prathamesh@localhost:~/practice/bank-heist$ sudo chown berlin:tech-team blueprints.pdf
prathamesh@localhost:~/practice/bank-heist$ ls -l
total 0
-rw-rw-r-- 1 berlin     tech-team  0 Feb 10 08:47 blueprints.pdf

prathamesh@localhost:~/practice/bank-heist$ sudo chown nairobi:vault-team escape-plan.txt
prathamesh@localhost:~/practice/bank-heist$ ls -l
total 0
-rw-rw-r-- 1 nairobi vault-team 0 Feb 10 08:47 escape-plan.txt

prathamesh@localhost:~/practice/bank-heist$ ls -l
total 0
-rw-rw-r-- 1 tokyo   vault-team 0 Feb 10 08:44 access-codes.txt
-rw-rw-r-- 1 berlin  tech-team  0 Feb 10 08:47 blueprints.pdf
-rw-rw-r-- 1 nairobi vault-team 0 Feb 10 08:47 escape-plan.txt
```


