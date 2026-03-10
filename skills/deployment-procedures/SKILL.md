---
name: deployment-procedures
description: "Production deployment principles, CI/CD pipeline design, GitOps workflows, and deployment automation. Safe deployment workflows, rollback strategies, verification, approval gates, and security-first pipelines."
allowed-tools: Read, Glob, Grep, Bash
risk: unknown
source: community
---

# Deployment Procedures

> Deployment principles and decision-making for safe production releases.
> **Learn to THINK, not memorize scripts.**

---

## ⚠️ How to Use This Skill

This skill teaches **deployment principles**, not bash scripts to copy.

- Every deployment is unique
- Understand the WHY behind each step
- Adapt procedures to your platform

---

## 1. Platform Selection

### Decision Tree

```
What are you deploying?
│
├── Static site / JAMstack
│   └── Vercel, Netlify, Cloudflare Pages
│
├── Simple web app
│   ├── Managed → Railway, Render, Fly.io
│   └── Control → VPS + PM2/Docker
│
├── Microservices
│   └── Container orchestration
│
└── Serverless
    └── Edge functions, Lambda
```

### Each Platform Has Different Procedures

| Platform | Deployment Method |
|----------|------------------|
| **Vercel/Netlify** | Git push, auto-deploy |
| **Railway/Render** | Git push or CLI |
| **VPS + PM2** | SSH + manual steps |
| **Docker** | Image push + orchestration |
| **Kubernetes** | kubectl apply |

---

## 2. Pre-Deployment Principles

### The 4 Verification Categories

| Category | What to Check |
|----------|--------------|
| **Code Quality** | Tests passing, linting clean, reviewed |
| **Build** | Production build works, no warnings |
| **Environment** | Env vars set, secrets current |
| **Safety** | Backup done, rollback plan ready |

### Pre-Deployment Checklist

- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] Production build successful
- [ ] Environment variables verified
- [ ] Database migrations ready (if any)
- [ ] Rollback plan documented
- [ ] Team notified
- [ ] Monitoring ready

---

## 3. Deployment Workflow Principles

### The 5-Phase Process

```
1. PREPARE
   └── Verify code, build, env vars

2. BACKUP
   └── Save current state before changing

3. DEPLOY
   └── Execute with monitoring open

4. VERIFY
   └── Health check, logs, key flows

5. CONFIRM or ROLLBACK
   └── All good? Confirm. Issues? Rollback.
```

### Phase Principles

| Phase | Principle |
|-------|-----------|
| **Prepare** | Never deploy untested code |
| **Backup** | Can't rollback without backup |
| **Deploy** | Watch it happen, don't walk away |
| **Verify** | Trust but verify |
| **Confirm** | Have rollback trigger ready |

---

## 4. Post-Deployment Verification

### What to Verify

| Check | Why |
|-------|-----|
| **Health endpoint** | Service is running |
| **Error logs** | No new errors |
| **Key user flows** | Critical features work |
| **Performance** | Response times acceptable |

### Verification Window

- **First 5 minutes**: Active monitoring
- **15 minutes**: Confirm stable
- **1 hour**: Final verification
- **Next day**: Review metrics

---

## 5. Rollback Principles

### When to Rollback

| Symptom | Action |
|---------|--------|
| Service down | Rollback immediately |
| Critical errors | Rollback |
| Performance >50% degraded | Consider rollback |
| Minor issues | Fix forward if quick |

### Rollback Strategy by Platform

| Platform | Rollback Method |
|----------|----------------|
| **Vercel/Netlify** | Redeploy previous commit |
| **Railway/Render** | Rollback in dashboard |
| **VPS + PM2** | Restore backup, restart |
| **Docker** | Previous image tag |
| **K8s** | kubectl rollout undo |

### Rollback Principles

1. **Speed over perfection**: Rollback first, debug later
2. **Don't compound errors**: One rollback, not multiple changes
3. **Communicate**: Tell team what happened
4. **Post-mortem**: Understand why after stable

---

## 6. Zero-Downtime Deployment

### Strategies

| Strategy | How It Works |
|----------|--------------|
| **Rolling** | Replace instances one by one |
| **Blue-Green** | Switch traffic between environments |
| **Canary** | Gradual traffic shift |

### Selection Principles

| Scenario | Strategy |
|----------|----------|
| Standard release | Rolling |
| High-risk change | Blue-green (easy rollback) |
| Need validation | Canary (test with real traffic) |

---

## 7. Emergency Procedures

### Service Down Priority

1. **Assess**: What's the symptom?
2. **Quick fix**: Restart if unclear
3. **Rollback**: If restart doesn't help
4. **Investigate**: After stable

### Investigation Order

| Check | Common Issues |
|-------|--------------|
| **Logs** | Errors, exceptions |
| **Resources** | Disk full, memory |
| **Network** | DNS, firewall |
| **Dependencies** | Database, APIs |

---

## 8. Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| Deploy on Friday | Deploy early in week |
| Rush deployment | Follow the process |
| Skip staging | Always test first |
| Deploy without backup | Backup before deploy |
| Walk away after deploy | Monitor for 15+ min |
| Multiple changes at once | One change at a time |

---

## 9. Decision Checklist

Before deploying:

- [ ] **Platform-appropriate procedure?**
- [ ] **Backup strategy ready?**
- [ ] **Rollback plan documented?**
- [ ] **Monitoring configured?**
- [ ] **Team notified?**
- [ ] **Time to monitor after?**

---

## 10. Best Practices

1. **Small, frequent deploys** over big releases
2. **Feature flags** for risky changes
3. **Automate** repetitive steps
4. **Document** every deployment
5. **Review** what went wrong after issues
6. **Test rollback** before you need it

---

> **Remember:** Every deployment is a risk. Minimize risk through preparation, not speed.

## When to Use
This skill is applicable to execute the workflow or actions described in the overview.

---

## 11. CI/CD Pipeline Design

### Standard Pipeline Flow

```
┌─────────┐   ┌──────┐   ┌─────────┐   ┌────────┐   ┌──────────┐
│  Build  │ → │ Test │ → │ Staging │ → │ Approve│ → │Production│
└─────────┘   └──────┘   └─────────┘   └────────┘   └──────────┘
```

### Detailed Stage Breakdown

1. **Source** - Code checkout
2. **Build** - Compile, package, containerize
3. **Test** - Unit, integration, security scans
4. **Staging Deploy** - Deploy to staging environment
5. **Integration Tests** - E2E, smoke tests
6. **Approval Gate** - Manual or automated approval
7. **Production Deploy** - Canary, blue-green, rolling
8. **Verification** - Health checks, monitoring
9. **Rollback** - Automated rollback on failure

### Approval Gate Patterns

| Pattern | When to Use |
|---------|------------|
| **Manual Approval** | High-risk changes, compliance requirements |
| **Time-Based** | Delayed rollout after staging validation |
| **Multi-Approver** | Critical production changes needing team lead sign-off |
| **Automated** | Metric-based promotion (error rate, latency thresholds) |

### Multi-Stage Pipeline Example (GitHub Actions)

```yaml
name: Production Pipeline
on:
  push:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:${{ github.sha }} .
      - name: Push to registry
        run: docker push myapp:${{ github.sha }}

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - name: Unit tests
        run: make test
      - name: Security scan
        run: trivy image myapp:${{ github.sha }}

  deploy-staging:
    needs: test
    environment: staging
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to staging
        run: kubectl apply -f k8s/staging/

  deploy-production:
    needs: deploy-staging
    environment: production
    runs-on: ubuntu-latest
    steps:
      - name: Canary deployment
        run: kubectl argo rollouts promote my-app

  verify:
    needs: deploy-production
    runs-on: ubuntu-latest
    steps:
      - name: Health check
        run: curl -f https://app.example.com/health
```

---

## 12. CI/CD Platform Selection

| Platform | Strengths |
|----------|-----------|
| **GitHub Actions** | Native GitHub integration, marketplace, reusable workflows |
| **GitLab CI/CD** | Built-in, DAG pipelines, multi-project |
| **Azure DevOps** | Enterprise, template libraries, environment approvals |
| **Jenkins** | Extensible, self-hosted, massive plugin ecosystem |
| **ArgoCD/Flux** | GitOps-native, Kubernetes-first, declarative |
| **Tekton** | Cloud-native, Kubernetes-native pipelines |

---

## 13. GitOps & Continuous Deployment

### GitOps Principles

| Principle | Implementation |
|-----------|---------------|
| **Declarative** | All desired state in Git (Helm, Kustomize, manifests) |
| **Versioned** | Git history = deployment history |
| **Automated** | ArgoCD/Flux auto-sync from Git |
| **Auditable** | Every change has a PR, review, and commit |

### Repository Patterns

| Pattern | When to Use |
|---------|------------|
| **App-of-apps** | Managing many microservices with ArgoCD |
| **Mono-repo** | Small team, tightly coupled services |
| **Multi-repo** | Large org, independent service ownership |
| **Environment branches** | Simple promotion (dev -> staging -> prod) |
| **Kustomize overlays** | Environment-specific configs from shared base |

### Secret Management in GitOps

| Tool | Approach |
|------|----------|
| **External Secrets Operator** | Sync from Vault/AWS Secrets Manager to K8s |
| **Sealed Secrets** | Encrypt secrets that can be stored in Git |
| **SOPS** | Mozilla's encrypted file format for secrets |

---

## 14. Container & Image Security

### Secure Container Build Practices

| Practice | Guideline |
|----------|-----------|
| **Multi-stage builds** | Separate build and runtime stages |
| **Distroless images** | Minimal attack surface, no shell |
| **Non-root users** | Never run containers as root |
| **Image signing** | Use Sigstore/cosign for supply chain security |
| **Vulnerability scanning** | Trivy, Grype, or Snyk in CI pipeline |
| **SBOM generation** | Track dependencies with SPDX or CycloneDX |

### Supply Chain Security (SLSA Framework)

| Level | Requirements |
|-------|-------------|
| **Level 1** | Build process documented |
| **Level 2** | Version control, hosted build service |
| **Level 3** | Source verified, build reproducible |
| **Level 4** | Two-party review, hermetic builds |

---

## 15. Pipeline Metrics (DORA)

| Metric | Target (Elite) | How to Measure |
|--------|----------------|----------------|
| **Deployment Frequency** | Multiple per day | Count deploys per time period |
| **Lead Time for Changes** | < 1 hour | Commit timestamp to production deploy |
| **Change Failure Rate** | < 5% | Failed deploys / total deploys |
| **Mean Time to Recovery** | < 1 hour | Incident start to resolution |
| **Pipeline Success Rate** | > 95% | Successful runs / total runs |

---

## 16. Pipeline Best Practices

1. **Fail fast** - Run quick tests first
2. **Parallel execution** - Run independent jobs concurrently
3. **Caching** - Cache dependencies between runs
4. **Artifact management** - Store build artifacts with versioning
5. **Environment parity** - Keep environments consistent
6. **Secrets management** - Use secret stores (Vault, etc.)
7. **Deployment windows** - Schedule deployments appropriately
8. **Monitoring integration** - Track deployment success metrics
9. **Rollback automation** - Auto-rollback on health check failure
10. **Documentation** - Document pipeline stages and runbooks

---

## 17. Progressive Delivery

### Canary Deployment with Argo Rollouts

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
spec:
  strategy:
    canary:
      steps:
      - setWeight: 10
      - pause: {duration: 5m}
      - setWeight: 25
      - pause: {duration: 5m}
      - setWeight: 50
      - pause: {duration: 5m}
      - setWeight: 100
```

### Feature Flag Integration

| Tool | Use Case |
|------|----------|
| **LaunchDarkly** | Enterprise feature management |
| **Flagr** | Open-source feature flags |
| **Unleash** | Self-hosted feature toggles |

Benefits: Deploy without releasing, A/B testing, instant rollback, granular control.

---

## 18. Testing in Pipelines

| Test Type | Stage | Purpose |
|-----------|-------|---------|
| **Unit tests** | Build | Verify business logic |
| **SAST** | Build | Static security analysis |
| **Integration tests** | Staging | Service interaction verification |
| **DAST** | Staging | Runtime security testing |
| **Smoke tests** | Post-deploy | Critical path validation |
| **Performance tests** | Pre-production | Load and latency benchmarks |
| **Chaos tests** | Production | Resilience validation |

---

## 19. Multi-Environment Management

| Environment | Purpose | Promotion |
|-------------|---------|-----------|
| **Development** | Feature development | Automatic on merge |
| **Staging** | Integration testing | Automatic after tests pass |
| **Pre-production** | Final validation | Manual approval gate |
| **Production** | Live traffic | After pre-prod sign-off |

### Cost Optimization

- Schedule non-production environments to shut down outside business hours
- Use spot/preemptible instances for CI runners
- Implement environment lifecycle management with auto-teardown
