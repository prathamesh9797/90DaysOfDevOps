# Day 28 – Revision Day: Everything from Day 1 to Day 27

## What I've Covered So Far
| **Days** | **Topic** | **Key Concepts** |
| ----- | ----- | ----- |
| 1 | DevOps & Cloud Intro | What is DevOps, SDLC, Cloud basics |
| 2–7 | Linux Fundamentals | Architecture, commands, processes, systemd, file system hierarchy, troubleshooting, text files |
| 8 | Cloud Server Setup | Docker, Nginx, web deployment |
| 9–11 | Users, Permissions & Ownership | User/group management, file permissions, chown/chgrp |
| 12 | Revision Day 1 | Days 1–11 recap |
| 13 | Volume Management | LVM — physical volumes, volume groups, logical volumes |
| 14–15 | Networking | Fundamentals, DNS, IP, subnets, ports, hands-on checks |
| 16–18 | Shell Scripting | Basics, loops, arguments, error handling, functions |
| 19–20 | Shell Scripting Projects | Log rotation, backup, crontab, log analyzer |
| 21 | Shell Scripting Cheat Sheet | Personal reference guide |
| 22–25 | Git & GitHub | Init, branching, merge, rebase, stash, cherry pick, reset, revert, branching strategies |
| 26 | GitHub CLI | Managing GitHub from the terminal |
| 27 | GitHub Profile | Profile README, repo organization, developer branding |
## Challenge Tasks
### Task 1: Self-Assessment Checklist
Go through the checklist below. For each item, mark yourself honestly:

- **Can do confidently**
- **Need to revisit**
- **Haven't done yet**
#### Linux
- [ ]  Navigate the file system, create/move/delete files and directories
- [ ]  Manage processes — list, kill, background/foreground
- [ ]  Work with systemd — start, stop, enable, check status of services
- [ ]  Read and edit text files using vi/vim or nano
- [ ]  Troubleshoot CPU, memory, and disk issues using top, free, df, du
- [ ]  Explain the Linux file system hierarchy (/, /etc, /var, /home, /tmp, etc.)
- [ ]  Create users and groups, manage passwords
- [ ]  Set file permissions using chmod (numeric and symbolic)
- [ ]  Change file ownership with chown and chgrp
- [ ]  Create and manage LVM volumes
- [ ]  Check network connectivity — ping, curl, netstat, ss, dig, nslookup
- [ ]  Explain DNS resolution, IP addressing, subnets, and common ports
#### Shell Scripting
- [ ]  Write a script with variables, arguments, and user input
- [ ]  Use if/elif/else and case statements
- [ ]  Write for, while, and until loops
- [ ]  Define and call functions with arguments and return values
- [ ]  Use grep, awk, sed, sort, uniq for text processing
- [ ]  Handle errors with set -e, set -u, set -o pipefail, trap
- [ ]  Schedule scripts with crontab
#### Git & GitHub
- [ ]  Initialize a repo, stage, commit, and view history
- [ ]  Create and switch branches
- [ ]  Push to and pull from GitHub
- [ ]  Explain clone vs fork
- [ ]  Merge branches — understand fast-forward vs merge commit
- [ ]  Rebase a branch and explain when to use it vs merge
- [ ]  Use git stash and git stash pop
- [ ]  Cherry-pick a commit from another branch
- [ ]  Explain squash merge vs regular merge
- [ ]  Use git reset (soft, mixed, hard) and git revert
- [ ]  Explain GitFlow, GitHub Flow, and Trunk-Based Development
- [ ]  Use GitHub CLI to create repos, PRs, and issues
---

### Task 2: Revisit Your Weak Spots
1. Pick **3 topics** from the checklist where you marked "Need to revisit"
2. Go back to that day's challenge and redo the hands-on tasks
3. Document what you re-learned in `day-28-notes.md` 
 

---

## Task 3: Quick-Fire Questions
## **Answer these from memory (no Googling). Then verify your answers:**
## **What does **`**chmod 755 script.sh**`**  do?**
>> **7 = 4 + 2 + 1 = rwx**
 → Owner can **read, write, and execute**

**5 = 4 + 1 = r-x**
 → Group can **read and execute**

**5 = 4 + 1 = r-x**
 → Others can **read and execute**

## **What is the difference between a process and a service?**
#### >>**A process:**
- Is any running program
- Can be foreground or background
- Has a lifecycle (created, executed, terminated)
- Can be viewed using commands like `ps`  or `top` 
#### **A service:**
- Is designed to run in the background
- Usually starts automatically at system boot
- Is managed by tools like `systemctl` 
- Can automatically restart if it crashes
- Often provides system-wide functionality (e.g., web server, database)
## **How do you find which process is using port 8080?**
>>To identify which process is using port 8080, I would use networking utilities like `lsof`, `netstat`, or `ss`. 

```
lsof -i :8080
```
This shows:

- The process name
- The PID
- The user
- The network state
## **What does **`**set -euo pipefail**`**  do in a shell script?**
>> `set -euo pipefail` enables strict error handling in a Bash script.
 It makes the script fail fast and prevents silent errors.

It combines three options:

- `-e`  → Exit immediately if a command fails
- `-u`  → Treat unset variables as an error
- `-o pipefail`  → Make pipelines fail if any command in the pipeline fails
Together, these options improve script reliability and prevent unexpected behavior.

## **What is the difference between **`**git reset --hard**`**  and **`**git revert**`** ?**
### >> **git reset --hard**
```
git reset --hard <commit-id>
```
What it does:

- Moves `HEAD`  to the specified commit
- Updates the staging area
- Updates the working directory
- Permanently deletes uncommitted changes
### Important:
It **rewrites history**.
 If the branch was pushed to a shared repository, this can cause serious issues for other collaborators.

Typically used on **local branches only**.

### **git revert**
```
git revert <commit-id>
```
What it does:

- Creates a new commit
- The new commit reverses the changes from the specified commit
- Keeps full history intact
### Important:
It is **safe for shared/public branches** because it does not modify existing history.

## **What branching strategy would you recommend for a team of 5 developers shipping weekly?**
>>For a team of 5 developers releasing weekly, I would recommend a **Trunk-Based Development approach with short-lived feature branches**, or a simplified **Git Flow**, depending on release stability requirements.

For most modern teams, trunk-based development works best because it keeps integration frequent and reduces merge conflicts.

## Trunk-Based Development (Preferred for Weekly Releases)
### How it works:
- One main branch (`main` )
- Developers create short-lived feature branches
- Frequent merges (daily or within 1–2 days)
- Pull requests required
- CI/CD runs on every merge
- Weekly release from `main` 
### Why it’s good for a 5-person team:
- Low overhead
- Fewer merge conflicts
- Faster feedback
- Easier code reviews
- Works very well with CI/CD
## **What does **`**git stash**`**  do and when would you use it?**
>>`git stash` temporarily saves uncommitted changes in the working directory and staging area, allowing you to revert to a clean working state without committing those changes.

You would use it when you need to switch branches or pull updates but are not ready to commit your current work.

```
git stash
```
Git:

- Saves modified tracked files
- Reverts your working directory to the last commit
- Stores changes in a hidden stash stack
Your changes are not lost — they’re stored safely.

## **How do you schedule a script to run every day at 3 AM?**
>> To schedule a script to run daily at 3 AM in Linux, I would use a **cron job**.

First, I would edit the crontab file using:

```
crontab -e
```
Then I would add the following entry:

```
0 3 * * * /path/to/script.sh
```
This schedules the script to run every day at 3:00 AM.

```
0 3 * * * /path/to/script.sh
│ │ │ │ │
│ │ │ │ └── Day of week (0–7)
│ │ │ └──── Month
│ │ └────── Day of month
│ └──────── Hour (3 AM)
└────────── Minute (0)
```
## **What is the difference between **`**git fetch**`**  and **`**git pull**`** ?**
>> `git fetch` downloads the latest changes from the remote repository but does not modify the working directory or current branch.

`git pull` fetches the changes and then automatically merges (or rebases) them into the current branch.

In short, `git pull` = `git fetch` + `git merge` (or rebase).

# Key Difference
| `git fetch`  | `git pull`  |
| ----- | ----- |
| Downloads changes only | Downloads + merges |
| Does not modify working files | Updates working files |
| Safer, more controlled | Faster but less controlled |
| Good for reviewing changes | Good for quick sync |
## **What is LVM and why would you use it instead of regular partitions?**
>> to create flexible, resizable logical volumes instead of fixed disk partitions.

Unlike traditional partitions, LVM allows you to dynamically resize volumes, combine multiple disks into a single volume group, and take snapshots.

It provides flexibility and easier storage management, especially in production environments.

### 1. Easy Resizing
You can extend a logical volume without rebooting (in many cases).

### 2. Storage Pooling
Combine multiple disks into one large volume.

### 3. Snapshots
Useful for backups and testing before upgrades.

### 4. Better for Cloud & Servers
Production systems often require dynamic storage growth.

| Regular Partition | LVM |
| ----- | ----- |
| Fixed size | Resizable |
| Hard to modify | Flexible |
| One disk = one partition | Multiple disks pooled |
| No snapshots | Supports snapshots |
> LVM is a flexible storage management layer that allows dynamic resizing, disk pooling, and snapshots, unlike traditional fixed partitions. 



