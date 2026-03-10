---
name: app-builder
description: "Full-stack application scaffolding, project templates, monorepo setup, and CI/CD configuration for rapid project bootstrapping."
---

# App Builder

> "Weeks of coding can save you hours of planning." -- Unknown

## When to Use
- Scaffolding a new full-stack application from scratch
- Setting up monorepo structures with multiple packages or services
- Configuring CI/CD pipelines for automated testing and deployment
- Choosing and configuring project templates and starter kits
- Establishing project conventions (linting, formatting, commit hooks)
- Planning technology stack decisions for new projects

## Project Scaffolding Principles

### Before Writing Code
1. **Define the scope:** What does the MVP look like? What are the core features?
2. **Choose the stack:** Pick technologies based on team expertise, requirements, and ecosystem maturity
3. **Design the data model:** Sketch entities, relationships, and access patterns before coding
4. **Plan the API surface:** Define endpoints or queries/mutations before implementing
5. **Set up the repository:** Structure, tooling, and CI/CD before feature development

### Directory Structure Conventions
A well-organized project follows predictable patterns:

```
project-root/
  apps/               # Application entry points
    web/              # Frontend application
    api/              # Backend API server
    mobile/           # Mobile application
  packages/           # Shared libraries
    ui/               # Shared UI components
    config/           # Shared configurations
    types/            # Shared TypeScript types
    utils/            # Shared utility functions
  infra/              # Infrastructure as code
  scripts/            # Build and maintenance scripts
  docs/               # Project documentation
```

## Technology Stack Selection

### Frontend Frameworks
| Framework | Best For | Considerations |
|-----------|----------|---------------|
| Next.js | Full-stack React, SSR/SSG, SEO | Vercel ecosystem, app router maturity |
| Nuxt | Full-stack Vue, SSR/SSG | Vue ecosystem, auto-imports |
| SvelteKit | Performance-critical apps | Smaller ecosystem, growing fast |
| Remix | Nested routing, progressive enhancement | React Router foundation |
| Astro | Content-heavy sites, multi-framework | Content collections, island architecture |

### Backend Frameworks
| Framework | Language | Best For |
|-----------|----------|----------|
| Next.js API / Server Actions | TypeScript | Unified full-stack with React |
| FastAPI | Python | ML/AI backends, data-heavy APIs |
| Express / Fastify | Node.js | Flexible REST APIs, real-time apps |
| NestJS | TypeScript | Enterprise APIs, structured architecture |
| Django | Python | Admin-heavy apps, rapid CRUD |
| Go (Chi/Gin/Echo) | Go | High-performance microservices |

### Database Selection
- **PostgreSQL:** Default choice for relational data, JSON support, full-text search
- **SQLite (Turso/libSQL):** Embedded or edge databases, simpler deployments
- **MongoDB:** Document-oriented, flexible schema, rapid prototyping
- **Redis:** Caching, sessions, queues, real-time leaderboards
- **Supabase:** Managed Postgres with auth, storage, and real-time built in

### ORM and Data Layer
- **Prisma:** Type-safe, great DX, schema-first approach
- **Drizzle:** Lightweight, SQL-like syntax, great performance
- **TypeORM:** Decorator-based, good for NestJS
- **SQLAlchemy:** Python standard, flexible and powerful
- **Kysely:** Type-safe SQL query builder (no schema generation)

## Monorepo Setup

### Monorepo Tools
- **Turborepo:** Fast builds with caching, minimal config, great for JS/TS
- **Nx:** Full-featured with dependency graph, generators, and plugins
- **pnpm workspaces:** Package management with workspace protocol
- **Yarn workspaces:** Mature workspace support with hoisting

### Turborepo Configuration
Key files for a Turborepo monorepo:
- `turbo.json` - Define pipeline tasks, caching rules, and dependencies
- `pnpm-workspace.yaml` - Define workspace packages
- Root `package.json` - Shared dev dependencies and workspace scripts

### Monorepo Best Practices
- Share TypeScript configs via a `@repo/typescript-config` package
- Share ESLint configs via a `@repo/eslint-config` package
- Use internal packages with `"main": "./src/index.ts"` for development (no build step)
- Build only for production deployments
- Use `--filter` to run commands on specific packages
- Set up remote caching (Vercel, Nx Cloud) for CI speedup

## CI/CD Configuration

### GitHub Actions Pipeline
Essential workflows for any project:

**PR Checks (on pull_request):**
1. Lint and type-check
2. Run unit and integration tests
3. Build all packages to verify compilation
4. Run E2E tests (optionally on merge only)
5. Deploy preview environment

**Main Branch (on push to main):**
1. All PR checks
2. Build production artifacts
3. Deploy to staging
4. Run smoke tests against staging
5. Deploy to production (manual approval or auto)

### Pipeline Optimization
- Cache `node_modules` and build outputs between runs
- Use matrix builds for cross-platform/cross-version testing
- Run independent jobs in parallel (lint, test, build)
- Use path filters to skip unchanged packages
- Pin action versions to specific SHAs for security

### Environment Management
- Use GitHub Environments for staging/production with protection rules
- Store secrets in GitHub Secrets, never in code
- Use environment-specific `.env` files with `.env.example` as template
- Implement feature flags for gradual rollouts
- Use preview deployments for every PR (Vercel, Netlify, Cloudflare Pages)

## Project Setup Checklist

### Code Quality Tooling
- **ESLint:** Linting with framework-specific plugins (next, react, vue)
- **Prettier:** Code formatting with consistent config
- **TypeScript:** Strict mode enabled (`strict: true`)
- **Husky + lint-staged:** Pre-commit hooks for linting and formatting
- **commitlint:** Enforce conventional commit messages

### Testing Setup
- **Vitest:** Unit and integration testing (fast, Vite-native)
- **Playwright:** E2E testing with cross-browser support
- **MSW:** Mock Service Worker for API mocking in tests and development
- **Testing Library:** Component testing for React/Vue/Svelte

### Development Experience
- **Hot reload:** Ensure fast feedback loops in development
- **Path aliases:** Use `@/` for clean imports (configure in tsconfig and bundler)
- **Error overlay:** Framework dev servers show errors in-browser
- **API proxy:** Configure dev server to proxy API requests (avoid CORS in dev)

## Authentication Setup
- Use established libraries: NextAuth.js/Auth.js, Clerk, Lucia, Supabase Auth
- Never roll your own auth unless you have specific requirements
- Implement OAuth providers (Google, GitHub) for quick onboarding
- Add email/password as fallback
- Set up RBAC (role-based access control) from the start
- Use middleware for route protection, not per-page checks

## Deployment Patterns

### Platform Selection
- **Vercel:** Best for Next.js, automatic previews, edge functions
- **Cloudflare Pages/Workers:** Edge-first, cost-effective, fast globally
- **Railway/Render:** Simple container hosting, good for backends
- **Fly.io:** Multi-region deployment, good for latency-sensitive apps
- **AWS/GCP/Azure:** Full control, complex setup, use for enterprise requirements

### Infrastructure as Code
- Use Terraform, Pulumi, or SST for reproducible infrastructure
- Define environments (dev, staging, production) as code
- Version control all infrastructure definitions
- Use modules/constructs for reusable infrastructure patterns
- Document manual setup steps that cannot be automated

## Common Starter Recipes

### SaaS Starter
- Next.js + Prisma + PostgreSQL + NextAuth + Stripe + Tailwind
- Landing page, auth, dashboard, billing, admin panel
- Multi-tenant architecture from day one

### API Service
- FastAPI/NestJS + PostgreSQL + Redis + Docker
- OpenAPI documentation auto-generated
- Rate limiting, authentication, logging, health checks

### Content Site
- Astro/Next.js + CMS (Sanity/Contentful/MDX) + Tailwind
- SEO-optimized, fast builds, preview mode for editors
- Image optimization, sitemap generation, RSS feed
