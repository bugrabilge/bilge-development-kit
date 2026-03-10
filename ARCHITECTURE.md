# Bilge Development Kit (BDK) Architecture

> Comprehensive AI Agent Capability Expansion Toolkit for Claude Code & Gemini

---

## Overview

Bilge Development Kit is a modular system consisting of:

- **23 Specialist Agents** - Role-based AI personas
- **96 Skills** - Domain-specific knowledge modules
- **15 Workflows** - Slash command procedures
- **6 Scripts** - Automation and validation tools
- **4 Hooks** - Automated guardrails (secret scanning, dangerous cmd detection)
- **5 Rules** - Always-on coding standards
- **3 Contexts** - Mode-specific behavior (dev, review, research)

---

## Directory Structure

```plaintext
.agent/
├── ARCHITECTURE.md          # This file
├── mcp_config.json.example  # MCP configuration example
├── .gitignore               # Git ignore rules
├── .shared/                 # Shared assets across skills
│   └── ui-ux-pro-max/      # Shared UI/UX resources
├── agents/                  # 23 Specialist Agents
├── skills/                  # 96 Skills + doc.md guide
├── workflows/               # 15 Slash Commands
├── rules/                   # Global Rules + Always-On Standards
│   ├── CLAUDE.md            # Claude Code protocol rules
│   ├── GEMINI.md            # Gemini protocol rules
│   └── common/              # Always-on coding standards
│       ├── git-workflow.md  # Commit format, branch naming, PR rules
│       ├── coding-style.md  # Naming conventions, file organization
│       ├── testing.md       # Test requirements, AAA pattern, coverage
│       ├── security.md      # Secrets, input validation, OWASP
│       └── performance.md   # Core Web Vitals, bundle size, caching
├── contexts/                # Mode-specific behavior contexts
│   ├── dev.md               # Development mode
│   ├── review.md            # Code review mode
│   └── research.md          # Research/analysis mode
├── scripts/                 # 6 Automation Scripts
│   ├── hooks/               # Hook scripts (guardrails)
│   │   ├── dangerous_cmd_check.sh  # Block destructive commands
│   │   ├── secret_scanner.sh       # Detect hardcoded secrets
│   │   ├── lint_check.sh           # Post-edit lint verification
│   │   └── session_save.sh         # Session context persistence
│   ├── detect_pm.py         # Package manager auto-detection
│   ├── checklist.py         # Priority-based validation
│   ├── verify_all.py        # Comprehensive verification
│   ├── auto_preview.py      # Dev server management
│   └── session_manager.py   # Project state analysis
└── .claude/
    └── settings.json        # Hooks configuration
```

---

## Agents (23)

Specialist AI personas for different domains.

| Agent                    | Focus                              |
| ------------------------ | ---------------------------------- |
| `orchestrator`           | Multi-agent coordination           |
| `project-planner`        | Discovery, task planning           |
| `frontend-specialist`    | Web UI/UX                          |
| `backend-specialist`     | API, business logic                |
| `database-architect`     | Schema, SQL, migrations            |
| `mobile-developer`       | React Native, Flutter              |
| `game-developer`         | Game logic, engines, mechanics     |
| `ai-engineer`            | AI/ML, LLM, RAG, agents           |
| `data-engineer`          | ETL, pipelines, analytics          |
| `devops-engineer`        | CI/CD, Docker, production ops      |
| `security-auditor`       | OWASP, supply chain, zero trust    |
| `penetration-tester`     | Offensive security, exploitation   |
| `test-engineer`          | Testing, TDD, coverage             |
| `qa-automation-engineer` | E2E testing, Playwright, CI        |
| `debugger`               | Root cause analysis, crash investigation |
| `performance-optimizer`  | Speed, Web Vitals, profiling       |
| `seo-specialist`         | Ranking, visibility, SEO           |
| `documentation-writer`   | Technical docs, manuals            |
| `product-manager`        | Requirements, user stories         |
| `product-owner`          | Strategy, backlog, MVP             |
| `api-designer`           | REST, GraphQL, gRPC API design     |
| `code-archaeologist`     | Legacy code, refactoring           |
| `explorer-agent`         | Codebase discovery, deep analysis  |

---

## Skills (95)

Modular knowledge domains that agents can load on-demand based on task context.

### AI & LLM

| Skill                              | Description                                      |
| ---------------------------------- | ------------------------------------------------ |
| `ai-engineer`                      | Production-ready LLM apps, RAG systems           |
| `ai-agents-architect`              | Autonomous AI agent design, tool use, memory      |
| `ai-product`                       | AI-powered product patterns, LLM integration     |
| `ai-wrapper-product`               | Building products wrapping AI APIs               |
| `agent-evaluation`                 | LLM agent testing and benchmarking               |
| `agent-manager-skill`              | Multi-agent tmux session management              |
| `agent-memory-mcp`                 | Hybrid memory system for AI agents               |
| `agent-memory-systems`             | Agent memory architecture (short/long-term)      |
| `agent-tool-builder`               | Tools for AI agent interaction                   |
| `agents-v2-py`                     | Azure AI Foundry container-based agents          |
| `computer-use-agents`              | AI agents that interact with computer screens    |
| `computer-vision-expert`           | YOLO, SAM, Vision Language Models                |
| `deep-research`                    | Autonomous multi-step research with Gemini       |
| `intelligent-routing`              | Automatic agent selection and task routing        |
| `langchain-architecture`           | LangChain/LangGraph LLM app design              |
| `langfuse`                         | LLM observability, tracing, evaluation           |
| `langgraph`                        | Stateful multi-actor AI applications             |
| `llm-app-patterns`                 | Production RAG, agent, and AI assistant patterns |
| `llm-application-dev-prompt-optimize` | Advanced prompt engineering techniques        |
| `llm-evaluation`                   | LLM evaluation strategies and metrics            |
| `rag-engineer`                     | RAG systems, embeddings, vector databases        |
| `rag-implementation`               | RAG with vector databases and semantic search    |
| `research-engineer`                | Academic research, formal verification           |
| `tool-design`                      | Building tools for agent use                     |

### Backend & API

| Skill                              | Description                                      |
| ---------------------------------- | ------------------------------------------------ |
| `api-patterns`                     | REST, GraphQL, tRPC design principles            |
| `api-design-principles`            | Scalable, maintainable API design                |
| `api-security-best-practices`      | API auth, validation, rate limiting              |
| `api-testing-observability-api-mock` | Realistic API mocking for dev/test             |
| `backend-dev-guidelines`           | Node.js + Express + TypeScript standards         |
| `fastapi-pro`                      | High-performance async APIs with FastAPI         |
| `fastapi-templates`                | Production-ready FastAPI project scaffolding     |
| `nodejs-best-practices`            | Node.js async, error handling, security          |

### Frontend & UI

| Skill                   | Description                                                 |
| ----------------------- | ----------------------------------------------------------- |
| `frontend-design`       | UI/UX patterns, design systems, component architecture      |
| `react-best-practices`  | React/Next.js performance, hooks, state management          |
| `tailwind-patterns`     | Tailwind CSS utilities, responsive design, themes           |
| `web-design-guidelines` | Responsive design, accessibility (WCAG), web performance    |

### Database

| Skill             | Description                               |
| ----------------- | ----------------------------------------- |
| `database-design` | Schema design, indexing, migrations       |

### Python

| Skill                    | Description                                 |
| ------------------------ | ------------------------------------------- |
| `python-patterns`        | Python standards, async, type hints         |
| `python-packaging`       | Package distribution, PyPI publishing       |
| `python-testing-patterns`| pytest, fixtures, mocking, TDD             |

### Data & ML

| Skill               | Description                                  |
| -------------------- | -------------------------------------------- |
| `data-engineer`      | Data pipelines, Spark, dbt, Airflow          |
| `data-scientist`     | Advanced analytics, machine learning         |
| `ml-engineer`        | Production ML with PyTorch, TensorFlow       |
| `mlops-engineer`     | ML pipelines, experiment tracking            |
| `airflow-dag-patterns` | Apache Airflow DAGs and best practices     |

### DevOps & Infrastructure

| Skill                              | Description                              |
| ---------------------------------- | ---------------------------------------- |
| `deployment-procedures`            | CI/CD, GitOps, rollback strategies       |
| `deployment-validation-config-validate` | Configuration validation and testing |
| `devops-troubleshooter`            | Rapid incident troubleshooting           |
| `server-management`               | Process management, monitoring, scaling  |
| `grafana-dashboards`              | Grafana dashboard creation               |
| `monitoring-observability`        | Logging, tracing, alerting, SLI/SLO      |
| `prometheus-configuration`        | Prometheus metric collection setup       |
| `secrets-management`              | Vault, AWS Secrets Manager, CI/CD secrets|
| `hugging-face-cli`                | Hugging Face Hub CLI operations          |

### Testing & Quality

| Skill                          | Description                            |
| ------------------------------ | -------------------------------------- |
| `testing-patterns`             | Unit, integration, mocking strategies  |
| `webapp-testing`               | Playwright, Cypress, visual regression |
| `tdd-workflow`                 | Test-Driven Development cycle          |
| `code-review-checklist`        | Comprehensive code review standards    |
| `code-reviewer`                | AI-powered code review                 |
| `lint-and-validate`            | Linting, static analysis, formatting   |
| `unit-testing-test-generate`   | Comprehensive unit test generation     |
| `verification-before-completion` | Verify before claiming work done     |

### Security

| Skill                   | Description                             |
| ----------------------- | --------------------------------------- |
| `vulnerability-scanner` | SAST/DAST, dependency auditing, CVE     |
| `red-team-tactics`      | Offensive security, penetration testing |

### Architecture & Planning

| Skill                          | Description                              |
| ------------------------------ | ---------------------------------------- |
| `app-builder`                  | Full-stack scaffolding, monorepo setup   |
| `architecture`                 | System design, DDD, clean architecture   |
| `architecture-decision-records`| ADR documentation                        |
| `plan-writing`                 | Structured task planning, breakdowns     |
| `brainstorming`                | Socratic questioning, design review      |
| `project-development`          | LLM project structure, pipeline design   |

### Code Quality & Refactoring

| Skill                              | Description                               |
| ---------------------------------- | ----------------------------------------- |
| `clean-code`                       | Clean Code principles (Robert C. Martin)  |
| `refactoring-patterns`             | Extract method, strategy, strangler fig   |
| `code-refactoring-refactor-clean`  | SOLID design patterns refactoring         |
| `code-refactoring-tech-debt`       | Technical debt identification, prioritization |
| `code-refactoring-context-restore` | Code refactoring context restore          |
| `codebase-cleanup-deps-audit`     | Dependency security, license compliance   |

### Documentation

| Skill                              | Description                               |
| ---------------------------------- | ----------------------------------------- |
| `documentation-templates`          | README, API docs, code comment formats    |
| `code-documentation-code-explain`  | Code explanation with diagrams            |
| `code-documentation-doc-generate`  | Auto-generate docs from code              |
| `readme`                           | README.md creation and updates            |
| `writing-skills`                   | Creating and editing BDK skills           |

### Mobile & Game

| Skill              | Description                               |
| ------------------ | ----------------------------------------- |
| `mobile-design`    | Mobile UI/UX, iOS HIG, Material Design    |
| `game-development` | Game architecture, engines, mechanics     |

### SEO & Growth

| Skill              | Description                           |
| ------------------ | ------------------------------------- |
| `seo-fundamentals` | SEO, meta tags, structured data       |
| `geo-fundamentals` | Generative Engine Optimization (GEO)  |

### Shell/CLI

| Skill                  | Description                    |
| ---------------------- | ------------------------------ |
| `bash-linux`           | Linux commands, scripting      |
| `powershell-windows`   | Windows PowerShell patterns    |
| `linux-shell-scripting`| Production shell scripts       |

### Rust

| Skill      | Description                                 |
| ---------- | ------------------------------------------- |
| `rust-pro` | Ownership, lifetimes, async, concurrency    |

### Caching & Performance

| Skill                   | Description                          |
| ----------------------- | ------------------------------------ |
| `caching-patterns`      | Browser, CDN, Redis cache strategies |
| `performance-profiling` | Measurement, analysis, optimization  |

### Agent Behavior

| Skill              | Description                       |
| ------------------ | --------------------------------- |
| `behavioral-modes` | Agent personas and modes          |
| `parallel-agents`  | Multi-agent orchestration         |
| `mcp-builder`      | Model Context Protocol servers    |

---

## Workflows (14)

Slash command procedures. Invoke with `/command`.

| Command          | Description              |
| ---------------- | ------------------------ |
| `/brainstorm`    | Socratic discovery       |
| `/create`        | Create new features      |
| `/debug`         | Debug issues             |
| `/deploy`        | Deploy application       |
| `/enhance`       | Improve existing code    |
| `/orchestrate`   | Multi-agent coordination |
| `/plan`          | Task breakdown           |
| `/preview`       | Preview changes          |
| `/refactor`      | Systematic refactoring   |
| `/review`        | Code review              |
| `/security`      | Security audit           |
| `/status`        | Check project status     |
| `/test`          | Run tests                |
| `/ui-ux-pro-max` | Design with 50 styles    |
| `/build-fix`     | Build error resolver     |

---

## Skill Loading Protocol

```plaintext
User Request → Skill Description Match → Load SKILL.md
                                            ↓
                                    Read references/
                                            ↓
                                    Read scripts/
```

### Skill Structure

```plaintext
skill-name/
├── SKILL.md           # (Required) Metadata & instructions
├── scripts/           # (Optional) Python/Bash scripts
├── references/        # (Optional) Templates, docs
└── assets/            # (Optional) Images, logos
```

---

## Scripts (6)

Automation and validation scripts.

| Script               | Purpose                                      | When to Use               |
| -------------------- | -------------------------------------------- | ------------------------- |
| `checklist.py`       | Priority-based validation (core checks)      | Development, pre-commit   |
| `verify_all.py`      | Comprehensive verification (all checks)      | Pre-deployment, releases  |
| `auto_preview.py`    | Dev server management (start/stop/status)    | Local preview, testing    |
| `session_manager.py` | Project state analysis, tech stack detection | Session info, diagnostics |
| `detect_pm.py`       | Package manager auto-detection               | Build/test/deploy commands|

### Usage

```bash
# Quick validation during development
python .agent/scripts/checklist.py .

# Full verification before deployment
python .agent/scripts/verify_all.py . --url http://localhost:3000

# Manage local dev server
python .agent/scripts/auto_preview.py start [port]
python .agent/scripts/auto_preview.py stop
python .agent/scripts/auto_preview.py status

# Analyze project state
python .agent/scripts/session_manager.py status [path]
python .agent/scripts/session_manager.py info [path]
```

### What They Check

**checklist.py** (Core checks):

- Security (vulnerabilities, secrets)
- Code Quality (lint, types)
- Schema Validation
- Test Suite
- UX Audit
- SEO Check

**verify_all.py** (Full suite):

- Everything in checklist.py PLUS:
- Lighthouse (Core Web Vitals)
- Playwright E2E
- Bundle Analysis
- Mobile Audit
- i18n Check

---

## Hooks (4)

Automated guardrails configured in `.claude/settings.json`. Run automatically without user intervention.

| Hook                      | Event        | Matcher      | Purpose                              |
| ------------------------- | ------------ | ------------ | ------------------------------------ |
| `dangerous_cmd_check.sh`  | PreToolUse   | Bash         | Block destructive commands           |
| `secret_scanner.sh`       | PreToolUse   | Write\|Edit  | Detect hardcoded secrets/credentials |
| `lint_check.sh`           | PostToolUse  | Edit\|Write  | Auto-lint after file changes         |
| `session_save.sh`         | Stop         | (all)        | Persist session context to memory    |

---

## Always-On Rules (5)

Located in `rules/common/`. Applied automatically to all code output.

| Rule              | Enforces                                        |
| ----------------- | ----------------------------------------------- |
| `git-workflow.md` | Conventional Commits, branch naming, PR format  |
| `coding-style.md` | Naming conventions, file organization, imports  |
| `testing.md`      | AAA pattern, coverage targets, test pyramid     |
| `security.md`     | Secret management, OWASP, input validation      |
| `performance.md`  | Core Web Vitals, bundle size, caching strategy  |

---

## Contexts (3)

Mode-specific behavior adjustments in `contexts/`. Load based on task type.

| Context        | When Active                     | Behavior Focus           |
| -------------- | ------------------------------- | ------------------------ |
| `dev.md`       | Writing new code, prototyping   | Fast iteration, debug    |
| `review.md`    | Code review, PR assessment      | Quality checklist, SOLID |
| `research.md`  | Tech comparison, investigation  | Evidence-based, tables   |

---

## Statistics

| Metric              | Value  |
| ------------------- | ------ |
| **Total Agents**    | 23     |
| **Total Skills**    | 96     |
| **Total Workflows** | 15     |
| **Total Scripts**   | 6      |
| **Total Hooks**     | 4      |
| **Total Rules**     | 5      |
| **Total Contexts**  | 3      |

---

## Quick Reference

| Need     | Agent                 | Skills                                |
| -------- | --------------------- | ------------------------------------- |
| Web App  | `frontend-specialist` | react-best-practices, frontend-design |
| API      | `backend-specialist`  | api-patterns, nodejs-best-practices   |
| Mobile   | `mobile-developer`    | mobile-design                         |
| Database | `database-architect`  | database-design                       |
| Security | `security-auditor`    | vulnerability-scanner                 |
| Testing  | `test-engineer`       | testing-patterns, webapp-testing      |
| Debug    | `debugger`            | systematic-debugging                  |
| Plan     | `project-planner`     | brainstorming, plan-writing           |
| AI/LLM   | `ai-engineer`         | ai-engineer, rag-engineer             |
| Data     | `data-engineer`       | data-engineer, python-patterns        |
| DevOps   | `devops-engineer`     | deployment-procedures                 |
| Pentest  | `penetration-tester`  | red-team-tactics                      |
