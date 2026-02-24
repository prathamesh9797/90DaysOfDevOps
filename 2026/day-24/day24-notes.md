# Day 24 – Advanced Git: Merge, Rebase, Stash & Cherry Pick

### Task 1: Git Merge — Hands-On
## **Create a new branch **`**feature-login**`**  from **`**main**`** , add a couple of commits to it**
>>  

![Screenshot from 2026-02-24 22-48-27.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2022-48-27_H70oOtM0kQil7EFZFte4G.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 22-48-27.png")



## **Switch back to **`**main**`**  and merge **`**feature-login**`**  into **`**main**`** **
>> 

![Screenshot from 2026-02-24 22-52-15.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2022-52-15_-4F-0kh2wjb4cGaabAf8_.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 22-52-15.png")



## Observe the merge — did Git do a fast-forward merge or a merge commit?
>> Git did a Fast-forward merge

## **Now create another branch **`**feature-signup**`** , add commits to it — but also add a commit to **`**main**`**  before merging**
>> 

![Screenshot from 2026-02-24 22-59-11.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-24%2022-59-11_-cBPzxVjfWqUV2Eg0yJ8p.png?ixlib=js-3.8.0 "Screenshot from 2026-02-24 22-59-11.png")



## **Merge **`**feature-signup**`**  into **`**main**`**  — what happens this time?**
>> Got a Conflict message and Automatic merge failed, merge conflict in git-notes.md

```
prathamesh@localhost:~/devops-git-practice$ git branch
  feature-1
  feature-login
  feature-signup
* master
prathamesh@localhost:~/devops-git-practice$ git merge feature-signup
Auto-merging git-notes.md
CONFLICT (content): Merge conflict in git-notes.md
Automatic merge failed; fix conflicts and then commit the result.
```
## **Answer in your notes:**
## **What is a fast-forward merge?**
>> A fast-forward merge happens when the current branch has no new commits since the feature branch was created. Git simply moves the branch pointer forward without creating a merge commit.

## **When does Git create a merge commit instead?**
>> Git creates a merge commit when both branches have diverged (both have new commits). If changes do not conflict, Git automatically combines them and creates a merge commit with two parents.

## **What is a merge conflict? (try creating one intentionally by editing the same line in both branches)**
>>A merge conflict happens when Git cannot automatically merge changes because the same lines in the same file were changed differently in both branches. The developer must manually resolve the conflict, then commit the result.

---

## **Task 2: Git Rebase — Hands-On**
## **Create a branch **`**feature-dashboard**`**  from **`**main**`** , add 2-3 commits**
```
>> prathamesh@localhost:~/devops-git-practice$ git branch
  feature-1
  feature-login
  feature-signup
* master
prathamesh@localhost:~/devops-git-practice$ git branch feature-dashboard
prathamesh@localhost:~/devops-git-practice$ git switch feature-dashboard
Switched to branch 'feature-dashboard'
prathamesh@localhost:~/devops-git-practice$ l
git-commands.md  git-notes.md
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "git-notes.md file updated"
[feature-dashboard e4d0154] git-notes.md file updated
 1 file changed, 2 insertions(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "git-notes.md updated for dashboard"
[feature-dashboard c580c20] git-notes.md updated for dashboard
 1 file changed, 2 insertions(+), 1 deletion(-)
```
## **While on **`**main**`** , add a new commit (so **`**main**`**  moves ahead)**
```
>> prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "git-notes.md updated from master"
[master c0ab33d] git-notes.md updated from master
 1 file changed, 2 insertions(+)
```
## **Switch to **`**feature-dashboard**`**  and rebase it onto **`**main**`** **
>> Conflict Occured as below

```
prathamesh@localhost:~/devops-git-practice$ git switch feature-dashboard
Switched to branch 'feature-dashboard'
prathamesh@localhost:~/devops-git-practice$ git rebase master
Auto-merging git-notes.md
CONFLICT (content): Merge conflict in git-notes.md
error: could not apply e4d0154... git-notes.md file updated
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply e4d0154... git-notes.md file updated
```
#### CONFLICT RESOLUTION
```
prathamesh@localhost:~/devops-git-practice$ git rebase --continue
git-notes.md: needs merge
You must edit all merge conflicts and then
mark them as resolved using git add
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git rebase --continue
[detached HEAD 8bc08aa] git-notes.md updated for dashboard
 1 file changed, 6 insertions(+), 3 deletions(-)
Successfully rebased and updated refs/heads/feature-dashboard.
```
## **Observe your **`**git log --oneline --graph --all**`**  — how does the history look compared to a merge?**
```
>>   prathamesh@localhost:~/devops-git-practice$ git log --oneline --graph --all
8bc08aa (HEAD -> feature-dashboard) git-notes.md updated for dashboard
06ffed2 git-notes.md file updated
c0ab33d (master) git-notes.md updated from master
c9b9465 Merge branch 'feature-signup'
|\
| * 5b8189b (feature-signup) signup updated
| d4615a5 git-notes.md updated uner master branch
|/ 
954f94d (feature-login) git notes updated
126a8f7 git notes added
0c04004 (origin/master) Update git-commands.md
| * e75d010 (origin/feature-1, feature-1) git-commands.md updated
|/ 
dd00f51 Added git push pull merge commands
4064aa6 Added branching commands
0b8493f Add git commands reference
```
This proves your rebase worked

- `feature-dashboard`  is now **directly on top of **`**master**` 
- Your commits:
    - `06ffed2` 
    - `8bc08aa` 

- They come **after**:
    - `c0ab33d (master)` 

This is exactly what a rebase is supposed to do:
_ linear history, no merge commit ,, your work replayed on top of master._

## Answer in your notes:
## What does rebase actually do to your commits?
>> Rebase takes the commits from a feature branch and reapplies them one by one on top of the latest commit of the target branch. This rewrites history and creates new commit hashes. Conflicts may need to be resolved for each commit.

## How is the history different from a merge?
>>  **Merge** keeps the original branch structure and creates a merge commit.

**Rebase** creates a clean, linear history with no merge commits and no visible branching.

## Why should you **never rebase commits that have been pushed and shared** with others?
>> Because rebase rewrites commit history and changes commit hashes. If others have already pulled those commits, rebasing will break their history and cause confusing conflicts when they try to sync.

## When would you use rebase vs merge?
>>**Use rebase when:**

- Working on your own local feature branch
- Cleaning up commits before opening a PR
- Keeping a linear project history
**Use merge when:**

- The branch is shared with others
- You want to preserve how work actually happened
- Merging into `main`  in team workflows
---

### Task 3: Squash Commit vs Merge Commit
1. Create a branch `feature-profile` , add 4-5 small commits (typo fix, formatting, etc.)
```
>> prathamesh@localhost:~/devops-git-practice$ git branch
  feature-1
* feature-dashboard
  feature-login
  feature-signup
  master
prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
prathamesh@localhost:~/devops-git-practice$ git branch feature-profile
prathamesh@localhost:~/devops-git-practice$ git switch feature-profile
Switched to branch 'feature-profile'
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "updated git-notes.md"
[feature-profile 0cdfbe7] updated git-notes.md
 1 file changed, 4 insertions(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "added few lines to git-notes"
[feature-profile 3b33929] added few lines to git-notes
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "again did few changes"
[feature-profile 05d5403] again did few changes
 1 file changed, 2 insertions(+)
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "fianl changes done"
[feature-profile 09fe448] fianl changes done
 1 file changed, 1 insertion(+), 1 deletion(-)
prathamesh@localhost:~/devops-git-practice$ 
```
1. Merge it into `main`  using `--squash`  — what happens?
```
>> prathamesh@localhost:~/devops-git-practice$ git branch
  feature-1
  feature-dashboard
  feature-login
  feature-profile
  feature-signup
* master
prathamesh@localhost:~/devops-git-practice$ git merge --squash feature-profile
Updating c0ab33d..09fe448
Fast-forward
Squash commit -- not updating HEAD
 git-notes.md | 7 +++++++
 1 file changed, 7 insertions(+)
 
 
Key line:
Squash commit -- not updating HEAD
This means:
Git has taken all changes from feature-profile
Combined them into one staged change
But it has NOT created a commit yet
This is expected behavior for --squash.
```
## Check `git log`   — how many commits were added to `main`  ?
```
prathamesh@localhost:~/devops-git-practice$ git commit -m "Add profile feature (squashed)"
[master b667b89] Add profile feature (squashed)
 1 file changed, 7 insertions(+)
prathamesh@localhost:~/devops-git-practice$ git log
commit b667b894f71b07ce6d9e57a45431c675c99690ff (HEAD -> master)
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:00:48 2026 +0530

    Add profile feature (squashed)
    
The squash merge worked
Only ONE commit was added to master
None of the tiny feature-profile commits appear on master
Your history is clean and readable    
 
```
# **Now create another branch **`**feature-settings**`** , add a few commits**
# Merge it into `main`  without `--squash`  (regular merge) — compare the history
```
>>  prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m " final changes done to file 4"
[feature-setting 4a03bba]  final changes done to file 4
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
prathamesh@localhost:~/devops-git-practice$ git merge feature-setting
Updating b667b89..4a03bba
Fast-forward
 git-notes.md | 7 +++++++
 1 file changed, 7 insertions(+)
prathamesh@localhost:~/devops-git-practice$ git log
commit 4a03bbace77980223063e48231d51b7a5f0e05bf (HEAD -> master, feature-setting)
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:12:36 2026 +0530

     final changes done to file 4

commit 096f8aeb563cebef7242619a6be8e89b5af347d2
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:11:42 2026 +0530

    add line 3

commit bb9b0fc5c6dd5c16089191f8e01a19696f84085d
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:10:38 2026 +0530

    add line 2

commit 8998eee97ff59597342d964b2dfd60ddd91be7cc
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:09:57 2026 +0530

    added under git-notes.md

commit b667b894f71b07ce6d9e57a45431c675c99690ff
Author: prathamesh <prathameshjoshi321@gmail.com>
Date:   Wed Feb 25 00:00:48 2026 +0530

    Add profile feature (squashed)

commit c0ab33d42127eb9c24d90edf62b5cad66e2c2544
```
## Compare the history (Squash vs Regular Merge)
### 🔹 Squash merge (`feature-profile` → `main`)
```
* b667b89 Add profile feature (squashed)
```
- Only **1 commit** added to `main` 
- ❌ No small commits visible
- Clean, compact history
### 🔹 Regular merge (`feature-settings` → `main`)
```
* 4a03bba final changes done to file 4* 096f8ae add line 3* bb9b0fc add line 2* 8998eee added under git-notes.md
```
- **All commits preserved**
- Shows how the feature evolved
- History is more detailed (and messier)


# **Answer in your notes:**
# **What does squash merging do?**
>>Squash merging combines all commits from a feature branch into a single commit on the target branch. Only one commit is added to `main`, and the individual commits from the feature branch do not appear in `main`’s history.

# **When would you use squash merge vs regular merge?**
>>**Use squash merge when:**

- The feature branch has many small or messy commits (typos, formatting, WIP)
- You want a clean, readable `main`  branch history
- You prefer one commit per feature/PR
- The intermediate commits don’t add much value
**Use regular merge when:**

- Each commit is meaningful and well-structured
- You want to preserve how the feature evolved
- Debugging and traceability matter
- Multiple developers worked on the branch and commit history is important
# **What is the trade-off of squashing?**
**Pros:**

- Clean and simple history on `main` 
- Easier to revert a whole feature
- Keeps the main branch readable
**Cons (Trade-off):**

- You lose detailed commit history
- Harder to trace how the feature evolved
- `git blame`  becomes less granular
- Context from intermediate commits is lost
---

## Task 4: Git Stash — Hands-On
## Start making changes to a file but **do not commit**
```
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git-notes.md

no changes added to commit (use "git add" and/or "git commit -a")
```
## **Now imagine you need to urgently switch to another branch — try switching. What happens?**
>> If changes don’t conflict → Git lets you switch (but your changes follow you)

If changes conflict with the target branch → ❌ Git blocks the switch
 You’ll see: “Your local changes would be overwritten…”

This is the “oh no, I need to park my work” moment.

```
>> prathamesh@localhost:~/devops-git-practice$ git switch feature-login
error: Your local changes to the following files would be overwritten by checkout:
	git-notes.md
Please commit your changes or stash them before you switch branches.
Aborting
```
1. Use `git stash`  to save your work-in-progress
```
>> prathamesh@localhost:~/devops-git-practice$ git stash push -m "WIP: notes update"
Saved working directory and index state On master: WIP: notes update
prathamesh@localhost:~/devops-git-practice$
```
## Switch to another branch, do some work, switch back
```
>> prathamesh@localhost:~/devops-git-practice$ git switch feature-login
Switched to branch 'feature-login'
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "urgent work updated"
[feature-login b09986e] urgent work updated
 1 file changed, 2 insertions(+)
prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
```
## **Try stashing multiple times and list all stashes**
>>

```
>> prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git stash push -m "WIP: change 1"
Saved working directory and index state On master: WIP: change 1
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git stash push -m "WIP: change 2"
Saved working directory and index state On master: WIP: change 2
prathamesh@localhost:~/devops-git-practice$ vim git-notes.md
prathamesh@localhost:~/devops-git-practice$ git stash push -m "WIP: change 3"
Saved working directory and index state On master: WIP: change 3
prathamesh@localhost:~/devops-git-practice$ git stash list
stash@{0}: On master: WIP: change 3
stash@{1}: On master: WIP: change 2
stash@{2}: On master: WIP: change 1
```
## **Try applying a specific stash from the list**
```
>> prathamesh@localhost:~/devops-git-practice$ git stash apply stash@{1}
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git-notes.md

no changes added to commit (use "git add" and/or "git commit -a")
```
## **Answer in your notes:**
## **What is the difference between **`**git stash pop**`**  and **`**git stash apply**`** ?**
>>>`**git stash pop**`
 Applies the latest stash to your working directory **and removes it** from the stash list.
 Use this when you’re sure you won’t need that stash again.

`**git stash apply**` 
 Applies a stash to your working directory **but keeps it** in the stash list.
 Use this when you might want to reuse the same stash later or apply it to multiple branches.

## When would you use stash in a real-world workflow?
>>You use `git stash` when:

- You’re in the middle of work and need to switch branches urgently
- Git won’t let you checkout another branch because of uncommitted changes
- You need to pull/rebase but your working tree isn’t clean
- You want to temporarily park messy “work in progress” changes
- You’re interrupted by a hotfix or urgent production issue
- You’re experimenting and don’t want to commit half-baked work yet
---

### Task 5: Cherry Picking
## Create a branch `feature-hotfix` , make 3 commits with different changes
```
prathamesh@localhost:~/devops-git-practice$ git switch feature-hotfix
Switched to branch 'feature-hotfix'
prathamesh@localhost:~/devops-git-practice$ echo "hotfix part 1" >> git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "hotfix step 1"
[feature-hotfix a8e07d0] hotfix step 1
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ echo "hotfix part 2" >> git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "hotfix step 2"
[feature-hotfix 8c10f32] hotfix step 2
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git-practice$ echo "hotfix part 3" >> git-notes.md
prathamesh@localhost:~/devops-git-practice$ git add .
prathamesh@localhost:~/devops-git-practice$ git commit -m "hotfix step 3"
[feature-hotfix 2bd8983] hotfix step 3
 1 file changed, 1 insertion(+)
prathamesh@localhost:~/devops-git
```
## **Switch to **`**main**`** **
```
>>prathamesh@localhost:~/devops-git-practice$ git switch master
Switched to branch 'master'
```
## Cherry-pick **only the second commit** from `feature-hotfix`  onto `main` 
```
.>> prathamesh@localhost:~/devops-git-practice$ git log --oneline --graph --all
fcc91d8 (HEAD -> master) hotfix step 2
a564ec1 added git-notes.md
| * 947b5e0 (feature-hotfix) hotfix step 3
| * 4c49b58 hotfix step 2
| * 318f8c7 hotfix step 1
| * 2bd8983 hotfix step 3
| * 8c10f32 hotfix step 2
| * a8e07d0 hotfix step 1
|/
| * 6b21638 (refs/stash) On master: WIP: change 3
|/|
| * 968089f index on master: 4a03bba final changes done to file 4
|/ 
4a03bba (feature-setting) final changes done to file 4
096f8ae add line 3
bb9b0fc add line 2
8998eee added under git-notes.md
b667b89 Add profile feature (squashed)
| * b09986e (feature-login) urgent work updated
| | * 09fe448 (feature-profile) fianl changes done
| | * 05d5403 again did few changes
| | * 3b33929 added few lines to git-notes
| | * 0cdfbe7 updated git-notes.md
| |/
|/|
| | * 8bc08aa (feature-dashboard) git-notes.md updated for dashboard
| | * 06ffed2 git-notes.md file updated
| |/
|/| 
| c0ab33d git-notes.md updated from master
| c9b9465 Merge branch 'feature-signup'
:
```
## Verify with `git log`  that only that one commit was applied
```
>>prathamesh@localhost:~/devops-git-practice$ git log --oneline --graph --all
fcc91d8 (HEAD -> master) hotfix step 2
a564ec1 added git-notes.md
| * 947b5e0 (feature-hotfix) hotfix step 3
| * 4c49b58 hotfix step 2
| * 318f8c7 hotfix step 1
| * 2bd8983 hotfix step 3
| * 8c10f32 hotfix step 2
| * a8e07d0 hotfix step 1
|/
```
## Answer in your notes:
## What does cherry-pick do?
>> `git cherry-pick` takes a specific commit from another branch and applies it onto the current branch as a new commit. Only the selected commit is copied; the rest of the branch is not merged.

## When would you use cherry-pick in a real project?
>> Use cherry-pick when:

- You need one specific bugfix on `main`  or a release branch
- You want to backport a fix to an older version
- A commit was made on the wrong branch and needs to be moved
- Only one safe change should go into production, not the entire feature branch
- You need to apply the same fix to multiple branches
## What can go wrong with cherry-picking?
>>**Common pitfalls:**

- Merge conflicts can occur (especially if the same file/lines changed)
- The same change gets duplicated with a new commit hash
- History can become confusing if cherry-pick is overused
- Cherry-picking commits that depend on earlier commits can break functionality
- Future merges may reintroduce conflicts because Git sees different commit IDs


