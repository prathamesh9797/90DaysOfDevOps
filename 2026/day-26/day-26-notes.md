# Day 26 – GitHub CLI: Manage GitHub from Your Terminal

### Task 1: Install and Authenticate
### **Install the GitHub CLI on your machine**
>> On Ubuntu / Debian:

```
sudo apt update
sudo apt install gh
```
### **Authenticate with your GitHub account**
Run:

```
gh auth login
```
### **Verify you're logged in and check which account is active**
```
prathamesh@localhost:~$ gh auth login
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations on this host? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Paste an authentication token
Tip: you can generate a Personal Access Token here [﻿https://github.com/settings/tokens](https://github.com/settings/tokens)
The minimum required scopes are 'repo', 'read:org', 'workflow'.
? Paste your authentication token: ****************************************
gh config set -h github.com git_protocol https
✓ Configured git protocol
✓ Logged in as prathamesh9797
```
### **Answer in your notes: What authentication methods does **`**gh**`**  support?**
`gh` supports authentication via:

1. Browser-based OAuth login (recommended)
2. Personal Access Token (requires scopes: repo, read:org, workflow)
3. GitHub Enterprise authentication
---

### Task 2: Working with Repositories
### Create a new GitHub repo directly from the terminal — make it public with a README
```
prathamesh@localhost:~$ gh repo create devops-gh-test \
 --public 
--description "Test repo created using GitHub CLI" 
--clone 
--add-readme
✓ Created repository prathamesh9797/devops-gh-test on GitHub
 [﻿https://github.com/prathamesh9797/devops-gh-test](https://github.com/prathamesh9797/devops-gh-test)
Cloning into 'devops-gh-test'... 
```
### **Clone a repo using **`**gh**`**  instead of **`**git clone**`** **
```
gh repo clone <username>/<repo-name>
```
```
✓ Created repository prathamesh9797/devops-gh-test on GitHub
 [﻿https://github.com/prathamesh9797/devops-gh-test](https://github.com/prathamesh9797/devops-gh-test)
Cloning into 'devops-gh-test'... 
```
### **View details of one of your repos from the terminal**
```
gh repo view devops-gh-test
```
```
prathamesh@localhost:~$ gh repo view devops-gh-test
prathamesh9797/devops-gh-test
Test repo created using GitHub CLI


   devops-gh-test                                                                                                   
                                                                                                                    
  Test repo created using GitHub CLI                                                                                



View this repository on GitHub: https://github.com/prathamesh9797/devops-gh-test
```


### **List all your repositories**
```
gh repo list
```
```
prathamesh@localhost:~$ gh repo list

Showing 7 of 7 repositories in @prathamesh9797

NAME                                DESCRIPTION                                     INFO          UPDATED             
prathamesh9797/devops-gh-test       Test repo created using GitHub CLI              public        about 7 minutes ago
prathamesh9797/90DaysOfDevOps       This repository is a Challenge for the DevO...  public, fork  about 45 minutes ago
prathamesh9797/devops-git-practice  This repo is created to practice between lo...  public        about 2 days ago
prathamesh9797/devops-nginx-demo    this is a demo for nginx                        public        about 2 days ago
prathamesh9797/shell-scripts        A curated collection of shell scripting not...  public        about 4 days ago
prathamesh9797/python_practice      Python related work code, projects, blogs, ...  public        about 23 days ago
prathamesh9797/python-for-devops    Python For DevOps [AI Edition] is a hands-o...  public, fork  about 1 month ago
```
### **Open a repo in your browser directly from the terminal**
```
gh repo view devops-gh-test --web
```
```
gh repo view <repo name > --web
```
```
prathamesh@localhost:$ gh repo view devops-gh-test --web
Opening github.com/prathamesh9797/devops-gh-test in your browser.
prathamesh@localhost:$ Opening in existing browser session.
```
![Screenshot from 2026-02-27 00-35-50.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-27%2000-35-50_YRtEqPeUeGUc4CLiVevt8.png?ixlib=js-3.8.0 "Screenshot from 2026-02-27 00-35-50.png")



### **Delete the test repo you created (be careful!)**
```
gh repo delete <repo name>
gh auth refresh -h github.com -s delete_repo
```
```
prathamesh@localhost:~$ gh repo delete devops-gh-test
X Sorry, your reply was invalid: You entered yes
? Type prathamesh9797/devops-gh-test to confirm deletion: prathamesh9797/devops-gh-test
HTTP 403: Must have admin rights to Repository. (https://api.github.com/repos/prathamesh9797/devops-gh-test)
This API operation needs the "delete_repo" scope. To request it, run:  gh auth refresh -h github.com -s delete_repo
prathamesh@localhost:~$ gh auth refresh -h github.com -s delete_repo

! First copy your one-time code: 2BA9-D65D
Press Enter to open github.com in your browser... 
Opening in existing browser session.
✓ Authentication complete.
prathamesh@localhost:~$ gh repo delete devops-gh-test
? Type prathamesh9797/devops-gh-test to confirm deletion: prathamesh9797/devops-gh-test
✓ Deleted repository prathamesh9797/devops-gh-test
```
---

# Task 3: Issues
### **Create an issue on one of your repos from the terminal — give it a title, body, and a label**
```
prathamesh@localhost:$ gh repo create gh-issues-practice 
 --public 
 --add-readme 
 --clone
✓ Created repository prathamesh9797/gh-issues-practice on GitHub
 [﻿https://github.com/prathamesh9797/gh-issues-practice](https://github.com/prathamesh9797/gh-issues-practice)
Cloning into 'gh-issues-practice'...
prathamesh@localhost:$ cd gh-issues-practice
prathamesh@localhost:~/gh-issues-practice$ 

prathamesh@localhost:~$ gh repo create gh-issues-practice \
  --public \
  --add-readme \
  --clone
✓ Created repository prathamesh9797/gh-issues-practice on GitHub
  https://github.com/prathamesh9797/gh-issues-practice
Cloning into 'gh-issues-practice'...

prathamesh@localhost:~$ cd gh-issues-practice
prathamesh@localhost:~/gh-issues-practice$ gh issue create \
  --title "CLI Practice Issue" \
  --body "This issue was created from the terminal using GitHub CLI." \
  --label "bug"

Creating issue in prathamesh9797/gh-issues-practice

https://github.com/prathamesh9797/gh-issues-practice/issues/1
```
### **List all open issues on that repo**
```
gh issue list
```
```
prathamesh@localhost:~/gh-issues-practice$ gh issue list

Showing 1 of 1 open issue in prathamesh9797/gh-issues-practice

ID  TITLE               LABELS  UPDATED           
#1  CLI Practice Issue  bug     about 1 minute ago
```
### **View a specific issue by its number**
```
gh issue view 1 --web
```
```
prathamesh@localhost:/gh-issues-practice$ gh issue view 1 --web
Opening github.com/prathamesh9797/gh-issues-practice/issues/1 in your browser.
prathamesh@localhost:/gh-issues-practice$ Opening in existing browser session.
```
![Screenshot from 2026-02-27 00-51-48.png](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-02-27%2000-51-48_3lNvXnFoymDg2_eD16vU0.png?ixlib=js-3.8.0 "Screenshot from 2026-02-27 00-51-48.png")

### **Close an issue from the terminal**
```
gh issue close 1 --comment "Closing issue after CLI testing."
```
```
prathamesh@localhost:~/gh-issues-practice$ gh issue close 1 --comment "Closing issue after CLI testing."
✓ Closed issue #1 (CLI Practice Issue)
prathamesh@localhost:~/gh-issues-practice$
```
### **Answer in your notes: How could you use **`**gh issue**`**  in a script or automation?**
>>`gh issue` can be used in automation to:

- Automatically create issues when CI/CD builds fail
- Create bug reports from monitoring systems
- Auto-label issues based on error keywords
- Assign issues to team members automatically
- Close issues after successful deployments
- Generate automated weekly issue reports
### Example Automation Script
```
if ! ./run-tests.sh; then  gh issue create \    --title "Build Failed" \    --body "Automated test failure detected." \    --label "bug"fi
```
---

# **Task 4: Pull Requests**
### Create a branch, make a change, push it, and create a **pull request** entirely from the terminal
### Create a new branch:
```
git switch -c feature/readme-update
```
### Make a change:
```
echo "Updated via PR from CLI" >> README.md
```
### Commit it:
```
git add .git commit -m "Update README from feature branch"
```
### Push branch to GitHub:
```
git push -u origin feature/readme-update
```
```
prathamesh@localhost:~/gh-issues-practice$ git switch -c feature/readme-update
Switched to a new branch 'feature/readme-update'
prathamesh@localhost:~/gh-issues-practice$ echo "Updated via PR from CLI" >> README.md
prathamesh@localhost:~/gh-issues-practice$ git add .
prathamesh@localhost:~/gh-issues-practice$ git commit -m "Update README from feature branch"
[feature/readme-update 9961a78] Update README from feature branch
 1 file changed, 1 insertion(+), 1 deletion(-)
prathamesh@localhost:~/gh-issues-practice$ git push -u origin feature/readme-update
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Writing objects: 100% (3/3), 309 bytes | 309.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: 
remote: Create a pull request for 'feature/readme-update' on GitHub by visiting:
remote:      https://github.com/prathamesh9797/gh-issues-practice/pull/new/feature/readme-update
remote: 
To https://github.com/prathamesh9797/gh-issues-practice.git
 * [new branch]      feature/readme-update -> feature/readme-update
branch 'feature/readme-update' set up to track 'origin/feature/readme-update'.
```
# Create a Pull Request from Terminal
```
gh pr create \  --title "Update README via CLI PR" \  --body "This PR updates README as part of GitHub CLI practice." \  --base main \  --head feature/readme-update
```
If prompted, choose:

- “Create pull request”
- Not draft (unless you want draft)
```
prathamesh@localhost:~/gh-issues-practice$ gh pr create \
  --title "Update README via CLI PR" \
  --body "This PR updates README as part of GitHub CLI practice." \
  --base main \
  --head feature/readme-update

Creating pull request for feature/readme-update into main in prathamesh9797/gh-issues-practice

https://github.com/prathamesh9797/gh-issues-practice/pull/2
prathamesh@localhost:~/gh-issues-practice$
```
### **List all open PRs on a repo**
```
gh pr list
```
```
prathamesh@localhost:~/gh-issues-practice$ gh pr list

Showing 1 of 1 open pull request in prathamesh9797/gh-issues-practice

ID  TITLE                     BRANCH                 CREATED AT        
#2  Update README via CLI PR  feature/readme-update  about 1 minute ago
```
### **View the details of your PR — check its status, reviewers, and checks**
If PR number is `1`:

```
gh pr view 1
```
To see checks, reviewers, status:

```
gh pr view 1 --web
```
Or in terminal with more detail:

```
gh pr view 1 --comments
```
```
prathamesh@localhost:~/gh-issues-practice$ gh pr list

Showing 1 of 1 open pull request in prathamesh9797/gh-issues-practice

ID  TITLE                     BRANCH                 CREATED AT         
#2  Update README via CLI PR  feature/readme-update  about 3 minutes ago
prathamesh@localhost:~/gh-issues-practice$ gh pr view 2
GraphQL: Projects (classic) is being deprecated in favor of the new Projects experience, see: https://github.blog/changelog/2024-05-23-sunset-notice-projects-classic/. (repository.pullRequest.projectCards)
```


### **Merge your PR from the terminal**
```
gh pr merge 2 --merge
```
```
prathamesh@localhost:~/gh-issues-practice$ gh pr merge 2 --merge
✓ Merged pull request #2 (Update README via CLI PR)
```
## **Answer in your notes:**
## **What merge methods does **`**gh pr merge**`**  support?**
>>`--merge` → Create a merge commit

`--squash`  → Squash all commits into one

`--rebase`  → Rebase and merge

## **How would you review someone else's PR using **`**gh**`** ?**
>>You can:

List PRs:

```
gh pr list
```
Checkout PR locally:

```
gh pr checkout <number>
```
View details:

```
gh pr view <number>
```
Approve:

```
gh pr review <number> --approve
```
---

## **Task 5: GitHub Actions & Workflows (Preview)**
### **List the workflow runs on any public repo that uses GitHub Actions**
```
>>gh run list --repo cli/cli
```
This shows:

- Run ID
- Workflow name
- Branch
- Status (completed, in_progress, failed, etc.)
- Conclusion (success, failure)
- Example output
```
completed success CI main 1234567890
completed failure Go main 1234567888
```
### **View the status of a specific workflow run**
>>Take the **Run ID** from the list (example: `1234567890`):

```
gh run view 1234567890 --repo cli/cli
```
To see logs:

```
gh run view 1234567890 --log --repo cli/cli
```
To open in browser:

```
gh run view 1234567890 --web --repo cli/cli
```
### **Answer in your notes: How could **`**gh run**`**  and **`**gh workflow**`**  be useful in a CI/CD pipeline?**
>>How could `gh run` and `gh workflow` be useful in a CI/CD pipeline?

`gh run` and `gh workflow` allow you to manage and monitor GitHub Actions directly from the terminal.

They can be useful in CI/CD pipelines to:

- Monitor build and deployment status without opening GitHub
- Automatically check if the latest workflow run succeeded
- Fetch logs when a build fails
- Trigger workflows manually
- Integrate workflow checks into automation scripts
- Fail a deployment script if the previous workflow failed
---

## **Task 6: Useful **`**gh**`** Tricks**
## **Explore and try these — add the ones you find useful to your **`**git-commands.md**`**:**
## ****`**gh api**`**  — make raw GitHub API calls from the terminal**
Allows you to directly call the GitHub REST API from the terminal.

### 🔹 Example: Get Your User Info
```
gh api user
```
## `**gh gist**`**  — create and manage GitHub Gists**
### Create a Gist
```
echo "Hello from CLI Gist" > test.txtgh gist create test.txt --public
```
## `**gh release**`**  — create and manage releases**
1. `gh alias`  — create shortcuts for commands you use often
2. `gh search repos`  — search GitHub repos from the terminal
With these commands, you can:

- Trigger releases
- Query GitHub programmatically
- Automate workflows
- Build custom CLI dashboards
- Manage open-source from terminal
- Integrate GitHub deeply into CI/CD


