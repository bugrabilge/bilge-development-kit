---
user-invocable: false
name: nodejs-best-practices
description: "Node.js patterns, async/await best practices, error handling, security hardening, performance optimization, and project structure. Use when building or reviewing Node.js backends and services."
---

# Node.js Best Practices

> "Node.js excels when you respect its single-threaded, event-driven nature; fight it and you lose."

## When to Use
- Building Node.js backend services or APIs
- Reviewing Node.js code for anti-patterns and security issues
- Optimizing Node.js application performance
- Structuring a new Node.js project
- Handling errors, logging, and graceful shutdown

## Project Structure

### Layered Architecture
```
src/
  config/           # Environment config, constants
  routes/           # Route definitions (Express/Fastify)
  controllers/      # Request handling, input validation
  services/         # Business logic (framework-agnostic)
  repositories/     # Data access layer (DB queries)
  middleware/       # Auth, rate limiting, error handling
  models/           # Database models / schemas
  utils/            # Pure utility functions
  types/            # TypeScript type definitions
  jobs/             # Background jobs, cron tasks
  __tests__/        # Test files mirroring src structure
```

### Key Principles
- Separate business logic from framework code; services should not import Express
- Each module exports a clear interface; avoid circular dependencies
- Use dependency injection for testability (pass dependencies as function/constructor args)
- Keep the entry point (index.ts / app.ts) thin: wire up middleware, routes, and start server

## Async/Await Patterns

### Always Use async/await Over Raw Callbacks
- Never mix callbacks and promises in the same flow
- Use util.promisify() to convert legacy callback APIs
- Avoid the async/await + .then() hybrid; choose one style

### Parallel Execution
- Use `Promise.all()` when all promises are independent and all must succeed
- Use `Promise.allSettled()` when you need results from all, even if some fail
- Use `Promise.race()` for timeouts: race the operation against a timer promise
- Limit concurrency for bulk operations with p-limit or p-map

### Common Pitfalls
- Forgetting await: `const data = fetchData()` returns a Promise, not data
- Await inside loops: sequential when you want parallel; use Promise.all with map instead
- Unhandled promise rejections: always catch at the top level or use process event handlers
- Async functions always return promises; do not mix with synchronous return expectations

## Error Handling

### Error Classification
- **Operational errors**: expected failures (DB down, invalid input, network timeout) -- handle gracefully
- **Programmer errors**: bugs (TypeError, null reference) -- crash and restart; do not attempt to recover

### Error Handling Strategy
```typescript
// Custom error class
class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public isOperational: boolean = true,
    public code?: string
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

// Central error handler middleware (Express)
function errorHandler(err, req, res, next) {
  if (err.isOperational) {
    return res.status(err.statusCode).json({
      error: { message: err.message, code: err.code }
    });
  }
  // Programmer error: log and return generic message
  logger.error('Unexpected error', { error: err, stack: err.stack });
  return res.status(500).json({ error: { message: 'Internal server error' } });
}
```

### Process-Level Error Handling
- Listen for `unhandledRejection` and `uncaughtException` events
- Log the error, then exit the process; let the process manager (PM2, Docker) restart
- Never swallow unhandled exceptions; they indicate unknown state

## Security

### Input Validation
- Validate all input at the boundary (controllers/routes) using Zod, Joi, or class-validator
- Sanitize HTML input to prevent XSS (use DOMPurify or sanitize-html)
- Use parameterized queries / ORM methods to prevent SQL injection; never interpolate user input

### Authentication and Authorization
- Store passwords with bcrypt (cost factor 12+) or argon2
- Use JWTs with short expiry (15 min) + refresh tokens for session management
- Validate JWTs on every request; check issuer, audience, and expiry
- Implement role-based or attribute-based access control in middleware

### HTTP Security Headers
- Use helmet middleware to set security headers automatically
- Set Content-Security-Policy to restrict resource loading
- Enable Strict-Transport-Security (HSTS) for HTTPS enforcement
- Set X-Content-Type-Options: nosniff, X-Frame-Options: DENY

### Secrets Management
- Never commit secrets to version control; use .env files locally, secrets manager in production
- Validate required environment variables at startup; fail fast if missing
- Use different secrets per environment (dev, staging, prod)

### Rate Limiting
- Apply rate limiting to authentication endpoints (stricter) and API endpoints (standard)
- Use express-rate-limit or fastify-rate-limit with a Redis store for distributed deployments
- Return 429 with Retry-After header

## Performance

### Event Loop Health
- Never block the event loop with CPU-intensive work (crypto, image processing, JSON parsing of huge payloads)
- Offload heavy computation to worker threads (worker_threads module) or a job queue
- Monitor event loop lag with `monitorEventLoopDelay` from perf_hooks
- Set appropriate timeouts on HTTP requests and database queries

### Memory Management
- Monitor heap usage with `process.memoryUsage()`
- Stream large files instead of loading them entirely into memory
- Use `--max-old-space-size` to set heap limits explicitly
- Watch for common memory leaks: growing arrays, unclosed event listeners, forgotten intervals

### Database Connection Pooling
- Always use connection pools; never create a new connection per request
- Set pool size based on available DB connections divided by app instances
- Close pools gracefully on shutdown

### Caching
- Cache expensive computations and frequent DB queries in Redis or in-memory (node-cache)
- Use Cache-Control headers for HTTP caching
- Implement cache invalidation strategy; stale data is worse than no cache

## Logging and Observability

### Structured Logging
- Use a structured logger (pino, winston) that outputs JSON in production
- Include correlation/request IDs in every log entry for tracing
- Log levels: error (failures), warn (degraded), info (key events), debug (development)
- Never log sensitive data: passwords, tokens, PII

### Health Checks
- Expose /health endpoint that checks DB connectivity, Redis, and external dependencies
- Return 200 with dependency status for orchestrators (Kubernetes liveness/readiness probes)
- Separate liveness (app is running) from readiness (app can serve traffic)

## Graceful Shutdown
```typescript
async function shutdown(signal: string) {
  logger.info(`Received ${signal}, shutting down gracefully`);
  // 1. Stop accepting new connections
  server.close();
  // 2. Finish in-flight requests (give them a timeout)
  await drainConnections(30_000);
  // 3. Close DB pools, Redis clients, message queues
  await db.end();
  await redis.quit();
  // 4. Exit
  process.exit(0);
}
process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));
```

## Testing
- Use Vitest or Jest for unit and integration tests
- Mock external services at the network level with MSW or nock
- Test error paths as thoroughly as happy paths
- Use supertest or light-my-request for HTTP endpoint testing
- Run tests with `--detectOpenHandles` to catch resource leaks
