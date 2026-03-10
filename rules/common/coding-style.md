# Coding Style Rules

> Always-on naming and organization conventions. Applied to all code output.

---

## Naming Conventions

| Context | Convention | Example |
|---------|-----------|---------|
| JS/TS variables & functions | camelCase | `getUserById`, `isActive` |
| Python variables & functions | snake_case | `get_user_by_id`, `is_active` |
| Classes & Components | PascalCase | `UserProfile`, `AuthService` |
| Constants | UPPER_SNAKE | `MAX_RETRY_COUNT`, `API_BASE_URL` |
| CSS classes | kebab-case | `user-profile`, `nav-item` |
| Database tables | snake_case, plural | `user_profiles`, `order_items` |
| Database columns | snake_case, singular | `created_at`, `first_name` |
| Environment variables | UPPER_SNAKE | `DATABASE_URL`, `NODE_ENV` |
| File names (components) | PascalCase | `UserProfile.tsx` |
| File names (utilities) | camelCase or kebab-case | `formatDate.ts`, `api-client.ts` |

---

## File Organization

- **Single Responsibility:** One primary export per file
- **Max file length:** 300 lines (signal to refactor if exceeded)
- **Group by feature**, not by type (co-locate related files)

### Import Order (enforced)

```
1. Standard library / built-ins
2. External packages (node_modules)
3. Internal modules (absolute paths)
4. Relative imports (./  ../)
5. Type imports (TypeScript)
```

Separate groups with a blank line.

---

## Code Principles

- **Self-documenting:** Names explain purpose. Comments explain WHY, not WHAT.
- **DRY threshold:** 3+ repetitions = extract. 2 is acceptable.
- **Early return:** Reduce nesting. Guard clauses first.
- **No magic numbers:** Extract to named constants.
- **No dead code:** Delete it, don't comment it out. Git has history.
- **Explicit over implicit:** Prefer clarity over cleverness.
