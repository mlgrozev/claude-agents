# Redispute Deployment Guide

Complete guide to deploying Redispute to Cloudflare.

## Prerequisites

- [x] Cloudflare account (free tier works)
- [ ] Shopify Partner account
- [ ] Stripe test account
- [ ] OpenAI API key
- [ ] Node.js 20+ and PNPM 8+

## Step-by-Step Deployment

### 1. Cloudflare Authentication

First, authenticate with Cloudflare:

```bash
# Install Wrangler CLI (if not already installed)
npm install -g wrangler

# Login to Cloudflare
wrangler login
```

This will open your browser to authenticate.

### 2. Create Cloudflare Resources

Run the setup script to create all necessary resources:

```bash
chmod +x scripts/setup-cloudflare.sh
./scripts/setup-cloudflare.sh
```

This script will:
- ✅ Create D1 database (`redispute-dev`)
- ✅ Apply database schema (8 tables)
- ✅ Load seed data (test merchants and disputes)
- ✅ Create KV namespaces (SESSIONS, CACHE, WEBHOOK_LOG)
- ✅ Save resource IDs to `.cloudflare-config`

**Expected output:**
```
🚀 Redispute - Cloudflare Setup
================================
✓ Wrangler CLI found
✓ Already authenticated

================================
Step 1: Creating D1 Database
================================
✓ Created database 'redispute-dev'
Development Database ID: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
✓ Schema applied
✓ Seed data loaded

================================
Step 2: Creating KV Namespaces
================================
✓ Created KV namespace 'SESSIONS'
SESSIONS ID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
✓ Created KV namespace 'CACHE'
CACHE ID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
✓ Created KV namespace 'WEBHOOK_LOG'
WEBHOOK_LOG ID: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

================================
Step 3: Configuration Summary
================================
✓ Configuration saved to .cloudflare-config

📋 Resource IDs:
   D1 Database:   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   KV SESSIONS:   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   KV CACHE:      xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   KV WEBHOOK_LOG: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3. Update Wrangler Configuration

Update all wrangler.toml files with the resource IDs:

```bash
chmod +x scripts/update-wrangler-config.sh
./scripts/update-wrangler-config.sh
```

This automatically updates:
- `workers/api/wrangler.toml`
- `workers/webhooks/wrangler.toml`
- `workers/email-parser/wrangler.toml`
- `workers/scheduled/wrangler.toml`
- `apps/admin/wrangler.toml`

### 4. Create Shopify Partner App

Before setting secrets, you need Shopify API credentials:

1. Go to [Shopify Partners](https://partners.shopify.com/)
2. Click **Apps** → **Create app** → **Create app manually**
3. Fill in app details:
   - **App name**: PreventFlow (Dev)
   - **App URL**: `https://redispute-admin.pages.dev` (temporary, will update after deployment)
   - **Allowed redirection URL(s)**:
     ```
     https://redispute-admin.pages.dev/auth/callback
     ```
4. Click **Create app**
5. Go to **App setup** → **Configuration**
6. Copy your **Client ID** and **Client secret**

### 5. Set Secrets

Set all required secrets for the workers:

#### API Worker Secrets

```bash
cd workers/api

# Shopify credentials
wrangler secret put SHOPIFY_CLIENT_ID
# Paste your Shopify Client ID when prompted

wrangler secret put SHOPIFY_CLIENT_SECRET
# Paste your Shopify Client Secret when prompted

# Stripe credentials (get from https://dashboard.stripe.com/test/apikeys)
wrangler secret put STRIPE_SECRET_KEY
# Paste your Stripe test secret key (sk_test_...)

# Stripe webhook secret (get after creating webhook endpoint)
wrangler secret put STRIPE_WEBHOOK_SECRET
# Paste webhook signing secret (whsec_...)

# PayPal credentials (optional for MVP, can set dummy values)
wrangler secret put PAYPAL_CLIENT_ID
wrangler secret put PAYPAL_CLIENT_SECRET

# OpenAI API key (get from https://platform.openai.com/api-keys)
wrangler secret put OPENAI_API_KEY
# Paste your OpenAI API key (sk-...)

cd ../..
```

#### Admin App Secrets

```bash
cd apps/admin

wrangler secret put SHOPIFY_CLIENT_ID
# Same as above

wrangler secret put SHOPIFY_CLIENT_SECRET
# Same as above

cd ../..
```

#### Other Workers (Optional for MVP)

Email parser and scheduled workers can be configured later:

```bash
# Email parser (for Klarna)
cd workers/email-parser
wrangler secret put OPENAI_API_KEY
cd ../..

# Scheduled worker (for emails)
cd workers/scheduled
wrangler secret put RESEND_API_KEY  # Optional, for email notifications
cd ../..
```

### 6. Deploy Everything

Run the deployment script:

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

This will:
1. ✅ Run type checks and linter
2. ✅ Deploy API worker
3. ✅ Deploy Webhooks worker
4. ✅ Deploy Email parser worker
5. ✅ Deploy Scheduled worker
6. ✅ Build and deploy Admin app to Cloudflare Pages

**Expected output:**
```
🚀 Redispute - Deployment
=========================
✓ Authenticated with Cloudflare

================================
Step 1: Building Packages
================================
Running type checks...
Running linter...

================================
Step 2: Deploying Workers
================================
Deploying API Worker...
✓ API Worker deployed

Deploying Webhooks Worker...
✓ Webhooks Worker deployed

Deploying Email Parser Worker...
✓ Email Parser Worker deployed

Deploying Scheduled Worker...
✓ Scheduled Worker deployed

================================
Step 3: Deploying Admin App
================================
Building Remix admin app...
✓ Admin app built

Deploying to Cloudflare Pages...
✓ Admin app deployed

================================
✅ Deployment Complete!
================================

📍 Deployment URLs:
   Admin Dashboard: https://redispute-admin.pages.dev
   API Worker:      https://redispute-api-dev.your-subdomain.workers.dev
```

### 7. Update Shopify App URLs

Now that your app is deployed, update the Shopify app configuration:

1. Go to [Shopify Partners](https://partners.shopify.com/)
2. Click your app → **Configuration**
3. Update URLs:
   - **App URL**: `https://redispute-admin.pages.dev`
   - **Allowed redirection URL(s)**: `https://redispute-admin.pages.dev/auth/callback`
4. Click **Save**

### 8. Configure Shopify Webhooks

Set up webhook endpoints in your Shopify app:

1. In Shopify Partner Dashboard → **Configuration**
2. Scroll to **Webhooks** section
3. Add the following webhooks:

| Topic | URL |
|-------|-----|
| `orders/create` | `https://redispute-webhooks-dev.your-subdomain.workers.dev/webhooks/shopify/orders-create` |
| `orders/paid` | `https://redispute-webhooks-dev.your-subdomain.workers.dev/webhooks/shopify/orders-paid` |
| `disputes/create` | `https://redispute-webhooks-dev.your-subdomain.workers.dev/webhooks/shopify/disputes-create` |
| `refunds/create` | `https://redispute-webhooks-dev.your-subdomain.workers.dev/webhooks/shopify/refunds-create` |
| `app/uninstalled` | `https://redispute-webhooks-dev.your-subdomain.workers.dev/webhooks/shopify/app-uninstalled` |

4. Set webhook version to **2024-10 or later**

### 9. Test the Installation

Test the complete OAuth flow:

1. Create a Shopify development store (if you don't have one):
   - Shopify Partners → **Stores** → **Add store** → **Development store**

2. Install the app:
   ```
   https://redispute-admin.pages.dev/auth?shop=your-dev-store.myshopify.com
   ```

3. Complete OAuth flow:
   - You'll be redirected to Shopify to authorize
   - Grant permissions
   - You'll be redirected back to the dashboard

4. Verify dashboard loads:
   - Should show dispute rate, stats, and welcome message
   - Check browser console for errors

### 10. Verify Database

Check that the merchant was created in D1:

```bash
wrangler d1 execute redispute-dev --command="SELECT * FROM merchants"
```

Expected output:
```
┌─────────────────┬────────────────────────┬──────────────┬──────────────────┐
│ id              │ shop_domain            │ tier         │ dispute_rate     │
├─────────────────┼────────────────────────┼──────────────┼──────────────────┤
│ mrch_xxx        │ your-store.myshopify…  │ free         │ 0.0              │
└─────────────────┴────────────────────────┴──────────────┴──────────────────┘
```

## Deployment Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Cloudflare Global Network                │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐  ┌───────────────┐ │
│  │  Admin App     │  │  API Worker    │  │  Webhooks     │ │
│  │  (Pages)       │  │                │  │  Worker       │ │
│  │  Remix + React │  │  Hono + D1     │  │  Event Queue  │ │
│  └────────────────┘  └────────────────┘  └───────────────┘ │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐                     │
│  │  Email Parser  │  │  Scheduled     │                     │
│  │  Worker        │  │  Worker        │                     │
│  │  (Klarna)      │  │  (Cron Jobs)   │                     │
│  └────────────────┘  └────────────────┘                     │
│                                                               │
│  ┌────────────────┐  ┌────────────────┐  ┌───────────────┐ │
│  │  D1 Database   │  │  KV Namespaces │  │  Durable      │ │
│  │  (SQLite)      │  │  (Sessions)    │  │  Objects      │ │
│  └────────────────┘  └────────────────┘  └───────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Monitoring

### View Logs

**API Worker logs:**
```bash
cd workers/api
wrangler tail
```

**Admin app logs:**
```bash
cd apps/admin
wrangler pages deployment tail
```

### Check Analytics

1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. **Workers & Pages** → **redispute-api-dev**
3. View:
   - Request volume
   - Error rates
   - Response times
   - CPU usage

### Database Queries

```bash
# View all merchants
wrangler d1 execute redispute-dev --command="SELECT * FROM merchants"

# View recent orders
wrangler d1 execute redispute-dev --command="SELECT * FROM orders ORDER BY created_at DESC LIMIT 10"

# View chargebacks
wrangler d1 execute redispute-dev --command="SELECT * FROM chargebacks"

# Check webhook log
wrangler d1 execute redispute-dev --command="SELECT * FROM webhook_log ORDER BY created_at DESC LIMIT 10"
```

## Troubleshooting

### Issue: "database_id is empty"

**Solution**: Run `./scripts/update-wrangler-config.sh` to update wrangler.toml files.

### Issue: "Secret not found"

**Solution**: Ensure you've set all required secrets with `wrangler secret put`.

### Issue: "OAuth error: invalid_hmac"

**Solution**: Verify `SHOPIFY_CLIENT_SECRET` is set correctly in both API worker and admin app.

### Issue: "Merchant not found"

**Solution**: Check D1 database connection and verify merchant was created during OAuth.

### Issue: "Pages deployment failed"

**Solution**:
1. Check build output: `cd apps/admin && pnpm run build`
2. Verify `build/client` directory exists
3. Ensure wrangler.toml has correct project name

### Issue: "Worker exceeded CPU time"

**Solution**: This shouldn't happen in MVP. If it does, check for infinite loops or heavy computations.

## Rollback

If deployment fails, rollback to previous version:

```bash
# Rollback API worker
cd workers/api
wrangler rollback

# Rollback admin app
cd apps/admin
wrangler pages deployment list --project-name=redispute-admin
wrangler pages deployment rollback <deployment-id>
```

## Production Deployment

For production (after MVP testing):

1. Create production D1 database:
   ```bash
   wrangler d1 create redispute-prod
   wrangler d1 execute redispute-prod --file=packages/database/schema.sql
   ```

2. Create production KV namespaces

3. Update wrangler.toml `[env.production]` sections

4. Set production secrets:
   ```bash
   wrangler secret put SHOPIFY_CLIENT_ID --env production
   ```

5. Deploy to production:
   ```bash
   wrangler deploy --env production
   ```

6. Set up custom domain (redispute.com)

## Cost Estimate

**Cloudflare Free Tier** (should cover MVP):
- Workers: 100K requests/day
- Pages: Unlimited requests
- D1: 100K reads/day, 1K writes/day
- KV: 100K reads/day, 1K writes/day

**Estimated costs for 100 merchants**:
- Workers: Free (within limits)
- D1: Free (within limits)
- KV: Free (within limits)
- **Total: $0/month**

**At scale (1,000 merchants)**:
- Workers Paid: $5/month
- D1: $5/month
- **Total: ~$10/month**

## Next Steps

After successful deployment:

1. ✅ Test OAuth flow
2. ✅ Verify dashboard loads
3. ✅ Check database connectivity
4. ⏳ Configure Stripe webhooks (Day 2)
5. ⏳ Set up Klarna email forwarding (Day 2)
6. ⏳ Implement multi-processor integration (Day 2)
7. ⏳ Build prevention layer (Day 3)

---

**Questions or issues?** Check logs with `wrangler tail` or review the [Cloudflare Workers docs](https://developers.cloudflare.com/workers/).
