# Redispute Database Package

Database schemas and migrations for Redispute (Cloudflare D1).

## Overview

This package contains:
- **schema.sql**: Complete database schema with all tables
- **migrations/**: D1 migration files (sequential)
- **seed.sql**: Development seed data for testing

## Database: Cloudflare D1

[Cloudflare D1](https://developers.cloudflare.com/d1/) is a serverless SQL database built on SQLite, globally distributed and replicated.

**Benefits**:
- Sub-50ms query latency globally
- Automatic replication and backups
- Integrated with Cloudflare Workers
- SQLite compatibility (standard SQL)
- Free tier: 100K reads/day, 1K writes/day

## Tables

### Core Tables

1. **merchants**: Shopify merchant accounts and subscription status
2. **orders**: Order data from Shopify webhooks for risk analysis
3. **customer_disputes**: Customer-initiated dispute resolution (prevention layer)
4. **chargebacks**: Actual chargebacks from payment processors
5. **evidence_packages**: AI-generated evidence for disputes

### Supporting Tables

6. **analytics_events**: User actions and prevention attempts
7. **webhook_log**: Incoming webhook log for debugging
8. **billing_records**: Subscription and usage fee tracking

## Setup

### 1. Install Wrangler CLI

```bash
npm install -g wrangler
# or
pnpm add -g wrangler
```

### 2. Authenticate with Cloudflare

```bash
wrangler login
```

### 3. Create D1 Database

```bash
# Development database
wrangler d1 create redispute-dev

# Production database
wrangler d1 create redispute-prod
```

Copy the database IDs to `wrangler.toml` in each worker.

### 4. Apply Schema

```bash
# Development
wrangler d1 execute redispute-dev --file=schema.sql

# Production
wrangler d1 execute redispute-prod --file=schema.sql
```

### 5. Seed Development Data (Optional)

```bash
wrangler d1 execute redispute-dev --file=seed.sql
```

## Usage in Workers

### Binding Configuration

In `wrangler.toml`:

```toml
[[d1_databases]]
binding = "DB"
database_name = "redispute-dev"
database_id = "your-database-id-here"
```

### TypeScript Interface

```typescript
export interface Env {
  DB: D1Database;
}
```

### Query Examples

```typescript
// Select
const result = await env.DB.prepare(
  'SELECT * FROM merchants WHERE shop_domain = ?'
).bind('test-store.myshopify.com').first();

// Insert
await env.DB.prepare(`
  INSERT INTO orders (id, merchant_id, shopify_order_id, order_number, customer_email, total_amount, currency)
  VALUES (?, ?, ?, ?, ?, ?, ?)
`).bind(id, merchantId, shopifyOrderId, orderNumber, email, amount, currency).run();

// Update
await env.DB.prepare(
  'UPDATE merchants SET dispute_rate = ? WHERE id = ?'
).bind(newRate, merchantId).run();

// Transaction
await env.DB.batch([
  env.DB.prepare('INSERT INTO orders ...').bind(...),
  env.DB.prepare('INSERT INTO analytics_events ...').bind(...),
]);
```

## Migrations

D1 migrations are tracked in the `migrations/` directory.

### Creating a Migration

```bash
wrangler d1 migrations create redispute-dev "add_column_xyz"
```

This creates a new migration file in `migrations/`.

### Applying Migrations

```bash
wrangler d1 migrations apply redispute-dev
```

## Schema Design Notes

### Security
- **Access tokens** are encrypted at rest (libsodium)
- **PII** (customer email, name) is encrypted
- All foreign keys have `ON DELETE CASCADE` or `ON DELETE SET NULL`

### Performance
- Indexes on frequently queried columns (merchant_id, created_at, status)
- Timestamps use SQLite `datetime('now')` for consistency
- Triggers automatically update `updated_at` fields

### Data Types
- **Amounts**: Stored as INTEGER (cents) to avoid floating-point errors
- **Dates**: Stored as TEXT in ISO 8601 format (SQLite standard)
- **Booleans**: Stored as INTEGER (0 or 1)
- **JSON**: Stored as TEXT (parse with `JSON.parse()`)

### Constraints
- CHECK constraints enforce valid enum values
- UNIQUE constraints prevent duplicate shop domains
- NOT NULL constraints ensure required fields

## Backup and Recovery

### Export Database

```bash
wrangler d1 export redispute-prod --output=backup.sql
```

### Import Backup

```bash
wrangler d1 execute redispute-prod --file=backup.sql
```

## Monitoring

View database analytics in [Cloudflare Dashboard](https://dash.cloudflare.com/):
- Query performance (p50, p95, p99)
- Storage usage
- Read/write volume
- Error rates

## Limits

**Free Tier**:
- 5 GB storage
- 100K reads/day
- 1K writes/day

**Paid Tier** ($5/month):
- 5 GB included storage
- 25M reads/month
- 50K writes/day
- Additional storage: $0.75/GB

See [D1 Pricing](https://developers.cloudflare.com/d1/platform/pricing/) for details.

## Development Tips

1. **Use transactions** for related operations (batch inserts)
2. **Index carefully** - indexes speed up reads but slow down writes
3. **Encrypt PII** - use Cloudflare Workers crypto API
4. **Test locally** with Wrangler dev mode
5. **Monitor query performance** - D1 analytics dashboard

## Resources

- [Cloudflare D1 Docs](https://developers.cloudflare.com/d1/)
- [D1 API Reference](https://developers.cloudflare.com/d1/platform/client-api/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
