# DAY-01

 What is your understanding of DevOps and Cloud Engineering?
 >>
 DevOps - DevOps = developers and operations people working together smoothly.
 Before DevOps:

```
A DevOps engineer:
Automates deployments (no manual copying files)
Monitors systems so problems are caught early
Makes sure updates don’t break the app
Helps teams release new features faster
```
---

# **DAY -02**
```
The core components of Linux (kernel, user space, init/systemd)
>>  Kernel >> is the heart of the linux OS
Its a Onion like structure ASK outermost layer is like below
 application > Shell > kernel > Hradware
```
```
How processes are created and managed
>> process is a set of instruction loaded in memory
    ps-ef > to list all the process running 
    ps    > to report a snapshot of current process
```
```
Process States
D>  means I/O wait is there on disk or uninteruptable sleep
R>  running or ready to run
S>  sleeping or it is waiting for event to complete / not getting resources now
     / uniteruptable sleep you can not kill sleeping process arbitrarily
T> stoppped
Z> zombie process or defunct process
    a process which execution is completed but its entry is still present 
    in process table and these processes contribute to load
```
```
- What systemd does and why it matters
>> systemd >> first process which is having PID1

    systemd will decide which process will get start while booting servers
    and it is started directly by the kernel.
    due to systemd booot time is very less

    RHEL 5,6 were having init > first process having PID1 RHEL 5,6 were having high boot time

    systemd features >
    Parallelization , logging,Dependencies
```
---

# **DAY -03**
We practiced Linux commands few of them listed below

```
sudo -s >   to get root access
cat     >   command to display the content of File
touch   >   to create File
mkdir   >   to make directory
cp      >   to copy File
cp -r   >   copy directory and content -r is known as recursive 
mv      >   move File
rm      >   remove File
rm -r   >   remove directory
rmdir   >   remove empty directory
```
---

# **DAY - 04**
we practiced process commands and observed outputs

```
2 process commands** (`ps`, `top`,
>>>>OutPut for TOP Command top - display Linux processes | htop -

>>>>2 service commands** (`systemctl status <service name>, `systemctl list-units`,

2 log commands** (`journalctl -u <service-name>`, `tail -n 50`
```
---

# **DAY -05**
# We did Linux Troubleshooting Drill: CPU, Memory, and Logs
- **Environment basics (2):** `uname -a` , `lsb_release -a`  (or `cat /etc/os-release` )
- **Filesystem sanity (2):** create a throwaway folder and file, e.g., `mkdir /tmp/runbook-demo` , `cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo` 
- **CPU / Memory (2):** `top` /`htop` /`ps -o pid,pcpu,pmem,comm -p <pid>` , `free -h` , `vm_stat`  (mac)
- **Disk / IO (2):** `df -h` , `du -sh /var/log` , `iostat` /`vmstat` /`dstat` 
- **Network (2):** `ss -tulpn` /`netstat -tulpn` , `curl -I <service-endpoint>` /`ping` 
- **Logs (2):** `journalctl -u <service> -n 50` , `tail -n 50 /var/log/<file>.log` 
---

# **DAY - 06**
Write 3 lines into the file using **redirection** (`>` and `>>` )

Use `**cat**` to read the full file

Use `**head**` and `**tail**` to read parts of the file

Use `**tee**` once to write and display at the same time

```
prathamesh@localhost:/home$ cat notes.txt
```
## What are `head` and `tail`?
They’re used to view **parts of a file** (or piped output) without opening the whole thing:

- `head`  → shows the **beginning** of a file
- `tail`  → shows the **end** of a file (great for logs
head -n 5 file.txt # first 5 lines
tail -n 20 file.txt # last 20 lines

tail -n 50 /var/log/syslog



## What is `tee` in Linux?
`tee` reads input from **STDIN** and writes it to:

- **STDOUT (your terminal)**
- **One or more files at the same time**
```
command | tee file.txt
```
```
ls -l | tee files.txt
```
It takes or copies output from first command and paste or write output into one or more files at same time

---

# **DAY - 07**
Linux file system hierarchy and  Scenario Based questions and answers practice

### 📁 Important Directories
- `/`  → Root of the filesystem (everything starts here)
- `/bin`  → Essential user commands (ls, cp, mv, cat, echo)
- `/sbin`  → System/admin commands (mount, ip, shutdown)
- `/etc`  → Configuration files (nginx.conf, sshd_config, passwd)
- `/home`  → Home directories for normal users
- `/root`  → Home directory of root user
- `/var`  → Variable data (logs, cache, service data)
    - `/var/log`  → System & application logs
    - `/var/lib`  → App data (e.g., Docker, DBs)

- `/tmp`  → Temporary files (often cleared on reboot)
- `/usr`  → User programs & libraries (`/usr/bin` , `/usr/lib` )
- `/opt`  → Optional / third-party applications
- `/lib` , `/lib64`  → Shared libraries for binaries
- `/dev`  → Device files (disks, null device, etc.)
- `/proc`  → Virtual filesystem for process & system info
- `/mnt` , `/media`  → Mount points for disks and USBs
###  DevOps-Focused Pointers
- Service configs → `/etc` 
- Logs for debugging → `/var/log` 
- App/service data → `/var/lib` 
- User scripts → `/home/<user>` 
- Temporary testing files → `/tmp` 
```
Question: How do you check if the 'nginx' service is running?

Step 1: Check service status
systemctl status nginx  >>  It shows if the service is active, failed, or stopped 

Step 2: If service is not found, list all services
systemctl list-units --type=service >> To see what services exist on the system

Step 3: Check if service is enabled on boot
systemctl is-enabled nginx  >>  To know if it will start automatically after reboot
What I learned: Always check status first, then investigate based on what you see.
```
```
Example Scenario: Service Not Starting
A web application service called 'myapp' failed to start after a server reboot. What 
commands would you run to diagnose the issue? Write at least 4 commands in order.

Step 1: systemctl status myapp
Why: i will check the status of the service It shows if the service is 
active, failed, or stopped

Step 2: [journalctl -u myapp -n 50]
Why: [reviews recent logs to identify startup errors or missconfigurations]

step 3: systemctl is-enabled myapp
Why :   verifies whether the service enabled to start automatically on boot

step 4:  systemctl restart myapp
Why :   attempts to restart the service after identifying or fixing the issue

step 5:  systemctl daemon-reload  ( interview bonus / optional follow up)
Why :  reloads systemd configuration if the service unit file was modified
...
```
```
Scenario 2: High CPU Usage
Your manager reports that the application server is slow. You SSH into the server.
What commands would you run to identify which process is using high CPU?

step 1 : Use a command that shows **live** CPU usage that is >> top
why :- shows live cpu usage and highlights the processes consuming 
highest cpu in real time

step 2: Look for processes sorted by CPU percentage >> htop
why : - provides an interactive and clearer view of CPU usage sorted processes 
and per core utilization

step3 : ps aux --sort=%cpu | head -10
why : lists the top CPU consuming processes in descending order to quickly 
identify 

step 4 : ps -p <PID> -o pid,ppid,%cpu,%mem,cmd
why : - inspects the identified process in details to understand what is causing high cpu usage
```
```
Scenario 4: File Permissions Issue
A script at /home/user/backup.sh is not executing. When you run it: ./backup.sh You get: "Permission denied"
What commands would you use to fix this?

step 1 : Check current permissions
Command: ls -l /home/user/backup.sh
why : checks current file permissions to confirm execute (x) is missing

step 2: Add execute permission
Command: chmod +x /home/user/backup.sh
why : adds execute permission so the script can run

step 3 : Verify it worked
Command: ls -l /home/user/backup.sh
Look for: -rwxr-xr-x (notice 'x' = executable)

Step 4: Try running it
Command: ./backup.sh
```
---

# **DAY -08**
# Cloud Server Setup: Docker, Nginx & Web Deployment
- Launch a cloud instance (AWS EC2 or Utho)
- Connect via SSH
- Install Nginx
- Configure security groups for web access (port 80 by default for nginx)
- Extract and save logs to a file
- Verify your webpage is accessible from the internet
Completed hands on exercises for above and committed in the github

---

# **DAY - 09**
# Linux User & Group Management Challenge
- Create users and set passwords
- Create groups and assign users
- Set up shared directories with group permissions
- Task 1: Create Users (20 minutes)
    - `tokyo` 
    - `berlin` 
    - `professor` 



![image.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/image_OtgvJqWZnXuAa6kpSZzRd.png?ixlib=js-3.8.0 "image.png")

### Task 2: Create Groups (10 minutes)
Create two groups:

- `developers` 
- `admins`  **Verify:** Check `/etc/group` 
developers:x:1004: admins:x:1005: ubuntu@ip-172-31-2-199:/$

### Task 3: Assign to Groups (15 minutes)
Assign users:

- `tokyo`  → `developers` 
- `berlin`  → `developers`  + `admins`  (both groups)
- `professor`  → `admins`  **Verify:** Use appropriate command to check group membership
```
developers:x:1004:tokyo,berlin
admins:x:1005:berlin,professor
ubuntu@ip-172-31-2-199:/$
```
### Task 4: Shared Directory (20 minutes)
1. Create directory: `/opt/dev-project` 
2. Set group owner to `developers` 
3. Set permissions to `775`  (rwxrwxr-x)
4. Test by creating files as `tokyo`  and `berlin` 
![image.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/image_9kNSoMXIq8ozvVGshF5H5.png?ixlib=js-3.8.0 "image.png")



---

# Day 10 – File Permissions & File Operations Challenge
 Create and read files using `touch` , `cat` , `vim` 

Understand and modify permissions using `chmod` 

### Understand Permissions 
Format: `rwxrwxrwx` (owner-group-others)  421+421+421

or you can assign permission using  chmod ugo+x filename

u - user 

g - group

o - others

---

# **DAY - 11 - File Ownership Challenge (chown & chgrp)**
- Understand file ownership (user and group)
- Change file owner using `chown` 
- Change file group using `chgrp` 
- Apply ownership changes recursively
## What is `chown`?
`chown` = **change owner**
 It changes who owns a file or directory in Linux/Ubuntu.

Basic form:

```bash
chown USER file
```
## What is `chgrp`?
`chgrp` = **change group**
 It changes the **group ownership** of a file or directory.

Basic form:

```bash
chgrp GROUP file
```
## Combined Owner & Group Change 
Using `chown` you can change both owner and group together:

1. **Syntax:** `sudo chown owner:group filename` 


# **Recursive Ownership **
## What does “recursively” mean?
**Recursively = apply to everything inside a folder too**

Not just the folder itself, but:

- all subfolders
- all files
- all sub-subfolders
- and so on, all the way down 📂
```
sudo chown -R USER:GROUP file/folderPATH
```


