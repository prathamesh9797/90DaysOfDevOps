# 

## Task
Today's goal is to **understand where things live in Linux** and **practice troubleshooting like a DevOps engineer**.

You will create notes covering:

- Linux File System Hierarchy (the most important directories)
- Practice solving real-world scenarios step by step
Document the purpose of these **essential** directories:

**Core Directories (Must Know):**

`/`  (root) - The starting point of everything    >>  home directory of the root (superuser) account and stores root specific files and configurations not regular user data 

**ls -l  **>  i saw **mnt , opt, etc** i would use **mnt **_**to temporarily mount filesystem such as external disks, USB drives **_



`/home`  - User home directories    >>  contains the home directories of regular users, where their personal files, configs, and projects are stored.

**ls -l** > i saw list of user home directories along with their permissions owners groups sizes and last modified times



`/root`  - Root user's home directory    >>  home directory of the root (superuser) account and stores root specific files and configurations not regular user data

**ls -l  **>  i saw **mnt , opt, etc** i would use **mnt **_**to temporarily mount filesystem such as external disks, USB drives **_



`/etc`  - Configuration files    >>  contains system-wide configuration files and settings used by the operating system and installed services.

ls -l >> i saw passwd systemd netconfig i would use passwd to see userdetails or userinfo



`/var/log`  - Log files (very important for DevOps!)    >>  stores system and application log files used for monitoring , troubleshooting and auditing.

ls -l  >>  i saw syslog journal installer , i would use journald for troubleshooting auditing and system analysis 



`/tmp`  - Temporary files    >>  used for temporary files created by applications and the system , usually cleared on reboot

ls -l  >> to store short lived, non critical temporary files needed during execution 



`/bin`  - Essential command binaries    >>  contains essential user command binariesrequired for basic system operation and recovery.

ls -l  >>  i will use /bin for essential system commands needed for basic operation and recovery ( example - ls , cp, mv )



`/usr/bin`  - User command binaries   >>  contains non-essential user command binaries and applications available to all users

ls -l  >>  i will use for standard user applications and non essential command binaries available system wide



`/opt`  - Optional/third-party applications    >>   used to install optional or third party software packages separate from the system's default directories 

ls -l   >> i saw google , i will use for to install and manage optional or third party software separately from core system packages.



### Part 2: Scenario-Based Practice (40 minutes)
**Example Scenario: Check if a service is running**

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
**Example Scenario:  Service Not Starting**

A web application service called 'myapp' failed to start after a server reboot.
What commands would you run to diagnose the issue?
Write at least 4 commands in order.

```
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
**Scenario 2: High CPU Usage**

Your manager reports that the application server is slow.
You SSH into the server. What commands would you run to identify
which process is using high CPU?

```
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
**Scenario 3: Finding Service Logs**

A developer asks: "Where are the logs for the 'docker' service?"
The service is managed by systemd.
What commands would you use?

```
step 1 : systemctl status docker
why : confirms wheteher the docker service is running and shows recent
 log snippets
 
step 2: journalctl -u docker -n 50
why : displays the last 50 log entries for docker service from systemd journal

step 3: journalctl -u docker -f 
why : follows docker logs in real time ( similar to tail -f ) for 
live troubleshooting

one line interview summary > for a systemd managed services like docker i use 
journalctl -u docker to view and follow service logs.
```
**Scenario 4: File Permissions Issue**

A script at /home/user/backup.sh is not executing.
When you run it: ./backup.sh
You get: "Permission denied"

What commands would you use to fix this?

```
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




