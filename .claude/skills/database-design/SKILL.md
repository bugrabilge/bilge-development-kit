---
user-invocable: false
name: database-design
description: "Database schema design, normalization, indexing strategies, relationship modeling, and migration patterns. Use when designing new schemas, optimizing queries, planning migrations, or reviewing data models."
---

# Database Design

> "Data is the foundation; a well-designed schema is the bedrock upon which reliable systems are built."

## When to Use
- Designing new database schemas or tables
- Reviewing existing data models for normalization issues
- Planning indexing strategies for query performance
- Modeling relationships between entities
- Writing or reviewing migration scripts
- Choosing between SQL and NoSQL for a use case
- Optimizing slow queries through schema changes

## Normalization Principles

### First Normal Form (1NF)
- Every column contains atomic (indivisible) values
- No repeating groups or arrays stored in a single column
- Each row is uniquely identifiable via a primary key

### Second Normal Form (2NF)
- Must satisfy 1NF
- Every non-key column depends on the entire primary key, not just part of it
- Eliminate partial dependencies in composite key tables

### Third Normal Form (3NF)
- Must satisfy 2NF
- No transitive dependencies: non-key columns must not depend on other non-key columns
- Example violation: storing `city` and `zip_code` together when city is determined by zip

### When to Denormalize
- Read-heavy workloads where join performance is critical
- Reporting tables and materialized views
- Caching layers (e.g., Redis-backed denormalized snapshots)
- Always document why denormalization was chosen and maintain consistency mechanisms

## Primary Key Strategies

### Auto-increment IDs
- Simple and sequential; good for internal-only references
- Can leak information about record count and creation rate
- Problematic in distributed systems (conflicts across nodes)

### UUIDs (v4)
- Globally unique without coordination
- Poor index locality due to randomness (fragmented B-trees)
- Use UUIDv7 (time-ordered) for better index performance

### ULIDs / Snowflake IDs
- Time-sortable and globally unique
- Better B-tree locality than UUIDv4
- Preferred for distributed systems needing ordered IDs

### Natural Keys
- Use when a domain-meaningful unique value exists (e.g., ISO country codes)
- Immutable natural keys are safe; mutable ones cause cascading update pain

## Relationship Modeling

### One-to-Many
- Place a foreign key on the "many" side pointing to the "one" side
- Always index foreign key columns
- Consider ON DELETE behavior: CASCADE, SET NULL, or RESTRICT

### Many-to-Many
- Use a junction/join table with composite primary key
- Add timestamps (created_at) to junction tables for auditability
- Consider whether the relationship itself has attributes (e.g., role in a membership)

### One-to-One
- Often indicates a candidate for table merging
- Valid use cases: splitting hot/cold data, separating optional large blobs
- Enforce with UNIQUE constraint on the foreign key

### Polymorphic Associations
- Avoid the anti-pattern of `entity_type` + `entity_id` columns (no FK enforcement)
- Prefer: separate FK columns (nullable), or exclusive arc pattern, or table-per-type inheritance

## Indexing Strategies

### B-Tree Indexes (Default)
- Best for equality and range queries
- Place most selective columns first in composite indexes
- Follow the "leftmost prefix" rule for composite index usage

### Covering Indexes
- Include all columns needed by a query to avoid table lookups
- Use INCLUDE clause (PostgreSQL) or add columns to the index
- Trade-off: larger index size vs. faster reads

### Partial / Filtered Indexes
- Index only rows matching a condition (e.g., WHERE deleted_at IS NULL)
- Dramatically smaller and faster for filtered queries
- Ideal for soft-delete patterns and status-based queries

### GIN / GiST Indexes (PostgreSQL)
- GIN: full-text search, JSONB containment, array operations
- GiST: geometric data, range types, nearest-neighbor searches

### Index Anti-Patterns
- Indexing every column individually (maintenance overhead, write slowdown)
- Indexing low-cardinality columns alone (e.g., boolean flags)
- Ignoring index usage in EXPLAIN ANALYZE output
- Not removing unused indexes (check pg_stat_user_indexes)

## Migration Best Practices

### Safety Rules
- Never rename columns directly in production; add new, migrate data, drop old
- Never add NOT NULL without a DEFAULT in a live system
- Use backward-compatible migrations: old code must work with new schema
- Deploy schema changes separately from application changes

### Migration Workflow
1. Write migration SQL with explicit UP and DOWN scripts
2. Test migration on a production-sized dataset copy
3. Measure lock duration; avoid long-held ACCESS EXCLUSIVE locks
4. For large tables, use batched backfills instead of single UPDATE statements
5. Validate with integration tests before and after migration

### Zero-Downtime Patterns
- Adding a column: always nullable or with a default
- Removing a column: stop reading it first, then drop in a later migration
- Renaming a table: create new, sync via triggers or dual-write, cut over
- Adding an index: use CREATE INDEX CONCURRENTLY (PostgreSQL)

## Query Optimization Checklist
- Run EXPLAIN ANALYZE on slow queries
- Check for sequential scans on large tables
- Verify indexes are being used (not bypassed by type mismatches or functions)
- Look for N+1 query patterns in application code
- Use connection pooling (PgBouncer, PgCat) for high-concurrency workloads
- Set appropriate work_mem and shared_buffers for analytical queries
- Partition large tables by date or tenant when they exceed hundreds of millions of rows

## Schema Review Checklist
- Every table has a primary key
- Foreign keys have indexes
- Timestamps use timestamptz (not timestamp without timezone)
- Text fields have appropriate length constraints or CHECK constraints
- Soft-delete columns (deleted_at) are covered by partial indexes
- Enum-like values use a reference table or CHECK constraint, not magic strings
- Audit columns (created_at, updated_at, created_by) are present where needed
- Naming is consistent: snake_case, singular table names, _id suffix for FKs
