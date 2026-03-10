---
user-invocable: false
name: architecture
description: "Comprehensive architecture skill: decision-making, pattern selection, architectural review, distributed systems design, DDD, clean architecture, and code quality principles. Use for architecture decisions, system design, or reviewing architectural changes."
allowed-tools: Read, Glob, Grep
risk: unknown
source: community
---

# Architecture Decision Framework

> "Requirements drive architecture. Trade-offs inform decisions. ADRs capture rationale."

## 🎯 Selective Reading Rule

**Read ONLY files relevant to the request!** Check the content map, find what you need.

| File | Description | When to Read |
|------|-------------|--------------|
| `context-discovery.md` | Questions to ask, project classification | Starting architecture design |
| `trade-off-analysis.md` | ADR templates, trade-off framework | Documenting decisions |
| `pattern-selection.md` | Decision trees, anti-patterns | Choosing patterns |
| `examples.md` | MVP, SaaS, Enterprise examples | Reference implementations |
| `patterns-reference.md` | Quick lookup for patterns | Pattern comparison |

---

## 🔗 Related Skills

| Skill | Use For |
|-------|---------|
| `@[skills/database-design]` | Database schema design |
| `@[skills/api-patterns]` | API design patterns |
| `@[skills/deployment-procedures]` | Deployment architecture |

---

## Core Principle

**"Simplicity is the ultimate sophistication."**

- Start simple
- Add complexity ONLY when proven necessary
- You can always add patterns later
- Removing complexity is MUCH harder than adding it

---

## Validation Checklist

Before finalizing architecture:

- [ ] Requirements clearly understood
- [ ] Constraints identified
- [ ] Each decision has trade-off analysis
- [ ] Simpler alternatives considered
- [ ] ADRs written for significant decisions
- [ ] Team expertise matches chosen patterns

## When to Use
This skill is applicable to execute the workflow or actions described in the overview.

---

## Architectural Review Process

### Response Approach
1. **Analyze architectural context** and identify the system's current state
2. **Assess architectural impact** of proposed changes (High/Medium/Low)
3. **Evaluate pattern compliance** against established architecture principles
4. **Identify architectural violations** and anti-patterns
5. **Recommend improvements** with specific refactoring suggestions
6. **Consider scalability implications** for future growth
7. **Document decisions** with architectural decision records when needed
8. **Provide implementation guidance** with concrete next steps

### Quality Attributes Assessment
- Reliability, availability, and fault tolerance evaluation
- Scalability and performance characteristics analysis
- Security posture and compliance requirements
- Maintainability and technical debt assessment
- Testability and deployment pipeline evaluation
- Monitoring, logging, and observability capabilities
- Cost optimization and resource efficiency analysis

---

## Architecture Patterns Catalog

### Modern Architecture Patterns
- **Clean Architecture**: Dependencies point inward; business logic independent of frameworks
- **Hexagonal Architecture** (Ports & Adapters): Domain core with interface ports and implementation adapters
- **Microservices**: Proper service boundaries, database-per-service, API versioning
- **Event-Driven Architecture** (EDA): Event sourcing and CQRS patterns
- **Domain-Driven Design** (DDD): Bounded contexts, ubiquitous language, aggregates
- **Serverless**: Function-as-a-Service design patterns
- **API-first**: GraphQL, REST, and gRPC best practices

### Distributed Systems Design
- Service mesh (Istio, Linkerd, Consul Connect)
- Event streaming (Kafka, Pulsar, NATS)
- Distributed data patterns: Saga, Outbox, Event Sourcing
- Resilience: Circuit breaker, bulkhead, timeout patterns
- Distributed caching (Redis Cluster, Hazelcast)
- Distributed tracing and observability architecture

### SOLID Principles & Design Patterns
- Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion
- Repository, Unit of Work, Specification, Factory, Strategy, Observer, Command patterns
- Anti-corruption layers and adapter patterns

### Cloud-Native Architecture
- Container orchestration (Kubernetes, Docker Swarm)
- Infrastructure as Code (Terraform, Pulumi, CloudFormation)
- GitOps and CI/CD pipeline architecture
- Auto-scaling, multi-cloud, and edge computing patterns

### Security Architecture
- Zero Trust model, OAuth2/OIDC/JWT management
- API security (rate limiting, throttling)
- Secret management (HashiCorp Vault, cloud key services)
- Defense in depth strategies

### Data Architecture
- Polyglot persistence (SQL + NoSQL)
- Data lake, data warehouse, data mesh architectures
- Event sourcing and CQRS
- Database-per-service, replication, distributed transactions

---

## Code Style & Quality Principles

### General Principles
- **Early return pattern**: Use early returns over nested conditions for readability
- Avoid code duplication through reusable functions and modules
- Decompose long components (>80 lines) into smaller pieces; split files >200 lines
- Keep functions focused and under 50 lines; avoid nesting >3 levels

### Library-First Approach
- **Always search for existing solutions before writing custom code**
- Use established libraries instead of custom utils (e.g., `cockatiel` for retry logic)
- Custom code is justified for: unique business logic, performance-critical paths, security-sensitive code

### Naming Conventions
- **Avoid** generic names: `utils`, `helpers`, `common`, `shared`
- **Use** domain-specific names: `OrderCalculator`, `UserAuthenticator`, `InvoiceGenerator`

### Anti-Patterns to Avoid
- NIH Syndrome: Don't build custom auth when Auth0/Supabase exists
- God objects (>500 lines, >20 methods), Anemic domain models
- Mixing business logic with UI components
- Database queries directly in controllers
- `utils.js` with 50 unrelated functions

### Architecture Documentation
- C4 model for software architecture visualization
- Architecture Decision Records (ADRs)
- System context, container, and component diagrams
- API documentation with OpenAPI/Swagger

---

## Reference Resources

For detailed implementation patterns:
- `resources/architecture-patterns-playbook.md` - Clean Architecture, Hexagonal, and DDD implementation with code examples

### Tech Stack Reference
**Languages:** TypeScript, JavaScript, Python, Go, Swift, Kotlin
**Frontend:** React, Next.js, React Native, Flutter
**Backend:** Node.js, Express, GraphQL, REST APIs
**Database:** PostgreSQL, Prisma, NeonDB, Supabase
**DevOps:** Docker, Kubernetes, Terraform, GitHub Actions
**Cloud:** AWS, GCP, Azure
