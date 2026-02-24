# Day 23 – Git Branching & Working with GitHub

### Task 1: Understanding Branches
Answer these in your `day-23-notes.md`:

## What is a branch in Git?
>> A branch in Git is an independent line of development that lets you work on changes safely and merge them back when ready.

## Why do we use branches instead of committing everything to `main` ?
>>We use branches so that `**main**`** always stays clean, stable, and deployable**, while people can safely experiment, build features, and fix bugs without breaking everyone else

## What is `HEAD`  in Git?
>>`**HEAD**`** is Git’s pointer to “where you currently are.”** It tells Git which commit (and usually which branch) you’re on right now.

## What happens to your files when you switch branches?
>>When you switch branches, **Git changes the files in your working directory to match the snapshot of the branch you’re switching to.**

---

### Task 2: Branching Commands — Hands-On
In your `devops-git-practice` repo, perform the following:

### **List all branches in your repo**
>> git branch

### **Create a new branch called **`**feature-1**`** **
>> `prathamesh@localhost:~/devops-git-practice$ git branch feature-1` 

### **Switch to **`**feature-1**`** **
>> prathamesh@localhost:~/devops-git-practice$ git switch feature-1
Switched to branch 'feature-1'

### Create a new branch and switch to it in a single command — call it `feature-2` 
>> prathamesh@localhost:~/devops-git-practice$ git checkout -b feature-2
Switched to a new branch 'feature-2'

### Try using `git switch`  to move between branches — how is it different from `git checkout` ?
>> `git switch` is a focused command for changing or creating branches, while `git checkout` is a legacy multi-purpose command that can also modify files and move HEAD. The newer `switch` and `restore` commands separate concerns, making Git workflows clearer and safer

### Make a commit on `feature-1`  that does **not** exist on `main` 
>> prathamesh@localhost:~/devops-git-practice$ git commit -m " git-commands.md updated"
[feature-1 e75d010]  git-commands.md updated
 1 file changed, 1 insertion(+), 1 deletion(-)

### **Switch back to **`**main**`**  — verify that the commit from **`**feature-1**`**  is not there**
>> prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
prathamesh@localhost:~/devops-git-practice$ git log --oneline
dd00f51 (HEAD -> master, feature-2) Added git push pull merge commands
4064aa6 Added branching commands
0b8493f Add git commands reference

### **Delete a branch you no longer need**
>> prathamesh@localhost:~/devops-git-practice$ git branch
 feature-1
 feature-2

- master
prathamesh@localhost:~/devops-git-practice$ git branch -d feature-2
Deleted branch feature-2 (was dd00f51).
### **Add all branching commands to your **`**git-commands.md**`** **
>> Switch branches:

`git switch <name>` 

**OR**

`git checkout <name>` 

### Create a branch:
`git switch -c <name>` 

**OR**

`git checkout -b <name>` 

### List branches:
`git branch` 

### List branches by most recently committed to:
`git branch --sort=-committerdate` 

### Delete a branch:
`git branch -d <name>` 

### Force delete a branch:
`git branch -D <name>` 

---

### Task 3: Push to GitHub
### **Create a new repository on GitHub (do NOT initialize it with a README)**
>>

![Screenshot from 2026-02-24 17-34-53.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2017-34-53_NgdV7HjsvNc-s1RCD9EOr.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 17-34-53.png")



### **Connect your local **`**devops-git-practice**`**  repo to the GitHub remote**
>> Connect Local Repo to GitHub (Simple Steps)

1️⃣ **Create a repo on GitHub**

- Go to GitHub → New repository
- Name it: `devops-git-practice` 
- Do **not** add README
2️⃣ **Add GitHub remote to local repo**

```
git remote add origin https://github.com/<your-username>/devops-git-practice.git
```
3️⃣ **Verify remote**

```
git remote -v
```
4️⃣ **Push your code to GitHub**

```
git push -u origin master
```
_(Use _`_main_`_ instead of _`_master_`_ if your branch is main)_

## Simple Summary
- `git remote add origin URL`  → connect to GitHub
- `git remote -v`  → check connection
- `git push -u origin branch`  → upload code


### **Push your **`**main**`**  branch to GitHub**
>> prathamesh@localhost:~/devops-git-practice$ git remote add origin https://github.com/prathamesh9797/devops-git-practice.git
prathamesh@localhost:~/devops-git-practice$ git remote -v
origin	https://github.com/prathamesh9797/devops-git-practice.git (fetch)
origin	https://github.com/prathamesh9797/devops-git-practice.git (push)

prathamesh@localhost:~/devops-git-practice$ git push origin master
Username for 'https://github.com': prathamesh9797
Password for 'https://prathamesh9797@github.com': 
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 16 threads
Compressing objects: 100% (6/6), done.
Writing objects: 100% (9/9), 1.30 KiB | 1.30 MiB/s, done.
Total 9 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), done.
To https://github.com/prathamesh9797/devops-git-practice.git
 * [new branch]      master -> master


### **Push **`**feature-1**`**  branch to GitHub**
>> prathamesh@localhost:~/devops-git-practice$ git push origin feature-1
Username for 'https://github.com': prathamesh9797
Password for 'https://prathamesh9797@github.com': 
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 16 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 288 bytes | 288.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
remote: 
remote: Create a pull request for 'feature-1' on GitHub by visiting:
remote:      https://github.com/prathamesh9797/devops-git-practice/pull/new/feature-1
remote: 
To https://github.com/prathamesh9797/devops-git-practice.git
 * [new branch]      feature-1 -> feature-1

### **Verify both branches are visible on GitHub**
>> 

![Screenshot from 2026-02-24 17-53-46.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2017-53-46_jGmj7Vmo9C1icn7g2qUbx.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 17-53-46.png")



Answer in your notes: What is the difference between `origin`  and `upstream` ?

>> `origin`: origin is the default name for the repo you cloned,points to your own GitHub repository where you push and pull changes.  Example - [﻿github.com/prathamesh9797/devops-git-practice](https://github.com/prathamesh9797/devops-git-practice) 

`upstream`: upstream refers to the original repository you forked from.You use it to pull updates from the original project into your fork.

---

### Task 4: Pull from GitHub
1. Make a change to a file **directly on GitHub** (use the GitHub editor)
>>

![Screenshot from 2026-02-24 17-58-35.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2017-58-35_LDeQR0LKRd97vVENtdC7X.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 17-58-35.png")



### **Pull that change to your local repo**
>> prathamesh@localhost:~/devops-git-practice$ git pull origin master
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 1), reused 0 (delta 0), pack-reused 0 (from 0)
Unpacking objects: 100% (3/3), 1011 bytes | 1011.00 KiB/s, done.
From https://github.com/prathamesh9797/devops-git-practice
 * branch            master     -> FETCH_HEAD
   dd00f51..0c04004  master     -> origin/master
Updating dd00f51..0c04004
Fast-forward
 git-commands.md | 2 ++
 1 file changed, 2 insertions(+)

### **Answer in your notes: What is the difference between **`**git fetch**`**  and **`**git pull**`** ?**
- `git fetch` : Downloads changes from remote only; does not change your branch,just updates remote info.
- `git pull`  : Downloads changes from remote and merges them into your current branch, updating your local branch immediately.
---

### Task 5: Clone vs Fork
### **Clone any public repository from GitHub to your local machine**
#### Clone any public repo (direct clone)
Pick any public repo on GitHub 

```
git clone https://github.com/<owner>/<repo>.git
```
This gives you 

- a local copy
- remote called `origin`  → pointing to the original repo
Check:

```
git remote -v
```
### **Fork** the same repository on GitHub, then clone your fork
>> On GitHub:

- Open the same repo
- Click **Fork**
- This creates: `your-username/Hello-World` 
Now clone **your fork**:

```
git clone https://github.com/<your-username>/Hello-World.gitcd Hello-World
```
Check:

```
git remote -v
```
### **Answer in your notes:**
### **What is the difference between clone and fork?**
>>**Clone** creates a local copy of a repository on your machine.
 **Fork** creates a copy of a repository under your own GitHub account, which you own and can push to.

### **When would you clone vs fork?**
>> **Clone when:**

- You just want to run or explore the code locally
- You already have write access to the repo
- You’re not contributing back
**Fork when:**

- You don’t have write access to the repo
- You want to contribute via Pull Requests
- You want to maintain your own version of the project
- After forking, how do you keep your fork in sync with the original repo?


