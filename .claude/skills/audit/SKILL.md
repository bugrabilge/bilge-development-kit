---
name: audit
description: >
  Full codebase audit: architecture health, dependencies, complexity, tech debt.
  Use when: "audit", "health check", "codebase analysis", "tech debt",
  "architecture review", "dependency check", "code quality"
argument-hint: "[dependencies|complexity|architecture|full]"
user-invocable: true
disable-model-invocation: true
---

# /audit - Codebase Audit

$ARGUMENTS

---

## Purpose

Project-wide codebase health analysis. Unlike `/review` (file/PR focused), `/audit` examines the entire project: architecture patterns, dependency risks, complexity hotspots, and tech debt.

---

## Sub-commands

```
/audit                - Full audit (all dimensions)
/audit architecture   - Architecture patterns and violations
/audit dependencies   - Dependency graph, outdated/vulnerable packages
/audit complexity     - Cyclomatic complexity hotspots
/audit tech-debt      - Tech debt inventory with effort estimates
/audit size           - File/module size analysis
```

---

## Behavior

When `/audit` is triggered:

### 1. Project Discovery

Auto-collect project context using Read, Glob, and Grep tools:

1. **Tech stack**: Read `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`
2. **File count**: Use Glob to count source files
3. **Lines of code**: Use Bash with simple commands (no pipes)
4. **Recent commits**: Use `git log --oneline -10`

### 2. Architecture Audit

Analyze project structure for:

| Check | What to Look For |
|-------|-----------------|
| **Pattern consistency** | Is it feature-based, domain-driven, or flat? Are there violations? |
| **Circular dependencies** | Import cycles between modules |
| **Layer violations** | UI importing from DB layer, utils importing from features |
| **Dead code** | Exported but never imported files/functions |
| **Config sprawl** | Too many config files at root level |
| **Entry point clarity** | Is the app's starting point obvious? |

### 3. Dependency Audit

```bash
# Node.js
npm audit 2>/dev/null || true
npm outdated 2>/dev/null || true

# Python
pip audit 2>/dev/null || true
pip list --outdated 2>/dev/null || true

# General
cat package-lock.json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(f'Total deps: {len(d.get(\"packages\",{}))}')" 2>/dev/null || true
```

Check for:
- **Vulnerable packages** — known CVEs
- **Outdated majors** — 2+ major versions behind
- **Abandoned packages** — no updates in 2+ years
- **Duplicate packages** — same functionality, different libs
- **Bundle impact** — largest dependencies by size

### 4. Complexity Audit

Identify the most complex files:

| Metric | Threshold | Action |
|--------|-----------|--------|
| **File LOC > 500** | Warning | Consider splitting |
| **File LOC > 1000** | Critical | Must split |
| **Function LOC > 50** | Warning | Extract subfunctions |
| **Function LOC > 100** | Critical | Refactor immediately |
| **Nesting depth > 4** | Warning | Flatten with early returns |
| **Parameters > 5** | Warning | Use options object |
| **Imports > 15** | Warning | File doing too much |

Scan for complexity hotspots:
```bash
# Find largest files (excluding generated/vendor)
find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.py" \) \
  -not -path '*/node_modules/*' -not -path '*/.next/*' -not -path '*/dist/*' \
  -exec wc -l {} + | sort -rn | head -20
```

### 5. Tech Debt Inventory

Search for debt indicators:
```bash
# TODO/FIXME/HACK comments
grep -rn "TODO\|FIXME\|HACK\|XXX\|WORKAROUND" --include="*.ts" --include="*.tsx" --include="*.py" --include="*.js" . 2>/dev/null | grep -v node_modules

# Any types in TypeScript
grep -rn ": any" --include="*.ts" --include="*.tsx" . 2>/dev/null | grep -v node_modules | wc -l

# Console.log left in code
grep -rn "console\.log" --include="*.ts" --include="*.tsx" --include="*.js" . 2>/dev/null | grep -v node_modules | wc -l

# Disabled linting rules
grep -rn "eslint-disable\|noqa\|type: ignore" --include="*.ts" --include="*.tsx" --include="*.py" . 2>/dev/null | grep -v node_modules | wc -l
```

### 6. Generate Report

---

## Output Format

```markdown
## Codebase Audit Report

### Project Overview
- **Name:** {name}
- **Stack:** {framework} + {language}
- **Size:** {file count} files, {LOC} lines of code
- **Dependencies:** {dep count} packages

---

### Health Score: {X}/100

| Dimension | Score | Grade |
|-----------|-------|-------|
| Architecture | {0-25} | {A-F} |
| Dependencies | {0-25} | {A-F} |
| Complexity | {0-25} | {A-F} |
| Tech Debt | {0-25} | {A-F} |

---

### Architecture
{Pattern detected, violations found}

### Dependencies
| Status | Count |
|--------|-------|
| Vulnerable | {X} |
| Outdated (major) | {X} |
| Abandoned | {X} |

Top risks:
1. {package} — {reason}

### Complexity Hotspots
| File | Lines | Imports | Issue |
|------|-------|---------|-------|
| {path} | {LOC} | {count} | {description} |

### Tech Debt
| Type | Count | Severity |
|------|-------|----------|
| TODO/FIXME | {X} | Low |
| `any` types | {X} | Medium |
| console.log | {X} | Low |
| Lint bypasses | {X} | Medium |
| Dead code | {X} | Low |

### Top 5 Recommendations
1. **[Critical]** {action}
2. **[High]** {action}
3. **[Medium]** {action}
4. **[Medium]** {action}
5. **[Low]** {action}

### Next Steps
- [ ] Fix critical findings
- [ ] Run `/security` for detailed vulnerability analysis
- [ ] Run `/refactor` on complexity hotspots
- [ ] Schedule tech debt cleanup sprint
```

---

## Examples

```
/audit
/audit architecture
/audit dependencies
/audit complexity
/audit tech-debt
/audit size
```

---

## Key Principles

- **Measure, don't guess** — use actual metrics, not impressions
- **Prioritize by risk** — critical security > complexity > style
- **Actionable output** — every finding has a recommended action
- **No false alarms** — only flag real issues, not style preferences
- **Compare to baseline** — track improvement over time
