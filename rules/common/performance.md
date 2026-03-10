# Performance Rules

> Always-on performance guidelines. Applied when building user-facing applications.

---

## Core Web Vitals Targets

| Metric | Target | What It Measures |
|--------|--------|-----------------|
| **LCP** (Largest Contentful Paint) | < 2.5s | Loading speed |
| **INP** (Interaction to Next Paint) | < 200ms | Responsiveness |
| **CLS** (Cumulative Layout Shift) | < 0.1 | Visual stability |
| **TTFB** (Time to First Byte) | < 800ms | Server response |
| **FCP** (First Contentful Paint) | < 1.8s | Perceived load |

---

## Frontend Performance

### Bundle Size

| Type | Limit (gzipped) |
|------|-----------------|
| Total JS | < 200KB |
| Per-route chunk | < 50KB |
| CSS total | < 50KB |

### Image Optimization

- Use WebP/AVIF with fallbacks
- Lazy load below-the-fold images
- Responsive images with `srcset`
- Set explicit `width` and `height` (prevents CLS)

### Rendering

- Minimize re-renders (React.memo, useMemo for expensive computations)
- Virtualize long lists (> 50 items)
- Debounce/throttle frequent events (scroll, resize, search input)
- Code-split routes and heavy components

---

## Backend Performance

### Database Queries

- **N+1 is forbidden:** Use eager loading / JOINs
- Index frequently queried columns (WHERE, JOIN, ORDER BY)
- Use `EXPLAIN ANALYZE` for slow queries (> 100ms)
- Paginate all list endpoints (no unbounded queries)
- Connection pooling mandatory in production

### API Response

- Target: < 200ms for simple reads, < 500ms for complex operations
- Use caching headers (`Cache-Control`, `ETag`)
- Compress responses (gzip/brotli)
- Paginate collections (default limit: 20, max: 100)

---

## Caching Strategy

| Layer | What to Cache | TTL |
|-------|--------------|-----|
| Browser | Static assets (JS, CSS, images) | 1 year (fingerprinted) |
| CDN | HTML pages, API responses | 5min - 1hr |
| Application | DB query results, computed data | 1min - 1hr |
| Database | Query cache | Auto-managed |

**Cache invalidation:** Use cache-busting hashes for static assets. Event-based invalidation for dynamic data.

---

## Measurement First

- Don't optimize without measuring
- Profile before and after changes
- Use Lighthouse CI for automated checks
- Monitor real user metrics (RUM) in production
