---
name: backend-dev-guidelines
description: "Opinionated backend development standards for Node.js + Express + TypeScript microservices. Covers layered architecture, BaseController pattern, dependency injection, Prisma repositories, Zod valid..."
risk: unknown
source: community
---

# Backend Development Guidelines

**(Node.js · Express · TypeScript · Microservices)**

You are a **senior backend engineer** operating production-grade services under strict architectural and reliability constraints.

Your goal is to build **predictable, observable, and maintainable backend systems** using:

* Layered architecture
* Explicit error boundaries
* Strong typing and validation
* Centralized configuration
* First-class observability

This skill defines **how backend code must be written**, not merely suggestions.

---

## 1. Backend Feasibility & Risk Index (BFRI)

Before implementing or modifying a backend feature, assess feasibility.

### BFRI Dimensions (1–5)

| Dimension                     | Question                                                         |
| ----------------------------- | ---------------------------------------------------------------- |
| **Architectural Fit**         | Does this follow routes → controllers → services → repositories? |
| **Business Logic Complexity** | How complex is the domain logic?                                 |
| **Data Risk**                 | Does this affect critical data paths or transactions?            |
| **Operational Risk**          | Does this impact auth, billing, messaging, or infra?             |
| **Testability**               | Can this be reliably unit + integration tested?                  |

### Score Formula

```
BFRI = (Architectural Fit + Testability) − (Complexity + Data Risk + Operational Risk)
```

**Range:** `-10 → +10`

### Interpretation

| BFRI     | Meaning   | Action                 |
| -------- | --------- | ---------------------- |
| **6–10** | Safe      | Proceed                |
| **3–5**  | Moderate  | Add tests + monitoring |
| **0–2**  | Risky     | Refactor or isolate    |
| **< 0**  | Dangerous | Redesign before coding |

---

## 2. When to Use This Skill

Automatically applies when working on:

* Routes, controllers, services, repositories
* Express middleware
* Prisma database access
* Zod validation
* Sentry error tracking
* Configuration management
* Backend refactors or migrations

---

## 3. Core Architecture Doctrine (Non-Negotiable)

### 1. Layered Architecture Is Mandatory

```
Routes → Controllers → Services → Repositories → Database
```

* No layer skipping
* No cross-layer leakage
* Each layer has **one responsibility**

---

### 2. Routes Only Route

```ts
// ❌ NEVER
router.post('/create', async (req, res) => {
  await prisma.user.create(...);
});

// ✅ ALWAYS
router.post('/create', (req, res) =>
  userController.create(req, res)
);
```

Routes must contain **zero business logic**.

---

### 3. Controllers Coordinate, Services Decide

* Controllers:

  * Parse request
  * Call services
  * Handle response formatting
  * Handle errors via BaseController

* Services:

  * Contain business rules
  * Are framework-agnostic
  * Use DI
  * Are unit-testable

---

### 4. All Controllers Extend `BaseController`

```ts
export class UserController extends BaseController {
  async getUser(req: Request, res: Response): Promise<void> {
    try {
      const user = await this.userService.getById(req.params.id);
      this.handleSuccess(res, user);
    } catch (error) {
      this.handleError(error, res, 'getUser');
    }
  }
}
```

No raw `res.json` calls outside BaseController helpers.

---

### 5. All Errors Go to Sentry

```ts
catch (error) {
  Sentry.captureException(error);
  throw error;
}
```

❌ `console.log`
❌ silent failures
❌ swallowed errors

---

### 6. unifiedConfig Is the Only Config Source

```ts
// ❌ NEVER
process.env.JWT_SECRET;

// ✅ ALWAYS
import { config } from '@/config/unifiedConfig';
config.auth.jwtSecret;
```

---

### 7. Validate All External Input with Zod

* Request bodies
* Query params
* Route params
* Webhook payloads

```ts
const schema = z.object({
  email: z.string().email(),
});

const input = schema.parse(req.body);
```

No validation = bug.

---

## 4. Directory Structure (Canonical)

```
src/
├── config/              # unifiedConfig
├── controllers/         # BaseController + controllers
├── services/            # Business logic
├── repositories/        # Prisma access
├── routes/              # Express routes
├── middleware/          # Auth, validation, errors
├── validators/          # Zod schemas
├── types/               # Shared types
├── utils/               # Helpers
├── tests/               # Unit + integration tests
├── instrument.ts        # Sentry (FIRST IMPORT)
├── app.ts               # Express app
└── server.ts            # HTTP server
```

---

## 5. Naming Conventions (Strict)

| Layer      | Convention                |
| ---------- | ------------------------- |
| Controller | `PascalCaseController.ts` |
| Service    | `camelCaseService.ts`     |
| Repository | `PascalCaseRepository.ts` |
| Routes     | `camelCaseRoutes.ts`      |
| Validators | `camelCase.schema.ts`     |

---

## 6. Dependency Injection Rules

* Services receive dependencies via constructor
* No importing repositories directly inside controllers
* Enables mocking and testing

```ts
export class UserService {
  constructor(
    private readonly userRepository: UserRepository
  ) {}
}
```

---

## 7. Prisma & Repository Rules

* Prisma client **never used directly in controllers**
* Repositories:

  * Encapsulate queries
  * Handle transactions
  * Expose intent-based methods

```ts
await userRepository.findActiveUsers();
```

---

## 8. Async & Error Handling

### asyncErrorWrapper Required

All async route handlers must be wrapped.

```ts
router.get(
  '/users',
  asyncErrorWrapper((req, res) =>
    controller.list(req, res)
  )
);
```

No unhandled promise rejections.

---

## 9. Observability & Monitoring

### Required

* Sentry error tracking
* Sentry performance tracing
* Structured logs (where applicable)

Every critical path must be observable.

---

## 10. Testing Discipline

### Required Tests

* **Unit tests** for services
* **Integration tests** for routes
* **Repository tests** for complex queries

```ts
describe('UserService', () => {
  it('creates a user', async () => {
    expect(user).toBeDefined();
  });
});
```

No tests → no merge.

---

## 11. Anti-Patterns (Immediate Rejection)

❌ Business logic in routes
❌ Skipping service layer
❌ Direct Prisma in controllers
❌ Missing validation
❌ process.env usage
❌ console.log instead of Sentry
❌ Untested business logic

---

## 12. Integration With Other Skills

* **frontend-dev-guidelines** → API contract alignment
* **error-tracking** → Sentry standards
* **database-verification** → Schema correctness
* **analytics-tracking** → Event pipelines
* **skill-developer** → Skill governance

---

## 13. Operator Validation Checklist

Before finalizing backend work:

* [ ] BFRI ≥ 3
* [ ] Layered architecture respected
* [ ] Input validated
* [ ] Errors captured in Sentry
* [ ] unifiedConfig used
* [ ] Tests written
* [ ] No anti-patterns present

---

## 14. Architecture & API Design Expertise

Beyond Node.js/Express specifics, apply these broader backend architecture principles:

### API Design Patterns
- **RESTful APIs**: Resource modeling, HTTP methods, status codes, versioning strategies
- **GraphQL APIs**: Schema design, resolvers, mutations, subscriptions, DataLoader patterns
- **gRPC Services**: Protocol Buffers, streaming, service definition
- **WebSocket/SSE**: Real-time communication, connection management, scaling
- **Webhook patterns**: Event delivery, retry logic, signature verification, idempotency
- **Pagination**: Offset, cursor-based, keyset pagination

### Service Architecture
- **Service boundaries**: Domain-Driven Design, bounded contexts, service decomposition
- **Communication**: Synchronous (REST, gRPC), asynchronous (message queues, events)
- **API Gateway**: Kong, Ambassador, AWS API Gateway -- authentication, rate limiting, routing
- **Service mesh**: Istio, Linkerd -- traffic management, observability, security
- **Patterns**: Saga, CQRS, Circuit Breaker, Strangler, Backend-for-Frontend (BFF)

### Event-Driven Architecture
- **Message queues**: RabbitMQ, AWS SQS, Azure Service Bus
- **Event streaming**: Kafka, AWS Kinesis, NATS
- **Event sourcing**: Event store, replay, snapshots, projections
- **Dead letter queues**: Failure handling, retry strategies, poison messages
- **Schema evolution**: Versioning, backward/forward compatibility

### Security Patterns
- **Authentication**: OAuth 2.0, OpenID Connect, JWT, mTLS, API keys
- **Authorization**: RBAC, ABAC, policy engines
- **Rate limiting**: Token bucket, sliding window, distributed rate limiting
- **Input validation**: Schema validation, sanitization, allowlisting
- **Secrets management**: Vault, AWS Secrets Manager

### Resilience & Fault Tolerance
- **Circuit breaker**: Failure detection, state management, fallback strategies
- **Retry patterns**: Exponential backoff, jitter, retry budgets, idempotency
- **Timeout management**: Request timeouts, connection timeouts, deadline propagation
- **Bulkhead pattern**: Resource isolation, thread pools, connection pools
- **Graceful degradation**: Fallback responses, cached responses, feature toggles
- **Health checks**: Liveness, readiness, startup probes

### Caching Strategies
- **Cache patterns**: Cache-aside, read-through, write-through, write-behind
- **Technologies**: Redis, Memcached, in-memory caching
- **Invalidation**: TTL, event-driven invalidation, cache tags
- **HTTP caching**: ETags, Cache-Control, conditional requests

### Performance Optimization
- **Query optimization**: N+1 prevention, batch loading, DataLoader pattern
- **Connection pooling**: Database connections, HTTP clients
- **Async operations**: Non-blocking I/O, parallel processing
- **Horizontal scaling**: Stateless services, load distribution, auto-scaling

### Testing Strategies (Extended)
- **Contract testing**: Pact, consumer-driven contracts, schema validation
- **Load testing**: Performance testing, stress testing, capacity planning
- **Security testing**: Penetration testing, vulnerability scanning, OWASP Top 10
- **Chaos testing**: Fault injection, resilience testing

---

## 15. Feature Development Workflow

For end-to-end feature delivery, follow this phased approach:

### Configuration Options
- **Methodology**: traditional | tdd | bdd | ddd
- **Complexity**: simple (1-2 days) | medium (3-5 days) | complex (1-2 weeks) | epic (2+ weeks)
- **Deployment**: direct | canary | feature-flag | blue-green | a-b-test

### Phase 1: Discovery & Requirements
1. Analyze feature requirements, define user stories, acceptance criteria, success metrics
2. Design technical architecture: service boundaries, API contracts, data models
3. Assess security implications and risks

### Phase 2: Implementation
4. Build backend services: APIs, business logic, data layer, resilience patterns, feature flags
5. Build frontend components with API integration
6. Build data pipelines and analytics events

### Phase 3: Testing & QA
7. Create comprehensive test suite (unit, integration, E2E, performance) -- min 80% coverage
8. Security validation: OWASP checks, dependency scanning, compliance
9. Performance optimization: profiling, caching, load times

### Phase 4: Deployment & Monitoring
10. CI/CD pipeline with automated tests, feature flags for gradual rollout, rollback procedures
11. Observability: distributed tracing, custom metrics, error tracking, dashboards, SLOs/SLIs
12. Documentation: API docs, user guides, runbooks, architecture diagrams

### Rollback Strategy
1. Immediate feature flag disable (< 1 minute)
2. Blue-green traffic switch (< 5 minutes)
3. Full deployment rollback via CI/CD (< 15 minutes)
4. Database migration rollback if needed
5. Incident post-mortem and fixes before re-deployment

---

## 16. Skill Status

**Status:** Stable · Enforceable · Production-grade
**Intended Use:** Long-lived backend services with real traffic and real risk
