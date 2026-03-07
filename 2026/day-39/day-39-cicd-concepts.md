# Day 39 – What is CI/CD?

### Task 1: The Problem
### **Think about a team of 5 developers all pushing code to the same repo manually deploying to production.**
### **Write in your notes:**
### **What can go wrong?**
>> Developers may **overwrite each other's changes**.

**Wrong code version** might get deployed.

**Human errors** during manual deployment.

**Missed steps** in the deployment process.

Difficult to **track who deployed what and when**.

Production can **break unexpectedly**.

### **What does "it works on my machine" mean and why is it a real problem?**
>> This happens because of differences like:

- Different **OS**
- Different **library versions**
- Missing **environment variables**
- Different **configurations**
 This is a real problem because **software should run consistently across environments**, not just on one developer's laptop.

### **How many times a day can a team safely deploy manually?**
>> Usually **very few times (1–2 times per day at most)**.

Manual deployments are:

- **Slow**
- **Risky**
- **Error-prone**
That’s why teams use **CI/CD pipelines and automation** to deploy **many times a day safely and reliably**.

---

### Task 2: CI vs CD
Research and write short definitions (2-3 lines each):

### **Continuous Integration** — what happens, how often, what it catches
Continuous Integration is the practice where developers **frequently merge code changes into a shared repository** (often multiple times a day). Each commit automatically triggers **builds and tests** to catch bugs early.

**What it catches:**

- Integration issues
- Build failures
- Unit test failures
**Example:**
 A developer pushes code to GitHub → **GitHub Actions/Jenkins automatically runs tests and builds the project**.

### **Continuous Delivery** — how it's different from CI, what "delivery" means
>>Continuous Delivery extends CI by ensuring the application is **always in a deployable state**. After automated tests pass, the code is **automatically prepared for release**, but deployment to production usually requires **manual approval**.

**What “delivery” means:**
 The software is **ready to be deployed anytime**.

**Example:**
 After CI tests pass, the pipeline **automatically deploys the application to a staging environment**, waiting for a manager or engineer to approve production release.

### **Continuous Deployment** — how it differs from Delivery, when teams use it
Continuous Deployment goes one step further than Continuous Delivery. **Every change that passes automated tests is automatically deployed to production** without manual approval.

**When teams use it:**
 Used by teams with **very strong automated testing and monitoring**.

**Example:**
 A developer pushes code → tests pass → **the application is automatically deployed to production servers**.

```
CI → Build & Test
CD (Delivery) → Ready to Deploy
CD (Deployment) → Automatically Deploy
```
---

### Task 3: Pipeline Anatomy
A pipeline has these parts — write what each one does:

### **Trigger** — what starts the pipeline
A **trigger** is the event that starts a pipeline automatically.

Common triggers:

- Code push to a repository
- Pull request creation
- Scheduled runs
**Example:**
 A developer pushes code to GitHub → the **CI/CD pipeline starts automatically**.

### **Stage** — a logical phase (build, test, deploy)
>>Common stages:

- Build
- Test
- Deploy
**Example:**
 A pipeline may have stages like **build → test → deploy**.

### **Job** — a unit of work inside a stage
>> A **job** is a specific task executed inside a stage.

Jobs run on a **runner** and contain multiple steps.

**Example:**
 A **build job** that compiles the application.

### **Step** — a single command or action inside a job
>> A **step** is a single command or action inside a job.

Steps are executed sequentially to complete the job.

**Example:**

```
run: npm install
run: npm test
run: npm build
```
Each command is a **step**.

### **Runner** — the machine that executes the job
>> A **runner** is the machine (server or VM) that executes the pipeline jobs.

It can be:

- Hosted by the CI platform
- Self-hosted by the team
**Example:**
 A **GitHub Actions runner** running jobs on an Ubuntu virtual machine.

### **Artifact** — output produced by a job
>> An **artifact** is a file or output produced by a job that can be used later in the pipeline.

Examples:

- Compiled binaries
- Docker images
- Test reports
**Example:**
 After the build stage, the pipeline saves a **compiled application file** as an artifact for the deploy stage.



### Simple  Pipeline Flow :-
```
Trigger → Stage → Job → Step → Artifact
 ↓
 Runner executes the job
```
---

### Task 4: Draw a Pipeline
Draw a CI/CD pipeline for this scenario:

> A developer pushes code to GitHub. The app is tested, built into a Docker image, and deployed to a staging server.

Include at least 3 stages. Hand-drawn and photographed is perfectly fine.

**Trigger**

- Developer pushes code to GitHub.
**Test Stage**

- CI pipeline runs automated tests.
- If tests fail → pipeline stops.
**Build Stage**

- Application is built.
- Docker image is created.
Example command:

```
docker build -t myapp:latest .
```
**Deploy Stage**

- Docker image is deployed to the **staging server**.
Example:

```
docker run -d -p 80:80 myapp:latest
```
![WhatsApp Image 2026-03-07 at 8.11.03 AM.jpeg](https://eraser.imgix.net/workspaces/IbttGkhddthBGGWsAQER/wT5AjlQjuoRNZa07dGqXHOM5M9s2/WhatsApp%20Image%202026-03-07%20at%208.11.03%20AM_GZCfw2ogE_WGUm1YQaofP.jpeg?ixlib=js-3.8.0 "WhatsApp Image 2026-03-07 at 8.11.03 AM.jpeg")

---

### Task 5: Explore in the Wild
1. Open any popular open-source repo on GitHub (Kubernetes, React, FastAPI — pick one you know)
2. Find their `.github/workflows/`  folder
3. Open one workflow YAML file
4. Write in your notes:
    - What triggers it?
    - How many jobs does it have?
    - What does it do? (best guess)

>>

**Repository chosen:** FastAPI
 It contains workflow files inside the `.github/workflows/` folder where automation pipelines are defined.

## What triggers it?
Most workflows are triggered by:

- **Push events** to the `main`  branch
- **Pull requests**
Example trigger in the YAML:

```
on:
push:
  branches: [main]
pull_request:
  branches: [main]
```
**Meaning:**
 Whenever a developer pushes code or opens a pull request, the pipeline automatically starts.

## How many jobs does it have?
Example workflow usually contains **1–2 jobs**, such as:

- `build` 
- `test` 
Each job runs on a virtual machine like:

```
runs-on: ubuntu-latest
```
## What does it do? (Best guess)
Typical steps in the workflow:

- Checkout the repository code
- Install Python dependencies
- Run linting tools
- Run automated tests
Example steps:

```
- uses: actions/checkout@v3
- name: Install dependencies
  run: pip install -r requirements.txt
- name: Run tests
  run: pytest
```
**Purpose of the workflow:**

- Ensure new code **does not break the project**
- Automatically **test every code change**
- Maintain **code quality and stability**.
```
Trigger: push and pull_request on main branch
Jobs: build and test
Purpose: install dependencies, run tests, and ensure the code works before merging
```
## Hints
- CI/CD is a practice, not just a tool
- GitHub Actions, Jenkins, GitLab CI, CircleCI — all are tools that implement CI/CD
- A pipeline failing is not a problem — it's CI/CD doing its job


