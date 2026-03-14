# Day 43 – Jobs, Steps, Env Vars & Conditionals

### Task 1: Multi-Job Workflow
Create `.github/workflows/multi-job.yml` with 3 jobs:

- `build`  — prints "Building the app"
- `test`  — prints "Running tests"
- `deploy`  — prints "Deploying"
Make `test` run only **after** `build` succeeds. Make `deploy` run only **after** `test` succeeds.

**Verify:** Check the workflow graph in the Actions tab — does it show the dependency chain?

>> yes

![Screenshot from 2026-03-14 18-04-21.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-04-21_482o09Ok2X8nCaIAKFajh.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-04-21.png")

---

### Task 2: Environment Variables
In a new workflow, use environment variables at 3 levels:

1. **Workflow level** — `APP_NAME: myapp` 
2. **Job level** — `ENVIRONMENT: staging` 
3. **Step level** — `VERSION: 1.0.0` 
Print all three in a single step and verify each is accessible.

Then use a **GitHub context variable** — print the commit SHA and the actor (who triggered the run).

![Screenshot from 2026-03-14 18-13-21.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-13-21_Tmi9ZlrbDAfwrGzOuwd8K.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-13-21.png")

---

### Task 3: Job Outputs
1. Create a job that **sets an output** — e.g., today's date as a string
2. Create a second job that **reads that output** and prints it
3. Pass the value using `outputs:`  and `needs.<job>.outputs.<name>` 
Write in your notes: Why would you pass outputs between jobs?



### Share generated data
Example:

- Build job creates **Docker image tag**
- Deploy job uses that **same tag**
```
build → image_tag=1.2.3
deploy → uses image_tag
```
### Pass build artifacts metadata
Example:

```
build job → calculates version number
test job → tests that version
deploy job → deploys that version
```
###  Avoid recomputing values
Instead of recalculating:

```
date
commit hash
version
artifact path
```
You compute **once** and pass it forward.

###  Coordinate pipeline logic
Example:

```
job1 → determine environment (dev/staging/prod)
job2 → deploy to chosen environment
```
![Screenshot from 2026-03-14 18-37-52.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-37-52_PRLUubRry-Lho7lQOYdwz.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-37-52.png")

![Screenshot from 2026-03-14 18-37-43.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-37-43_aJlMmZJUKZhaVxHGWWkL0.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-37-43.png")



![Screenshot from 2026-03-14 18-38-05.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-38-05__cZkFXG6RzfeQelDQV8dh.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-38-05.png")

---

### Task 4: Conditionals
In a workflow, add:

1. A step that only runs when the branch is `main` 
2. A step that only runs when the previous step **failed**
3. A job that only runs on **push** events, not on pull requests
4. A step with `continue-on-error: true`  — what does this do?
>>> A step with `**continue-on-error: true**` tells GitHub Actions:

**If this step fails, do NOT stop the job — continue running the remaining steps.**

Normally, when a step fails, the job stops immediately.



![Screenshot from 2026-03-14 18-44-12.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-44-12_0rGCGIj_xi2-O1Wmg0c7d.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-44-12.png")

---

### Task 5: Putting It Together
Create `.github/workflows/smart-pipeline.yml` that:

1. Triggers on push to any branch
2. Has a `lint`  job and a `test`  job running in parallel
3. Has a `summary`  job that runs after both, prints whether it's a `main`  branch push or a feature branch push, and prints the commit message


![Screenshot from 2026-03-14 18-51-41.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-51-41_Zs3RlQaACUZ06KSlIYbyn.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-51-41.png")



![Screenshot from 2026-03-14 18-51-22.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2018-51-22_kJsb1CHNNZK1NgjvAOfGJ.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 18-51-22.png")



