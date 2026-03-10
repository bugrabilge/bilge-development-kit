---
name: build-fix
description: "Build error diagnosis and resolution. Parses compiler/bundler errors, identifies patterns, and applies targeted fixes."
user-invocable: false
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

# Build Error Resolution Knowledge Base

> Domain knowledge for diagnosing and fixing build errors across frameworks and languages.

---

## Error Pattern Database

### JavaScript / TypeScript

| Error Pattern | Root Cause | Fix |
|--------------|-----------|-----|
| `Cannot find module 'X'` | Package not installed | `npm install X` / `pnpm add X` |
| `Module not found: Can't resolve './X'` | Wrong import path | Check file exists, fix relative path |
| `has no exported member 'X'` | Wrong named import | Check actual exports, use correct name |
| `Type 'X' is not assignable to type 'Y'` | Type mismatch | Add type assertion, narrow type, or fix data |
| `Cannot use JSX unless '--jsx' flag is provided` | tsconfig missing jsx | Add `"jsx": "react-jsx"` to tsconfig |
| `Unexpected token '<'` | JSX in .js file | Rename to .jsx/.tsx or configure babel |
| `ERESOLVE unable to resolve dependency tree` | Peer dep conflict | Use `--legacy-peer-deps` or align versions |
| `JavaScript heap out of memory` | Bundle too large | Increase `NODE_OPTIONS=--max-old-space-size=4096` |

### Python

| Error Pattern | Root Cause | Fix |
|--------------|-----------|-----|
| `ModuleNotFoundError: No module named 'X'` | Package not installed | `pip install X` |
| `ImportError: cannot import name 'X'` | Wrong import or circular | Check actual exports, fix circular deps |
| `SyntaxError: invalid syntax` | Python version or typo | Check Python version, fix syntax |
| `IndentationError` | Mixed tabs/spaces | Normalize indentation |
| `TypeError: X() got unexpected keyword` | API change | Check library version, update call |

### Next.js Specific

| Error Pattern | Root Cause | Fix |
|--------------|-----------|-----|
| `'use client' must be added` | Server/client boundary | Add `'use client'` directive |
| `Dynamic server usage` | Static page using dynamic API | Add `export const dynamic = 'force-dynamic'` |
| `Hydration mismatch` | Server/client HTML differs | Fix conditional rendering, use `suppressHydrationWarning` |

---

## Diagnosis Strategy

```
1. Read FULL error output (don't stop at first error)
2. Group related errors (often one root cause = many symptoms)
3. Fix root cause first (usually the first error chronologically)
4. Re-build after each fix to see if cascading errors resolve
```

## Version Conflict Resolution

```bash
# Check what's installed vs what's needed
npm ls <package>
npm explain <package>

# Common resolution strategies
1. Update the conflicting package
2. Use --legacy-peer-deps (npm)
3. Add overrides/resolutions in package.json
4. Pin compatible versions
```
