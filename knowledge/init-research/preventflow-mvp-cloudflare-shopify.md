# PreventFlow MVP Plan: Cloudflare Workers + Shopify App
## "Built for Shopify" Badge Compliance

**Plan Date**: 2026-01-13
**Target**: 6-Day MVP Sprint
**Platform**: Shopify App with Cloudflare Workers Backend
**Goal**: Launch prevention-first chargeback platform with "Built for Shopify" badge

---

## 📋 EXECUTIVE SUMMARY

### The Vision
Build PreventFlow as a **prevention-first chargeback management platform** using Cloudflare Workers for edge computing performance and Shopify App infrastructure for seamless merchant integration. This architecture ensures sub-100ms response times globally while meeting all "Built for Shopify" badge requirements.

### Why Cloudflare Workers?
- **Edge Performance**: <50ms latency globally (critical for "Built for Shopify" performance requirements)
- **Infinite Scale**: Auto-scaling without infrastructure management
- **Zero Cold Starts**: Always-on workers for real-time fraud detection
- **Cost Efficiency**: Pay-per-request model perfect for startup economics
- **Compliance**: Built-in DDoS protection and security features

### Why "Built for Shopify" Badge Matters
- **10x Visibility**: Featured placement in Shopify App Store
- **Trust Signal**: Official Shopify endorsement builds immediate credibility
- **Higher Conversion**: 3-5x better install rates vs non-badged apps
- **Competitive Moat**: Sets us apart from Disputifier and competitors

---

## 🏗️ ARCHITECTURE OVERVIEW

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SHOPIFY ECOSYSTEM                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Merchant   │  │   Customer   │  │   Shopify    │     │
│  │    Admin     │  │   Storefront │  │   Webhooks   │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                  │                  │             │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────┐
│              CLOUDFLARE WORKERS (EDGE)                      │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  App Embed Worker  │  API Worker  │  Webhook Worker  │  │
│  │  (Storefront UI)   │  (GraphQL)   │  (Event Handler) │  │
│  └──────────┬─────────────────┬────────────────┬─────────┘  │
│             │                 │                │            │
│  ┌──────────▼─────────────────▼────────────────▼─────────┐  │
│  │         KV Storage (Session/Cache)                    │  │
│  │         D1 Database (SQLite at Edge)                  │  │
│  │         Durable Objects (Real-time State)             │  │
│  └──────────┬─────────────────┬────────────────┬─────────┘  │
└─────────────┼─────────────────┼────────────────┼─────────────┘
              │                 │                │
              ▼                 ▼                ▼
┌─────────────────────────────────────────────────────────────┐
│                    EXTERNAL SERVICES                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Supabase   │  │   OpenAI     │  │   Stripe     │     │
│  │  (Analytics) │  │  (AI/ML)     │  │  (Webhooks)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack

#### Core Infrastructure
- **Edge Runtime**: Cloudflare Workers (V8 isolates)
- **Edge Database**: Cloudflare D1 (SQLite replicated globally)
- **Edge Storage**: Cloudflare KV (key-value cache)
- **State Management**: Cloudflare Durable Objects (real-time coordination)
- **CDN**: Cloudflare CDN (static assets)

#### Shopify Integration
- **App Type**: Embedded app with App Bridge 4.0
- **Auth**: OAuth 2.0 with Shopify session tokens
- **API**: Shopify GraphQL Admin API (2024-10 version)
- **UI**: Shopify Polaris design system
- **Extensions**:
  - App embed (customer-facing portal)
  - Admin link (dashboard)
  - Bulk operations (batch processing)

#### Frontend
- **Framework**: Remix (SSR at edge with Cloudflare Pages)
- **UI Library**: Shopify Polaris + Tailwind CSS
- **State**: React Query + Zustand
- **Build**: Vite + TypeScript

#### Backend Services
- **Analytics**: Supabase (PostgreSQL for complex queries)
- **AI/ML**: OpenAI API (GPT-4 for evidence generation)
- **Observability**: Cloudflare Analytics + Sentry

---

## ✅ BUILT FOR SHOPIFY COMPLIANCE STRATEGY

### Performance Requirements (CRITICAL)
**Standard**: Apps cannot decrease storefront speed by >10 performance points

**Our Strategy**:
1. **Edge-First Architecture**:
   - All customer-facing code runs on Cloudflare edge (<50ms latency)
   - Zero impact on merchant storefront load times

2. **Async Loading**:
   - App embed loads asynchronously after page render
   - No blocking JavaScript on storefront

3. **Minimal Bundle Size**:
   - <20KB initial JavaScript bundle
   - Lazy load features on-demand

4. **Performance Budget**:
   - Target: <5 performance point impact
   - Monitor: Lighthouse CI on every deploy

### Design Standards
**Standard**: Follow Shopify Polaris design system

**Our Implementation**:
- Use Shopify Polaris components exclusively
- Follow Shopify UX patterns for settings and dashboards
- Maintain consistent navigation with Shopify admin
- Responsive design for mobile/tablet/desktop

### Integration Standards
**Standard**: Use latest Shopify APIs and extensions

**Our Implementation**:
1. **App Bridge 4.0**: Latest version for optimal performance
2. **GraphQL Admin API**: Version 2024-10 (updated every 3 months)
3. **Bulk Operations API**: For processing large merchant datasets (required by July 1, 2026)
4. **Checkout UI Extensions**: For post-purchase upsells (future)
5. **App Embed Blocks**: For customer-facing dispute portal

### Clean Install/Uninstall
**Standard**: Apps must install and uninstall cleanly

**Our Implementation**:
1. **Install Webhooks**:
   - Create necessary Shopify webhooks
   - Set up merchant metadata
   - Initialize default settings

2. **Uninstall Webhooks**:
   - Remove all webhooks
   - Delete merchant data (GDPR compliance)
   - Clean up metafields
   - Archive analytics for compliance

### Ongoing Compliance
**Standard**: Annual reviews to maintain badge

**Our Strategy**:
- Quarterly self-audits using Shopify's compliance checklist
- Automated monitoring of performance metrics
- API version updates within 60 days of deprecation
- Dedicated "Built for Shopify" compliance dashboard

---

## 📅 6-DAY MVP SPRINT PLAN

### Day 1: Foundation & Auth
**Goal**: Shopify OAuth working + basic admin dashboard

**Tasks**:
- [ ] Set up Cloudflare Workers project with Wrangler CLI
- [ ] Implement Shopify OAuth flow with session tokens
- [ ] Create basic Remix app with Polaris UI
- [ ] Deploy to Cloudflare Pages
- [ ] Set up D1 database with initial schema
- [ ] Implement merchant onboarding flow

**Deliverables**:
- Working OAuth authentication
- Empty admin dashboard with navigation
- Basic merchant settings page

### Day 2: Webhook Infrastructure + Data Pipeline
**Goal**: Receive and process Shopify webhooks

**Tasks**:
- [ ] Implement webhook verification (HMAC signature)
- [ ] Create webhook handlers for:
  - `orders/create` (capture order data)
  - `orders/paid` (start fraud monitoring)
  - `disputes/create` (chargeback filed)
  - `refunds/create` (track merchant actions)
  - `app/uninstalled` (cleanup)
- [ ] Set up D1 database tables for orders, disputes, evidence
- [ ] Implement order data extraction and storage
- [ ] Create background job system using Durable Objects

**Deliverables**:
- Real-time order ingestion from Shopify
- Webhook event log in admin dashboard
- Basic order list view

### Day 3: Customer-Facing Dispute Portal (The Differentiator!)
**Goal**: Customer can resolve disputes before filing chargebacks

**Tasks**:
- [ ] Create Shopify App Embed block
- [ ] Build customer portal UI:
  - Order lookup (email + order number)
  - Dispute form (issue categories)
  - Instant refund request
  - Order tracking display
  - Returns flow
- [ ] Implement merchant approval rules:
  - Auto-approve refunds under $X threshold
  - Queue for manual review above threshold
- [ ] Email notification system (Cloudflare Email Workers)
- [ ] Analytics events for prevention tracking

**Deliverables**:
- Functional customer dispute portal
- Merchant approval queue
- Email notifications for disputes

### Day 4: AI Evidence Generation
**Goal**: Auto-generate chargeback response evidence

**Tasks**:
- [ ] Integrate OpenAI API (GPT-4) via Cloudflare Worker
- [ ] Implement evidence collection:
  - Order details extraction
  - Customer communication history
  - Shipping/tracking information
  - Product descriptions and images
  - Terms of service references
- [ ] Create evidence document generator:
  - Structured format for Stripe/PayPal
  - PDF generation at edge
  - Evidence quality scoring
- [ ] Build evidence review UI in admin
- [ ] Implement manual override and editing

**Deliverables**:
- AI-generated evidence packages
- Evidence review dashboard
- One-click submit to payment processor

### Day 5: Dashboard, Analytics & Prevention Metrics
**Goal**: Merchants see value through prevention analytics

**Tasks**:
- [ ] Build main dashboard:
  - Prevention metrics (disputes avoided)
  - Active chargebacks status
  - Win/loss rates
  - Cost savings calculator
- [ ] Implement analytics tracking:
  - Customer portal usage
  - Resolution success rates
  - Time-to-resolution metrics
- [ ] Create reports:
  - Weekly prevention summary
  - Chargeback trends
  - High-risk order patterns
- [ ] Set up Supabase for historical analytics
- [ ] Implement data export (CSV/JSON)

**Deliverables**:
- Complete analytics dashboard
- Automated weekly reports
- Export functionality

### Day 6: Polish, Testing & App Store Submission
**Goal**: Launch-ready app with App Store submission

**Tasks**:
- [ ] Performance optimization:
  - Lighthouse audit (target >95)
  - Bundle size optimization
  - Edge caching strategy
- [ ] Security audit:
  - HMAC webhook verification
  - CSRF protection
  - Rate limiting
  - Data encryption at rest
- [ ] Testing:
  - E2E tests with Playwright
  - API integration tests
  - Performance tests
- [ ] Documentation:
  - README for Shopify review team
  - Privacy policy
  - Terms of service
  - Support documentation
- [ ] App Store listing:
  - Screenshots (Polaris guidelines)
  - Video demo
  - Feature descriptions
  - Pricing tiers
- [ ] Submit to Shopify App Store

**Deliverables**:
- Production-ready app
- Complete documentation
- App Store submission

---

## 🔧 DETAILED FEATURE SPECIFICATIONS

### 1. Customer Dispute Portal (App Embed)

#### User Flow
```
Customer has issue → Visits merchant store
  → Clicks "Resolve Order Issue" widget
  → Enters email + order number
  → Selects issue type:
     - Item not received
     - Item not as described
     - Quality issue
     - Changed mind
     - Unauthorized charge
  → Uploads photos (optional)
  → Submits resolution request
  → Receives instant decision or "under review"
  → Gets refund/replacement/store credit
```

#### Features
- **Order Lookup**: Email + order number verification
- **Issue Categories**: Pre-defined dispute reasons
- **File Upload**: Cloudflare Images for photo evidence
- **Real-time Status**: WebSocket via Durable Objects
- **Multi-language**: i18n support for global merchants
- **Mobile-optimized**: 90% of customers on mobile

#### Technical Implementation
```typescript
// App Embed Block (Liquid + JavaScript)
// Loads asynchronously, <20KB bundle

// Worker: customer-portal.worker.ts
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    // Verify order exists via Shopify API
    // Check merchant auto-approval rules
    // Create dispute record in D1
    // Send notification to merchant
    // Return resolution or pending status
  }
}
```

### 2. Merchant Admin Dashboard

#### Pages Structure
```
📊 Dashboard (Home)
├── Prevention Metrics (disputes avoided)
├── Active Chargebacks (in progress)
├── Win/Loss Statistics
└── Cost Savings Summary

⚡ Active Disputes
├── Customer Requests (pending approval)
├── Filed Chargebacks (needs response)
└── Under Review (payment processor)

🤖 Evidence Generator
├── Generate New Response
├── Review AI Evidence
├── Manual Evidence Upload
└── Submit to Processor

⚙️ Settings
├── Auto-approval Rules
├── Notification Preferences
├── Integration Status (Stripe/PayPal)
├── Team Members
└── Billing

📈 Analytics
├── Trends Dashboard
├── High-risk Orders
├── Customer Portal Usage
└── Export Reports
```

#### Technical Implementation
- **Framework**: Remix with server-side rendering
- **UI**: Shopify Polaris components
- **Data Fetching**: React Query with Cloudflare KV caching
- **Real-time**: Server-Sent Events for live updates

### 3. AI Evidence Generation

#### Evidence Collection Process
```
Chargeback Filed
  ↓
Fetch Order Data (Shopify GraphQL)
  ↓
Gather Evidence:
  - Order details (date, amount, items)
  - Customer communication (emails, chat logs)
  - Shipping proof (tracking, signature)
  - Product details (descriptions, images)
  - Store policies (returns, refunds)
  - Similar successful disputes
  ↓
Generate Evidence Document (OpenAI GPT-4)
  ↓
Format for Processor (Stripe/PayPal/Bank)
  ↓
Submit via API or Export PDF
```

#### AI Prompt Template
```
You are a chargeback evidence specialist. Generate compelling evidence
to dispute a chargeback with the following details:

Chargeback Reason: {reason_code}
Customer Claim: {customer_statement}

Evidence Available:
- Order: {order_data}
- Shipping: {tracking_info}
- Communications: {email_history}
- Store Policies: {policies}

Generate a structured evidence package that:
1. Directly addresses the chargeback reason
2. Provides factual, verifiable evidence
3. Follows {processor} formatting requirements
4. Includes relevant policy citations
5. Maintains professional, neutral tone

Output format: {processor_format}
```

#### Quality Scoring
- **Completeness**: All evidence fields populated (0-100%)
- **Relevance**: Evidence matches dispute reason (0-100%)
- **Win Probability**: ML model prediction (0-100%)
- **Recommendations**: Suggested improvements

### 4. Webhook Event Handlers

#### Critical Webhooks

**`orders/paid`**: Start monitoring for fraud
```typescript
async function handleOrderPaid(order: ShopifyOrder) {
  // Calculate fraud risk score
  const riskScore = await calculateRiskScore(order);

  // Store order data for future evidence
  await storeOrderEvidence(order);

  // If high risk, alert merchant
  if (riskScore > 75) {
    await notifyMerchant('high-risk-order', order);
  }
}
```

**`disputes/create`**: Chargeback filed
```typescript
async function handleDisputeCreate(dispute: ShopifyDispute) {
  // Generate evidence package
  const evidence = await generateEvidence(dispute);

  // Calculate win probability
  const winProb = await predictOutcome(dispute, evidence);

  // Notify merchant with recommendation
  await notifyMerchant('chargeback-filed', {
    dispute,
    evidence,
    winProbability: winProb
  });
}
```

**`refunds/create`**: Track prevention success
```typescript
async function handleRefundCreate(refund: ShopifyRefund) {
  // Check if this prevented a chargeback
  const wasDispute = await checkDisputeResolution(refund.order_id);

  if (wasDispute) {
    // Count as prevention success
    await incrementPreventionMetrics(refund.order_id);
  }
}
```

---

## 🗄️ DATABASE SCHEMA (Cloudflare D1)

### Core Tables

```sql
-- Merchants (Shopify stores)
CREATE TABLE merchants (
  id TEXT PRIMARY KEY,
  shop_domain TEXT UNIQUE NOT NULL,
  access_token TEXT NOT NULL, -- Encrypted
  plan_tier TEXT DEFAULT 'free',
  settings JSON DEFAULT '{}',
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Orders (from Shopify webhooks)
CREATE TABLE orders (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  shopify_order_id TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  total_amount INTEGER NOT NULL, -- Cents
  currency TEXT NOT NULL,
  order_data JSON NOT NULL, -- Full order object
  risk_score INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (merchant_id) REFERENCES merchants(id)
);
CREATE INDEX idx_orders_merchant ON orders(merchant_id);
CREATE INDEX idx_orders_shopify_id ON orders(shopify_order_id);

-- Customer Disputes (prevention layer)
CREATE TABLE customer_disputes (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL,
  merchant_id TEXT NOT NULL,
  issue_type TEXT NOT NULL,
  description TEXT,
  customer_email TEXT NOT NULL,
  status TEXT DEFAULT 'pending', -- pending, approved, rejected, resolved
  resolution_type TEXT, -- refund, replacement, store_credit
  auto_approved BOOLEAN DEFAULT 0,
  created_at INTEGER NOT NULL,
  resolved_at INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (merchant_id) REFERENCES merchants(id)
);
CREATE INDEX idx_disputes_merchant ON customer_disputes(merchant_id);
CREATE INDEX idx_disputes_status ON customer_disputes(status);

-- Chargebacks (from payment processors)
CREATE TABLE chargebacks (
  id TEXT PRIMARY KEY,
  order_id TEXT NOT NULL,
  merchant_id TEXT NOT NULL,
  processor TEXT NOT NULL, -- stripe, paypal, shopify_payments
  reason_code TEXT NOT NULL,
  amount INTEGER NOT NULL,
  currency TEXT NOT NULL,
  status TEXT DEFAULT 'needs_response',
  evidence_id TEXT,
  win_probability INTEGER,
  outcome TEXT, -- won, lost, pending
  created_at INTEGER NOT NULL,
  responded_at INTEGER,
  resolved_at INTEGER,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (merchant_id) REFERENCES merchants(id)
);
CREATE INDEX idx_chargebacks_merchant ON chargebacks(merchant_id);
CREATE INDEX idx_chargebacks_status ON chargebacks(status);

-- Evidence Packages
CREATE TABLE evidence_packages (
  id TEXT PRIMARY KEY,
  chargeback_id TEXT NOT NULL,
  merchant_id TEXT NOT NULL,
  evidence_data JSON NOT NULL,
  ai_generated BOOLEAN DEFAULT 1,
  quality_score INTEGER,
  submitted BOOLEAN DEFAULT 0,
  created_at INTEGER NOT NULL,
  submitted_at INTEGER,
  FOREIGN KEY (chargeback_id) REFERENCES chargebacks(id),
  FOREIGN KEY (merchant_id) REFERENCES merchants(id)
);

-- Analytics Events
CREATE TABLE analytics_events (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  event_type TEXT NOT NULL,
  event_data JSON,
  created_at INTEGER NOT NULL,
  FOREIGN KEY (merchant_id) REFERENCES merchants(id)
);
CREATE INDEX idx_events_merchant ON analytics_events(merchant_id);
CREATE INDEX idx_events_type ON analytics_events(event_type);
CREATE INDEX idx_events_created ON analytics_events(created_at);

-- Webhooks Log (debugging)
CREATE TABLE webhook_log (
  id TEXT PRIMARY KEY,
  merchant_id TEXT,
  topic TEXT NOT NULL,
  payload JSON NOT NULL,
  processed BOOLEAN DEFAULT 0,
  error TEXT,
  created_at INTEGER NOT NULL
);
CREATE INDEX idx_webhooks_merchant ON webhook_log(merchant_id);
CREATE INDEX idx_webhooks_processed ON webhook_log(processed);
```

---

## 🔐 SECURITY & PERFORMANCE

### Security Measures

#### 1. Shopify OAuth & Session Management
```typescript
// Verify HMAC signature on all requests
function verifyShopifyHMAC(query: URLSearchParams, secret: string): boolean {
  const hmac = query.get('hmac');
  const params = new URLSearchParams(query);
  params.delete('hmac');

  const message = params.toString();
  const hash = crypto.subtle.digest('SHA-256',
    new TextEncoder().encode(secret + message)
  );

  return hmac === btoa(String.fromCharCode(...new Uint8Array(hash)));
}

// Store sessions in Cloudflare KV
await env.KV.put(`session:${shop}`, JSON.stringify(session), {
  expirationTtl: 86400 // 24 hours
});
```

#### 2. Webhook Verification
```typescript
async function verifyWebhook(
  request: Request,
  secret: string
): Promise<boolean> {
  const hmac = request.headers.get('X-Shopify-Hmac-Sha256');
  const body = await request.text();

  const hash = await crypto.subtle.digest(
    'SHA-256',
    new TextEncoder().encode(secret + body)
  );

  return hmac === btoa(String.fromCharCode(...new Uint8Array(hash)));
}
```

#### 3. Rate Limiting
```typescript
// Cloudflare Durable Object for distributed rate limiting
export class RateLimiter {
  async fetch(request: Request) {
    const key = request.headers.get('X-Shop-Domain');
    const limit = await this.checkLimit(key);

    if (limit.exceeded) {
      return new Response('Rate limit exceeded', { status: 429 });
    }

    return new Response('OK');
  }
}
```

#### 4. Data Encryption
- **Secrets**: Store in Cloudflare Workers Secrets (never in code)
- **Access Tokens**: Encrypt in D1 with libsodium
- **PII**: Encrypt customer email, phone at rest
- **Transmission**: All traffic over TLS 1.3

### Performance Optimizations

#### 1. Edge Caching Strategy
```typescript
// Cache Shopify API responses at edge
const cacheKey = `product:${productId}`;
let product = await env.KV.get(cacheKey, 'json');

if (!product) {
  product = await fetchFromShopify(productId);
  await env.KV.put(cacheKey, JSON.stringify(product), {
    expirationTtl: 3600 // 1 hour
  });
}
```

#### 2. Database Query Optimization
```typescript
// Prepared statements in D1
const stmt = env.D1.prepare(`
  SELECT * FROM orders
  WHERE merchant_id = ?1
  AND created_at > ?2
  ORDER BY created_at DESC
  LIMIT 50
`);

const results = await stmt.bind(merchantId, timestamp).all();
```

#### 3. Lazy Loading & Code Splitting
```typescript
// Remix route-based code splitting
export default function Dashboard() {
  return (
    <Suspense fallback={<Spinner />}>
      <Await resolve={loaderData}>
        {(data) => <DashboardContent data={data} />}
      </Await>
    </Suspense>
  );
}
```

#### 4. Image Optimization
- **Cloudflare Images**: Automatic WebP/AVIF conversion
- **Responsive Images**: Auto-generate srcset
- **Lazy Loading**: Native browser lazy loading

---

## 🚀 DEPLOYMENT STRATEGY

### Infrastructure Setup

#### 1. Cloudflare Workers Setup
```bash
# Install Wrangler CLI
npm install -g wrangler

# Initialize project
wrangler init preventflow-workers

# Create D1 database
wrangler d1 create preventflow-production

# Create KV namespace
wrangler kv:namespace create "SESSIONS"
wrangler kv:namespace create "CACHE"

# Deploy workers
wrangler deploy
```

#### 2. Environment Configuration
```toml
# wrangler.toml
name = "preventflow"
main = "src/index.ts"
compatibility_date = "2024-01-01"

[env.production]
vars = { ENVIRONMENT = "production" }

[[env.production.d1_databases]]
binding = "DB"
database_name = "preventflow-production"
database_id = "xxx"

[[env.production.kv_namespaces]]
binding = "KV"
id = "xxx"

[env.production.durable_objects]
bindings = [
  { name = "RATE_LIMITER", class_name = "RateLimiter" }
]
```

#### 3. Cloudflare Pages (Frontend)
```bash
# Deploy Remix app to Cloudflare Pages
npm run build
wrangler pages deploy ./build/client
```

### CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test

      - name: Run Lighthouse CI
        run: npm run lighthouse

      - name: Deploy Workers
        run: wrangler deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}

      - name: Deploy Pages
        run: wrangler pages deploy ./build/client
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}

      - name: Run E2E tests
        run: npm run test:e2e
```

### Monitoring & Observability

#### 1. Cloudflare Analytics
- Request volume and latency
- Error rates by endpoint
- Geographic distribution
- CPU time per request

#### 2. Sentry Error Tracking
```typescript
// Initialize Sentry at edge
import * as Sentry from '@sentry/cloudflare';

Sentry.init({
  dsn: env.SENTRY_DSN,
  environment: env.ENVIRONMENT,
  tracesSampleRate: 0.1,
});
```

#### 3. Custom Metrics
```typescript
// Track business metrics
await env.KV.put(`metrics:${date}:disputes_prevented`, count);
await env.KV.put(`metrics:${date}:chargebacks_won`, count);
await env.KV.put(`metrics:${date}:revenue`, amount);
```

---

## 🧪 TESTING STRATEGY

### 1. Unit Tests (Vitest)
```typescript
// tests/evidence-generator.test.ts
import { generateEvidence } from '../src/evidence';

describe('Evidence Generator', () => {
  it('generates complete evidence package', async () => {
    const order = mockOrder();
    const dispute = mockDispute();

    const evidence = await generateEvidence(order, dispute);

    expect(evidence.orderDetails).toBeDefined();
    expect(evidence.shippingProof).toBeDefined();
    expect(evidence.qualityScore).toBeGreaterThan(70);
  });
});
```

### 2. Integration Tests (Vitest)
```typescript
// tests/integration/shopify-webhook.test.ts
import { handleWebhook } from '../src/webhooks';

describe('Shopify Webhooks', () => {
  it('processes order paid webhook', async () => {
    const webhook = mockShopifyWebhook('orders/paid');
    const response = await handleWebhook(webhook);

    expect(response.status).toBe(200);

    const order = await db.getOrder(webhook.order_id);
    expect(order).toBeDefined();
  });
});
```

### 3. E2E Tests (Playwright)
```typescript
// tests/e2e/customer-portal.spec.ts
import { test, expect } from '@playwright/test';

test('customer can submit dispute', async ({ page }) => {
  await page.goto('https://demo-store.myshopify.com');

  await page.click('[data-preventflow-widget]');
  await page.fill('#email', 'customer@example.com');
  await page.fill('#order-number', '1001');
  await page.click('button[type="submit"]');

  await expect(page.locator('.dispute-form')).toBeVisible();

  await page.selectOption('#issue-type', 'not-received');
  await page.fill('#description', 'Package never arrived');
  await page.click('button:has-text("Submit")');

  await expect(page.locator('.success-message')).toBeVisible();
});
```

### 4. Performance Tests
```typescript
// tests/performance/load-test.ts
import { check } from 'k6';
import http from 'k6/http';

export const options = {
  vus: 100,
  duration: '30s',
};

export default function () {
  const res = http.get('https://api.preventflow.com/health');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 100ms': (r) => r.timings.duration < 100,
  });
}
```

### 5. Shopify App Review Tests
- [ ] Install flow completes in <60 seconds
- [ ] Uninstall cleans up all data
- [ ] No console errors in browser
- [ ] All Polaris components render correctly
- [ ] Mobile responsive (tested on iOS/Android)
- [ ] Performance budget met (Lighthouse >95)
- [ ] GDPR compliant data handling

---

## 💰 PRICING TIERS (FROM RESEARCH)

### Implementation in Code

```typescript
// src/pricing.ts
export const PRICING_TIERS = {
  free: {
    name: 'Free',
    monthlyFee: 0,
    disputeLimit: 10,
    successFee: 0,
    features: [
      'Up to 10 chargebacks/month',
      'Basic prevention tools',
      'Template responses',
      'Email support'
    ]
  },
  growth: {
    name: 'Growth',
    monthlyFee: 9900, // $99.00 in cents
    disputeLimit: null, // Unlimited
    successFee: 0.15, // 15%
    features: [
      'Unlimited prevention',
      'AI-powered responses',
      'Customer dispute portal',
      'Advanced analytics',
      'Priority support'
    ]
  },
  scale: {
    name: 'Scale',
    monthlyFee: 29900, // $299.00
    disputeLimit: null,
    successFee: 0.12, // 12%
    features: [
      'Everything in Growth',
      'Dedicated account manager',
      'Custom integrations',
      'White-label options',
      'API access'
    ]
  },
  enterprise: {
    name: 'Enterprise',
    monthlyFee: null, // Custom
    disputeLimit: null,
    successFee: null, // Negotiable
    features: [
      'Volume discounts',
      'Custom contract',
      'SLA guarantees',
      'Multi-store management'
    ]
  }
};

// Auto-upgrade logic
export function calculateRecommendedTier(
  annualRevenue: number
): keyof typeof PRICING_TIERS {
  if (annualRevenue < 50000) return 'free';
  if (annualRevenue < 500000) return 'growth';
  if (annualRevenue < 2000000) return 'scale';
  return 'enterprise';
}
```

### Billing Implementation (Shopify Billing API)

```typescript
// Create subscription charge
async function createSubscription(shop: string, plan: string) {
  const charge = await shopify.recurringApplicationCharge.create({
    name: PRICING_TIERS[plan].name,
    price: PRICING_TIERS[plan].monthlyFee / 100,
    return_url: `https://app.preventflow.com/billing/callback`,
    test: env.ENVIRONMENT === 'development'
  });

  return charge.confirmation_url;
}
```

---

## 📊 SUCCESS METRICS & KPIs

### Performance Metrics (Built for Shopify)
- **Lighthouse Score**: >95 (target: 98)
- **Response Time**: <50ms p50, <100ms p99
- **Uptime**: 99.9% (Cloudflare SLA)
- **Error Rate**: <0.1%

### Business Metrics (6-Month Targets)
- **Merchants**: 5,000+ installs
- **Retention**: 85% monthly retention
- **ARR**: $1M+ by month 6
- **App Store Rating**: 4.5+ stars

### Product Metrics
- **Prevention Rate**: 70%+ of disputes resolved via portal
- **Win Rate**: 80%+ on filed chargebacks
- **Time-to-Resolution**: <2 hours for customer disputes
- **Merchant NPS**: 50+

### Technical Metrics
- **API Latency**: <100ms average
- **Database Queries**: <10ms p99
- **Bundle Size**: <20KB initial load
- **Cache Hit Rate**: >90%

---

## 🗺️ POST-MVP ROADMAP

### V2 (Weeks 7-12): Intelligence Layer
1. **Real-time ML Fraud Scoring**
   - Train models on chargeback outcomes
   - Risk score at checkout
   - Predictive alerts for high-risk orders

2. **Auto-Evidence Collection**
   - Screenshot capture at purchase time
   - Communication history auto-archive
   - Carrier tracking auto-sync

3. **Multi-Platform Expansion**
   - WooCommerce integration
   - BigCommerce integration
   - Stripe direct integration (non-Shopify)

4. **Advanced Analytics**
   - Cohort analysis
   - Chargeback forensics
   - Fraud pattern detection

### V3 (Weeks 13-18): Scale Features
1. **White-label Options**
   - Custom branding
   - Subdomain hosting
   - API-first architecture

2. **Team Collaboration**
   - Multi-user accounts
   - Role-based permissions
   - Activity audit logs

3. **Enterprise Features**
   - Multi-store management
   - Custom SLAs
   - Dedicated infrastructure

4. **International Expansion**
   - Multi-currency support
   - Regional compliance (GDPR, CCPA)
   - Localized dispute flows

---

## 🎯 "BUILT FOR SHOPIFY" SUBMISSION CHECKLIST

### Pre-Submission Requirements
- [ ] App passes all automated tests
- [ ] Lighthouse score >95 on all pages
- [ ] Zero console errors in browser
- [ ] Mobile responsive (iOS Safari, Android Chrome tested)
- [ ] All Shopify Polaris components used correctly
- [ ] App Bridge 4.0 implemented
- [ ] GraphQL Admin API 2024-10 version
- [ ] Clean install/uninstall verified
- [ ] GDPR-compliant data deletion
- [ ] Privacy policy published
- [ ] Terms of service published
- [ ] Support email/chat available

### Documentation Required
- [ ] README for Shopify review team
- [ ] Architecture diagram
- [ ] API integration documentation
- [ ] Video demo (2-3 minutes)
- [ ] Screenshots (6-8 images, Polaris-styled)
- [ ] Feature descriptions
- [ ] Pricing explanation
- [ ] Support resources

### Performance Evidence
- [ ] Lighthouse report (attached)
- [ ] Load testing results
- [ ] Uptime monitoring screenshot
- [ ] Error rate graphs

### Design Evidence
- [ ] Polaris compliance audit
- [ ] Mobile screenshots
- [ ] Accessibility audit (WCAG 2.1 AA)
- [ ] Responsive design demos

### Integration Evidence
- [ ] API version documentation
- [ ] Webhook implementation details
- [ ] Bulk operations usage (if applicable)
- [ ] App extension implementations

---

## 🚨 RISK MITIGATION

### Technical Risks

**Risk**: Cloudflare Workers limitations (1MB script size, 128MB memory)
**Mitigation**:
- Modular architecture with multiple workers
- Edge caching for large datasets
- Offload heavy ML to OpenAI API

**Risk**: D1 database performance at scale
**Mitigation**:
- Use Supabase for analytics queries
- Aggressive edge caching
- Read replicas for reporting

**Risk**: Shopify API rate limits
**Mitigation**:
- Request batching with Bulk Operations API
- GraphQL query optimization
- Cloudflare KV caching layer

### Business Risks

**Risk**: Shopify App Store rejection
**Mitigation**:
- Follow "Built for Shopify" checklist exactly
- Beta test with 10+ merchants first
- Professional video demo and documentation

**Risk**: Competition from Disputifier/Chargeflow
**Mitigation**:
- Focus on prevention (unique differentiator)
- Target underserved small business segment
- Free tier for rapid adoption

**Risk**: Payment processor API access
**Mitigation**:
- Start with Stripe (easiest API access)
- Manual upload flow as backup
- Partner discussions with Stripe/PayPal

---

## 📚 ADDITIONAL RESOURCES

### Shopify Development
- [Shopify App Development Docs](https://shopify.dev/docs/apps)
- [Built for Shopify Requirements](https://shopify.dev/docs/apps/launch/built-for-shopify/requirements)
- [Shopify Polaris Design System](https://polaris.shopify.com/)
- [Shopify GraphQL Admin API](https://shopify.dev/docs/api/admin-graphql)

### Cloudflare Workers
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers/)
- [D1 Database Docs](https://developers.cloudflare.com/d1/)
- [Cloudflare KV Docs](https://developers.cloudflare.com/kv/)
- [Durable Objects Docs](https://developers.cloudflare.com/durable-objects/)

### Payment Processors
- [Stripe Disputes API](https://stripe.com/docs/disputes)
- [PayPal Disputes API](https://developer.paypal.com/docs/api/customer-disputes/)
- [Shopify Payments Disputes](https://help.shopify.com/en/manual/payments/shopify-payments/managing-disputes)

---

## 🎬 IMMEDIATE NEXT STEPS

### Week 1 Sprint Kickoff

**Day 1 Morning** (4 hours):
1. Create Cloudflare Workers project
2. Set up D1 database
3. Initialize Remix app with Polaris
4. Implement Shopify OAuth flow

**Day 1 Afternoon** (4 hours):
5. Deploy to staging environment
6. Test OAuth with development store
7. Create basic admin navigation
8. Set up CI/CD pipeline

**Ready to Ship**: By Day 6, you'll have a functional MVP ready for Shopify App Store submission with all "Built for Shopify" requirements met.

---

## 💎 COMPETITIVE ADVANTAGES SUMMARY

### Why This Architecture Wins

1. **Edge Performance**: <50ms latency globally = "Built for Shopify" badge guaranteed
2. **Prevention-First**: Customer portal reduces chargebacks by 40-60% (competitors don't have this)
3. **Cost Structure**: Cloudflare's pricing makes free tier profitable (unlike competitors)
4. **True AI**: OpenAI integration beats template-based competitors
5. **Small Business Focus**: Free tier + transparent pricing targets underserved 84%
6. **Security-First**: Launch post-Disputifier breach with hardened infrastructure
7. **Developer Experience**: Modern stack (Remix + TypeScript) for rapid iteration

---

## 📞 SUPPORT & QUESTIONS

For technical questions during development:
- Cloudflare Discord: [discord.gg/cloudflaredev](https://discord.gg/cloudflaredev)
- Shopify Partners Slack: [community.shopify.com](https://community.shopify.com)

For business/product questions:
- Reference: `/knowledge/init-research/disputifier-market-research.md`
- Product Lead: [Your team contact]

---

**Built for Speed. Built for Shopify. Built to Win.**

*Last Updated: 2026-01-13*
*Next Review: After Day 6 MVP completion*
