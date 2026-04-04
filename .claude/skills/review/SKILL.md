---
name: review
description: >
  Comprehensive code review with multi-agent analysis.
  Use when: "review", "code review", "check my code", "review PR",
  "audit code", "is this good", "review changes"
argument-hint: "[file/dir|pr|security|performance]"
user-invocable: true
disable-model-invocation: true
---

# /review - Code Review

$ARGUMENTS

---

## Purpose

This command performs a structured code review on specified files, directories, or recent changes.

---

## Sub-commands

```
/review                - Review all staged/unstaged changes
/review [file/dir]     - Review specific file or directory
/review pr             - Review current PR changes
/review security       - Security-focused review
/review performance    - Performance-focused review
```

---

## Behavior

When `/review` is triggered:

1. **Identify scope**
   - What files/changes to review
   - Auto-collect context using tools:
     1. Run `git branch --show-current`
     2. Run `git diff --cached --stat`
     3. Run `git diff --stat`
     4. Run `git log --oneline -5`

2. **Multi-agent analysis**
   Invoke relevant agents based on file types:

   | File Pattern | Agent | Focus |
   |-------------|-------|-------|
   | `*.tsx, *.jsx, *.css` | `frontend-specialist` | Component quality, a11y, performance |
   | `*.ts (server), *.py` | `backend-specialist` | API design, security, error handling |
   | `*.test.*` | `test-engineer` | Test quality, coverage gaps |
   | `prisma/*, migrations/*` | `database-architect` | Schema quality, query performance |
   | `Dockerfile, CI/*` | `devops-engineer` | Config quality, security |
   | All files | `security-auditor` | Vulnerabilities, secrets, OWASP |

3. **Synthesize findings**
   - Combine all agent findings
   - Prioritize by severity
   - Provide actionable fixes

---

## Output Format

```markdown
## Code Review Report

### Scope
[Files reviewed, line count]

### Summary
| Severity | Count |
|----------|-------|
| Critical | X |
| Warning  | X |
| Info     | X |

### Findings

#### Critical
1. **[File:Line]** - [Issue description]
   - Why: [Explanation]
   - Fix: [Code suggestion]

#### Warnings
1. **[File:Line]** - [Issue description]
   - Fix: [Suggestion]

#### Suggestions
1. **[File:Line]** - [Improvement idea]

### Verdict
[APPROVE / REQUEST CHANGES / NEEDS DISCUSSION]
```

---

## Review Dimensions

| Dimension | What to Check |
|-----------|---------------|
| **Correctness** | Logic bugs, edge cases, off-by-one |
| **Security** | Injection, auth gaps, secrets exposure |
| **Performance** | N+1 queries, unnecessary re-renders, large bundles |
| **Maintainability** | Naming, complexity, single responsibility |
| **Type Safety** | Any types, missing generics, unsafe casts |
| **Error Handling** | Uncaught errors, missing fallbacks |
| **Testing** | Missing tests for new logic |

---

## Examples

```
/review
/review src/services/auth.ts
/review src/components/
/review security
/review pr
```

---

## Key Principles

- **Be specific** - Point to exact lines and files
- **Explain why** - Don't just say "bad", explain the risk
- **Suggest fixes** - Provide concrete code alternatives
- **Prioritize** - Critical > Warning > Suggestion
- **Respect intent** - Understand what the code tries to do before critiquing
