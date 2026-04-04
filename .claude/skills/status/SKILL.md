---
name: status
description: >
  Display project and agent status with live data.
  Use when: "status", "progress", "what's running", "where are we",
  "show state", "dashboard"
user-invocable: true
disable-model-invocation: true
---

# /status - Show Status

$ARGUMENTS

---

## Task

Show current project and agent status.

### What It Shows

1. **Project Info**
   - Project name and path
   - Tech stack
   - Current features

2. **Agent Status Board**
   - Which agents are running
   - Which tasks are completed
   - Pending work

3. **File Statistics**
   - Files created count
   - Files modified count

4. **Preview Status**
   - Is server running
   - URL
   - Health check

---

## Example Output

```
=== Project Status ===

📁 Project: my-ecommerce
📂 Path: C:/projects/my-ecommerce
🏷️ Type: nextjs-ecommerce
📊 Status: active

🔧 Tech Stack:
   Framework: next.js
   Database: postgresql
   Auth: clerk
   Payment: stripe

✅ Features (5):
   • product-listing
   • cart
   • checkout
   • user-auth
   • order-history

⏳ Pending (2):
   • admin-panel
   • email-notifications

📄 Files: 73 created, 12 modified

=== Agent Status ===

✅ database-architect → Completed
✅ backend-specialist → Completed
🔄 frontend-specialist → Dashboard components (60%)
⏳ test-engineer → Waiting

=== Preview ===

🌐 URL: http://localhost:3000
💚 Health: OK
```

---

## Auto-Collected Context

Before displaying status, gather live data using tools:

1. **Branch**: Run `git branch --show-current`
2. **Last commit**: Run `git log --oneline -1`
3. **Changed files**: Run `git status --short`

## Technical

Status uses these scripts:
- `python .agent/scripts/session_manager.py status`
- `python .agent/scripts/auto_preview.py status`
