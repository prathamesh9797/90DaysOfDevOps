# Day 25 – Git Reset vs Revert & Branching Strategies

## Task 1: Git Reset — Hands-On
## Make 3 commits in your practice repo (commit A, B, C)
```
>> prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit 1"
[master a86be62] commit 1
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit 2"
[master 1f0594d] commit 2
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit 3"
[master 372dda5] commit 3
 1 file changed, 1 insertion(+)
```
## **Use **`**git reset --soft**`**  to go back one commit — what happens to the changes?**
>> The last commit was removed from commit history

The changes from that commit were **not lost**

All changes stayed **staged** (in the index)

The working directory remained unchanged

**Conclusion:**
 `git reset --soft` moves HEAD back by one commit but keeps all changes from that commit staged and ready to be re-committed.

```
prathamesh@localhost:~/devops-git-practice$ git reset --soft HEAD~1
prathamesh@localhost:~/devops-git-practice$ git log --oneline
1f0594d (HEAD -> master) commit 2
a86be62 commit 1
```
## **Re-commit, then use **`**git reset --mixed**`**  to go back one commit — what happens now?**
```
>> prathamesh@localhost:~/devops-git-practice$ git commit -m "commit 3 again"
[master 2da86e7] commit 3 again
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ git log --oneline
2da86e7 (HEAD -> master) commit 3 again
1f0594d commit 2
a86be62 commit 1

prathamesh@localhost:~/devops-git-practice$ git reset --mixed HEAD~1
Unstaged changes after reset:
M	git-notes.md
```
- The last commit is removed from commit history
- The changes from that commit are **not lost**
- The changes become **unstaged**
- The working directory still contains the changes
**Conclusion:**
 `git reset --mixed` moves HEAD back one commit and keeps changes in the working directory, but removes them from the staging area.

## **Re-commit, then use **`**git reset --hard**`**  to go back one commit — what happens this time?**
```
>> prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit 3 again"
[master f535c1e] commit 3 again
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ git reset --hard HEAD~1
HEAD is now at 1f0594d commit 2
prathamesh@localhost:~/devops-git-practice$ git log --oneline
1f0594d (HEAD -> master) commit 2
a86be62 commit 1
fcc91d8 hotfix step 2
```
- The last commit was removed from commit history
- The changes from that commit were **completely deleted**
- The staging area was cleared
- The working directory was reset to match the previous commit
**Conclusion:**
 `git reset --hard` moves HEAD back by one commit and permanently discards all changes from that commit from both the staging area and the working directory.

## Answer in your notes:
## What is the difference between `--soft` , `--mixed` , and `--hard` ?
>>`--soft` → undo commit, keep changes staged

`--mixed`  → undo commit, keep changes but unstaged

`--hard`  → undo commit and delete changes completely

This controls **how far back Git resets**:

- `--soft`  = reset HEAD only
- `--mixed`  = reset HEAD + staging area
- `--hard`  = reset HEAD + staging area + working directory
## Which one is destructive and why?
>> `git reset --hard` is destructive because it deletes both the commit and the actual file changes from the working directory, causing permanent data loss.

- ❌ The commit is removed from history
- ❌ The staging area is cleared
- ❌ The changes in your files (working directory) are wiped out
So after `git reset --hard`, your project files go back to the previous commit state, and the work from the last commit is **lost**.

Unless you recover it using `git reflog` (and even that’s not guaranteed forever), the changes are gone.

## When would you use each one?
>>  When to use `git reset --soft` 

Use this when you want to **undo the last commit but keep all changes staged**.

**Typical use cases:**

- You want to change the commit message
- You committed too early
- You want to add/remove files to the last commit
- You want to squash or edit recent commits
>  Best for: fixing the _last commit_ without touching your work. 



###  When to use `git reset --mixed` 
Use this when you want to **undo the last commit and rework what goes into the next commit**.

**Typical use cases:**

- You want to split one commit into multiple commits
- You accidentally committed too many files
- You want to selectively stage changes again
- You want to reorganize your commits
>  Best for: re-selecting files/changes before committing again. 



### When to use `git reset --hard` 
Use this when you want to **completely discard the last commit and its changes**.

**Typical use cases:**

- You broke something and want to go back to a clean state
- You were experimenting and want to throw away the work
- You want your working directory to exactly match a previous commit
- Best for: safely nuking local mistakes you’re 100% sure you don’t need. 
### One-liner summary (easy to remember)
- `--soft`  → “Undo commit, keep staged”
- `--mixed`  → “Undo commit, keep files”
- `--hard`  → “Undo commit, delete everything”
## Should you ever use `git reset`  on commits that are already pushed?
>>Why not?

Because `git reset` **rewrites commit history**.
 If the commits are already pushed and other people have pulled them:

- Your local history will differ from theirs
- They’ll get conflicts and diverged branches
- It can break your teammates’ work
- It creates confusion and messy merges
### When is it okay?
Only in controlled situations:

- You’re working **alone** on the branch
- Or it’s your **own feature branch**
- And you understand force-pushing
In that case, you _can_ reset and force push:

```
git push --force
```
### One-line >>
>  You should avoid using `git reset` on already pushed commits because it rewrites history and can break other collaborators’ branches; it’s only safe when working alone or on a private feature branch with force push.

---

## Task 2: Git Revert — Hands-On
## Make 3 commits (commit X, Y, Z)
```
>> prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit x"
[master 6c7b998] commit x
 1 file changed, 2 insertions(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit y"
[master ec609fb] commit y
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "commit z"
[master 9ee1960] commit z
 1 file changed, 1 insertion(+)
```
## **Revert commit Y (the middle one) — what happens?**
## **>> **tried to revert **commit Y**, but: Conflict occured
- Commit Z modified the same part of `git-notes.md` 
- Git doesn’t know how to safely undo Y without breaking Z
- So Git stopped and asked _you_ to resolve the conflict
```
prathamesh@localhost:~/devops-git-practice$ git log --oneline
a9ad1b0 (HEAD -> master) commit z
4c05652 commit y
8340423 commit x

prathamesh@localhost:~/devops-git-practice$ git revert 4c05652
Auto-merging git-notes.md
CONFLICT (content): Merge conflict in git-notes.md
error: could not revert 4c05652... commit y
hint: After resolving the conflicts, mark them with
hint: "git add/rm <pathspec>", then run
hint: "git revert --continue".
hint: You can instead skip this commit with "git revert --skip".
hint: To abort and get back to the state before "git revert",
hint: run "git revert --abort".
```
## Fix the conflict (fastest path)
### 1. Open the conflicted file
Since you’re **reverting Y**, you usually want to:

- **Keep the current content (HEAD / Z)**
- **Remove the part from Y remove Y entry entirely **
So delete the `<<<<<<<`, `=======`, `>>>>>>>` lines and keep the correct final content.

### 2. Mark it resolved
```
git add git-notes.md
```
### 3. Continue the revert
```
git revert --continue
```
When Nano opens:

- `Ctrl + O`  → Enter
- `Ctrl + X` 
## 4. Verify
```
git log --oneline
```
You should see a new commit like:

```
Revert "commit y"
```
```
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git revert --continue
[master f03266c] Revert "commit y"
 1 file changed, 1 deletion(-)
prathamesh@localhost:~/devops-git-practice$ git status
On branch master
nothing to commit, working tree clean
prathamesh@localhost:~/devops-git-practice$ git log --oneline
f03266c (HEAD -> master) Revert "commit y"
a9ad1b0 commit z
4c05652 commit y
8340423 commit x
```
## **Check **`**git log**`**  — is commit Y still in the history?**
>> **Yes, commit Y is still in the history.**

After running `git revert`, `git log` shows:

- The original **commit Y** is still present
- A new commit `**Revert "commit y"**`  is added on top
**Conclusion:**
 `git revert` does not delete commit Y from history. It creates a new commit that undoes the changes made by commit Y while keeping the full commit history intact.

## Answer in your notes:
## How is `git revert`  different from `git reset` ?
>>`**git revert**`** and **`**git reset**`** both undo changes, but they work in very different ways:**

- `**git revert**` 
    - Creates a **new commit** that undoes the changes of a specific commit
    - **Does not rewrite history**
    - The original commit stays in `git log` 
    - Safe to use on **shared branches**

- `**git reset**` 
    - Moves HEAD backward to a previous commit
    - **Rewrites commit history**
    - The removed commit disappears from the branch history
    - Risky on **shared branches** (can break teammates’ work)

**One-line summary:**

>  `git revert` undoes changes by adding a new commit, while `git reset` undoes changes by rewriting commit history.

## Why is revert considered safer than reset for shared branches?
>> `git revert` is safer because it **does not rewrite commit history**.

- It creates a **new commit** that undoes the changes
- The original commits stay in the history
- Teammates can pull the new revert commit normally
- No one’s branch breaks, and no force-push is needed
In contrast, `git reset` **rewrites history** by removing commits from the branch, which can:

- Desync teammates’ branches
- Cause conflicts and confusion
- Require force-pushing
**One-line answer:**

>  Revert is safer for shared branches because it preserves history and avoids rewriting commits that others may already have pulled.

## When would you use revert vs reset?
>>  Use `**git revert**` when:

- The commit is **already pushed** to the remote
- You’re working on a **shared branch** (like `main`  / `master` )
- You want to undo a specific commit **safely**
- You want to keep a clear history of what was undone and why
###  Use `**git reset**` when:
- The commit is **local only** (not pushed yet)
- You’re cleaning up your own work before pushing
- You want to rewrite history (edit/squash recent commits)
- You’re working on a private feature branch
**One-line summary:**

>  Use `revert` for shared/pushed commits; use `reset` for local, private cleanup before pushing.

---

## **Task 3: Reset vs Revert — Summary**
## **Create a comparison in your notes:**
|  | git reset | git revert |
| ----- | ----- | ----- |
| What it does | Moves HEAD to a previous commit (rewrites history) | Creates a new commit that undoes a specific commit |
| Removes commit from history? | Yes (on the current branch) |  No (original commit stays in history) |
| Safe for shared/pushed branches? | No (can break teammates’ branches) | Yes (safe; no history rewrite) |
| When to use | Local cleanup before pushing; fixing recent commits; squashing | Undo a pushed commit; fix mistakes on shared branches |
---

# Task 4: Branching Strategies
Research the following branching strategies and document each in your notes with:

## **How it works (short description)**
>>GitFlow uses multiple long-lived branches for different purposes:

- `main`  → production-ready code
- `develop`  → integration branch
- `feature/*`  → new features
- `release/*`  → prepare releases
- `hotfix/*`  → urgent production fixes
## **A simple diagram or flow (text-based is fine)**
>>main ────────────────●───────────────●
 ↑ hotfix/* ↑
 │ │ │
release/* ───────────┘──────────────┘
 ↑
 │
develop ──●────●────●───────────────
 ↑ ↑
 feature feature

## **When/where it's used**
>>Large teams

Enterprise projects

Products with **scheduled releases**

Long QA/testing cycles

## **Pros and cons**
**Pros:**

- Clear structure and roles for branches
- Good for release management
- Safe separation between dev and prod
- Supports hotfixes cleanly
**Cons:**

- Complex workflow
- Slower development
- More merges and overhead
- Overkill for small teams
#### **GitFlow — develop, feature, release, hotfix branches**
#### **GitHub Flow — simple, single main branch + feature branches**
#### **Trunk-Based Development — everyone commits to main, short-lived branches**
## **Answer:**
## **Which strategy would you use for a startup shipping fast?**
>> **GitHub Flow**

- Simple
- Fast iteration
- Minimal process overhead
## **Which strategy would you use for a large team with scheduled releases?**
>>**GitFlow**

- Structured release management
- Clear separation of dev and production
- Supports hotfixes and planned releases
## **Which one does your favorite open-source project use? (check any repo on GitHub)**
>>Example: **Kubernetes (kubernetes/kubernetes on GitHub)**
 Uses a **GitHub Flow–style model**:

- `main`  branch
- Feature branches
- Pull requests + CI before merge
(Most modern open-source projects follow GitHub Flow because it works well with PRs.)

## One-line summary
>  GitFlow = structured releases
 GitHub Flow = fast shipping
 Trunk-based = extreme CI/CD discipline





---

### Task 5: Git Commands Reference Update
Update your `git-commands.md` to cover everything from Days 22–25:

### **Setup & Config**
```
git config --global user.name "Your Name"git config --global user.email "you@example.com"git config --listgit init 
```
**What they do:**

- Set your Git identity
- Initialize a new repo
- View config
### **Basic Workflow (add, commit, status, log, diff)**
```
git status              # Check repo status
git add <file>         # Stage file
git add .              # Stage all changes
git commit -m "msg"    # Commit staged changes
git log --oneline      # View commit history
git diff               # Show unstaged changes
git diff --staged      # Show staged changes
```


### **Branching (branch, checkout, switch)**
```
git branch                  # List branches
git branch <name>           # Create branch
git checkout <branch>       # Switch branch (old way)
git switch <branch>         # Switch branch (new way)
git switch -c <branch>      # Create & switch
git merge <branch>          # Merge branch into current
```
### **Remote (push, pull, fetch, clone, fork)**
```
git clone <repo-url>             # Copy remote repo
git remote -v                   # List remotes
git push origin <branch>        # Push branch to remote
git pull origin <branch>        # Fetch + merge
git fetch origin                # Fetch only
```
### **Merging & Rebasing**
```
git merge <branch>              # Merge branch into current
git rebase <branch>             # Rebase current branch onto another
git rebase -i HEAD~3            # Interactive rebase (edit last 3 commits)
```
**Use cases:**

- `merge`  → preserve history
- `rebase`  → clean linear history
### **Stash & Cherry Pick**
```
git stash                       # Save local changes
git stash list                  # View stashes
git stash pop                   # Apply & remove stash
git stash apply                 # Apply stash (keep it)
git cherry-pick <commit-hash>   # Apply a specific commit to current branch
```
### **Reset & Revert**
```
git reset --soft HEAD~1         # Undo commit, keep staged changes
git reset --mixed HEAD~1        # Undo commit, keep unstaged changes
git reset --hard HEAD~1         # Undo commit, delete changes (DANGEROUS)

git revert <commit-hash>        # Create new commit that undoes a commit
```
**Notes:**

- `reset`  rewrites history (don’t use on pushed commits)
- `revert`  is safe for shared branches
## Quick Tips
```
git log --graph --oneline --all   # Pretty branch viewgit reflog                       # Recover lost commitsgit restore <file>               # Discard changes in a filegit restore --staged <file>      # Unstage a file
```
---

## Safety Rules
- Avoid `git reset --hard`  unless you’re sure
- Don’t reset pushed commits on shared branches
- Use `git revert`  for undoing pushed commits
- `git reflog`  is your safety net — it shows everything Git has done, even after a hard reset
- For branching strategies, look at how projects like Kubernetes, React, or Linux kernel manage branches


