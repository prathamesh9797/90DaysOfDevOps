# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab

### Task 1: Log Rotation Script
Create `log_rotate.sh` that:

1. Takes a log directory as an argument (e.g., `/var/log/myapp` )
2. Compresses `.log`  files older than 7 days using `gzip` 
3. Deletes `.gz`  files older than 30 days
4. Prints how many files were compressed and deleted
5. Exits with an error if the directory doesn't exist
```
prathamesh@localhost:~/devops/scripts$ vim log_rotate.sh
prathamesh@localhost:~/devops/scripts$ chmod +x log_rotate.sh
prathamesh@localhost:~/devops/scripts$ ./log_rotate.sh
Usage: ./log_rotate.sh <log_directory>
```
---

### Task 2: Server Backup Script
Create `backup.sh` that:

1. Takes a source directory and backup destination as arguments
2. Creates a timestamped `.tar.gz`  archive (e.g., `backup-2026-02-08.tar.gz` )
3. Verifies the archive was created successfully
4. Prints archive name and size
5. Deletes backups older than 14 days from the destination
6. Handles errors — exit if source doesn't exist
```
prathamesh@localhost:~/devops/scripts$ vim backup.sh
prathamesh@localhost:~/devops/scripts$ chmod +x backup.sh
prathamesh@localhost:~/devops/scripts$ ./backup.sh
Usage: ./backup.sh <source_directory> <backup_destination>
prathamesh@localhost:~/devops/scripts$
```
---

### Task 3: Crontab
1. Read: `crontab -l`  — what's currently scheduled?
```
prathamesh@localhost:~/devops/scripts$ crontab -l
no crontab for prathamesh
```
1. Understand cron syntax:* * * * *  command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)


1. Write cron entries (in your markdown, don't apply if unsure) for:
    - Run `log_rotate.sh`  every day at 2 AM

```
0 2 * * * /home/prathamesh/devops/scripts/log_rotate.sh /var/log/myapp >> /home/prathamesh/devops/log_rotate.log 2>&1
```
- Run `backup.sh`  every Sunday at 3 AM
```
0 3 * * 0 /home/prathamesh/devops/scripts/backup.sh /data /backups >> /home/prathamesh/devops/backup.log 2>&1
```
- Run a health check script every 5 minutes
```
*/5 * * * * /home/prathamesh/devops/scripts/system_info.sh >> /home/prathamesh/devops/health.log 2>&1
```
---

### Task 4: Combine — Scheduled Maintenance Script
Create `maintenance.sh` that:

1. Calls your log rotation function
2. Calls your backup function
3. Logs all output to `/var/log/maintenance.log`  with timestamps
4. Write the cron entry to run it daily at 1 AM
```
prathamesh@localhost:~/devops/scripts$ vim maintenance.sh
prathamesh@localhost:~/devops/scripts$ chmod +x maintenance.sh
prathamesh@localhost:~/devops/scripts$ ./maintenance.sh
tee: /var/log/maintenance.log: Permission denied
[2026-02-20 01:29:11] ===== Maintenance job started =====
prathamesh@localhost:~/devops/scripts$ sudo ./maintenance.sh
[2026-02-20 01:29:31] ===== Maintenance job started =====
[2026-02-20 01:29:31] Starting log rotation for /var/log/myapp
prathamesh@localhost:~/devops/scripts$
```


