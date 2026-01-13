---

kanban-plugin: board

---

## 📋 Backlog (Pre-Development)

- [ ] Create Shopify Partner account
- [ ] Create Cloudflare account (Workers Paid plan)
- [ ] Set up Shopify development store
- [ ] Create Stripe test account
- [ ] Create PayPal sandbox account
- [ ] Create OpenAI API account
- [ ] Configure domain (redispute.com)


## 🔧 Day 1: Foundation & Auth

- [ ] Create monorepo with PNPM workspaces + Turborepo
- [ ] Setup ESLint, Prettier, TypeScript configs
- [ ] Create shared packages (database, shared, shopify)
- [ ] Git repository initialization
- [ ] Create API worker (main backend)
- [ ] Create Webhook worker (event processing)
- [ ] Create Email parser worker (Klarna)
- [ ] Create Scheduled worker (cron jobs)
- [ ] Configure wrangler.toml for each worker
- [ ] Set up D1 database (dev + prod)
- [ ] Create KV namespaces (sessions, cache)
- [ ] Create schema.sql with all tables
- [ ] Create initial migration
- [ ] Seed development database
- [ ] Register Shopify Partner account
- [ ] Create new app in Partner Dashboard
- [ ] Configure OAuth scopes
- [ ] Set up app URLs (auth, callback, webhooks)
- [ ] Implement Remix admin app
- [ ] Shopify OAuth flow with session management
- [ ] Basic dashboard route (Polaris UI)
- [ ] Deploy to Cloudflare Pages (staging)


## 🔌 Day 2: Multi-Processor Integration

- [ ] Build GraphQL Admin API client
- [ ] Fetch disputes from Shopify Payments
- [ ] Parse dispute data (id, reason, amount, status)
- [ ] Store Shopify disputes in D1
- [ ] Calculate dispute rate (disputes/orders last 30 days)
- [ ] Build Stripe API client with webhook verification
- [ ] Fetch disputes from Stripe API
- [ ] Handle Stripe webhooks (dispute.created, dispute.updated)
- [ ] Store Stripe disputes in unified table
- [ ] Map Stripe reason codes
- [ ] Build PayPal Customer Disputes API client
- [ ] Fetch disputes from PayPal
- [ ] Handle PayPal webhooks
- [ ] Store PayPal disputes in unified format
- [ ] Map PayPal dispute reasons
- [ ] 🔥 Set up Cloudflare Email Workers
- [ ] 🔥 Create email forwarding endpoint (disputes@redispute.com)
- [ ] 🔥 Build Klarna email parser (regex patterns)
- [ ] 🔥 Add NLP fallback (OpenAI) for unusual formats
- [ ] 🔥 Store parsed Klarna disputes in D1
- [ ] 🔥 Send merchant alert for Klarna disputes
- [ ] 🔥 Add Klarna forwarding email to admin UI
- [ ] Build webhook receiver with HMAC verification
- [ ] Handle orders/create webhook
- [ ] Handle orders/paid webhook
- [ ] Handle disputes/create webhook
- [ ] Handle refunds/create webhook
- [ ] Handle app/uninstalled webhook
- [ ] Implement webhook processing queue (Durable Objects)
- [ ] Add webhook log for debugging
- [ ] Implement error handling and retries


## 🛡️ Day 3: Prevention Layer

- [ ] Build rules-based risk engine (item not received)
- [ ] Add customer confusion risk rule
- [ ] Add high-risk product categories rule
- [ ] Add velocity risk rule
- [ ] Implement risk score calculation (0-100)
- [ ] Store risk scores in orders table
- [ ] Set risk threshold triggers (>70 = high risk)
- [ ] Create prevention email templates
- [ ] Set up Cloudflare Email Workers for sending
- [ ] Build trigger logic based on risk scores
- [ ] Track prevention attempts in analytics_events
- [ ] Create merchant notification queue
- [ ] 🔥 Build customer portal UI (mobile-optimized)
- [ ] 🔥 Implement order lookup (email + order number)
- [ ] 🔥 Verify order exists (Shopify API)
- [ ] 🔥 Add issue type selection (5 categories)
- [ ] 🔥 Add issue description (text + photos)
- [ ] 🔥 Implement merchant approval flow
- [ ] 🔥 Add auto-approve refunds < $100 (configurable)
- [ ] 🔥 Build resolution options (refund, store credit, replacement)
- [ ] 🔥 Add email notifications (customer + merchant)
- [ ] Build pending disputes list (Polaris DataTable)
- [ ] Create dispute details modal
- [ ] Add actions: Approve, Reject, Message
- [ ] Implement bulk actions (approve all <$X)
- [ ] Add auto-approval rules configuration


## 🤖 Day 4: AI Evidence Generation

- [ ] Fetch order details from Shopify (GraphQL)
- [ ] Fetch shipping/tracking information
- [ ] Fetch customer communication history
- [ ] Fetch product details (descriptions, images)
- [ ] Fetch store policies (return, shipping, TOS)
- [ ] Store evidence in evidence_packages table
- [ ] Build OpenAI API client (GPT-4)
- [ ] Create evidence generation prompt template
- [ ] Call OpenAI API with collected evidence
- [ ] Parse AI response into structured format
- [ ] Implement quality scoring (completeness, relevance)
- [ ] Store generated evidence in DB
- [ ] Build processor-specific formatters (Stripe, PayPal, Shopify)
- [ ] Implement PDF generation for manual upload
- [ ] Calculate evidence quality score (0-100)
- [ ] Add recommendations for improvement
- [ ] Add "Generate Evidence" button in UI
- [ ] Show loading state (usually <30 seconds)
- [ ] Build evidence preview (formatted display)
- [ ] Add quality score badge
- [ ] Show win probability estimate
- [ ] Implement edit functionality (merchant can edit)
- [ ] Add manual evidence upload
- [ ] One-click submit to processor (API)
- [ ] Add PDF download option
- [ ] Track submission in DB (submitted_at)


## 📊 Day 5: Analytics & Billing

- [ ] Build key metrics display (real-time dispute rate)
- [ ] Add status indicator (🟢 SAFE / 🟡 WARNING / 🔴 DANGER)
- [ ] Show pending high-risk orders
- [ ] Calculate projected dispute rate (7-day forecast)
- [ ] Track disputes prevented this month
- [ ] Calculate payment hold risk score (0-100)
- [ ] Build dispute rate trend chart (Recharts)
- [ ] Create prevention funnel bar chart
- [ ] Add processor breakdown pie chart
- [ ] Add quick actions (view pending, generate evidence)
- [ ] Create weekly digest preview
- [ ] Build disputes list with filters (DataTable)
- [ ] Add filter by: Processor, status, date, amount
- [ ] Implement sort by: Date, amount, risk score
- [ ] Create high-risk orders view
- [ ] Build prevention report (success rate)
- [ ] Add cost savings calculator
- [ ] Create chargeback trends view
- [ ] Implement data export (CSV/JSON)
- [ ] Integrate Shopify Billing API
- [ ] Create recurring charge (Free, Growth, Scale, Enterprise)
- [ ] Handle billing callbacks
- [ ] Store subscription status in merchants table
- [ ] Track prevented disputes (12% success fee)
- [ ] Track won disputes (12% success fee)
- [ ] Calculate monthly usage charge
- [ ] Create usage charge at end of billing cycle
- [ ] Generate invoice preview
- [ ] Build billing UI (current plan display)
- [ ] Add upgrade/downgrade flow
- [ ] Show usage tracker
- [ ] Display success fee breakdown
- [ ] Show invoice history
- [ ] Implement free tier limits (max 5 disputes/month)
- [ ] Add in-app upgrade prompts
- [ ] Create alert email templates
- [ ] Build digest email templates
- [ ] Implement email templates with React Email
- [ ] Set up Cloudflare Email Workers for delivery
- [ ] Schedule daily summary emails
- [ ] Schedule weekly prevention reports
- [ ] Schedule monthly invoice emails


## ✅ Day 6: Polish, Security & Launch

- [ ] Implement HMAC webhook verification (all processors)
- [ ] Add CSRF protection (Remix built-in)
- [ ] Build rate limiting (Durable Objects)
- [ ] Encrypt access tokens at rest (D1)
- [ ] Encrypt PII (customer email, phone)
- [ ] Store secrets in Cloudflare Workers Secrets
- [ ] Add Zod schemas for all API inputs
- [ ] Sanitize user-generated content
- [ ] Use prepared statements (prevent SQL injection)
- [ ] Configure CORS (restrict origins)
- [ ] Add Content Security Policy headers
- [ ] Implement audit logging
- [ ] Run Lighthouse audit on admin dashboard (target: >95)
- [ ] Run Lighthouse audit on customer portal
- [ ] Fix lazy loading issues
- [ ] Implement code splitting by route
- [ ] Tree shake unused Polaris components
- [ ] Optimize admin app bundle (<100KB)
- [ ] Optimize customer portal bundle (<20KB)
- [ ] Configure edge caching (Shopify API: 1hr, static: 1yr)
- [ ] Add database indexes
- [ ] Implement query result caching (KV)
- [ ] Verify API response times (p50 < 50ms)
- [ ] Run load testing with k6 (100 concurrent, 1000 webhooks/min)
- [ ] Write unit tests for risk scoring (Vitest)
- [ ] Write unit tests for evidence generation
- [ ] Write unit tests for billing calculations
- [ ] Write unit tests for utility functions
- [ ] Target >80% test coverage
- [ ] Write integration tests (Shopify OAuth flow)
- [ ] Write integration tests (webhook processing)
- [ ] Write integration tests (API endpoints)
- [ ] Write E2E tests (merchant install flow) (Playwright)
- [ ] Write E2E tests (dashboard navigation)
- [ ] Write E2E tests (dispute approval)
- [ ] Write E2E tests (evidence generation)
- [ ] Write E2E tests (billing upgrade)
- [ ] Manual testing: all user flows
- [ ] Manual testing: error states
- [ ] Manual testing: mobile devices
- [ ] Manual testing: Klarna email parser with real emails
- [ ] Write README.md (what, features, installation, setup)
- [ ] Write API documentation (webhooks, endpoints, auth)
- [ ] Create help center (getting started guide)
- [ ] Write "How to forward Klarna emails" guide
- [ ] Write "How to set up auto-approvals" guide
- [ ] Add FAQs
- [ ] Add troubleshooting guide
- [ ] Write Privacy Policy (GDPR compliance)
- [ ] Write Terms of Service
- [ ] Create video demo (2-3 minutes)
- [ ] Take 8 screenshots (dashboard, disputes, evidence, portal, etc.)
- [ ] Create app listing title and subtitle
- [ ] Write app description (300-500 words)
- [ ] Add pricing tiers to listing
- [ ] Add support contact info
- [ ] Submit app for Shopify review
- [ ] Apply for "Built for Shopify" badge
- [ ] Attach Lighthouse report (>95)
- [ ] Demonstrate clean install/uninstall
- [ ] Show GDPR compliance
- [ ] Provide video demo link


## 🚀 Week 2: Beta Testing

- [ ] Onboard 10 beta merchants
- [ ] Daily check-ins with beta users
- [ ] Collect feedback and iterate
- [ ] Fix critical bugs immediately
- [ ] Track: disputes prevented, time saved, NPS
- [ ] Collect testimonials
- [ ] Draft 3 case studies
- [ ] Record video testimonials
- [ ] Screenshot dashboard with real metrics


## 📈 Month 2-3: Launch & Scale

- [ ] Monitor Shopify App Store approval process
- [ ] Respond to any reviewer feedback
- [ ] Launch marketing campaign
- [ ] Publish blog posts (5-10 SEO guides)
- [ ] Post on Reddit (r/shopify, r/ecommerce)
- [ ] Social media push (Twitter, LinkedIn, Facebook)
- [ ] Reach out to 9 pre-qualified customers (Tier 1, 2, 3)
- [ ] Direct outreach to high-value prospects
- [ ] Set up referral program (1 month free)
- [ ] Monitor CAC (target: <$75)
- [ ] Track MRR growth
- [ ] Aim for $100K MRR milestone


## 💰 Month 3-6: Seed Fundraising

- [ ] Prepare pitch deck
- [ ] Update financial projections
- [ ] Collect due diligence materials
- [ ] Reach out to seed investors
- [ ] Target: Raise $2-3M at $10-15M valuation
- [ ] Hire 5-10 people (engineers, sales, support)
- [ ] Invest $50K/month in paid acquisition
- [ ] Build V2 features (ML scoring, auto-evidence)
- [ ] Aim for $300K MRR milestone


## 🏆 Month 7-12: Market Leadership

- [ ] Scale to $1.5M-2M MRR
- [ ] Reach 1,200-1,500 paying merchants
- [ ] Expand to WooCommerce integration
- [ ] Expand to BigCommerce integration
- [ ] Achieve "Built for Shopify" badge
- [ ] Become Top 3 player in market
- [ ] Capture 5-7% market share
- [ ] Prepare Series A materials
- [ ] Target: $10-20M at $100M-150M valuation


## ✅ Done

- [x] Complete market research (Disputifier $3M MRR analysis)
- [x] Analyze customer conversations (9 pre-qualified merchants)
- [x] Create comprehensive MVP plan
- [x] Define technical architecture (Cloudflare + Shopify)
- [x] Create pricing strategy (Free, Growth, Scale, Enterprise)
- [x] Design database schema (D1/SQLite)
- [x] Map out 6-day sprint (day-by-day tasks)
- [x] Define post-MVP roadmap (V2, V3, V4)
- [x] Set success metrics and KPIs
- [x] Identify initial customer targets
- [x] Create Obsidian Kanban board


## 📊 Sprint Metrics



## 🎯 Current Focus



## 💡 Key Differentiators

- [ ] **🔥 Klarna Email Parser** - Only solution with Klarna dispute management
- [ ] **🔥 Payment Hold Prevention** - Keep dispute rates below 0.5% threshold
- [ ] **🔥 Customer Dispute Portal** - Prevent 40-60% of chargebacks before filing
- [ ] **🔥 AI Evidence Generation** - GPT-4 powered, <30 seconds per dispute
- [ ] **🔥 Multi-Processor Dashboard** - Unified view (Shopify, Stripe, PayPal, Klarna)




%% kanban:settings
```
{"kanban-plugin":"board","list-collapse":[null,false,null,false]}
```
%%