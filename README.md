# Redispute (PreventFlow MVP)

**Payment Hold Prevention & Chargeback Management Platform for Shopify**

Redispute helps Shopify merchants stay below the critical 0.5% dispute rate threshold to avoid payment holds, while providing AI-powered dispute resolution tools.

## 🎯 What We're Building

A prevention-first chargeback management platform that:
1. **Prevents payment holds** by keeping dispute rates below 0.5%
2. **Prevents chargebacks** through automated customer intervention (40-60% reduction)
3. **Wins disputes** with AI-generated evidence (80%+ win rate)
4. **Unifies multi-processor management** (Shopify, Stripe, PayPal, Klarna)

## 🔥 Unique Differentiators

- **Klarna Email Parser** - First platform with automated Klarna dispute management
- **Payment Hold Prevention** - Real-time monitoring and alerts
- **Customer Dispute Portal** - Resolve issues before chargebacks are filed
- **AI Evidence Generation** - GPT-4 powered, <30 seconds per dispute
- **Multi-Processor Dashboard** - Unified view across all payment processors

## 📊 Market Opportunity

- **TAM**: $100M-200M (chargeback management software market)
- **Reference**: Disputifier at $36M ARR (3,000 merchants × $1,000/month avg)
- **Disruption**: Post-breach opportunity + prevention-first approach
- **Target**: $1.5M-2M MRR by Month 12

## 🏗️ Architecture

### Tech Stack

**Frontend**:
- Remix v2 (React SSR at edge)
- Shopify Polaris + Tailwind CSS
- Vite for builds

**Backend**:
- Cloudflare Workers (V8 isolates, sub-50ms latency)
- Cloudflare D1 (SQLite, globally replicated)
- Cloudflare KV (sessions, cache)
- Cloudflare Durable Objects (webhook queue)

**Integrations**:
- Shopify GraphQL Admin API
- Stripe API v2023-10
- PayPal Customer Disputes API
- OpenAI GPT-4 API

### Project Structure

```
redispute/
├── apps/
│   ├── admin/              # Merchant dashboard (Remix)
│   └── customer-portal/    # Customer dispute resolution (Day 3)
├── workers/
│   ├── api/               # Main API worker (Hono)
│   ├── webhooks/          # Event processing
│   ├── email-parser/      # Klarna email parser (UNIQUE!)
│   └── scheduled/         # Cron jobs (analytics, emails)
├── packages/
│   ├── database/          # D1 schema, migrations, seed data
│   ├── shared/            # Types, utils, constants
│   └── shopify/           # Shopify API wrapper
├── scripts/
│   ├── setup-cloudflare.sh    # Create Cloudflare resources
│   ├── update-wrangler-config.sh  # Update configuration
│   └── deploy.sh              # Deploy everything
├── knowledge/
│   ├── MVP-Implementation-Plan.md      # 20K word implementation guide
│   └── PreventFlow-MVP-Sprint.md       # Obsidian Kanban (217 tasks)
├── DEPLOYMENT.md          # Complete deployment guide
├── package.json           # Root monorepo config
├── pnpm-workspace.yaml    # PNPM workspace definition
└── turbo.json            # Turborepo build pipeline
```

## 🚀 Quick Start (Deployment)

See **[DEPLOYMENT.md](./DEPLOYMENT.md)** for the complete step-by-step deployment guide.

### TL;DR

```bash
# 1. Authenticate with Cloudflare
wrangler login

# 2. Create all Cloudflare resources
./scripts/setup-cloudflare.sh

# 3. Update configuration files
./scripts/update-wrangler-config.sh

# 4. Set secrets (Shopify, Stripe, OpenAI)
cd workers/api
wrangler secret put SHOPIFY_CLIENT_ID
wrangler secret put SHOPIFY_CLIENT_SECRET
wrangler secret put STRIPE_SECRET_KEY
wrangler secret put OPENAI_API_KEY

# 5. Deploy everything
cd ../..
./scripts/deploy.sh
```

## 📅 Development Roadmap

### ✅ Day 1: Foundation & Auth (COMPLETED - Jan 13, 2026)
- [x] Monorepo setup (PNPM + Turborepo)
- [x] TypeScript, ESLint, Prettier
- [x] 4 Cloudflare Workers (API, webhooks, email-parser, scheduled)
- [x] D1 database with 8 tables
- [x] Remix admin app with Shopify OAuth
- [x] Polaris dashboard (dispute rate, stats, welcome)
- [x] Deployment scripts and documentation

### ⏳ Day 2: Multi-Processor Integration
- [ ] Shopify Payments integration
- [ ] Stripe integration with webhooks
- [ ] PayPal integration
- [ ] Klarna email parser implementation
- [ ] Webhook infrastructure (Durable Objects queue)

### ⏳ Day 3: Prevention Layer
- [ ] Risk scoring engine (rules-based MVP)
- [ ] Automated prevention triggers
- [ ] Customer dispute portal (mobile-optimized)
- [ ] Merchant approval queue

### ⏳ Day 4: AI Evidence Generation
- [ ] Evidence collection engine
- [ ] OpenAI integration (GPT-4)
- [ ] Evidence quality scoring
- [ ] Evidence review UI

### ⏳ Day 5: Analytics & Billing
- [ ] Analytics dashboard with charts
- [ ] Shopify Billing API integration
- [ ] Email notifications (alerts, digests)
- [ ] Usage tracking and invoicing

### ⏳ Day 6: Polish, Security & Launch
- [ ] Security audit (HMAC, CSRF, encryption)
- [ ] Performance optimization (Lighthouse >95)
- [ ] Testing (unit, integration, E2E)
- [ ] Shopify App Store submission
- [ ] "Built for Shopify" badge application

## 🛠️ Development Commands

```bash
# Root commands
pnpm run dev          # Start all workspaces in dev mode
pnpm run build        # Build all workspaces
pnpm run lint         # Lint all workspaces
pnpm run type-check   # Type check all workspaces

# Admin app
cd apps/admin
pnpm run dev          # Start Remix dev server
pnpm run build        # Build for production

# API worker
cd workers/api
wrangler dev          # Start local dev server
wrangler deploy       # Deploy to Cloudflare
wrangler tail         # View live logs

# Database
wrangler d1 execute redispute-dev --command="SELECT * FROM merchants"
```

## 📊 Database Schema

8 core tables:

1. **merchants** - Shopify accounts and subscription status
2. **orders** - Order data with risk scores
3. **customer_disputes** - Prevention layer (customer portal)
4. **chargebacks** - Disputes from all 4 processors
5. **evidence_packages** - AI-generated evidence
6. **analytics_events** - Tracking and metrics
7. **webhook_log** - Debugging
8. **billing_records** - Subscription and usage fees

See [packages/database/schema.sql](./packages/database/schema.sql) for full schema.

## 🎯 Pricing Strategy

| Tier | Price | Features |
|------|-------|----------|
| **Free** | $0 | 5 disputes/month, basic tools |
| **Growth** | $299/mo | Unlimited disputes, AI evidence |
| **Scale** | $699/mo | Multi-store, priority support |
| **Enterprise** | $1,999/mo | Custom SLAs, dedicated support |

**Plus**: 12% success fee on prevented/won disputes

## 📈 Success Metrics

### MVP Goals (Week 1)
- ✅ App deployed to Cloudflare
- ✅ Shopify OAuth working
- ⏳ 10 beta merchants onboarded

### Month 3 Goals
- $100K MRR (80-120 paying merchants)
- 4.7+ App Store rating
- "Built for Shopify" badge

### Month 12 Goals
- $1.5M-2M MRR (1,200-1,500 merchants)
- Top 3 player in market
- Series A ready

## 📚 Documentation

- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Complete deployment guide ⭐
- [MVP-Implementation-Plan.md](./knowledge/MVP-Implementation-Plan.md) - Detailed implementation plan (20K words)
- [PreventFlow-MVP-Sprint.md](./knowledge/PreventFlow-MVP-Sprint.md) - Kanban board (217 tasks)
- [packages/database/README.md](./packages/database/README.md) - Database documentation
- [apps/admin/README.md](./apps/admin/README.md) - Admin app documentation

## 📄 License

Proprietary - All rights reserved

---

**Built with**: Remix, Cloudflare Workers, Shopify Polaris, OpenAI GPT-4

**Status**: 🎉 Day 1 Complete (6-Day Sprint)

**Next**: Day 2 - Multi-Processor Integration

---

*PreventFlow - Keep your dispute rate under 0.5%. Never get held.*
