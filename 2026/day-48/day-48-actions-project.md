# GitHub Actions Capstone

A complete CI/CD pipeline built using GitHub Actions, Docker, and scheduled health checks.

---

## Workflow Status

![PR Pipeline](https://github.com/prathamesh9797/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)

![Main Pipeline](https://github.com/prathamesh9797/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)

![Health Check](https://github.com/prathamesh9797/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)

---

## Project Overview

This project demonstrates:
- CI pipeline using reusable workflows
- Docker build and push automation
- Deployment workflow
- Scheduled health checks

---

##  Pipeline Flow

### Pull Request
PR opened  
→ Build & Test  
→ PR checks pass 


### Main Branch
Merge to main  
→ Build & Test  
→ Docker Build & Push  
→ Deploy 

### Scheduled Job
Every 12 hours  
→ Pull Docker image  
→ Run container  
→ Health check  
→ Report generated 

---

##  Future Improvements

- Slack notifications on failure
- Multi-environment deployment (dev/staging/prod)
- Rollback strategy
- Kubernetes deployment