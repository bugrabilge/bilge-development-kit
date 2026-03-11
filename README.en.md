<p align="center">
  <img src="assets/bdk-banner.png" alt="Bilge Development Kit" width="600">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen" alt="Status">
  <img src="https://img.shields.io/badge/Version-1.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/Agents-22-blue" alt="Agents">
  <img src="https://img.shields.io/badge/Core_Skills-56-green" alt="Core Skills">
  <img src="https://img.shields.io/badge/Extra_Skills-37-lightgrey" alt="Extra Skills">
  <img src="https://img.shields.io/badge/Workflows-16-orange" alt="Workflows">
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License">
  <br>
  <img src="https://img.shields.io/badge/Claude_Code-Compatible-blueviolet" alt="Claude Code">
  <img src="https://img.shields.io/badge/Gemini_CLI-Compatible-4285F4" alt="Gemini CLI">
  <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs Welcome">
  <a href="https://buymeacoffee.com/bilgeai"><img src="https://img.shields.io/badge/Buy_Me_A_Coffee-FFDD00?logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>
</p>

<p align="center"><strong><a href="README.en.md">English</a> | <a href="README.md">Türkçe</a></strong></p>

# Bilge Development Kit (BDK)

**Turn a single AI assistant into a team of 22 specialist developers.**

BDK is a modular toolkit that gives AI coding assistants like Claude Code and Gemini expert behaviors, automatic security guardrails, and structured workflows. It has zero runtime dependencies -- it's entirely made of markdown files and shell scripts. Copy the `.agent/` directory into your project, and your AI assistant instantly knows which expert to invoke, which rules to apply, and which security checks to run.

```
22 Agents | 56 Core Skills | 37 Extra Skills | 16 Workflows | 4 Hooks | 5 Rules | 3 Contexts
```

---

## Table of Contents

- [Why BDK?](#why-bdk)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Agents (22)](#agents-22)
- [Skills (56 Core + 37 Extra)](#skills-56-core--37-extra)
- [Slash Commands (19)](#slash-commands-19)
- [Hooks -- Automatic Guardrails (4)](#hooks----automatic-guardrails-4)
- [Memory Bank](#memory-bank--cross-session-persistence)
- [Always-On Rules (5)](#always-on-rules-5)
- [Context Modes (3)](#context-modes-3)
- [Scripts (5)](#scripts-5)
- [MCP Configuration](#mcp-configuration)
- [How It Works](#how-it-works)
- [Customization](#customization)
- [Requirements](#requirements)

---

## Why BDK?

AI coding assistants are powerful but generic. When you say "write a React component," it produces working code -- but it doesn't know your project's style rules, doesn't check for security vulnerabilities, might forget to write tests, and can run `rm -rf /` without questioning it.

BDK fills this gap:

**Expert team instead of a generic assistant.** Every request is automatically routed to the right specialist. Frontend task? The `frontend-specialist` agent kicks in and loads domain-specific knowledge like `react-best-practices` and `tailwind-patterns`. Security scan? The `security-auditor` applies the OWASP checklist.

**Think before coding.** For complex requests, the Socratic Gate activates: if you say "build an e-commerce site," Claude first asks questions to clarify architectural decisions. Single vendor or marketplace? Payment method? At least 3 questions, no coding without answers.

**Automatic safety net.** The hooks system runs silently in the background: catches secrets written to files, blocks destructive commands, runs lint after every edit. Without you noticing.

**Consistent quality.** Always-on rules apply to every code output: Conventional Commits format, camelCase/snake_case consistency, 80% test coverage target, Core Web Vitals limits. Even when the agent changes, the standard doesn't.

---

## Quick Start

### 1. Add to your project

```bash
git clone https://github.com/bugrabilge/bilge-development-kit.git
cp -r bilge-development-kit your-project/.agent
```

### 2. Configure for your platform

**Claude Code:** Works automatically. Reads `.agent/CLAUDE.md` automatically. For hooks, `.agent/.claude/settings.json` must be in place.

**Gemini:** Reference `.agent/rules/GEMINI.md` in your project's AI settings.

### 3. Start using

```
/brainstorm authentication system     # Compare different approaches
/plan e-commerce MVP                  # Create task breakdown
/create user profile page             # Implement from scratch
/review                               # Code review
/build-fix                            # Auto-fix build errors
/security full scan                   # Security audit
```

---

## Architecture

```
.agent/
├── ARCHITECTURE.md              # System map
├── CLAUDE.md                    # Claude Code protocol rules
├── mcp_config.json.example      # MCP server template
│
├── agents/                      # 22 Specialist Agents
│   ├── orchestrator.md          #   Multi-agent coordination
│   ├── frontend-specialist.md   #   Web UI/UX
│   ├── backend-specialist.md    #   API, business logic
│   ├── security-auditor.md      #   OWASP, zero trust
│   └── ...                      #   +18 more specialists
│
├── skills/                      # 56 Core Skills (agent-referenced)
│   ├── clean-code/
│   ├── react-best-practices/
│   ├── api-patterns/
│   └── ...
│
├── skills-extra/                # 37 Extra Skills (niche/optional)
│   ├── langchain-architecture/
│   ├── grafana-dashboards/
│   └── ...
│
├── .claude/
│   ├── settings.json            # Hooks configuration
│   └── skills/                  # 16 Workflow Skills
│       ├── brainstorm/
│       ├── build-fix/
│       ├── plan/
│       ├── remember/
│       └── ...
│
├── workflows/                   # 16 Slash Commands
│   ├── brainstorm.md            #   /brainstorm
│   ├── create.md                #   /create
│   ├── build-fix.md             #   /build-fix
│   ├── remember.md              #   /remember
│   └── ...
│
├── rules/                       # Global Rules
│   ├── CLAUDE.md                #   Claude Code rules
│   ├── GEMINI.md                #   Gemini rules
│   └── common/                  #   Always-on standards
│       ├── git-workflow.md      #   Commit format, branch naming
│       ├── coding-style.md      #   Naming conventions, file organization
│       ├── testing.md           #   Test requirements, coverage targets
│       ├── security.md          #   Secret management, OWASP protections
│       └── performance.md       #   Core Web Vitals, bundle limits
│
├── contexts/                    # Mode-Based Behavior
│   ├── dev.md                   #   Development mode
│   ├── review.md                #   Code review mode
│   └── research.md              #   Research mode
│
├── scripts/                     # Automation Tools
│   ├── hooks/                   #   Guardrail scripts
│   │   ├── dangerous_cmd_check.sh
│   │   ├── secret_scanner.sh
│   │   ├── lint_check.sh
│   │   └── session_save.sh
│   ├── detect_pm.py             #   Package manager detection
│   ├── checklist.py             #   Project validation
│   ├── verify_all.py            #   Comprehensive test suite
│   ├── auto_preview.py          #   Dev server management
│   └── session_manager.py       #   Project analysis
│
└── .shared/
    └── ui-ux-pro-max/           # UI/UX resources (CSV data)
```

### Request Processing Flow

Every user request goes through 5 stages:

```
User Request
    │
    ▼
[1. Classification]  →  Question? Code? Design? Research?
    │
    ▼
[2. Agent Selection] →  frontend-specialist? backend-specialist? debugger?
    │
    ▼
[3. Skill Loading]   →  Agent's frontmatter skills: list is read
    │
    ▼
[4. Rule Application]→  Always-on rules (security, style, testing, performance)
    │
    ▼
[5. Hooks]           →  Secret scanning, lint check, session save
    │
    ▼
  Output
```

---

## Agents (22)

Each agent is a `.md` file containing a persona definition, area of expertise, principles to follow, and a list of skills to load. When a request comes in, BDK automatically selects the right agent -- you don't need to specify.

| Agent | Expertise | When It Activates |
|-------|-----------|-------------------|
| `orchestrator` | Multi-agent coordination | Complex tasks spanning 3+ domains |
| `project-planner` | Discovery and planning | New project starts, task breakdown |
| `frontend-specialist` | Web UI/UX | React, Next.js, Tailwind, component design |
| `backend-specialist` | API and business logic | Express, FastAPI, database integration |
| `database-architect` | Schema design | Migration, indexing, normalization, query optimization |
| `mobile-developer` | Mobile development | React Native, Flutter, SwiftUI |
| `game-developer` | Game development | Unity, Godot, Phaser, game mechanics |
| `ai-engineer` | AI/ML engineering | LLM applications, RAG systems, agent development |
| `data-engineer` | Data engineering | ETL pipelines, Spark, dbt, Airflow |
| `devops-engineer` | Infrastructure and ops | CI/CD, Docker, Kubernetes, production ops |
| `security-auditor` | Security audit | OWASP, supply chain security, zero trust |
| `penetration-tester` | Penetration testing | Red team operations, exploit development |
| `test-engineer` | Test engineering | TDD, unit/integration/E2E test strategy |
| `qa-automation-engineer` | Test automation | Playwright, Cypress, CI integration |
| `debugger` | Debugging | Root cause analysis, crash investigation |
| `performance-optimizer` | Performance | Web Vitals, profiling, bottleneck detection |
| `seo-specialist` | SEO optimization | Ranking, structured data, Core Web Vitals |
| `documentation-writer` | Technical documentation | API docs, README, user guides |
| `product-owner` | Product management and strategy | Requirements analysis, backlog, MVP, prioritization |
| `api-designer` | API design | REST, GraphQL, gRPC schema and contract design |
| `code-archaeologist` | Legacy code | Old code analysis, modernization strategy |
| `explorer-agent` | Codebase discovery | Deep code scanning and analysis |

### Agent Structure

```markdown
# agents/frontend-specialist.md
---
name: frontend-specialist
skills:
  - react-best-practices
  - frontend-design
  - tailwind-patterns
  - web-design-guidelines
---

## Persona
You are a senior frontend developer with 10+ years of experience...

## Principles
1. Think component-first: every UI piece should be reusable
2. Accessibility (WCAG 2.1 AA) is mandatory, not decorative
3. Performance budget: LCP < 2.5s, CLS < 0.1
...
```

When a frontend task arrives, Claude reads this file, loads the knowledge modules from the `skills:` list, and generates a response using that agent's persona and principles.

---

## Skills (56 Core + 37 Extra)

Skills are domain-specific knowledge modules that agents load during tasks. Each skill contains a `SKILL.md` file and optional `scripts/`, `references/`, `assets/` subdirectories. Agents only load the skills they need -- not all of them.

### Core Skills (56) -- `skills/`

Actively referenced by agents, applicable to every project.

| Category | Count | Examples |
|----------|-------|----------|
| **Backend & API** | 4 | `api-patterns`, `api-security-best-practices`, `nodejs-best-practices`, `backend-dev-guidelines` |
| **Frontend & UI** | 4 | `react-best-practices`, `tailwind-patterns`, `frontend-design`, `web-design-guidelines` |
| **Testing & Quality** | 8 | `testing-patterns`, `tdd-workflow`, `webapp-testing`, `code-review-checklist`, `lint-and-validate` |
| **Security** | 2 | `vulnerability-scanner`, `red-team-tactics` |
| **Architecture** | 5 | `architecture`, `app-builder`, `plan-writing`, `brainstorming`, `architecture-decision-records` |
| **Code Quality** | 4 | `clean-code`, `refactoring-patterns`, `code-refactoring-tech-debt`, `codebase-cleanup-deps-audit` |
| **DevOps & Infra** | 6 | `deployment-procedures`, `server-management`, `monitoring-observability`, `secrets-management` |
| **Documentation** | 5 | `readme`, `documentation-templates`, `code-documentation-doc-generate`, `writing-skills` |
| **Python** | 3 | `python-patterns`, `python-packaging`, `python-testing-patterns` |
| **Shell/CLI** | 3 | `bash-linux`, `powershell-windows`, `linux-shell-scripting` |
| **Mobile & Game** | 2 | `mobile-design`, `game-development` |
| **SEO** | 2 | `seo-fundamentals`, `geo-fundamentals` |
| **Caching & Perf** | 2 | `caching-patterns`, `performance-profiling` |
| **Agent Behavior** | 3 | `behavioral-modes`, `parallel-agents`, `mcp-builder` |
| **Other** | 3 | `rust-pro`, `database-design`, `build-fix` |

### Extra Skills (37) -- `skills-extra/`

Niche, framework-specific, or advanced skills. Not loaded by default agents, but can be activated by moving them to `skills/` and adding them to an agent's frontmatter.

AI/LLM tools (langchain, langfuse, langgraph, rag-engineer, llm-evaluation), ML/Data (ml-engineer, mlops-engineer, data-scientist, airflow-dag-patterns), Monitoring (grafana-dashboards, prometheus-configuration), Agent tools (agent-memory-mcp, agent-tool-builder, agent-evaluation), and more.

---

## Slash Commands (19)

Structured workflows triggered by typing `/command` in chat. 16 workflow commands + 3 skill commands.

### Workflow Commands

| Command | What It Does | Example |
|---------|-------------|---------|
| `/brainstorm` | Generates 3+ different approaches on a topic. Compares pros, cons, and effort level for each option. Provides a clear recommendation. No code -- helps you decide. | `/brainstorm auth system` |
| `/create` | Creates a new feature, component, or module from scratch. Auto-selects the right specialist agent for the domain, creates all necessary files, and delivers a fully working implementation. | `/create user profile page` |
| `/debug` | Investigates bugs through a systematic 4-stage process: symptom collection, hypothesis generation, root cause analysis, fix application. Analyzes logs, stack traces, and error patterns. | `/debug login 500 error` |
| `/deploy` | Manages the deployment process end-to-end. Environment checks, CI/CD pipeline preparation, rollback plan creation, and post-deploy verification steps. | `/deploy production` |
| `/enhance` | Improves existing working code. Performance optimization, readability improvement, or adding new capabilities. Enhances without breaking existing behavior or tests. | `/enhance search performance` |
| `/orchestrate` | Coordinates multiple specialist agents for complex tasks spanning 3+ domains. Manages planning, parallel implementation, and verification phases. The most powerful command. | `/orchestrate full-stack auth` |
| `/plan` | Breaks tasks into subtasks. Determines dependencies, priorities, and completion criteria for each task. Creates a clear roadmap before starting complex work. | `/plan e-commerce MVP` |
| `/preview` | Starts, stops, or checks dev server status. Manages port conflicts, provides hot reload support. | `/preview start 3000` |
| `/refactor` | Systematically restructures code. Applies proven techniques like extract method, SOLID principles, and strangler fig pattern. Improves internal structure without changing behavior. | `/refactor extract auth service` |
| `/review` | Performs comprehensive code review. Checks for security vulnerabilities, performance issues, style inconsistencies, missing tests, and breaking changes. Reports each finding with severity level (Critical/Major/Minor/Nit). | `/review` |
| `/security` | Applies security audit. OWASP top 10 scan, hardcoded secret check, dependency vulnerability audit, input validation, and authentication/authorization checks. | `/security full scan` |
| `/status` | Analyzes current project state. Tech stack detection, file structure mapping, health check, missing dependencies, and configuration issues in a detailed report. | `/status` |
| `/test` | Runs the test suite. Auto-detects package manager (npm/yarn/pnpm/bun), runs unit/integration/E2E tests, and reports failed tests in detail. | `/test unit` |
| `/ui-ux-pro-max` | Creates UI/UX with 50 different design styles. Draws inspiration from CSV databases of color palettes, icon sets, graphic styles, and product layouts. Supports 12 different tech stacks (React, Flutter, SwiftUI, etc.). | `/ui-ux-pro-max dashboard` |
| `/build-fix` | Auto-detects and fixes build/compile errors. Parses error output, matches against common patterns (missing dependency, type error, import error, version conflict), and applies fixes. Retries up to 3 iterations if unsuccessful. | `/build-fix` |
| `/remember` | Memory Bank system. Scans the project to capture patterns, architectural decisions, active context, and resolved issues into persistent files. Claude auto-reads these files when a new session opens -- providing cross-session memory. Sub-commands: `/remember context`, `/remember patterns`, `/remember decisions`, `/remember issues`, `/remember status`. | `/remember` |

### Skill Commands

| Command | What It Does |
|---------|-------------|
| `/brainstorming` | Socratic questioning protocol that auto-activates for complex requests. Asks at least 3 architecturally significant questions before coding -- each question is tied to an implementation decision. In advanced use, initiates a structured design review with 5 agents (Primary Designer, Skeptic, Constraint Guardian, User Advocate, Arbiter). |
| `/simplify` | Scans recent changes for quality: duplicate code blocks, unnecessary complexity, unused imports, and efficiency issues. Auto-fixes if findings exist. |
| `/loop` | Runs a command at recurring intervals. Default is 10 minutes. Ideal for post-deploy monitoring, CI status tracking, or periodic health checks. Example: `/loop 5m /status` |

---

## Hooks -- Automatic Guardrails (4)

Hooks are security and quality checks that run automatically in the background using Claude Code's built-in hook system. You don't need to do anything -- they're active on every file write, every command execution, and every session end.

Configuration: `.agent/.claude/settings.json`

| Hook | Event | Trigger | What It Does |
|------|-------|---------|-------------|
| `dangerous_cmd_check.sh` | PreToolUse | Bash commands | Detects irreversible commands like `rm -rf /`, `git push --force`, `DROP TABLE`, `git reset --hard` and **blocks** them before execution. |
| `secret_scanner.sh` | PreToolUse | Write, Edit | Scans content about to be written for 15+ secret patterns: AWS Access Key, OpenAI API key, GitHub PAT, Stripe key, JWT token. **Blocks** if a match is found. |
| `lint_check.sh` | PostToolUse | Edit, Write | Runs the appropriate linter based on file type after every change: ESLint for JS/TS, Ruff for Python, syntax validation for JSON/YAML. Reports errors to Claude. |
| `session_save.sh` | Stop | Every session end | Writes branch, recent commits, and changed files to `MEMORY-activeContext.md` when a session ends. Part of the Memory Bank system -- automatically updates files created by `/remember`. |

### How It Works

```
User: Run a command containing "rm -rf /"
    │
    ▼
[PreToolUse:Bash hook triggers]
    │
    ▼
dangerous_cmd_check.sh → Pattern matched!
    │
    ▼
Exit code 2 + stderr message → BLOCKED
    │
    ▼
Feedback to Claude: "This command is destructive. Suggesting a safer alternative..."
```

---

## Always-On Rules (5)

Rules under `rules/common/` are automatically applied to every code output. Regardless of which agent is active or which skill is loaded, these rules are enforced.

| Rule | What It Enforces |
|------|-----------------|
| **git-workflow.md** | Conventional Commits format (`feat(scope): description`), branch naming (`feature/`, `fix/`, `hotfix/`), PR standards (title < 70 chars, squash merge preferred) |
| **coding-style.md** | camelCase (JS/TS), snake_case (Python), PascalCase (class/component), import order (stdlib > external > internal > relative), max 300 lines per file |
| **testing.md** | New feature = test required, AAA pattern (Arrange-Act-Assert), 80% unit / 60% integration coverage target, test pyramid (70% unit, 20% integration, 10% E2E) |
| **security.md** | Secrets NEVER hardcoded, all user inputs sanitized, SQL parameterized, XSS encoded, CSRF token required, dependency audit before every deploy |
| **performance.md** | LCP < 2.5s, INP < 200ms, CLS < 0.1, JS bundle < 200KB (gzip), N+1 queries strictly forbidden, lazy loading mandatory, WebP/AVIF preferred |

---

## Context Modes (3)

Mode definitions that adjust Claude's behavior based on task type. Speed during development, thoroughness during review, depth during research.

| Context | When Active | Behavior Change |
|---------|-------------|----------------|
| **dev.md** | Writing new code, prototyping | Fast iteration priority. Debug-friendly output, hot reload suggestions, quick debugging with `console.log` / `print()`. "Working > perfect" principle. |
| **review.md** | PR review, code inspection | Quality checklist active: SOLID principles, security, performance, readability. Breaking change detection. Every finding reported with severity (Critical > Nit). |
| **research.md** | Technology comparison, problem research | Deep analysis mode. Comparison tables, evidence-based recommendations, pros/cons format. Priority on 2024-2026 sources. Always actionable conclusions. |

---

## Scripts (5)

Automation tools you can run from the terminal.

### Validation and Audit

```bash
# Quick validation (during development, before each commit)
python .agent/scripts/checklist.py .
# → Security, Lint, Schema, Test, UX, SEO checks

# Comprehensive validation (pre-deploy, release check)
python .agent/scripts/verify_all.py . --url http://localhost:3000
# → Above plus: Lighthouse, Playwright E2E, Bundle analysis, Mobile audit, i18n check
```

### Dev Server Management

```bash
python .agent/scripts/auto_preview.py start [port]   # Start dev server
python .agent/scripts/auto_preview.py stop            # Stop
python .agent/scripts/auto_preview.py status          # Check status
```

### Project Analysis

```bash
python .agent/scripts/session_manager.py status .     # Project health status
python .agent/scripts/session_manager.py info .       # Tech stack details
```

### Package Manager Detection

```bash
python .agent/scripts/detect_pm.py                    # Detect: npm / yarn / pnpm / bun
python .agent/scripts/detect_pm.py --install          # Correct install command
python .agent/scripts/detect_pm.py --run dev          # Correct run command
python .agent/scripts/detect_pm.py --test             # Correct test command
python .agent/scripts/detect_pm.py --json             # All commands in JSON format
```

Detection priority: lockfile > `package.json` packageManager field > `CLAUDE_PACKAGE_MANAGER` env var > npm fallback

---

## MCP Configuration

Model Context Protocol server example configuration is in `.agent/mcp_config.json.example`:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp", "--api-key", "YOUR_API_KEY"]
    },
    "shadcn": {
      "command": "npx",
      "args": ["shadcn@latest", "mcp"]
    }
  }
}
```

To use, copy `mcp_config.json.example` to `mcp_config.json` and enter your API keys. `.gitignore` already excludes this file -- your secrets are safe.

---

## Memory Bank -- Cross-Session Persistence

Claude Code starts from scratch with every new window. Memory Bank solves this.

Scan your project with the `/remember` command -- Claude writes patterns, architectural decisions, and active context to persistent files:

| File | Content |
|------|---------|
| `MEMORY-activeContext.md` | Which branch, what's being worked on, what was done last session |
| `MEMORY-patterns.md` | Naming conventions, file structure, import style used in the project |
| `MEMORY-decisions.md` | Architectural decisions made (ADR format): why JWT, why PostgreSQL |
| `MEMORY-troubleshooting.md` | Resolved bugs: symptom, root cause, solution |

**How it works:**

```
Session 1: You're building an auth system → /remember
    ↓
Memory files created (patterns, decisions, context)
    ↓
Session ends → session_save.sh auto-updates activeContext
    ↓
Session 2: You open a new window
    ↓
Claude auto-reads memory files via CLAUDE.md instruction
    ↓
You say "add rate limiting" → adds it to the right place with the right pattern, no questions asked
```

Sub-commands: `/remember context`, `/remember patterns`, `/remember decisions`, `/remember issues`, `/remember status`

**Rule:** Append-only. Existing records are never deleted, only new entries are added or old ones marked as `[DEPRECATED]`.

---

## How It Works

### 1. Request Classification

Every request is automatically classified and routed to the right processing:

| Type | Trigger Phrases | What Happens |
|------|----------------|--------------|
| **Question** | "what", "how", "explain", "difference" | Direct text response, no agent loaded |
| **Research** | "analyze", "list", "compare" | Deep analysis with Explore agent |
| **Simple Code** | "fix", "add", "change" (single file) | Relevant agent + inline edit |
| **Complex Code** | "create", "implement", "build" | Plan file + multi-agent coordination |
| **Design** | "design", "UI", "dashboard", "page" | Plan + design agent + UI/UX skills |

### 2. Socratic Gate

For complex requests (the `brainstorming` skill auto-activates), Claude stops before coding and asks questions to clarify architectural decisions:

```
User: "Build an e-commerce site"

Claude:
┌─ CRITICAL: Single vendor or marketplace?
│  → Marketplace: commission logic, seller dashboard, split payment needed
│  → Single vendor: simpler architecture, 3x faster development
│
├─ CRITICAL: Payment method?
│  → Stripe: 2.9% + $0.30, best documentation, US-focused
│  → LemonSqueezy: 5% + $0.50, global tax management included
│
└─ HIGH-LEVERAGE: Physical or digital products?
   → Physical: shipping API integration, tracking system needed
   → Digital: download links, license management sufficient
```

At least 3 questions are asked. Coding **does not begin** without answers.

### 3. Agent Routing

After the request is classified, the right specialist is automatically selected:

```
Frontend task
    │
    ▼
frontend-specialist.md is read
    │
    ▼
skills: [react-best-practices, frontend-design, tailwind-patterns] loaded
    │
    ▼
Output generated with agent persona + skill knowledge + always-on rules
```

### 4. Multi-Agent Orchestration

For tasks spanning 3+ domains, the `orchestrator` agent manages the entire process:

```
/orchestrate full-stack auth
    │
    ▼
Orchestrator:
  Phase 1 (Planning):       project-planner → Task breakdown and dependency map
  Phase 2 (Implementation):
    ├── backend-specialist  → API endpoints, JWT, session management
    ├── frontend-specialist → Login/register UI, form validation
    ├── database-architect  → User table, session table, migration
    └── security-auditor    → Auth flow review, OWASP checks
  Phase 3 (Verification):   test-engineer → Unit + integration + E2E test suite
```

---

## Customization

BDK is fully modular. You can add your own agents, skills, workflows, and hooks.

### Adding a New Agent

Add a new `.md` file to the `agents/` directory:

```markdown
---
name: my-custom-agent
skills:
  - clean-code
  - testing-patterns
---

## Persona
[Define the agent's expertise and behavior style]

## Principles
[List the rules it must follow]
```

### Adding a New Skill

Create `skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: "Short description of what this skill does"
user-invocable: false
---

# Skill Title

[Domain-specific knowledge, rules, patterns, references]
```

### Adding a New Workflow (Slash Command)

Create `workflows/my-command.md`:

```markdown
---
description: Short description of what this command does
---

# /my-command - Command Title

$ARGUMENTS

## Behavior
[Steps to execute when the command is triggered]
```

### Adding / Removing Hooks

Edit `.claude/settings.json`. To disable all hooks:

```json
{ "disableAllHooks": true }
```

---

## Requirements

| Requirement | Description |
|------------|-------------|
| **Claude Code** or **Google Gemini** | As AI assistant (required) |
| **Python 3.8+** | For scripts (checklist, verify, detect_pm) |
| **bash** | For hook scripts |
| **jq** | JSON parsing in hooks (recommended, not required) |

---

## Stats

| Metric | Value |
|--------|-------|
| Agents | 22 |
| Core skills | 56 |
| Extra skills | 37 |
| Workflows | 16 |
| Scripts | 5 |
| Hooks | 4 |
| Always-On rules | 5 |
| Context modes | 3 |
| Supported languages | Python, TypeScript, JavaScript, Rust, Go, Java, C++, Swift |
| Supported frameworks | React, Next.js, FastAPI, Express, Django, Flutter, Unity, Godot |
| Supported platforms | Claude Code, Gemini |

---

## License

MIT
