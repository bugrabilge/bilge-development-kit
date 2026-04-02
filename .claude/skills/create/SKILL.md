---
name: create
description: >
  Scaffold a full-stack application from a natural language description.
  Generates project structure, database schema, backend API, and frontend UI
  by orchestrating specialist agents (project-planner, database-architect,
  backend-specialist, frontend-specialist).

  Use when: the user wants to create an app, build a new project, scaffold
  an application, generate a web app, or says "create", "build me", "make
  an app", "new project", "scaffold".
user-invocable: true
disable-model-invocation: true
---

# /create - Create Application

$ARGUMENTS

---

## Task

This command starts a new application creation process.

### Steps:

1. **Request Analysis**
   - Understand what the user wants
   - If information is missing, use `conversation-manager` skill to ask

2. **Project Planning**
   - Use `project-planner` agent for task breakdown
   - Determine tech stack
   - Plan file structure
   - Create plan file and proceed to building

3. **Application Building (After Approval)**
   - Orchestrate with `app-builder` skill
   - Coordinate expert agents:
     - `database-architect` → Schema
     - `backend-specialist` → API
     - `frontend-specialist` → UI

4. **Preview**
   - Start with `auto_preview.py` when complete
   - Present URL to user

---

## Usage Examples

```
/create blog site
/create e-commerce app with product listing and cart
/create todo app
/create Instagram clone
/create crm system with customer management
```

---

## Before Starting

If request is unclear, ask:
- What type of application?
- What are the basic features?
- Who will use it?

Defaults: FastAPI backend, React frontend, SQLite database. Add details later.

## Error Recovery

| Problem | Action |
|---|---|
| User request too vague | Use `conversation-manager` to clarify before planning |
| Plan rejected by user | Revise with `project-planner`, do not proceed to build |
| Agent fails mid-build | Retry the failing agent, do not restart from scratch |
| Preview fails to start | Check `auto_preview.py` logs, fix config, retry |
