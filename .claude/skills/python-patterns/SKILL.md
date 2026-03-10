---
user-invocable: false
name: python-patterns
description: "Python development principles, project scaffolding, performance optimization, and modern tooling. Framework selection, async patterns, type hints, profiling, and production-ready project structures."
allowed-tools: Read, Write, Edit, Glob, Grep
risk: unknown
source: community
---

# Python Patterns

> Python development principles and decision-making for 2025.
> **Learn to THINK, not memorize patterns.**

## When to Use

Use this skill when making Python architecture decisions, choosing frameworks, designing async patterns, or structuring Python projects.

---

## ⚠️ How to Use This Skill

This skill teaches **decision-making principles**, not fixed code to copy.

- ASK user for framework preference when unclear
- Choose async vs sync based on CONTEXT
- Don't default to same framework every time

---

## 1. Framework Selection (2025)

### Decision Tree

```
What are you building?
│
├── API-first / Microservices
│   └── FastAPI (async, modern, fast)
│
├── Full-stack web / CMS / Admin
│   └── Django (batteries-included)
│
├── Simple / Script / Learning
│   └── Flask (minimal, flexible)
│
├── AI/ML API serving
│   └── FastAPI (Pydantic, async, uvicorn)
│
└── Background workers
    └── Celery + any framework
```

### Comparison Principles

| Factor | FastAPI | Django | Flask |
|--------|---------|--------|-------|
| **Best for** | APIs, microservices | Full-stack, CMS | Simple, learning |
| **Async** | Native | Django 5.0+ | Via extensions |
| **Admin** | Manual | Built-in | Via extensions |
| **ORM** | Choose your own | Django ORM | Choose your own |
| **Learning curve** | Low | Medium | Low |

### Selection Questions to Ask:
1. Is this API-only or full-stack?
2. Need admin interface?
3. Team familiar with async?
4. Existing infrastructure?

---

## 2. Async vs Sync Decision

### When to Use Async

```
async def is better when:
├── I/O-bound operations (database, HTTP, file)
├── Many concurrent connections
├── Real-time features
├── Microservices communication
└── FastAPI/Starlette/Django ASGI

def (sync) is better when:
├── CPU-bound operations
├── Simple scripts
├── Legacy codebase
├── Team unfamiliar with async
└── Blocking libraries (no async version)
```

### The Golden Rule

```
I/O-bound → async (waiting for external)
CPU-bound → sync + multiprocessing (computing)

Don't:
├── Mix sync and async carelessly
├── Use sync libraries in async code
└── Force async for CPU work
```

### Async Library Selection

| Need | Async Library |
|------|---------------|
| HTTP client | httpx |
| PostgreSQL | asyncpg |
| Redis | aioredis / redis-py async |
| File I/O | aiofiles |
| Database ORM | SQLAlchemy 2.0 async, Tortoise |

---

## 3. Type Hints Strategy

### When to Type

```
Always type:
├── Function parameters
├── Return types
├── Class attributes
├── Public APIs

Can skip:
├── Local variables (let inference work)
├── One-off scripts
├── Tests (usually)
```

### Common Type Patterns

```python
# These are patterns, understand them:

# Optional → might be None
from typing import Optional
def find_user(id: int) -> Optional[User]: ...

# Union → one of multiple types
def process(data: str | dict) -> None: ...

# Generic collections
def get_items() -> list[Item]: ...
def get_mapping() -> dict[str, int]: ...

# Callable
from typing import Callable
def apply(fn: Callable[[int], str]) -> str: ...
```

### Pydantic for Validation

```
When to use Pydantic:
├── API request/response models
├── Configuration/settings
├── Data validation
├── Serialization

Benefits:
├── Runtime validation
├── Auto-generated JSON schema
├── Works with FastAPI natively
└── Clear error messages
```

---

## 4. Project Structure Principles

### Structure Selection

```
Small project / Script:
├── main.py
├── utils.py
└── requirements.txt

Medium API:
├── app/
│   ├── __init__.py
│   ├── main.py
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── schemas/
├── tests/
└── pyproject.toml

Large application:
├── src/
│   └── myapp/
│       ├── core/
│       ├── api/
│       ├── services/
│       ├── models/
│       └── ...
├── tests/
└── pyproject.toml
```

### FastAPI Structure Principles

```
Organize by feature or layer:

By layer:
├── routes/ (API endpoints)
├── services/ (business logic)
├── models/ (database models)
├── schemas/ (Pydantic models)
└── dependencies/ (shared deps)

By feature:
├── users/
│   ├── routes.py
│   ├── service.py
│   └── schemas.py
└── products/
    └── ...
```

---

## 5. Django Principles (2025)

### Django Async (Django 5.0+)

```
Django supports async:
├── Async views
├── Async middleware
├── Async ORM (limited)
└── ASGI deployment

When to use async in Django:
├── External API calls
├── WebSocket (Channels)
├── High-concurrency views
└── Background task triggering
```

### Django Best Practices

```
Model design:
├── Fat models, thin views
├── Use managers for common queries
├── Abstract base classes for shared fields

Views:
├── Class-based for complex CRUD
├── Function-based for simple endpoints
├── Use viewsets with DRF

Queries:
├── select_related() for FKs
├── prefetch_related() for M2M
├── Avoid N+1 queries
└── Use .only() for specific fields
```

---

## 6. FastAPI Principles

### async def vs def in FastAPI

```
Use async def when:
├── Using async database drivers
├── Making async HTTP calls
├── I/O-bound operations
└── Want to handle concurrency

Use def when:
├── Blocking operations
├── Sync database drivers
├── CPU-bound work
└── FastAPI runs in threadpool automatically
```

### Dependency Injection

```
Use dependencies for:
├── Database sessions
├── Current user / Auth
├── Configuration
├── Shared resources

Benefits:
├── Testability (mock dependencies)
├── Clean separation
├── Automatic cleanup (yield)
```

### Pydantic v2 Integration

```python
# FastAPI + Pydantic are tightly integrated:

# Request validation
@app.post("/users")
async def create(user: UserCreate) -> UserResponse:
    # user is already validated
    ...

# Response serialization
# Return type becomes response schema
```

---

## 7. Background Tasks

### Selection Guide

| Solution | Best For |
|----------|----------|
| **BackgroundTasks** | Simple, in-process tasks |
| **Celery** | Distributed, complex workflows |
| **ARQ** | Async, Redis-based |
| **RQ** | Simple Redis queue |
| **Dramatiq** | Actor-based, simpler than Celery |

### When to Use Each

```
FastAPI BackgroundTasks:
├── Quick operations
├── No persistence needed
├── Fire-and-forget
└── Same process

Celery/ARQ:
├── Long-running tasks
├── Need retry logic
├── Distributed workers
├── Persistent queue
└── Complex workflows
```

---

## 8. Error Handling Principles

### Exception Strategy

```
In FastAPI:
├── Create custom exception classes
├── Register exception handlers
├── Return consistent error format
└── Log without exposing internals

Pattern:
├── Raise domain exceptions in services
├── Catch and transform in handlers
└── Client gets clean error response
```

### Error Response Philosophy

```
Include:
├── Error code (programmatic)
├── Message (human readable)
├── Details (field-level when applicable)
└── NOT stack traces (security)
```

---

## 9. Testing Principles

### Testing Strategy

| Type | Purpose | Tools |
|------|---------|-------|
| **Unit** | Business logic | pytest |
| **Integration** | API endpoints | pytest + httpx/TestClient |
| **E2E** | Full workflows | pytest + DB |

### Async Testing

```python
# Use pytest-asyncio for async tests

import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/users")
        assert response.status_code == 200
```

### Fixtures Strategy

```
Common fixtures:
├── db_session → Database connection
├── client → Test client
├── authenticated_user → User with token
└── sample_data → Test data setup
```

---

## 10. Decision Checklist

Before implementing:

- [ ] **Asked user about framework preference?**
- [ ] **Chosen framework for THIS context?** (not just default)
- [ ] **Decided async vs sync?**
- [ ] **Planned type hint strategy?**
- [ ] **Defined project structure?**
- [ ] **Planned error handling?**
- [ ] **Considered background tasks?**

---

## 11. Anti-Patterns to Avoid

### ❌ DON'T:
- Default to Django for simple APIs (FastAPI may be better)
- Use sync libraries in async code
- Skip type hints for public APIs
- Put business logic in routes/views
- Ignore N+1 queries
- Mix async and sync carelessly

### ✅ DO:
- Choose framework based on context
- Ask about async requirements
- Use Pydantic for validation
- Separate concerns (routes → services → repos)
- Test critical paths

---

> **Remember**: Python patterns are about decision-making for YOUR specific context. Don't copy code—think about what serves your application best.

---

## 12. Modern Python Tooling (2025)

### Package Management with uv

```bash
# Create new project
uv init <project-name>
cd <project-name>
uv venv
source .venv/bin/activate

# Add dependencies
uv add fastapi uvicorn pydantic
uv add --dev pytest ruff mypy
uv sync
```

### Code Quality with ruff

```toml
# pyproject.toml
[tool.ruff]
line-length = 100
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
```

ruff replaces black, isort, and flake8 in a single fast tool.

### Static Type Checking

| Tool | Strengths |
|------|-----------|
| **mypy** | Most mature, widest adoption |
| **pyright** | Fastest, best VS Code integration |
| **pytype** | Google's type checker, infers types |

---

## 13. Project Scaffolding Templates

### FastAPI Project Structure

```
fastapi-project/
├── pyproject.toml
├── .env.example
├── src/
│   └── project_name/
│       ├── __init__.py
│       ├── main.py
│       ├── config.py
│       ├── api/
│       │   ├── deps.py
│       │   └── v1/
│       │       ├── endpoints/
│       │       │   ├── users.py
│       │       │   └── health.py
│       │       └── router.py
│       ├── core/
│       │   ├── security.py
│       │   └── database.py
│       ├── models/
│       ├── schemas/
│       └── services/
└── tests/
    ├── conftest.py
    └── api/
```

### Django Project Structure

```bash
uv add django django-environ django-debug-toolbar
django-admin startproject config .
python manage.py startapp core
```

### Python Library Structure

```
library-name/
├── pyproject.toml        # Use hatchling as build backend
├── LICENSE
├── src/
│   └── library_name/
│       ├── __init__.py
│       ├── py.typed       # PEP 561 marker for typed package
│       └── core.py
└── tests/
```

### CLI Tool Structure

```python
# pyproject.toml: [project.scripts] cli-name = "project_name.cli:main"
import typer
from rich.console import Console

app = typer.Typer()
console = Console()

@app.command()
def hello(name: str = typer.Option(..., "--name", "-n")):
    console.print(f"[bold green]Hello {name}![/bold green]")

def main():
    app()
```

### Standard Makefile

```makefile
.PHONY: install dev test lint format clean

install:
	uv sync

dev:
	uv run uvicorn src.project_name.main:app --reload

test:
	uv run pytest -v

lint:
	uv run ruff check .

format:
	uv run ruff format .
```

---

## 14. Performance Optimization

### Profiling Tools

| Tool | Purpose | When to Use |
|------|---------|------------|
| **cProfile** | CPU profiling | Find slow functions |
| **py-spy** | Sampling profiler | Profile production without overhead |
| **memory_profiler** | Memory usage | Find memory leaks |
| **pytest-benchmark** | Micro-benchmarks | Compare implementations |
| **line_profiler** | Line-by-line timing | Optimize hot loops |
| **scalene** | CPU + memory + GPU | Comprehensive profiling |

### CPU Optimization Strategies

| Strategy | When to Apply |
|----------|--------------|
| **Algorithm optimization** | Always check Big-O first |
| **Built-in functions** | Use `sum()`, `map()`, `filter()` over manual loops |
| **List comprehensions** | 10-30% faster than equivalent for-loops |
| **Generator expressions** | Large datasets, memory-constrained |
| **`functools.lru_cache`** | Repeated function calls with same args |
| **`__slots__`** | Many instances of a class, reduce memory |
| **NumPy vectorization** | Numerical computations, avoid Python loops |

### Memory Optimization

| Technique | Impact |
|-----------|--------|
| **Generators over lists** | Process items one at a time, constant memory |
| **`__slots__`** | 40-50% memory reduction per instance |
| **`array` module** | Typed arrays for homogeneous numeric data |
| **Weak references** | Allow garbage collection of cached objects |
| **Chunked processing** | Process large files/datasets in batches |

### Concurrency Selection

```
I/O-bound (waiting for external):
├── asyncio          → Best for many concurrent I/O operations
├── threading        → Simple I/O parallelism, GIL-limited
└── aiohttp/httpx    → Async HTTP clients

CPU-bound (computing):
├── multiprocessing      → True parallelism, separate processes
├── concurrent.futures   → High-level pool interface
└── ProcessPoolExecutor  → Map-reduce style CPU work
```

### Database Query Optimization

| Technique | Framework |
|-----------|-----------|
| **`select_related()`** | Django - follow FK in single query |
| **`prefetch_related()`** | Django - batch M2M queries |
| **Eager loading** | SQLAlchemy - `joinedload()`, `subqueryload()` |
| **`.only()` / `.defer()`** | Load only needed columns |
| **Query caching** | Redis/Memcached for repeated queries |
| **Connection pooling** | SQLAlchemy pool, asyncpg pool |

### Caching Strategies

```python
from functools import lru_cache
import redis

# In-memory caching (same process)
@lru_cache(maxsize=1024)
def expensive_computation(key: str) -> dict:
    ...

# External caching (shared across processes)
cache = redis.Redis()
def get_data(key: str) -> dict:
    cached = cache.get(key)
    if cached:
        return json.loads(cached)
    result = compute(key)
    cache.setex(key, 3600, json.dumps(result))
    return result
```

---

## 15. Python 3.12+ Features

### Key Features to Leverage

| Feature | Version | Benefit |
|---------|---------|---------|
| **Improved error messages** | 3.12+ | More helpful tracebacks |
| **Pattern matching** | 3.10+ | Structural pattern matching with `match`/`case` |
| **Union syntax `X \| Y`** | 3.10+ | Cleaner type hints |
| **`tomllib`** | 3.11+ | Built-in TOML parsing |
| **Exception groups** | 3.11+ | Handle multiple exceptions |
| **Perf improvements** | 3.12+ | Faster interpreter, specializing adaptive |

### Advanced Patterns

| Pattern | Use Case |
|---------|----------|
| **Descriptors** | Reusable property-like behavior |
| **Metaclasses** | Class creation customization |
| **Protocol typing** | Structural subtyping (duck typing with types) |
| **Dataclasses** | Simple value objects with less boilerplate |
| **Context managers** | Resource lifecycle management |
| **Decorators** | Cross-cutting concerns (logging, auth, caching) |
| **Plugin architectures** | `importlib` + entry points for extensibility |

---

## 16. Production Deployment

### Docker Best Practices

```dockerfile
# Multi-stage build
FROM python:3.12-slim AS builder
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --frozen --no-dev

FROM python:3.12-slim AS runtime
WORKDIR /app
COPY --from=builder /app/.venv /app/.venv
COPY src/ ./src/
ENV PATH="/app/.venv/bin:$PATH"
USER nobody
CMD ["uvicorn", "src.project_name.main:app", "--host", "0.0.0.0"]
```

### Production Checklist

- [ ] Use multi-stage Docker builds
- [ ] Run as non-root user
- [ ] Pin all dependency versions (lock file)
- [ ] Configure structured logging
- [ ] Set up health check endpoints
- [ ] Configure environment-based settings (pydantic-settings)
- [ ] Enable monitoring and APM
- [ ] Set appropriate resource limits
