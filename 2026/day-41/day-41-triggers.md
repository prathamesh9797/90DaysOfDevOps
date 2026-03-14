# Day 41 – Triggers & Matrix Builds

### Task 1: Trigger on Pull Request
1. Create `.github/workflows/pr-check.yml` 
2. Trigger it only when a pull request is **opened or updated** against `main` 
3. Add a step that prints: `PR check running for branch: <branch name>` 
4. Create a new branch, push a commit, and open a PR
5. Watch the workflow run automatically
**Verify:** Does it show up on the PR page? >> Yes

![Screenshot from 2026-03-14 01-09-27.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2001-09-27_OlSCbvsw1T_lCpH1lpuVU.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 01-09-27.png")

![Screenshot from 2026-03-14 01-09-08.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2001-09-08_lTfANNzFY2-4IgtQGC1wc.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 01-09-08.png")



![Screenshot from 2026-03-14 01-08-28.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2001-08-28_DzXmL-77sq079lG8x8zgi.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 01-08-28.png")

```
name: PR check
on:
    pull_request:
        branches:
            - main
        types: [opened, synchronize]
jobs:
    pr-check:
        runs-on: ubuntu-latest
        steps:
           - name: Print PR branch name 
             run: 'echo "PR check running for branch: ${{ github.head_ref }}"'
```
---

### Task 2: Scheduled Trigger
1. Add a `schedule:`  trigger to any workflow using cron syntax
2. Set it to run every day at midnight UTC
3. Write in your notes: What is the cron expression for every Monday at 9 AM?
>>  cron: "0 9 * * 1"

0 0 * * *
│ │ │ │ │
│ │ │ │ └── day of week
│ │ │ └──── month
│ │ └────── day of month
│ └──────── hour
└────────── minute



![Screenshot from 2026-03-14 01-46-08.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2001-46-08_PHVJk4ENGmmOZ-eQ1BF3f.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 01-46-08.png")

---

### Task 3: Manual Trigger
1. Create `.github/workflows/manual.yml`  with a `workflow_dispatch:`  trigger
2. Add an **input** that asks for an `environment`  name (staging/production)
3. Print the input value in a step
4. Go to the **Actions** tab → find the workflow → click **Run workflow**
**Verify:** Can you trigger it manually and see your input printed?

>> yes 

```
Run echo "Environment selected: staging"
Environment selected: staging
```
![Screenshot from 2026-03-14 02-00-20.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2002-00-20_qimPF5LwAmge1CtMNagOp.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 02-00-20.png")

---

### Task 4: Matrix Builds
Create `.github/workflows/matrix.yml` that:

1. Uses a matrix strategy to run the same job across:
    - Python versions: `3.10` , `3.11` , `3.12` 

2. Each job installs Python and prints the version
3. Watch all 3 run in parallel
Then extend the matrix to also include 2 operating systems — how many total jobs run now?

![Screenshot from 2026-03-14 09-14-29.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-14-29_UmNbap2FgY4889xO7cdwa.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-14-29.png")

![Screenshot from 2026-03-14 09-14-20.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-14-20_Rg2RhHzx2nRu7iO4OLnVa.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-14-20.png")



![Screenshot from 2026-03-14 09-14-43.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-14-43_Jc4Fk0raZhYx8Q2UO_ypD.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-14-43.png")



Then extend the matrix to also include 2 operating systems — how many total jobs run now?

3 os * 5 python versions = 15 jobs run now

![Screenshot from 2026-03-14 09-26-26.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-26-26_o6noyIdWgJN4jLb15qDpg.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-26-26.png")

![Screenshot from 2026-03-14 09-26-35.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-26-35_iR2hxzFoU5w2t07sIeQWf.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-26-35.png")

---

### Task 5: Exclude & Fail-Fast
1. In your matrix, **exclude** one specific combination (e.g., Python 3.10 on Windows)
excluded windows 3.10

![Screenshot from 2026-03-14 09-38-55.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-38-55_jsjRDwJnpjqM9zaqmr0Em.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-38-55.png")



Set `fail-fast: false`  — trigger a failure in one job and observe what happens to the rest

**fail-fast: true (default)**
 If one matrix job fails, GitHub cancels all other matrix jobs.

**fail-fast: false**
 If one job fails, the remaining matrix jobs continue running.

![Screenshot from 2026-03-14 09-47-10.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-47-10_9tKY7NMuZgTt2mK0_9aVL.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-47-10.png")

![Screenshot from 2026-03-14 09-49-34.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2009-49-34_9rXBTwWVwrS0hWbDO3WBP.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 09-49-34.png")



### `fail-fast: true` (default)
If **any job in the matrix fails**, GitHub Actions **stops and cancels the remaining matrix jobs** that are still running or waiting.

Purpose:

- Saves **CI time and compute resources**
- Stops early when there is already a failure
Example:

```
Job 1 → Failed ❌
Job 2 → Cancelled ⛔
Job 3 → Cancelled ⛔
```
### `fail-fast: false`
If **one matrix job fails**, the **other matrix jobs continue running until completion**.

Purpose:

- Allows you to **see results for all environments**
- Useful when testing across multiple **OS, Python versions, Node versions, etc.**
Example:

```
Job 1 → Failed ❌
Job 2 → Success ✔
Job 3 → Success ✔
Job 4 → Failed ❌
```
All jobs finish even if some fail.

**Short summary for interviews or notes**

- **fail-fast: true** → stop remaining matrix jobs when one fails
- **fail-fast: false** → continue running all matrix jobs even if one fails




