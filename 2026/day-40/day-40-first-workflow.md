# Day 40 – Your First GitHub Actions Workflow

### Task 1: Set Up
1. Create a new **public** GitHub repository called `github-actions-practice` 
2. Clone it locally
3. Create the folder structure: `.github/workflows/` 


![Screenshot from 2026-03-07 14-48-11.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-07%2014-48-11_fGh-BLb4Vv89seIt-XC0I.png?ixlib=js-3.8.0 "Screenshot from 2026-03-07 14-48-11.png")

---

### Task 2: Hello Workflow
Create `.github/workflows/hello.yml` with a workflow that:

1. Triggers on every `push` 
2. Has one job called `greet` 
3. Runs on `ubuntu-latest` 
4. Has two steps:
    - Step 1: Check out the code using `actions/checkout` 
    - Step 2: Print `Hello from GitHub Actions!` 

Push it. Go to the **Actions** tab on GitHub and watch it run.

**Verify:** Is it green? Click into the job and read every step.

yes it is green

![Screenshot from 2026-03-07 15-20-42.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-07%2015-20-42_pxOCQGGcfsXoI5oJBceYT.png?ixlib=js-3.8.0 "Screenshot from 2026-03-07 15-20-42.png")

---

### Task 3: Understand the Anatomy
Look at your workflow file and write in your notes what each key does:

## ** **`**on:**` 
**Definition:**
 Specifies the **event that triggers the workflow**.

Example:

```
on: push
```
Meaning:

- The workflow runs **every time code is pushed** to the repository.
Other common triggers:

- `pull_request` 
- `workflow_dispatch` 
- `schedule` 
# ****`**jobs:**`** **
**Definition:**
 Defines the **tasks that the workflow will execute**.

Example:

```
jobs:  greet:
```
Meaning:

- The workflow contains a **job named **`**greet**` .
Notes:

- A workflow can have **multiple jobs**.
- Jobs can run **in parallel or sequentially**.
# ****`**runs-on:**`** **
**Definition:**
 Specifies the **virtual machine (runner) where the job runs**.

Example:

```
runs-on: ubuntu-latest
```
Meaning:

- The job runs on a **GitHub-hosted Ubuntu Linux machine**.
Other options:

- `windows-latest` 
- `macos-latest` 
# ****`**steps:**`** **
**Definition:**
 A **sequence of actions or commands** executed inside a job.

Example:

```
steps:
```
Meaning:

- The job will execute steps **one by one in order**.
# ****`**uses:**`** **
**Definition:**
 Used to **run a pre-built GitHub Action created by someone else**.

Example:

```
uses: actions/checkout@v4
```
Meaning:

- Uses the **checkout action** to download repository code into the runner.
# ****`**run:**`** **
**Definition:**
 Executes a **shell command directly on the runner machine**.

Example:

```
run: echo "Hello from GitHub Actions!"
```
Meaning:

- Runs a command that prints a message in the workflow logs.
You can run multiple commands like:

```
run: |  echo "Hello"  ls
```
# `**name:**`** (on a step)**
**Definition:**
 Provides a **human-readable label for a step** in the workflow.

Example:

```
- name: Say Hello
```
Meaning:

- The step will appear in logs as **“Say Hello”**.
Purpose:

- Makes workflows **easier to read and debug**.
| Key | Purpose |
| ----- | ----- |
| `on`  | Defines the event that triggers the workflow |
| `jobs`  | Defines tasks to execute |
| `runs-on`  | Specifies the runner environment |
| `steps`  | Ordered list of actions or commands |
| `uses`  | Runs an external GitHub Action |
| `run`  | Executes shell commands |
| `name`  | Label for a workflow or step |
---

### Task 4: Add More Steps
Update `hello.yml` to also:

1. Print the current date and time
2. Print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
3. List the files in the repo
4. Print the runner's operating system
Push again — watch the new run.



![Screenshot from 2026-03-10 08-14-38.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-10%2008-14-38_X_WnYuq35QItVN6qkpW9l.png?ixlib=js-3.8.0 "Screenshot from 2026-03-10 08-14-38.png")

![Screenshot from 2026-03-10 08-15-06.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-10%2008-15-06_-xdJVKoPCqI13lecXZW8I.png?ixlib=js-3.8.0 "Screenshot from 2026-03-10 08-15-06.png")

---

### Task 5: Break It On Purpose
1. Add a step that runs a command that will **fail** (e.g., `exit 1`  or a misspelled command)
2. Push and observe what happens in the Actions tab
3. Fix it and push again
Write in your notes: What does a failed pipeline look like? How do you read the error?

![Screenshot from 2026-03-10 08-20-07.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-10%2008-20-07_vaLA2u8laCBjYwPrXR5GH.png?ixlib=js-3.8.0 "Screenshot from 2026-03-10 08-20-07.png")

![Screenshot from 2026-03-10 08-27-04.png](https://eraser.imgix.net/workspaces/iakQgzIPVHK2csJSiMUt/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-10%2008-27-04_EwrS_PpFZlDCox7JIl8Qt.png?ixlib=js-3.8.0 "Screenshot from 2026-03-10 08-27-04.png")

### What does a failed pipeline look like?
- The workflow run shows a **red ❌ status** in the GitHub Actions tab.
- The failed job is marked with a **red X**.
- Steps before the failure run normally, but **steps after the failure are skipped**.
### How to read the error
1. Open the failed workflow run.
2. Click the failed **job**.
3. Click the failed **step**.
4. Read the **log output**.
5. Look for:
    - error message
    - exit code
    - command that failed

Example error:

```
Error: Process completed with exit code 1
```
This means the command returned a **failure status**.



