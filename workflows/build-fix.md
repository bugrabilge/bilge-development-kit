---
description: Diagnose and fix build errors automatically. Parses error output, identifies common patterns, and applies fixes.
---

# /build-fix - Build Error Resolver

$ARGUMENTS

---

## Purpose

Automatically diagnose and resolve build/compile errors. Parses error output, matches common patterns, and applies targeted fixes.

---

## Behavior

When `/build-fix` is triggered:

### Step 1: Detect Build System
```bash
python .agent/scripts/detect_pm.py --json
```
Identify: package manager, framework (Next.js, Vite, CRA, etc.), language (TS/JS/Python).

### Step 2: Run Build
Execute the build command and capture output:
```bash
$(python .agent/scripts/detect_pm.py --run build) 2>&1
```

If user provided error text as argument, use that instead of running build.

### Step 3: Parse Errors
Classify each error into categories:

| Category | Pattern Examples | Fix Strategy |
|----------|-----------------|-------------|
| **Missing dependency** | `Cannot find module`, `ModuleNotFoundError` | Install the package |
| **Type error** | `Type 'X' is not assignable`, `has no exported member` | Fix type mismatch |
| **Import error** | `Cannot find module './X'`, `No such file` | Fix path or create file |
| **Syntax error** | `Unexpected token`, `SyntaxError` | Fix syntax at line |
| **Version conflict** | `peer dep`, `ERESOLVE`, `incompatible version` | Resolve version |
| **Config error** | `Invalid configuration`, `Unknown option` | Fix config file |
| **Memory/resource** | `ENOMEM`, `heap out of memory` | Increase limit or optimize |

### Step 4: Apply Fixes
For each error (priority order):
1. Read the affected file
2. Understand the context
3. Apply the minimal fix
4. Verify the fix doesn't break other things

### Step 5: Verify
Re-run the build. If it passes, report success. If new errors appear, repeat from Step 3 (max 3 iterations).

---

## Output Format

```markdown
## Build Fix Report

### Errors Found: [count]

#### Error 1: [Category]
- **File:** [path:line]
- **Message:** [error text]
- **Fix:** [what was changed]
- **Status:** Fixed / Needs manual review

---

### Build Result: PASS / FAIL
[If FAIL: remaining errors that need manual attention]
```

---

## Common Fix Patterns

### Missing Dependency
```bash
# Auto-install
$(python .agent/scripts/detect_pm.py --add <package>)
```

### TypeScript Errors
- Missing type: Add type annotation or import
- Incompatible type: Narrow type or add type assertion
- Missing property: Add optional chaining or default value

### Import Resolution
- Relative path wrong: Fix `./` vs `../` vs `@/`
- Missing file: Create stub or check spelling
- Circular dependency: Restructure imports

---

## Key Principles

- **Minimal fixes** - Change only what's broken, don't refactor
- **One error at a time** - Fix in dependency order (imports before types)
- **Max 3 iterations** - If still failing after 3 rounds, report and stop
- **Never ignore errors** - Every error gets addressed or documented
