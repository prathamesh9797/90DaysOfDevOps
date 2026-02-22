# Day 22 – Introduction to Git: Your First Repository

## Challenge Tasks
### Task 1: Install and Configure Git
1. Verify Git is installed on your machine
2. Set up your Git identity — name and email
3. Verify your configuration
##  Verify Git is installed
Run this command:

```
git --version
```
### What you should see
Something like:

```
git version 2.43.0
```
- If you see a version → Git is installed
- ❌ If not → you need to install Git first
```
prathamesh@localhost:~$ git --version
git version 2.43.0
```
##  Set up your Git identity (name and email)
Git uses this info to label your commits.

Run these commands (use your own name and email):

```
git config --global user.name "Your Name"git config --global user.email "youremail@example.com"
```
### Example:
```
git config --global user.name "Alex Dev"git config --global user.email "alex@example.com"
```
- `--global`  means: use this for **all repos** on this computer


## 3. Verify your configuration
Check what you set:

```
git config --global --list
```
```
prathamesh@localhost:~$ git config --global --list
user.mail=prathameshjoshi321@gmail.com
user.name=prathamesh
user.email= prathameshjoshi321@gmail.com
pull.rebase=false
prathamesh@localhost
```
Or check one by one:

```
git config --global user.namegit config --global user.email
```
## Simple summary
- `git --version`  → check Git is installed
- `git config --global user.name "Name"`  → set your name
- `git config --global user.email "Email"`  → set your email
- `git config --global --list`  → check everything
---

### Task 2: Create Your Git Project
1. Create a new folder called `devops-git-practice` 
2. Initialize it as a Git repository
3. Check the status — read and understand what Git is telling you
4. Explore the hidden `.git/`  directory — look at what's inside
## 1. Create a new folder
```
mkdir devops-git-practice
```
## 2. Initialize it as a Git repository
```
git init
```
**What you’ll see:**

```
Initialized empty Git repository in .../devops-git-practice/.git/
```
**What this means:**

- Git is now “turned on” for this folder
- It created a hidden folder called `.git`  to store all history
## 3. Check the status (read Git’s message)
```
git status
```
```
prathamesh@localhost:~/devops-git-practice$ git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```
**How to understand this in simple words:**

- **On branch main** → you’re on the main branch
- **No commits yet** → you haven’t saved any history
- **nothing to commit** → no files yet for Git to track
## Explore the hidden `.git/` folder
Show hidden files:

```
ls -a
```
```
prathamesh@localhost:~/devops-git-practice$ ls -la
total 12
drwxrwxr-x  3 prathamesh prathamesh 4096 Feb 23 00:20 .
drwxr-x--- 28 prathamesh prathamesh 4096 Feb 23 00:20 ..
drwxrwxr-x  7 prathamesh prathamesh 4096 Feb 23 00:20 .git
```
## Simple summary
- `mkdir devops-git-practice`  → create project folder
- `git init`  → turn on Git for this folder
- `git status`  → see what Git knows about your files
- `.git/`  → hidden folder where Git stores everything
---

### Task 3: Create Your Git Commands Reference
1. Create a file called `git-commands.md`  inside the repo
2. Add the Git commands you've used so far, organized by category:
    - **Setup & Config**
    - **Basic Workflow**
    - **Viewing Changes**

3. For each command, write:
    - What it does (1 line)
    - An example of how to use it

```
prathamesh@localhost:~/devops-git-practice$ vim git-commands.md
```
Saved all used commands under .md file 

---

### Task 4: Stage and Commit
1. Stage your file
2. Check what's staged
3. Commit with a meaningful message
4. View your commit history
## Stage your file
```
git add git-commands.md
```
**What this means:**
 You’re telling Git: “I want to include this file in my next save (commit).”

## 2. Check what’s staged
```
git status
```
You should see something like:

```
prathamesh@localhost:~/devops-git-practice$ git add git-commands.md
prathamesh@localhost:~/devops-git-practice$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   git-commands.md
```
**How to read this:**

- “Changes to be committed” = staged and ready to save
## 3. Commit with a meaningful message
```
git commit -m "Add git commands reference"
```
**What this means:**
 You just saved a snapshot of your project with a message explaining _what you changed_.

```
prathamesh@localhost:~/devops-git-practice$ git commit -m "Add git commands reference"
[master (root-commit) 0b8493f] Add git commands reference
 1 file changed, 64 insertions(+)
 create mode 100644 git-commands.md
```
##  4. View your commit history
```
git log
```
```
prathamesh@localhost:~/devops-git-practice$ git log
commit 0b8493fd98a6f1d439ef9be913fb67fdd50497d3 (HEAD -> master)
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Mon Feb 23 00:35:28 2026 +0530

    Add git commands reference
```
You’ll see your commit listed with an ID and message.

## Simple summary
- `git add file`  → stage the file
- `git status`  → check what’s staged
- `git commit -m "message"`  → save changes
- `git log`  → see your history
---

### Task 5: Make More Changes and Build History
1. Edit `git-commands.md`  — add more commands as you discover them
2. Check what changed since your last commit
3. Stage and commit again with a different, descriptive message
4. Repeat this process at least **3 times** so you have multiple commits in your history
5. View the full history in a compact format
## Check what changed since your last commit
```
git status
```
See the exact changes:

```
git diff
```
**What this means:**

- `git status`  → shows files that changed
- `git diff`  → shows _what_ changed line by line
```
prathamesh@localhost:~/devops-git-practice$ vim git-commands.md
prathamesh@localhost:~/devops-git-practice$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git-commands.md

no changes added to commit (use "git add" and/or "git commit -a")
```
## 3. Stage and commit again (new message)
```
prathamesh@localhost:~/devops-git-practice$ git add git-commands.md
prathamesh@localhost:~/devops-git-practice$ git commit -m "Added branching commands"
[master 4064aa6] Added branching commands
 1 file changed, 12 insertions(+)
```
## View full history (compact format)
```
git log --oneline
```
```
prathamesh@localhost:~/devops-git-practice$ git log --oneline
dd00f51 (HEAD -> master) Added git push pull merge commands
4064aa6 Added branching commands
0b8493f Add git commands reference
```
---

### Task 6: Understand the Git Workflow
Answer these questions in your own words (add them to a `day-22-notes.md` file):

## What is the difference between `git add`  and `git commit` ?
>>**`****git add****`** selects the changes I want to save next. 
`**git commit**` actually saves those selected changes into Git history.

In simple words:
- `**git add`** = choose what to save 
- `**git commit**` = save it

## What does the **staging area** do? Why doesn't Git just commit directly?
>> The staging area is a waiting area where I can review and choose changes before saving them.
This is useful because:
- I can commit only some changes, not everything
- I can group related changes into one clean commit

Git does not commit directly so I have control over what goes into each commit.

## What information does `git log`  show you?
>> `git log` shows:
- Past commits
- Who made them
- When they were made
- The commit message
- A unique commit ID



## What is the `.git/`  folder and what happens if you delete it?
>>The `.git/` folder is where Git stores everything:
- commit history 
- branches 
- settings 

If I delete the `.git/` folder:
- my project is no longer a Git repository 
- all Git history is lost 
- the files remain, but Git tracking is gone

## **What is the difference between a working directory, staging area, and repository?**
>>  Working directory: the files I am editing on my computer 
- Staging area: the place where I choose which changes to include next 
- Repository: the saved history (commits) stored by Git 

In simple flow:
Working directory → Staging area → Repository

