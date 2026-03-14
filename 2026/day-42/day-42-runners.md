# Day 42 – Runners: GitHub-Hosted & Self-Hosted

### Task 1: GitHub-Hosted Runners
1. Create a workflow with 3 jobs, each on a different OS:
    - `ubuntu-latest` 
    - `windows-latest` 
    - `macos-latest` 

2. In each job, print:
    - The OS name
    - The runner's hostname
    - The current user running the job

3. Watch all 3 run in parallel
Write in your notes: What is a GitHub-hosted runner? Who manages it?

![Screenshot from 2026-03-14 15-06-37.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-06-37_8EZFtePVPeVkZwqlHfUgL.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-06-37.png")

![Screenshot from 2026-03-14 15-04-19.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-04-19_lf35skbalxehGk6eQ8ZNI.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-04-19.png")



![Screenshot from 2026-03-14 15-05-07.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-05-07_eXLDCi8ZBTuUafHEwHx0y.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-05-07.png")

![Screenshot from 2026-03-14 15-05-29.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-05-29_4LNnfgc9xhgQgUm20q61S.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-05-29.png")



Write in your notes: What is a GitHub-hosted runner? Who manages it?

>> A **GitHub-hosted runner** is a temporary virtual machine provided by GitHub that runs the jobs defined in a GitHub Actions workflow.

Each workflow job executes on a **fresh, clean environment** that already includes many preinstalled tools such as Python, Node.js, Docker, Git, and build tools.

When the job finishes, the runner is **automatically destroyed**, ensuring a clean environment for the next run.

---

## Who manages it?
GitHub manages the entire infrastructure for GitHub-hosted runners.

GitHub is responsible for:

- Provisioning the virtual machines
- Installing common development tools
- Maintaining the operating system images
- Starting the runner when a job begins
- Cleaning up and deleting the runner after the job completes
Users only need to specify the runner in the workflow using:

```
runs-on: ubuntu-latest
runs-on: windows-latest
runs-on: macos-latest
```
GitHub handles everything else automatically.

### Short Interview-Ready Answer
A **GitHub-hosted runner** is a virtual machine provided and managed by GitHub that executes workflow jobs. GitHub automatically provisions, maintains, and destroys these runners after each job run.

---

### Task 2: Explore What's Pre-installed
1. On the `ubuntu-latest`  runner, run a step that prints:
    - Docker version
    - Python version
    - Node version
    - Git version

2. Look up the GitHub docs for the full list of pre-installed software on `ubuntu-latest` 
Write in your notes: Why does it matter that runners come with tools pre-installed?

![Screenshot from 2026-03-14 15-30-24.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-30-24_v4jup66-p1f-wB13P74-2.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-30-24.png")

![Screenshot from 2026-03-14 15-30-36.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-30-36_u0THTazOX5Hzpm0WS2gr1.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-30-36.png")



![Screenshot from 2026-03-14 15-30-47.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-30-47_eeg06jela4Ia8fSnY-qXY.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-30-47.png")

![Screenshot from 2026-03-14 15-31-00.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2015-31-00_3bkWFmTDuAFqZMVaUcaom.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 15-31-00.png")

## Full List of Pre-installed Software on `ubuntu-latest`
GitHub provides a detailed list of all tools installed on the **ubuntu-latest runner** in the official runner images repository.

The list includes tools such as:

- Docker
- Git
- Python
- Node.js
- Java
- Go
- Ruby
- .NET
- Build tools (gcc, make, cmake)
- Package managers (npm, pip, yarn)
- Cloud CLI tools (AWS CLI, Azure CLI)
- Container tools
These tools are maintained and updated by GitHub in the runner images.

## Why Does It Matter That Runners Come With Tools Pre-installed?
Pre-installed tools make CI/CD workflows **faster and easier to configure**.

Because common development tools are already available on the runner, workflows do not need to install them during every run.

Benefits include:

- **Faster pipeline execution** since installation steps are reduced
- **Simpler workflow configuration**
- **Consistent environments** across different workflow runs
- **Reduced setup time** for CI pipelines
This allows developers to focus on **building, testing, and deploying applications rather than setting up the environment**.

---

### Task 3: Set Up a Self-Hosted Runner
1. Go to your GitHub repo → Settings → Actions → Runners → **New self-hosted runner**
2. Choose Linux as the OS
3. Follow the instructions to download and configure the runner on:
    - Your local machine, OR
    - A cloud VM (EC2, Utho, or any VPS)

4. Start the runner — verify it shows as **Idle** in GitHub
**Verify:** Your runner appears in the Runners list with a green dot.

![Screenshot from 2026-03-14 16-22-18.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2016-22-18_KxR3BNdS6lfSS8OxqGBv4.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 16-22-18.png")

![Screenshot from 2026-03-14 16-23-14.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2016-23-14_gk7QIcY_7cn_IjISoBLHu.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 16-23-14.png")

---

### Task 4: Use Your Self-Hosted Runner
1. Create `.github/workflows/self-hosted.yml` 
2. Set `runs-on: self-hosted` 
3. Add steps that:
    - Print the hostname of the machine (it should be YOUR machine/VM)
    - Print the working directory
    - Create a file and verify it exists on your machine after the run

4. Trigger it and watch it run on your own hardware
**Verify:** Check your machine — is the file there?

File is there in  _work >> GitHub Actions always runs jobs inside the **runner workspace**:

```
ubuntu@ip-172-31-16-173:~/actions-runner/_work/github-actions-practice/github-actions-practice$ ls
test.txt
```
![Screenshot from 2026-03-14 16-36-34.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2016-36-34_ezfWnl-ICLc9-0owtwmfI.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 16-36-34.png")

![Screenshot from 2026-03-14 16-37-05.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2016-37-05_IBLSqZ8efddSYTnVNuLRW.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 16-37-05.png")

---

### Task 5: Labels
1. Add a **label** to your self-hosted runner (e.g., `my-linux-runner` )
2. Update your workflow to use `runs-on: [self-hosted, my-linux-runner]` 
3. Trigger it — does it still pick up the job? >> yes it picks the job
Write in your notes: Why are labels useful when you have multiple self-hosted runners? 

>> Labels help GitHub decide **which runner should execute a job** when multiple self-hosted runners exist.

In real companies there may be runners like:

| Runner | Labels |
| ----- | ----- |
| Runner 1 | linux, docker |
| Runner 2 | linux, kubernetes |
| Runner 3 | windows |
| Runner 4 | gpu |
A workflow can target a specific environment:

```
runs-on: [self-hosted, docker]
```
or

```
runs-on: [self-hosted, gpu]
```
**Why are labels useful when you have multiple self-hosted runners?**

Labels help identify and target specific runners when multiple self-hosted runners are available. They allow workflows to run on runners with particular environments, hardware, or software configurations (for example Linux, Docker-enabled, or GPU machines). This ensures jobs run on the appropriate infrastructure.

---

### Short Interview Answer
Labels allow workflows to target specific self-hosted runners based on their capabilities, such as operating system, hardware, or installed software.





![Screenshot from 2026-03-14 17-12-58.png](https://eraser.imgix.net/workspaces/QovdTlJFs4thFKN0f9HE/wT5AjlQjuoRNZa07dGqXHOM5M9s2/Screenshot%20from%202026-03-14%2017-12-58_Bp8jhdk8pAtlM7P4j5K4m.png?ixlib=js-3.8.0 "Screenshot from 2026-03-14 17-12-58.png")

---

### Task 6: GitHub-Hosted vs Self-Hosted
Fill this in your notes:

|  | **GitHub-Hosted** | **Self-Hosted** |
| ----- | ----- | ----- |
| **Who manages it?** | GitHub | You / Your organization |
| **Cost** | Free tier available, then billed per minutes | You pay for the infrastructure (VM, server, cloud) |
| **Pre-installed tools** | <ul><li>Many tools already installed (Docker, Git, Python, Node, Java, Go, Ruby, .NET, build tools, package managers, cloud CLIs, etc.)</li></ul> | You must install and maintain all required tools yourself |
| **Good for** | Quick CI/CD setup, small to medium projects | Custom environments, internal networks, heavy workloads |
| **Security concern** | Lower risk since runners are ephemeral and managed by GitHub | Higher responsibility — you must secure and maintain the runner |
| **Scalability** | Automatically scales based on workflow demand | You must manually manage scaling of runners |


