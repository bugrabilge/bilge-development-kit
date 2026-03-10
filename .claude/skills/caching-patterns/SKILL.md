---
user-invocable: false
name: caching-patterns
description: Caching strategies for web applications. Covers browser caching, CDN, application cache (Redis), database query cache, and React/Next.js caching patterns.
---

# Caching Patterns Skill

Comprehensive caching strategies for every layer of a web application.

## Cache Decision Framework

```
Is the data expensive to compute/fetch?
|
+-- NO -> Don't cache (complexity not worth it)
|
+-- YES -> How often does it change?
    |
    +-- Never/rarely -> Long TTL (hours/days) + CDN
    |
    +-- Every few minutes -> Short TTL (30s-5min) + stale-while-revalidate
    |
    +-- Real-time -> Don't cache, or cache with instant invalidation
    |
    +-- Per-user -> Application cache (Redis) with user-scoped keys
```

---

## Caching Layers

| Layer | What | TTL | Tools |
|-------|------|-----|-------|
| **Browser** | Static assets, API responses | Hours-Years | Cache-Control headers |
| **CDN** | Static files, pages, API responses | Minutes-Days | Cloudflare, Vercel Edge |
| **Application** | Computed data, API results | Seconds-Hours | Redis, Upstash, in-memory |
| **Database** | Query results | Seconds-Minutes | Query cache, materialized views |
| **Framework** | Components, routes, data | Varies | Next.js cache, React Query |

---

## Browser Caching (HTTP Cache Headers)

### Cache-Control Directives

| Directive | Use Case | Example |
|-----------|----------|---------|
| `public, max-age=31536000, immutable` | Hashed static assets (JS, CSS, images) | `app.a1b2c3.js` |
| `public, max-age=0, must-revalidate` | HTML pages | `index.html` |
| `private, max-age=300` | User-specific API responses | `/api/me/profile` |
| `no-store` | Sensitive data | `/api/auth/session` |
| `stale-while-revalidate=60` | Fresh enough + fast | API responses |

### Strategy by Content Type

| Content | Strategy | Why |
|---------|----------|-----|
| JS/CSS (hashed) | `immutable, max-age=1y` | Hash changes on update |
| Images (hashed) | `immutable, max-age=1y` | Same as above |
| HTML | `no-cache` or `max-age=0, must-revalidate` | Always check for updates |
| API (public) | `max-age=60, stale-while-revalidate=300` | Fresh enough |
| API (private) | `private, max-age=0` or `no-store` | User-specific or sensitive |
| Fonts | `max-age=1y` | Rarely change |

---

## CDN Caching

### When to Use CDN

| Scenario | CDN? |
|----------|------|
| Static sites | Always |
| API responses (public) | Yes, with short TTL |
| User-specific content | Edge compute, not CDN cache |
| Real-time data | No |
| Global audience | Always |

### CDN Cache Keys

- Include: URL path, query params that affect response
- Exclude: Cookies, auth headers (unless needed)
- Vary: `Accept-Encoding`, `Accept-Language` (if i18n)

### Cache Invalidation

| Method | When |
|--------|------|
| TTL expiry | Default, simplest |
| Purge by URL | Specific page update |
| Purge by tag | Category/section update |
| Deploy-based | Full purge on new deploy |

---

## Application Cache (Redis / In-Memory)

### Common Patterns

| Pattern | Description | Use Case |
|---------|-------------|----------|
| **Cache-Aside** | App checks cache, fetches on miss | Most common, general purpose |
| **Write-Through** | Write to cache + DB together | Consistency critical |
| **Write-Behind** | Write to cache, async to DB | High write throughput |
| **Read-Through** | Cache fetches on miss automatically | Framework-managed |

### Cache-Aside Implementation

```
GET request:
1. Check cache for key
2. Cache hit? -> Return cached data
3. Cache miss? -> Fetch from DB -> Store in cache -> Return

WRITE request:
1. Update DB
2. Invalidate cache key (delete, not update)
```

### Key Design

| Principle | Rule |
|-----------|------|
| **Descriptive** | `user:{userId}:profile` not `u123` |
| **Hierarchical** | `product:{id}:reviews:{page}` |
| **Versioned** | `v2:user:{id}:settings` for schema changes |
| **Bounded** | Always set TTL, even if long |

### TTL Strategy

| Data Type | TTL | Rationale |
|-----------|-----|-----------|
| User session | 30 min - 24 hours | Security + freshness |
| Product catalog | 5-15 min | Changes occasionally |
| Search results | 1-5 min | Can be slightly stale |
| Config/settings | 5-30 min | Rarely changes |
| Rate limit counters | 1 min (sliding window) | Accuracy needed |
| Feature flags | 30s - 1 min | Quick propagation |

---

## Database Query Cache

### When to Cache Queries

| Scenario | Cache? |
|----------|--------|
| Dashboard aggregations | Yes (expensive, changes slowly) |
| List pages with filters | Yes (common queries) |
| Single record by ID | Maybe (if high traffic) |
| Real-time counts | No (stale = wrong) |
| Search results | Yes (short TTL) |

### Materialized Views (PostgreSQL)

Use for expensive aggregations that don't need real-time accuracy:
- Dashboard stats
- Leaderboards
- Report summaries
- Refresh on schedule (REFRESH MATERIALIZED VIEW CONCURRENTLY)

---

## Framework Caching (Next.js / React)

### Next.js Caching Layers

| Layer | What | Control |
|-------|------|---------|
| Request Memoization | Dedupe same fetch in render | Automatic |
| Data Cache | fetch() results | `revalidate` option |
| Full Route Cache | Pre-rendered pages | Static/Dynamic |
| Router Cache | Client-side route cache | Automatic |

### React Query / TanStack Query

| Setting | Recommended | Why |
|---------|-------------|-----|
| `staleTime` | 30s - 5min | How long data is "fresh" |
| `gcTime` | 5-30 min | How long unused cache lives |
| `refetchOnWindowFocus` | true (default) | Refresh on tab switch |
| `retry` | 3 (default) | Handle transient failures |

---

## Cache Invalidation Strategies

| Strategy | Complexity | Consistency |
|----------|-----------|-------------|
| **TTL-based** | Low | Eventually consistent |
| **Event-based** | Medium | Near-real-time |
| **Write-through** | Medium | Strong consistency |
| **Version-based** | Low | On deploy |

### Golden Rule

> "There are only two hard things in CS: cache invalidation and naming things."

**When in doubt:**
- Use short TTL over complex invalidation
- Delete cache keys on write, don't update them
- Prefer stale-while-revalidate for user experience

---

## Anti-Patterns

| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|
| Cache without TTL | Memory leak, stale forever | Always set TTL |
| Cache everything | Complexity, memory waste | Cache only expensive/hot data |
| Update cache on write | Race conditions | Delete on write, re-populate on read |
| Same TTL everywhere | Over/under caching | Tune per data type |
| No cache warming | Cold start latency | Pre-populate critical paths |
| Ignoring thundering herd | Spike on cache expiry | Stale-while-revalidate, locks |

---

## Review Checklist

- [ ] Static assets have long cache (immutable + content hash)
- [ ] HTML pages use `must-revalidate` or `no-cache`
- [ ] API responses have appropriate Cache-Control headers
- [ ] CDN configured for static assets
- [ ] Redis/cache has TTL on all keys
- [ ] Cache invalidation strategy documented
- [ ] No sensitive data in shared caches
- [ ] Cache hit rate being monitored
- [ ] Graceful degradation if cache is down
- [ ] stale-while-revalidate for user-facing data
