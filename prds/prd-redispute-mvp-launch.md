# PRD: ReDispute MVP Launch (2-Week Sprint)

**Created:** 2026-01-15
**Status:** Ready for Implementation
**Timeline:** 14 days (Launch by January 29, 2026)
**Current Progress:** Day 1 Complete (16.67%)
**Version:** 1.0

---

## Table of Contents

1. [Introduction](#introduction)
2. [Product Vision](#product-vision)
3. [Goals](#goals)
4. [User Personas](#user-personas)
5. [User Stories](#user-stories)
6. [Functional Requirements](#functional-requirements)
7. [Non-Goals (Out of Scope for MVP)](#non-goals-out-of-scope-for-mvp)
8. [Technical Considerations](#technical-considerations)
9. [Success Metrics](#success-metrics)
10. [Launch Plan & Milestones](#launch-plan--milestones)
11. [Risk Mitigation](#risk-mitigation)
12. [Open Questions](#open-questions)

---

## Introduction

**ReDispute** is a prevention-first chargeback management platform for Shopify merchants. The MVP focuses on preventing payment holds (keeping dispute rates below 0.5% threshold) and reducing chargebacks by 40-60% through customer intervention before disputes are filed with payment processors.

### Current State (Day 1 Complete)

**Completed:**
- OAuth 2.0 authentication with Shopify
- Cloudflare infrastructure deployed (D1 database, KV storage, Workers)
- Database schema (9 tables) created and indexed
- Admin dashboard deployed (https://redispute-admin.pages.dev)
- Test merchant installed and verified
- API foundation with Hono framework

**Remaining Work:**
- Shopify Payments integration (dispute data sync)
- Customer dispute portal (prevention layer)
- AI evidence generation (GPT-4)
- Klarna email parser (unique differentiator)
- Risk scoring engine
- Analytics dashboard with real data
- Billing integration
- Email notifications
- Security hardening and testing

### Problem Statement

E-commerce merchants face three critical payment challenges:

1. **Payment Holds:** Shopify/processors hold funds when dispute rates exceed 0.5%, crippling cash flow
2. **Chargebacks:** Customers file disputes directly with banks instead of contacting merchants first
3. **Evidence Burden:** Creating compelling evidence packages is time-consuming and requires expertise

ReDispute solves all three by preventing disputes before they're filed, monitoring rates in real-time, and generating AI-powered evidence in seconds.

---

## Product Vision

**Mission:** Make payment holds and chargebacks a non-issue for every Shopify merchant.

**Vision:** The default payment protection layer for e-commerce, preventing $100B+ in disputed transactions annually.

**MVP Vision (2 Weeks):** Launch a Shopify-native app that prevents 40-60% of chargebacks through automated customer intervention, generates AI evidence in <30 seconds, and includes the industry's only Klarna dispute tracking via email parsing.

---

## Goals

### Primary Goals (Must Achieve)

1. **Launch-Ready Product:** Fully functional MVP deployed to production, ready for beta users
2. **Core Prevention:** Customer dispute portal preventing 40-60% of chargebacks before filing
3. **AI Evidence:** GPT-4 powered evidence generation completing in <30 seconds with 80%+ quality
4. **Unique Feature:** Klarna email parser working (no competitor has this)
5. **Beta Success:** 5-10 merchants signed up, testing, and providing feedback
6. **Shopify Compliance:** Meet all "Built for Shopify" requirements (Lighthouse >95, security audit passed)

### Secondary Goals (Nice to Have)

1. **Early Revenue:** 2-3 paying customers by end of beta period
2. **Testimonials:** 3+ video or written testimonials from beta users
3. **App Store Submission:** Shopify App Store listing submitted for review
4. **Case Studies:** 1-2 documented success stories with metrics

### Success Criteria

- ✅ All 5 must-have features working in production
- ✅ 5-10 beta merchants actively using the platform
- ✅ Zero critical security vulnerabilities
- ✅ Lighthouse performance score >95
- ✅ Average customer dispute resolution time <24 hours
- ✅ AI evidence quality score averaging 80%+
- ✅ Payment hold risk alerts triggering accurately
- ✅ Positive feedback from 80%+ of beta users

---

## User Personas

### Primary Persona: Sarah - Growing E-commerce Merchant

**Demographics:**
- Age: 32
- Role: Founder/Owner of beauty brand
- Revenue: $300K-500K/month
- Team Size: 3-5 people
- Tech Savvy: Medium (can use Shopify, Stripe dashboards)

**Pain Points:**
- Averaging 10-15 chargebacks per month ($6K-9K at risk)
- Spends 2-3 hours per week dealing with disputes
- Received payment hold warning from Shopify (dispute rate at 0.47%)
- Doesn't know which orders are high-risk until dispute filed
- Creating evidence is stressful and time-consuming
- No visibility into Klarna disputes (received via email)

**Goals:**
- Keep dispute rate below 0.5% to avoid payment holds
- Prevent chargebacks from happening in the first place
- Quickly resolve disputes when they do occur
- Understand which orders are high-risk proactively
- Save time on evidence creation

**How ReDispute Helps:**
- Real-time dispute rate monitoring with threshold alerts
- Customer portal intercepts 40-60% of disputes before filing
- AI generates evidence in seconds instead of hours
- Risk scoring identifies problem orders early
- Unified dashboard shows all disputes (including Klarna)

### Secondary Persona: Michael - Scaling Operator

**Demographics:**
- Age: 28
- Role: E-commerce entrepreneur (multiple stores)
- Revenue: $1M+/month across stores
- Team Size: 10-15 people
- Tech Savvy: High (uses APIs, custom integrations)

**Pain Points:**
- Managing disputes across multiple stores manually
- Payment processors (Shopify, Stripe, Klarna) have separate dashboards
- High volume means 50+ disputes/month to handle
- Hired VA to handle disputes but quality inconsistent
- Payment holds have happened twice, each time lost $50K+ in held funds

**Goals:**
- Centralized dispute management across all stores
- Automated prevention to reduce manual workload
- Consistent, high-quality evidence for every dispute
- Stay well below 0.5% threshold on all stores
- Delegate dispute management without quality drop

**How ReDispute Helps:**
- Single dashboard for all Shopify stores (V2 feature - not MVP)
- Automated customer dispute resolution
- AI ensures consistent evidence quality
- Proactive risk monitoring prevents payment holds
- Team can approve/reject disputes via simple queue

### Tertiary Persona: Alex - First-Time Merchant

**Demographics:**
- Age: 25
- Role: New Shopify store owner (launched 3 months ago)
- Revenue: $50K-100K/month
- Team Size: Solo founder
- Tech Savvy: Low-Medium (learning as they go)

**Pain Points:**
- Received first chargeback, panicked, didn't know how to respond
- Payment processor sent scary email about reserves
- Doesn't understand what "dispute rate" means
- Scared of losing money to fraud or disputes
- No time to become an expert on chargebacks

**Goals:**
- Understand what's happening with disputes
- Avoid making mistakes that cause payment holds
- Learn best practices for dispute prevention
- Get expert help without hiring someone
- Focus on growing business, not managing disputes

**How ReDispute Helps:**
- Clear, simple dashboard showing dispute status
- Educational alerts explaining what to do
- AI handles evidence creation automatically
- Customer portal prevents disputes before they escalate
- Free tier supports small merchants learning the ropes

---

## User Stories

### Epic 1: Shopify Payments Integration

#### US-001: Fetch Shopify Disputes via GraphQL
**Description:** As a developer, I need to fetch dispute data from Shopify Admin API so merchants can see their disputes in ReDispute.

**Acceptance Criteria:**
- [ ] Create GraphQL client in `packages/shopify` for Admin API 2024-10
- [ ] Implement `fetchShopifyDisputes()` function querying `disputes` resource
- [ ] Parse dispute fields: id, reason, amount, status, currency, created_at, order_id
- [ ] Store disputes in `chargebacks` table with processor='shopify_payments'
- [ ] Handle pagination for merchants with >50 disputes
- [ ] Map Shopify reason codes to internal categories (fraud, not_received, product_issue, etc.)
- [ ] Add error handling for API rate limits (429 responses)
- [ ] TypeScript types pass
- [ ] Unit tests for dispute parsing

#### US-002: Sync Orders from Shopify
**Description:** As a merchant, I want my Shopify orders automatically synced so ReDispute can calculate accurate dispute rates.

**Acceptance Criteria:**
- [ ] Implement `fetchShopifyOrders()` GraphQL query for last 30 days of orders
- [ ] Store order data in `orders` table: id, merchant_id, shopify_order_id, customer_email, total_amount, currency, order_data (JSON)
- [ ] Calculate dispute rate: (disputes last 30 days / orders last 30 days) * 100
- [ ] Update merchant record with current dispute rate percentage
- [ ] Handle orders with multiple line items correctly
- [ ] Sync runs on merchant install and daily thereafter
- [ ] TypeScript types pass
- [ ] Unit tests for dispute rate calculation

#### US-003: Register Shopify Webhooks
**Description:** As a developer, I need to register webhooks for real-time order and dispute updates so data stays synchronized.

**Acceptance Criteria:**
- [ ] Register webhook topics on merchant install: `orders/create`, `orders/paid`, `disputes/create`, `disputes/update`, `refunds/create`, `app/uninstalled`
- [ ] Store webhook registration IDs in merchant settings
- [ ] Verify webhook HMAC signatures in webhook worker
- [ ] Handle webhook failures gracefully (log but don't block)
- [ ] Retry failed webhook processing (3 attempts with exponential backoff)
- [ ] Unregister webhooks on app uninstall
- [ ] TypeScript types pass
- [ ] Integration test for webhook verification

#### US-004: Display Real Dispute Rate in Dashboard
**Description:** As a merchant, I want to see my actual dispute rate prominently displayed so I know if I'm at risk of payment holds.

**Acceptance Criteria:**
- [ ] Replace mock "0.00%" with real calculated dispute rate
- [ ] Show disputes count (last 30 days) and orders count (last 30 days)
- [ ] Display risk level badge: 🟢 SAFE (<0.3%), 🟡 WARNING (0.3-0.5%), 🔴 DANGER (>0.5%)
- [ ] Update dashboard loader to fetch real data from D1
- [ ] Show loading state while calculating (skeleton UI)
- [ ] Handle edge case: new merchant with 0 orders shows "Insufficient Data"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 2: Customer Dispute Portal (Prevention Layer)

#### US-005: Create Customer Portal Route
**Description:** As a customer, I want a simple page where I can resolve order issues so I don't have to file a chargeback.

**Acceptance Criteria:**
- [ ] Create new Remix app in `apps/customer-portal/`
- [ ] Deploy to Cloudflare Pages (separate project from admin)
- [ ] Create route: `/resolve?email={email}&order={order_number}`
- [ ] Mobile-optimized UI (90% of customers on mobile)
- [ ] Minimal design: logo, form, footer
- [ ] Fast load time (<1.5 seconds on 3G)
- [ ] TypeScript types pass
- [ ] Verify in browser on mobile device

#### US-006: Order Lookup & Verification
**Description:** As a customer, I want to verify my order exists before submitting a dispute so I know I'm in the right place.

**Acceptance Criteria:**
- [ ] Form fields: Email address (required), Order number (required)
- [ ] Call Shopify API to verify order exists for that email
- [ ] Show error if order not found: "We couldn't find an order with that email and order number"
- [ ] Show order summary if found: Date, items, total amount
- [ ] Add rate limiting: 5 lookups per email per hour (prevent abuse)
- [ ] Handle Shopify API errors gracefully
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-007: Issue Type Selection
**Description:** As a customer, I want to select what's wrong with my order from common categories so merchants understand my concern.

**Acceptance Criteria:**
- [ ] Display 5 issue types: "Item not received", "Item damaged/defective", "Wrong item received", "Charged incorrect amount", "Other"
- [ ] Single-select radio buttons (one issue at a time)
- [ ] Each issue shows brief description (1 sentence)
- [ ] "Other" shows text field for custom description
- [ ] Store selected issue type in `customer_disputes` table
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-008: Issue Description & Photos
**Description:** As a customer, I want to explain my issue in detail and upload photos so merchants can understand the problem.

**Acceptance Criteria:**
- [ ] Text area for issue description (500 char limit)
- [ ] Photo upload: up to 3 photos, max 5MB each
- [ ] Upload to Cloudflare R2 (object storage)
- [ ] Show image previews before submission
- [ ] Validate file types: JPG, PNG, WEBP only
- [ ] Store photo URLs in customer_disputes record (JSON array)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-009: Create Customer Dispute Record
**Description:** As a developer, I need to store customer disputes in the database so merchants can review and respond.

**Acceptance Criteria:**
- [ ] Insert record into `customer_disputes` table with status='pending'
- [ ] Fields: order_id, merchant_id, issue_type, description, customer_email, photos (JSON array)
- [ ] Set auto_approved=false by default
- [ ] Check auto-approval rules: If order amount <$100 AND merchant has auto-approve enabled, set auto_approved=true and status='approved'
- [ ] Create analytics event: 'customer_dispute_created'
- [ ] Send email notification to merchant (if notification enabled)
- [ ] TypeScript types pass
- [ ] Integration test for dispute creation

#### US-010: Thank You & Next Steps Page
**Description:** As a customer, I want confirmation that my dispute was submitted so I know what happens next.

**Acceptance Criteria:**
- [ ] Show success message: "We've received your request"
- [ ] Display expected response time: "Most merchants respond within 24 hours"
- [ ] Show next steps based on auto-approval status
- [ ] If auto-approved: "Your refund has been approved and will be processed in 3-5 business days"
- [ ] If pending: "The merchant will review your request and contact you via email"
- [ ] Include support email for questions
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 3: Merchant Approval Queue

#### US-011: Pending Disputes List
**Description:** As a merchant, I want to see all pending customer disputes in one place so I can review and resolve them quickly.

**Acceptance Criteria:**
- [ ] Create `/disputes/pending` route in admin dashboard
- [ ] Use Polaris DataTable component for list view
- [ ] Columns: Order #, Customer Email, Issue Type, Amount, Date Submitted, Actions
- [ ] Sort by date (newest first)
- [ ] Filter by issue type (dropdown)
- [ ] Show total count: "5 pending disputes"
- [ ] Empty state: "No pending disputes - you're all caught up!"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-012: Dispute Details Modal
**Description:** As a merchant, I want to see full dispute details in a modal so I can make informed approval decisions.

**Acceptance Criteria:**
- [ ] Click row opens Polaris Modal with dispute details
- [ ] Show: Order summary, customer info, issue type, description, uploaded photos (gallery)
- [ ] Display order history: previous orders from this customer, previous disputes
- [ ] Show risk signals: first-time customer, high-value order, multiple disputes
- [ ] Calculate suggested action based on order value and history
- [ ] Modal footer: Approve, Reject, Message Customer buttons
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-013: Approve Dispute (Issue Refund)
**Description:** As a merchant, I want to approve a dispute and issue a refund so the customer doesn't file a chargeback.

**Acceptance Criteria:**
- [ ] "Approve" button in dispute modal
- [ ] Confirmation dialog: "This will issue a $X refund via Shopify. Continue?"
- [ ] Call Shopify Refund API to create refund for full order amount
- [ ] Update dispute status to 'approved' in database
- [ ] Set resolved_at timestamp
- [ ] Create analytics event: 'customer_dispute_approved'
- [ ] Send email to customer: "Your refund has been approved"
- [ ] Show success toast: "Refund issued successfully"
- [ ] Close modal and remove from pending list
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-014: Reject Dispute (With Reason)
**Description:** As a merchant, I want to reject disputes that are invalid or fraudulent so I don't lose money unnecessarily.

**Acceptance Criteria:**
- [ ] "Reject" button in dispute modal
- [ ] Show rejection reason dropdown: "Outside return window", "Delivery confirmed", "Fraudulent claim", "Other"
- [ ] Text area for explanation (optional)
- [ ] Update dispute status to 'rejected' in database
- [ ] Set resolved_at timestamp
- [ ] Send email to customer with rejection reason and next steps
- [ ] Create analytics event: 'customer_dispute_rejected'
- [ ] Show toast: "Dispute rejected"
- [ ] Close modal and remove from pending list
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-015: Message Customer
**Description:** As a merchant, I want to send a message to customers before approving/rejecting so I can ask clarifying questions.

**Acceptance Criteria:**
- [ ] "Message Customer" button in dispute modal
- [ ] Text area for message (1000 char limit)
- [ ] Send email to customer with merchant's message
- [ ] Update dispute status to 'in_progress'
- [ ] Store message in dispute record (JSON array for thread)
- [ ] Show toast: "Message sent to customer"
- [ ] Create analytics event: 'merchant_message_sent'
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-016: Auto-Approval Rules Configuration
**Description:** As a merchant, I want to configure which disputes get auto-approved so I can save time on low-value disputes.

**Acceptance Criteria:**
- [ ] Create `/settings/auto-approval` route
- [ ] Toggle: "Enable auto-approval" (default: off)
- [ ] Number input: "Auto-approve orders under $X" (default: $100)
- [ ] Multi-select: Auto-approve issue types (default: all)
- [ ] Save settings to merchant.settings JSON field
- [ ] Show preview: "Based on your settings, approximately X% of disputes would be auto-approved"
- [ ] Show warning if threshold too high: "Auto-approving orders over $200 may impact profitability"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 4: AI Evidence Generation

#### US-017: Evidence Collection Engine
**Description:** As a developer, I need to collect all relevant order data so the AI can generate comprehensive evidence packages.

**Acceptance Criteria:**
- [ ] Create `collectEvidence(chargeback_id)` function in API worker
- [ ] Fetch order details via Shopify GraphQL: line items, customer info, shipping address, billing address
- [ ] Fetch shipping/tracking: carrier, tracking number, delivery status, delivery date
- [ ] Fetch customer communication: order confirmation, shipping notification, any support tickets
- [ ] Fetch product details: title, description, images, SKU
- [ ] Fetch store policies: return policy, shipping policy, terms of service (from Shopify store settings)
- [ ] Compile into structured JSON object
- [ ] Store in `evidence_packages` table with ai_generated=true
- [ ] TypeScript types pass
- [ ] Unit tests for evidence collection

#### US-018: OpenAI GPT-4 Integration
**Description:** As a developer, I need to send evidence data to GPT-4 and get a structured response so we can generate compelling dispute evidence.

**Acceptance Criteria:**
- [ ] Create OpenAI client in API worker (use `@ai-sdk/openai`)
- [ ] Design prompt template for evidence generation (include chargeback reason, order data, policies)
- [ ] Call GPT-4 API with collected evidence JSON
- [ ] Set temperature=0.3 for consistent output
- [ ] Request structured JSON response with sections: summary, timeline, evidence_points, rebuttal_to_claim
- [ ] Parse AI response and validate structure
- [ ] Store generated evidence in evidence_packages table
- [ ] Track token usage for billing
- [ ] Handle API errors gracefully (retry once, then show manual option)
- [ ] TypeScript types pass
- [ ] Integration test with mock OpenAI response

#### US-019: Evidence Quality Scoring
**Description:** As a merchant, I want to see a quality score for AI-generated evidence so I know if it needs manual improvement.

**Acceptance Criteria:**
- [ ] Calculate quality score (0-100) based on: evidence completeness (25 pts), timeline clarity (25 pts), policy citations (25 pts), rebuttal strength (25 pts)
- [ ] Show score badge in evidence preview: 🟢 Excellent (80-100), 🟡 Good (60-79), 🟠 Fair (40-59), 🔴 Poor (<40)
- [ ] If score <60, show recommendations: "Consider adding: customer signature, delivery photo, communication logs"
- [ ] Store quality_score in evidence_packages table
- [ ] TypeScript types pass

#### US-020: Evidence Preview & Edit UI
**Description:** As a merchant, I want to review and edit AI-generated evidence before submitting so I can customize it.

**Acceptance Criteria:**
- [ ] Create `/disputes/[id]/evidence` route in admin
- [ ] Show sections: Summary, Timeline, Evidence Points, Rebuttal (editable text areas)
- [ ] Display quality score badge prominently
- [ ] Show character counts (Shopify limit: 5000 chars per field)
- [ ] "Add Evidence" button to insert custom bullet points
- [ ] "Regenerate" button calls OpenAI again with updated prompt
- [ ] Save draft functionality (auto-save every 30 seconds)
- [ ] Show loading state during generation (progress indicator)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-021: Submit Evidence to Shopify
**Description:** As a merchant, I want to submit evidence to Shopify Payments with one click so disputes get resolved quickly.

**Acceptance Criteria:**
- [ ] "Submit to Shopify" button in evidence UI
- [ ] Format evidence according to Shopify API requirements
- [ ] Call Shopify `disputeEvidenceUpdate` mutation with evidence fields
- [ ] Update chargeback status to 'evidence_submitted' in database
- [ ] Set evidence_packages.submitted=true and submitted_at timestamp
- [ ] Create analytics event: 'evidence_submitted'
- [ ] Show success toast: "Evidence submitted successfully"
- [ ] Send email notification to merchant confirming submission
- [ ] TypeScript types pass
- [ ] Integration test with Shopify test API

#### US-022: Generate Evidence Button in Disputes List
**Description:** As a merchant, I want a quick action button to generate evidence from the disputes list so I don't have to navigate away.

**Acceptance Criteria:**
- [ ] Add "Generate Evidence" button to each chargeback row
- [ ] Show loading spinner during generation (typically 15-30 seconds)
- [ ] Success: Navigate to evidence preview page
- [ ] Error: Show toast with error message and "Try Manual" option
- [ ] Disable button if evidence already exists (show "View Evidence" instead)
- [ ] Track generation time in analytics (target: <30 seconds)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 5: Klarna Email Parser (Unique Differentiator)

#### US-023: Cloudflare Email Workers Setup
**Description:** As a developer, I need to set up Cloudflare Email Workers to receive and parse Klarna dispute emails.

**Acceptance Criteria:**
- [ ] Create new worker: `workers/email-parser/`
- [ ] Configure email routing in Cloudflare dashboard: disputes@redispute.com → email parser worker
- [ ] Verify MX records and SPF/DKIM for domain
- [ ] Test email delivery to worker endpoint
- [ ] Log all incoming emails to webhook_log table (for debugging)
- [ ] TypeScript types pass
- [ ] Manual test: Send test email, verify worker receives it

#### US-024: Klarna Email Pattern Recognition
**Description:** As a developer, I need to parse Klarna dispute notification emails to extract structured dispute data.

**Acceptance Criteria:**
- [ ] Parse email subject for dispute ID: "Dispute #KLR-12345678"
- [ ] Parse email body for: order number, customer name, dispute amount, dispute reason, deadline date
- [ ] Use regex patterns for common Klarna email formats (analyze 10+ real Klarna emails for patterns)
- [ ] Extract dispute date from email timestamp
- [ ] Validate extracted data (all required fields present)
- [ ] If parsing fails, log full email and flag for manual review
- [ ] TypeScript types pass
- [ ] Unit tests with sample Klarna email HTML

#### US-025: NLP Fallback with OpenAI
**Description:** As a developer, I want AI to parse unusual Klarna email formats so we don't miss disputes.

**Acceptance Criteria:**
- [ ] If regex parsing fails, send email content to OpenAI
- [ ] Prompt: "Extract dispute data from this Klarna notification email: {email_html}"
- [ ] Request structured JSON: dispute_id, order_number, amount, reason, deadline
- [ ] Validate AI-extracted data
- [ ] Log fallback usage (track accuracy vs regex)
- [ ] Store parsing method: 'regex' or 'ai' in dispute record
- [ ] TypeScript types pass
- [ ] Integration test with mock OpenAI response

#### US-026: Store Klarna Disputes in Database
**Description:** As a merchant, I want Klarna disputes automatically added to my dashboard so I have a unified view.

**Acceptance Criteria:**
- [ ] Insert parsed Klarna dispute into chargebacks table with processor='klarna'
- [ ] Link to order record if order_number matches existing order
- [ ] Set status='needs_response'
- [ ] Set deadline from email (Klarna typically gives 7 days)
- [ ] Create analytics event: 'klarna_dispute_detected'
- [ ] TypeScript types pass
- [ ] Integration test for dispute creation

#### US-027: Merchant Alert for Klarna Disputes
**Description:** As a merchant, I want immediate email alerts when Klarna disputes arrive so I can respond before the deadline.

**Acceptance Criteria:**
- [ ] Send email alert to merchant within 5 minutes of Klarna email parsed
- [ ] Email subject: "🚨 New Klarna Dispute: [Order #] - $[amount]"
- [ ] Email body: Dispute summary, reason, deadline (with countdown), link to ReDispute dashboard
- [ ] Include "Respond Now" button (deep link to evidence generation)
- [ ] Send SMS alert if merchant has phone number (optional)
- [ ] Mark alert as sent in analytics_events
- [ ] TypeScript types pass
- [ ] Manual test: Trigger alert, verify email received

#### US-028: Klarna Forwarding Instructions in Dashboard
**Description:** As a merchant, I want clear instructions on how to forward Klarna emails so the parser works.

**Acceptance Criteria:**
- [ ] Create `/settings/klarna` route in admin
- [ ] Show forwarding email address prominently: disputes@redispute.com
- [ ] Step-by-step instructions with screenshots: "1. Open Klarna dispute email, 2. Click Forward, 3. Send to disputes@redispute.com"
- [ ] Test button: "Send Test Email" to verify forwarding works
- [ ] Show recent parsed emails list (last 10) with status: parsed successfully / failed
- [ ] FAQ section: "Why manual forwarding?" (Klarna has no API)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 6: Risk Scoring Engine

#### US-029: Rules-Based Risk Engine
**Description:** As a developer, I need to calculate risk scores for orders so merchants can prevent disputes proactively.

**Acceptance Criteria:**
- [ ] Create `calculateRiskScore(order_id)` function in API worker
- [ ] Rule 1 - Item Not Received Risk: Days in transit >10 with no delivery = +30 points
- [ ] Rule 2 - Customer Confusion Risk: Check for support keywords ("where is my order", "haven't received") = +20 points
- [ ] Rule 3 - High-Risk Categories: Electronics, supplements = +15 points
- [ ] Rule 4 - Velocity Risk: Multiple orders same card in 24h = +25 points
- [ ] Rule 5 - New Customer Risk: First order = +10 points
- [ ] Total score: 0-100 (sum of applicable rules)
- [ ] Store risk_score in orders table
- [ ] TypeScript types pass
- [ ] Unit tests for each risk rule

#### US-030: Risk Threshold Triggers
**Description:** As a merchant, I want automatic actions when orders exceed risk thresholds so I can prevent disputes.

**Acceptance Criteria:**
- [ ] Define thresholds: Low (0-40), Medium (41-70), High (71-100)
- [ ] High risk (>70): Send prevention email to customer ("Is everything okay with your order?")
- [ ] Medium risk (41-70): Flag in merchant dashboard for manual review
- [ ] Low risk (0-40): No action, monitor
- [ ] Track prevention attempts in analytics_events
- [ ] Calculate success rate: prevented disputes / total high-risk orders
- [ ] TypeScript types pass
- [ ] Integration test for threshold triggers

#### US-031: High-Risk Orders Dashboard View
**Description:** As a merchant, I want to see all high-risk orders in one place so I can take preventive action.

**Acceptance Criteria:**
- [ ] Create `/orders/high-risk` route in admin
- [ ] Show orders with risk score >70
- [ ] Columns: Order #, Customer, Amount, Risk Score, Risk Factors, Actions
- [ ] Sort by risk score (highest first)
- [ ] Quick actions: Send prevention email, Contact customer, Mark as reviewed
- [ ] Show estimated dispute probability: e.g., "72% chance of dispute based on historical data"
- [ ] Empty state: "No high-risk orders - great job!"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 7: Analytics Dashboard

#### US-032: Key Metrics Cards
**Description:** As a merchant, I want to see critical metrics at a glance so I know my payment protection status.

**Acceptance Criteria:**
- [ ] Create metrics cards on main dashboard: Dispute Rate (%), Total Disputes (30d), Orders (30d), Pending Disputes, Payment Hold Risk Score
- [ ] Dispute Rate: Show as large number (e.g., "0.38%") with risk badge (SAFE/WARNING/DANGER)
- [ ] Total Disputes: Count with trend arrow (↑ up 15% vs last period)
- [ ] Orders: Count with revenue (e.g., "1,247 orders ($342K)")
- [ ] Pending Disputes: Count with "View All" link
- [ ] Payment Hold Risk Score: 0-100 gauge chart with explanation
- [ ] Real-time updates (refresh every 60 seconds)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-033: Dispute Rate Trend Chart
**Description:** As a merchant, I want to see my dispute rate over time so I can track improvement.

**Acceptance Criteria:**
- [ ] Use Recharts LineChart component
- [ ] Show last 90 days of dispute rate (daily data points)
- [ ] X-axis: Dates, Y-axis: Dispute rate (%)
- [ ] Horizontal line at 0.5% threshold (red line with label "DANGER ZONE")
- [ ] Tooltip shows: Date, Dispute rate, Disputes count, Orders count
- [ ] Toggle: 30 days / 90 days / 1 year
- [ ] Show trend: "↓ Decreasing (good!)" or "↑ Increasing (take action)"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-034: Prevention Funnel Chart
**Description:** As a merchant, I want to see how many disputes were prevented vs filed so I understand ReDispute's impact.

**Acceptance Criteria:**
- [ ] Create funnel chart showing: High-risk orders identified → Prevention emails sent → Customer disputes submitted → Chargebacks prevented → Chargebacks filed
- [ ] Show percentages at each stage
- [ ] Calculate prevention rate: (chargebacks prevented / total high-risk orders) * 100
- [ ] Show in hero metric: "Preventing 47% of chargebacks"
- [ ] Use BarChart from Recharts (stacked bars)
- [ ] Color code: Green (prevented), Red (filed)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-035: Processor Breakdown Chart
**Description:** As a merchant, I want to see disputes by payment processor so I know which one is the problem.

**Acceptance Criteria:**
- [ ] PieChart showing dispute distribution: Shopify Payments, Stripe, PayPal, Klarna (MVP only shows Shopify + Klarna)
- [ ] Show count and percentage for each processor
- [ ] Click slice to filter disputes list by processor
- [ ] Legend below chart
- [ ] Empty state if only one processor: "Using 1 payment processor"
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-036: ROI Dashboard
**Description:** As a merchant, I want to see how much money ReDispute has saved me so I can justify the subscription cost.

**Acceptance Criteria:**
- [ ] Calculate saved amount: (prevented disputes * avg order value) + (won disputes * order value)
- [ ] Show as large hero number: "You've saved $8,420 this month"
- [ ] Break down savings: Prevented (before chargeback), Recovered (won disputes), Avoided fees (chargeback fees saved)
- [ ] Show ROI multiplier: "3.2x return on subscription cost"
- [ ] Compare to subscription cost: "Saved $8,420 vs $299 subscription = 28x ROI"
- [ ] Month-to-date vs all-time toggle
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 8: Billing Integration

#### US-037: Shopify Billing API Integration
**Description:** As a developer, I need to integrate Shopify Billing API so merchants can subscribe to paid plans.

**Acceptance Criteria:**
- [ ] Create billing service in API worker
- [ ] Define plan tiers: Free (free), Growth ($299), Scale ($699), Enterprise ($1,999)
- [ ] Implement `createRecurringCharge()` function using Shopify Admin API
- [ ] Store subscription status in merchants table: plan_tier, billing_status, billing_id
- [ ] Handle billing callback after merchant approves charge
- [ ] Activate subscription on successful payment
- [ ] Store charge ID for future reference
- [ ] TypeScript types pass
- [ ] Integration test with Shopify test store

#### US-038: Free Tier Limits
**Description:** As a merchant on the free tier, I want to see when I'm approaching limits so I know when to upgrade.

**Acceptance Criteria:**
- [ ] Define free tier limits: 5 disputes/month tracked, basic analytics only, community support
- [ ] Track usage against limits monthly
- [ ] Show progress bar in dashboard: "3 of 5 disputes used this month"
- [ ] Show upgrade prompt when approaching limit: "You've used 4 of 5 disputes. Upgrade to track unlimited disputes."
- [ ] Block features beyond limit (show paywall modal)
- [ ] Reset usage count on 1st of each month
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

#### US-039: Usage Charges (Success Fee)
**Description:** As a developer, I need to calculate and charge 12% success fees for prevented/won disputes.

**Acceptance Criteria:**
- [ ] Track success events: customer_dispute_approved (prevented), chargeback outcome='won' (recovered)
- [ ] Calculate fee: 12% of order value for Growth, 10% for Scale, 8% for Enterprise
- [ ] Store in billing_records table: merchant_id, fee_type, amount, dispute_id
- [ ] Calculate monthly total at end of billing cycle
- [ ] Create usage charge via Shopify API (merchants approve charges monthly)
- [ ] Show breakdown in billing UI: "Prevented: $576, Recovered: $432, Total: $1,008"
- [ ] TypeScript types pass
- [ ] Unit tests for fee calculation

#### US-040: Billing Settings & Upgrade UI
**Description:** As a merchant, I want to view my current plan and upgrade to a higher tier so I can unlock more features.

**Acceptance Criteria:**
- [ ] Create `/settings/billing` route in admin
- [ ] Show current plan card: tier name, monthly price, features included, usage this month
- [ ] Show all available plans in comparison table (like pricing page)
- [ ] Highlight recommended plan based on usage
- [ ] "Upgrade" button starts Shopify billing flow
- [ ] Show invoice history: past charges with dates and amounts
- [ ] "Download Invoice" button (PDF generation in V2, show link for now)
- [ ] Cancel subscription button (confirms, then cancels recurring charge)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 9: Email Notifications

#### US-041: Email Templates with React Email
**Description:** As a developer, I need to create professional email templates so merchants and customers receive clear notifications.

**Acceptance Criteria:**
- [ ] Set up React Email library in monorepo
- [ ] Create template components in `packages/shared/emails/`:
  - MerchantAlertEmail (new dispute)
  - CustomerDisputeReceivedEmail (confirmation)
  - CustomerDisputeApprovedEmail (refund approved)
  - CustomerDisputeRejectedEmail (with reason)
  - MerchantWeeklySummaryEmail (digest)
- [ ] Templates include: ReDispute logo, clear subject, body text, CTA button, footer
- [ ] Mobile-responsive (90% opens on mobile)
- [ ] Test rendering in email clients (Gmail, Outlook, Apple Mail)
- [ ] TypeScript types pass
- [ ] Visual test: Generate HTML, view in browser

#### US-042: Send Alert Emails (Real-Time)
**Description:** As a merchant, I want instant email alerts for new disputes so I can respond quickly.

**Acceptance Criteria:**
- [ ] Trigger alert when: New Shopify dispute created, New Klarna dispute parsed, High-risk order detected
- [ ] Use Cloudflare Email Workers for delivery (or Resend.com API)
- [ ] Email subject: "🚨 New Dispute Alert: Order #[number]"
- [ ] Include: Dispute amount, reason, deadline, quick actions (view in dashboard)
- [ ] Send within 5 minutes of event
- [ ] Track delivery status in analytics_events
- [ ] Handle email failures gracefully (retry once)
- [ ] TypeScript types pass
- [ ] Manual test: Trigger alert, verify email received

#### US-043: Weekly Digest Email
**Description:** As a merchant, I want a weekly summary of my dispute activity so I stay informed without constant alerts.

**Acceptance Criteria:**
- [ ] Schedule via Cloudflare Workers Cron: every Monday 9am merchant timezone
- [ ] Email content: Total disputes this week, Disputes prevented, Disputes won, Current dispute rate, Action items (pending disputes)
- [ ] Include charts/graphs as embedded images
- [ ] CTA: "View Full Dashboard"
- [ ] Allow opt-out via unsubscribe link
- [ ] Track open rates (optional: pixel tracking)
- [ ] TypeScript types pass
- [ ] Manual test: Trigger scheduled job, verify email sent

#### US-044: Email Notification Settings
**Description:** As a merchant, I want to control which email notifications I receive so I'm not overwhelmed.

**Acceptance Criteria:**
- [ ] Create `/settings/notifications` route
- [ ] Toggle for each notification type: Instant alerts, Daily summary, Weekly digest, Customer disputes, High-risk orders
- [ ] Email frequency: Instant, Daily, Weekly, Off
- [ ] Digest time: Dropdown for preferred time (9am, 12pm, 5pm)
- [ ] Save settings in merchant.settings JSON
- [ ] Test email button for each type
- [ ] Show email address currently receiving notifications (merchant can't change, tied to Shopify email)
- [ ] TypeScript types pass
- [ ] Verify in browser using dev tools

---

### Epic 10: Security & Compliance

#### US-045: HMAC Webhook Verification
**Description:** As a developer, I need to verify HMAC signatures on all webhooks so we prevent spoofed requests.

**Acceptance Criteria:**
- [ ] Implement HMAC verification in webhook worker using Web Crypto API
- [ ] Verify Shopify webhook signatures (HMAC-SHA256)
- [ ] Reject webhooks with invalid signatures (return 401)
- [ ] Log rejected webhooks for monitoring
- [ ] Test with valid and invalid signatures
- [ ] TypeScript types pass
- [ ] Integration test for HMAC verification

#### US-046: Rate Limiting with Durable Objects
**Description:** As a developer, I need to rate limit API requests to prevent abuse and ensure fair usage.

**Acceptance Criteria:**
- [ ] Create Durable Object for rate limiting (track requests per merchant)
- [ ] Limits: 100 requests/minute per merchant for API, 10 requests/hour for customer portal per email
- [ ] Return 429 status code when limit exceeded
- [ ] Include Retry-After header in response
- [ ] Whitelist internal requests (webhook processing)
- [ ] Log rate limit violations
- [ ] TypeScript types pass
- [ ] Load test to verify limits work

#### US-047: Data Encryption
**Description:** As a developer, I need to encrypt sensitive data at rest so we comply with security standards.

**Acceptance Criteria:**
- [ ] Encrypt Shopify access tokens before storing in D1 (use Web Crypto API)
- [ ] Encrypt customer email addresses (PII) in customer_disputes table
- [ ] Store encryption key in Cloudflare Workers Secrets (not in code)
- [ ] Decrypt on read (transparent to application code)
- [ ] Document encryption method (AES-256-GCM)
- [ ] TypeScript types pass
- [ ] Unit tests for encrypt/decrypt functions

#### US-048: Input Validation with Zod
**Description:** As a developer, I need to validate all API inputs to prevent injection attacks and bad data.

**Acceptance Criteria:**
- [ ] Create Zod schemas for all API request bodies in `packages/shared/schemas/`
- [ ] Validate in middleware before processing requests
- [ ] Return 400 errors with clear validation messages
- [ ] Sanitize user-generated content (strip HTML tags from customer dispute descriptions)
- [ ] Validate email formats, order IDs, amounts (positive numbers)
- [ ] TypeScript types pass
- [ ] Unit tests for each schema

#### US-049: CORS Configuration
**Description:** As a developer, I need to configure CORS properly so only authorized origins can access the API.

**Acceptance Criteria:**
- [ ] Allow origins: Shopify admin (admin.shopify.com), Customer portal (customer.redispute.com)
- [ ] Block all other origins
- [ ] Set CORS headers in API worker: Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers
- [ ] Handle preflight OPTIONS requests
- [ ] TypeScript types pass
- [ ] Test with allowed and blocked origins

#### US-050: Audit Logging
**Description:** As a developer, I need to log all security-relevant events so we can investigate issues and comply with regulations.

**Acceptance Criteria:**
- [ ] Log events: merchant_login, dispute_approved, dispute_rejected, evidence_submitted, settings_changed, webhook_received
- [ ] Store in analytics_events table with timestamp, merchant_id, event_type, event_data (JSON)
- [ ] Log includes: IP address, user agent, action result (success/failure)
- [ ] Retention: Keep logs for 90 days (compliance requirement)
- [ ] Create audit log viewer in admin (for debugging)
- [ ] TypeScript types pass

---

### Epic 11: Testing & Quality Assurance

#### US-051: Unit Tests for Critical Functions
**Description:** As a developer, I need comprehensive unit tests so we catch bugs before production.

**Acceptance Criteria:**
- [ ] Write unit tests (Vitest) for: Risk scoring, Dispute rate calculation, Evidence quality scoring, Fee calculation, HMAC verification
- [ ] Target: >80% code coverage for business logic
- [ ] All tests pass in CI/CD pipeline
- [ ] Tests run in <30 seconds total
- [ ] Mock external APIs (Shopify, OpenAI) in tests
- [ ] TypeScript types pass

#### US-052: Integration Tests for API Endpoints
**Description:** As a developer, I need integration tests to verify API endpoints work correctly end-to-end.

**Acceptance Criteria:**
- [ ] Write integration tests for: OAuth flow, Webhook processing, Dispute creation, Evidence generation API
- [ ] Use test Shopify store for real API calls
- [ ] Tests create and clean up test data
- [ ] Run against staging environment
- [ ] All tests pass before production deploy
- [ ] TypeScript types pass

#### US-053: E2E Tests with Playwright
**Description:** As a developer, I need E2E tests to verify critical user flows work correctly in the browser.

**Acceptance Criteria:**
- [ ] Write Playwright tests for: Merchant install flow (OAuth), View dashboard, Create customer dispute, Approve dispute, Generate evidence
- [ ] Tests run in headless Chrome and Firefox
- [ ] Tests take screenshots on failure (for debugging)
- [ ] Run in CI/CD pipeline on every PR
- [ ] All tests pass before production deploy
- [ ] TypeScript types pass

#### US-054: Manual Testing Checklist
**Description:** As a QA tester, I need a comprehensive checklist to verify all features before launch.

**Acceptance Criteria:**
- [ ] Create testing checklist document covering: All user stories, Edge cases, Error states, Mobile responsive, Cross-browser (Chrome, Firefox, Safari), Performance (Lighthouse score)
- [ ] Test with real Shopify test store
- [ ] Test customer portal on mobile device
- [ ] Test all email notifications
- [ ] Test Klarna email parsing with real emails
- [ ] Test billing flow end-to-end
- [ ] Document bugs in GitHub Issues
- [ ] All P0/P1 bugs fixed before launch

---

### Epic 12: Performance Optimization

#### US-055: Lighthouse Audit & Optimization
**Description:** As a developer, I need to achieve Lighthouse score >95 to meet "Built for Shopify" requirements.

**Acceptance Criteria:**
- [ ] Run Lighthouse audit on admin dashboard and customer portal
- [ ] Performance: >90 (target: 95+)
- [ ] Accessibility: >90
- [ ] Best Practices: >90
- [ ] SEO: >90 (customer portal only)
- [ ] Fix issues identified: Lazy load images, Minimize JavaScript, Optimize fonts, Remove unused CSS
- [ ] Use Cloudflare CDN for static assets (automatic)
- [ ] Re-run audit to verify improvements
- [ ] Document final scores

#### US-056: Bundle Size Optimization
**Description:** As a developer, I need to minimize bundle sizes so pages load quickly on slow connections.

**Acceptance Criteria:**
- [ ] Admin app: <150KB JavaScript bundle (gzipped)
- [ ] Customer portal: <50KB JavaScript bundle (gzipped)
- [ ] Use code splitting by route (Remix automatic)
- [ ] Tree shake unused Polaris components
- [ ] Lazy load charts (Recharts) only when visible
- [ ] Analyze bundle with `vite-bundle-analyzer`
- [ ] Remove unused dependencies
- [ ] TypeScript types pass

#### US-057: Database Query Optimization
**Description:** As a developer, I need fast database queries so the dashboard loads instantly.

**Acceptance Criteria:**
- [ ] Add indexes to frequently queried columns (already done in schema, verify)
- [ ] Optimize dispute rate calculation query (use indexed created_at)
- [ ] Cache expensive queries in KV (30-minute TTL)
- [ ] Target: p50 query time <5ms, p99 <20ms
- [ ] Profile slow queries in production (Cloudflare Analytics)
- [ ] Add EXPLAIN to understand query plans
- [ ] TypeScript types pass

#### US-058: Edge Caching Strategy
**Description:** As a developer, I need to cache static assets and API responses to reduce latency globally.

**Acceptance Criteria:**
- [ ] Cache static assets (JS, CSS, images) for 1 year (immutable)
- [ ] Cache API responses in KV: Shopify orders (1 hour), Dispute rate (5 minutes), Store policies (24 hours)
- [ ] Set Cache-Control headers correctly
- [ ] Purge cache on data changes (invalidation)
- [ ] Test cache hit rate (target: >80%)
- [ ] TypeScript types pass

---

### Epic 13: Documentation & Launch Prep

#### US-059: README Documentation
**Description:** As a new developer, I need clear README documentation so I can set up and contribute to the project.

**Acceptance Criteria:**
- [ ] README.md includes: Project overview, Tech stack, Prerequisites, Setup instructions, Environment variables, Running locally, Deployment, Testing
- [ ] Step-by-step setup (copy-paste commands)
- [ ] Troubleshooting section for common issues
- [ ] Contributing guidelines
- [ ] License information

#### US-060: API Documentation
**Description:** As a developer using the API, I need comprehensive API docs so I know how to integrate.

**Acceptance Criteria:**
- [ ] Document all API endpoints in `docs/api/`: Authentication, Webhooks, Disputes, Evidence, Analytics
- [ ] Include: HTTP method, URL, Request body (JSON schema), Response body (JSON schema), Error codes
- [ ] Provide examples with curl commands
- [ ] Document webhook payload formats
- [ ] Host docs on Cloudflare Pages (separate site)

#### US-061: Help Center (Basic)
**Description:** As a merchant, I need help documentation so I can learn how to use ReDispute.

**Acceptance Criteria:**
- [ ] Create help center pages in admin: Getting Started, How to Set Up Klarna Forwarding, Understanding Dispute Rates, Configuring Auto-Approvals, FAQs
- [ ] Simple design (Polaris typography)
- [ ] Searchable (basic keyword search)
- [ ] Link from dashboard header
- [ ] Include screenshots and step-by-step guides

#### US-062: Privacy Policy & Terms of Service
**Description:** As a merchant, I need to review privacy policy and terms before installing so I understand data handling.

**Acceptance Criteria:**
- [ ] Draft Privacy Policy covering: Data collected, How data is used, Third-party services (Shopify, OpenAI), Data retention, GDPR compliance, User rights
- [ ] Draft Terms of Service covering: Service description, Subscription terms, Usage limits, Liability limitations, Dispute resolution
- [ ] Legal review (consult lawyer or use template from Shopify Partners)
- [ ] Host on `/legal/privacy` and `/legal/terms` routes
- [ ] Link from footer and app listing

---

### Epic 14: Shopify App Store Submission

#### US-063: Video Demo (2-3 Minutes)
**Description:** As Shopify app reviewer, I need a clear demo video so I understand what the app does.

**Acceptance Criteria:**
- [ ] Record screen capture showing: Merchant installs app, Views dispute rate dashboard, Receives customer dispute, Approves dispute, Generates AI evidence, Views analytics
- [ ] Voiceover explaining each step
- [ ] Professional quality (1080p video, clear audio)
- [ ] Length: 2-3 minutes (Shopify requirement)
- [ ] Upload to YouTube (unlisted)
- [ ] Include link in app listing

#### US-064: Screenshots (8 Images)
**Description:** As a potential merchant, I need screenshots so I can see the app before installing.

**Acceptance Criteria:**
- [ ] Capture 8 high-quality screenshots (1600x1200px recommended):
  1. Dashboard with dispute rate and metrics
  2. Disputes list with filters
  3. Customer dispute portal (mobile view)
  4. Dispute approval queue
  5. AI evidence generation in progress
  6. Evidence preview with quality score
  7. Analytics charts (trend, prevention funnel)
  8. Klarna email parser settings
- [ ] Add captions explaining each screenshot
- [ ] Use real-looking data (not lorem ipsum)
- [ ] Upload to app listing

#### US-065: App Listing Copy
**Description:** As a potential merchant, I need compelling app listing copy so I understand the benefits.

**Acceptance Criteria:**
- [ ] Write app title (max 30 chars): "ReDispute: Chargeback Protection"
- [ ] Write subtitle (max 70 chars): "Prevent payment holds & chargebacks with AI-powered dispute management"
- [ ] Write description (500-800 words): Problem (payment holds, chargebacks), Solution (prevention, AI evidence, Klarna), Benefits (save money, save time, unified dashboard), Pricing, Support
- [ ] Use formatting: Bold headers, bullet points, clear sections
- [ ] Include keywords: chargeback, dispute, fraud, payment hold, Klarna, Shopify Payments
- [ ] Add FAQ section
- [ ] Link to help center and demo video
- [ ] Review and edit for clarity

#### US-066: Submit App for Review
**Description:** As the app developer, I need to submit the app to Shopify for review so it can be listed publicly.

**Acceptance Criteria:**
- [ ] Complete all required fields in Partner Dashboard: Listing info, Pricing, OAuth scopes, Webhooks, Support contact
- [ ] Upload video demo and screenshots
- [ ] Add test store credentials for Shopify reviewers
- [ ] Include testing instructions: "Install app, create test order, submit customer dispute via portal, generate AI evidence"
- [ ] Review submission checklist (Shopify provides)
- [ ] Click "Submit for Review"
- [ ] Monitor submission status (typically 5-10 business days)
- [ ] Respond to any reviewer feedback within 48 hours

#### US-067: Apply for "Built for Shopify" Badge
**Description:** As the app developer, I want the "Built for Shopify" badge so merchants trust the app quality.

**Acceptance Criteria:**
- [ ] Meet all requirements: Lighthouse score >90, Clean install/uninstall, Security standards, GDPR compliance, Mobile responsive
- [ ] Submit Lighthouse report (screenshot or JSON)
- [ ] Demonstrate clean uninstall (removes all data)
- [ ] Show GDPR compliance (data export, deletion)
- [ ] Provide support channels (email, help center)
- [ ] Submit application via Partner Dashboard
- [ ] Wait for approval (typically 2-4 weeks after app approval)

---

## Functional Requirements

### FR-1: Authentication & Authorization
- The system must authenticate merchants via Shopify OAuth 2.0
- The system must store session tokens securely in Cloudflare KV
- The system must require authentication for all admin dashboard routes
- The system must handle OAuth token refresh automatically

### FR-2: Dispute Data Synchronization
- The system must fetch disputes from Shopify Payments via GraphQL API
- The system must sync orders from Shopify daily (full sync)
- The system must receive real-time updates via Shopify webhooks
- The system must calculate dispute rate: (disputes last 30 days / orders last 30 days) * 100
- The system must update dispute rate every 60 seconds when dashboard is open

### FR-3: Customer Dispute Portal
- The system must provide a public URL for customers to submit disputes
- The system must verify order existence before allowing dispute submission
- The system must accept 5 issue types: item not received, damaged, wrong item, incorrect charge, other
- The system must allow photo uploads (up to 3 photos, max 5MB each)
- The system must store dispute photos in Cloudflare R2
- The system must send confirmation email to customer after submission

### FR-4: Merchant Approval Queue
- The system must display all pending customer disputes in a sortable table
- The system must allow merchants to approve disputes (issues refund via Shopify API)
- The system must allow merchants to reject disputes with a reason
- The system must allow merchants to message customers before deciding
- The system must support auto-approval rules (configurable by merchant)

### FR-5: AI Evidence Generation
- The system must collect evidence from Shopify: order details, shipping tracking, customer communication, product info, store policies
- The system must send evidence to OpenAI GPT-4 for analysis
- The system must generate structured evidence: summary, timeline, evidence points, rebuttal
- The system must calculate evidence quality score (0-100)
- The system must complete evidence generation in <30 seconds
- The system must allow merchants to edit generated evidence
- The system must submit evidence to Shopify Payments via API

### FR-6: Klarna Email Parser
- The system must receive emails at disputes@redispute.com
- The system must parse Klarna dispute notification emails using regex patterns
- The system must fall back to OpenAI for unusual email formats
- The system must extract: dispute ID, order number, amount, reason, deadline
- The system must store Klarna disputes in unified chargebacks table
- The system must send alert emails to merchants within 5 minutes

### FR-7: Risk Scoring
- The system must calculate risk scores (0-100) for all orders
- The system must apply 5 risk rules: item not received, customer confusion, high-risk categories, velocity, new customer
- The system must store risk scores in orders table
- The system must trigger prevention emails for orders with risk >70
- The system must display high-risk orders in dedicated dashboard view

### FR-8: Analytics Dashboard
- The system must display key metrics: dispute rate, total disputes, orders, pending disputes, payment hold risk
- The system must show dispute rate trend chart (90-day history)
- The system must show prevention funnel (prevented vs filed)
- The system must show processor breakdown (Shopify vs Klarna for MVP)
- The system must calculate ROI (money saved vs subscription cost)
- The system must refresh dashboard data every 60 seconds

### FR-9: Billing & Subscriptions
- The system must integrate Shopify Billing API for recurring charges
- The system must support 4 tiers: Free, Growth ($299), Scale ($699), Enterprise ($1,999)
- The system must enforce free tier limits (5 disputes/month)
- The system must calculate success fees: 12% (Growth), 10% (Scale), 8% (Enterprise)
- The system must create usage charges monthly for success fees
- The system must display current plan and invoice history in settings

### FR-10: Email Notifications
- The system must send instant alerts for: new disputes, high-risk orders, Klarna disputes
- The system must send weekly digest emails every Monday at 9am (merchant timezone)
- The system must allow merchants to configure notification preferences
- The system must use professional email templates (React Email)
- The system must deliver emails via Cloudflare Email Workers

### FR-11: Security & Compliance
- The system must verify HMAC signatures on all Shopify webhooks
- The system must rate limit API requests: 100/min for API, 10/hour for customer portal
- The system must encrypt access tokens and customer emails at rest
- The system must validate all API inputs with Zod schemas
- The system must configure CORS to allow only authorized origins
- The system must log all security-relevant events for 90 days

### FR-12: Performance
- The system must achieve Lighthouse score >95 on admin dashboard and customer portal
- The system must load dashboard in <2 seconds on 3G connection
- The system must complete database queries in <20ms (p99)
- The system must serve static assets from global CDN
- The system must cache API responses appropriately (1-60 minutes based on data type)

---

## Non-Goals (Out of Scope for MVP)

### Features Explicitly NOT in MVP
- ❌ Stripe integration (V2)
- ❌ PayPal integration (V2)
- ❌ Multi-store management (V2)
- ❌ Advanced ML fraud scoring (V2)
- ❌ White-label platform (V3)
- ❌ WooCommerce/BigCommerce support (V2)
- ❌ Returns management (V3)
- ❌ Order tracking integration (V2)
- ❌ Mobile native apps (V2)
- ❌ Chargeback insurance product (V4)

### Features Simplified for MVP
- ⚠️ Email notifications: Basic templates only (no custom branding yet)
- ⚠️ Analytics: Basic charts only (no cohort analysis or forecasting)
- ⚠️ Customer portal: Text-based only (no video evidence uploads)
- ⚠️ Risk scoring: Rules-based only (no ML models)
- ⚠️ Billing: Shopify Billing API only (no Stripe Billing, no invoices)

### Technical Decisions for Later
- ⏸️ Real-time dashboard updates via WebSockets (use polling for MVP)
- ⏸️ PDF invoice generation (show link to Shopify billing)
- ⏸️ SMS notifications (email only for MVP)
- ⏸️ Browser extension for quick access (web app only)
- ⏸️ Zapier/Make integrations (direct integrations only)

---

## Technical Considerations

### Infrastructure (Cloudflare)

**Frontend:**
- Remix v2.17.4 on Cloudflare Pages
- Server-side rendering at edge (sub-50ms globally)
- Automatic HTTPS and DDoS protection
- Deployment: Git push to main branch

**Backend:**
- Hono v4.x on Cloudflare Workers (V8 isolates, <1ms cold start)
- Zero-downtime deployments
- Automatic scaling (0-infinity)
- Cost: $0-5/month for MVP (generous free tier)

**Database:**
- D1 (SQLite) globally replicated across Cloudflare regions
- Sub-5ms query latency
- Schema migrations via Wrangler CLI
- Backups: Daily automatic snapshots

**Storage:**
- KV Namespaces: Session storage (24h TTL), API response cache
- R2 Object Storage: Customer dispute photos (V2)
- Durable Objects: Rate limiting state, webhook queue

**Email:**
- Cloudflare Email Workers: Receive Klarna emails, send notifications
- Alternative: Resend.com API (if Email Workers insufficient)

### External APIs

**Shopify:**
- GraphQL Admin API 2024-10
- Scopes: read_orders, write_orders, read_customers, read_disputes, write_disputes, read_products, read_shipping
- Rate limits: 1000 points/minute (cost per query varies)
- Webhooks: HMAC-verified, delivered within 5 minutes

**OpenAI:**
- GPT-4 Turbo (gpt-4-turbo-preview)
- Temperature: 0.3 (consistent output)
- Max tokens: 4000 per request
- Cost: ~$0.10-0.20 per evidence generation
- Fallback: GPT-3.5-turbo if GPT-4 unavailable

**Stripe/PayPal (V2):**
- Not in MVP scope
- Design API wrappers with abstraction for future integration

### Data Flow

**Dispute Detection Flow:**
```
Shopify → Webhook → Cloudflare Worker → D1 Database → Dashboard Update
```

**Klarna Flow:**
```
Klarna Email → Cloudflare Email Worker → Parser (regex/AI) → D1 Database → Merchant Alert
```

**Customer Dispute Flow:**
```
Customer → Portal → API Worker → D1 Database → Merchant Dashboard → Shopify Refund API
```

**Evidence Generation Flow:**
```
Merchant Click → Collect Evidence → OpenAI GPT-4 → Parse Response → Store in D1 → Display in UI
```

### Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| Dashboard load time | <2s on 3G | Lighthouse |
| API response time | p99 <200ms | Cloudflare Analytics |
| Database query time | p99 <20ms | D1 Analytics |
| Evidence generation | <30s | Internal timing |
| Webhook processing | <5s | Worker metrics |
| Email delivery | <5 min | Email logs |

### Security Considerations

**Authentication:**
- OAuth 2.0 only (no username/password)
- Session tokens in KV with 24h TTL
- CSRF protection via state parameter
- No long-lived credentials stored

**Data Protection:**
- Encryption at rest: Access tokens, customer emails (Web Crypto API, AES-256-GCM)
- Encryption in transit: HTTPS everywhere (Cloudflare automatic)
- PII handling: Minimal collection, encrypted storage, GDPR compliance

**API Security:**
- HMAC webhook verification (Shopify)
- Rate limiting (Durable Objects)
- Input validation (Zod schemas)
- CORS restrictions (Shopify admin + customer portal only)
- SQL injection prevention (prepared statements)

**Compliance:**
- GDPR: Data export/deletion on request
- CCPA: Privacy policy disclosure
- SOC 2: Audit logging for 90 days
- PCI: No credit card data stored (Shopify handles payments)

### Testing Strategy

**Unit Tests (Vitest):**
- Business logic functions (risk scoring, dispute rate, fee calculation)
- Utility functions (encryption, parsing, validation)
- Target: >80% coverage
- Run time: <30 seconds

**Integration Tests:**
- API endpoints (HTTP requests/responses)
- Shopify API calls (use test store)
- Database operations (create/read/update)
- Webhook processing

**E2E Tests (Playwright):**
- Critical user flows (install, view dashboard, approve dispute, generate evidence)
- Browser: Chrome, Firefox (headless)
- Mobile viewport testing

**Manual Testing:**
- Beta users: 5-10 merchants (3-5 days of testing)
- Test devices: Desktop (Chrome, Firefox, Safari), Mobile (iOS Safari, Chrome Android)
- Test scenarios: Edge cases, error states, performance

### Monitoring & Observability

**Metrics:**
- Cloudflare Analytics: Request count, errors, latency, bandwidth
- D1 Analytics: Query count, query time, errors
- Worker Analytics: Invocations, CPU time, errors

**Logging:**
- Structured logs via console.log (Cloudflare captures)
- Log levels: DEBUG, INFO, WARN, ERROR
- Correlation IDs for request tracing

**Alerts:**
- Error rate >5% (Cloudflare email alert)
- API latency p99 >500ms (Cloudflare alert)
- Database errors (manual monitoring initially)

**Dashboards:**
- Cloudflare dashboard: Real-time metrics
- Custom admin analytics: Usage stats, error logs

### Deployment Strategy

**Environments:**
- Development: Local (wrangler dev)
- Staging: Cloudflare (preview deployments)
- Production: Cloudflare (main branch)

**CI/CD:**
- GitHub Actions: Run tests on PR, deploy on merge to main
- Automatic: Staging deploy on every commit, production on release tag
- Rollback: Git revert + redeploy (instant)

**Database Migrations:**
- Wrangler CLI: `wrangler d1 migrations apply`
- Versioning: Sequential migration files
- Rollback: Manual (write down-migration)

**Secrets Management:**
- Cloudflare Workers Secrets (encrypted at rest)
- Never commit secrets to Git
- Rotate secrets quarterly (OAuth client secret, API keys)

---

## Success Metrics

### MVP Success (Launch - Week 2)

**Product Metrics:**
- ✅ All 67 user stories completed (100%)
- ✅ Zero P0/P1 bugs in production
- ✅ Lighthouse score >95 (admin + portal)
- ✅ Evidence generation <30 seconds average
- ✅ Dashboard load time <2 seconds

**User Metrics:**
- ✅ 5-10 beta merchants signed up
- ✅ 80%+ beta user satisfaction (survey)
- ✅ 3+ testimonials collected
- ✅ 1-2 case studies documented

**Technical Metrics:**
- ✅ API uptime >99.9%
- ✅ Zero security vulnerabilities (P0/P1)
- ✅ Test coverage >80%
- ✅ All E2E tests passing

### Beta Testing Success (Week 3-4)

**Engagement Metrics:**
- ✅ 100% of beta users complete onboarding
- ✅ 80%+ use customer dispute portal feature
- ✅ 50%+ generate at least one AI evidence package
- ✅ 60%+ log in daily (active usage)

**Feature Validation:**
- ✅ Customer dispute portal prevents 40-60% of chargebacks
- ✅ AI evidence quality score averages 80%+
- ✅ Klarna email parser successfully parses 90%+ of emails
- ✅ Risk scoring identifies high-risk orders with 70%+ accuracy

**Business Metrics:**
- ✅ 2-3 merchants convert to paid plans
- ✅ $600-900 MRR from beta conversions
- ✅ Net Promoter Score (NPS) >40

### Shopify App Store Approval (Week 4-6)

**Approval Criteria:**
- ✅ Pass Shopify security review
- ✅ Pass Shopify functionality review
- ✅ Meet "Built for Shopify" standards
- ✅ No major bugs reported by reviewers

**Launch Metrics:**
- ✅ App published in Shopify App Store
- ✅ 4.7+ average rating (from beta reviews)
- ✅ 10+ installs in first week
- ✅ <10% uninstall rate

### Post-Launch Success (Month 2-3)

**Growth Metrics:**
- 🎯 50-100 total installs
- 🎯 20-30 paying customers
- 🎯 $8K-12K MRR
- 🎯 85%+ monthly retention

**Product-Market Fit Signals:**
- 🎯 40%+ of users are highly engaged (daily usage)
- 🎯 Organic referrals: 10%+ of installs from word-of-mouth
- 🎯 Positive feedback: 90%+ of reviews are 4-5 stars
- 🎯 Feature requests: Users asking for specific enhancements

**Key Performance Indicators (KPIs):**

| Metric | Week 2 | Week 4 | Month 3 |
|--------|--------|--------|---------|
| **Total Installs** | 5-10 | 10-20 | 50-100 |
| **Paying Customers** | 0-2 | 5-10 | 20-30 |
| **MRR** | $0-600 | $2K-4K | $8K-12K |
| **Churn Rate** | N/A | <20% | <15% |
| **NPS** | 40+ | 50+ | 60+ |
| **Disputes Prevented** | 20-50 | 100-200 | 500-800 |
| **AI Evidence Generated** | 10-30 | 50-100 | 200-400 |
| **Avg Response Time** | <24h | <12h | <6h |

---

## Launch Plan & Milestones

### Phase 1: Development Sprint (Days 1-14)

#### Week 1: Core Features (Days 1-7)

**Day 1: ✅ COMPLETED**
- OAuth authentication
- Database schema
- Admin dashboard deployed
- Test merchant installed

**Day 2-3: Shopify Integration**
- [ ] Fetch disputes and orders from Shopify GraphQL
- [ ] Register webhooks (orders, disputes, refunds)
- [ ] Display real dispute rate in dashboard
- [ ] Calculate payment hold risk

**Day 4-5: Customer Dispute Portal**
- [ ] Create customer-facing portal UI
- [ ] Order lookup and verification
- [ ] Issue submission with photos
- [ ] Merchant approval queue in admin
- [ ] Auto-approval rules configuration

**Day 6-7: AI Evidence Generation**
- [ ] Evidence collection from Shopify
- [ ] OpenAI GPT-4 integration
- [ ] Evidence quality scoring
- [ ] Evidence preview and edit UI
- [ ] Submit to Shopify API

#### Week 2: Polish & Launch Prep (Days 8-14)

**Day 8-9: Klarna Email Parser**
- [ ] Cloudflare Email Workers setup
- [ ] Email parsing (regex + AI fallback)
- [ ] Store Klarna disputes in database
- [ ] Merchant alert notifications

**Day 10: Risk Scoring & Analytics**
- [ ] Implement risk scoring engine
- [ ] High-risk orders dashboard
- [ ] Analytics charts (trend, funnel, breakdown)
- [ ] ROI calculation

**Day 11: Billing Integration**
- [ ] Shopify Billing API integration
- [ ] Free tier limits enforcement
- [ ] Usage charges (success fees)
- [ ] Billing settings UI

**Day 12: Email Notifications**
- [ ] React Email templates
- [ ] Alert emails (real-time)
- [ ] Weekly digest emails
- [ ] Notification settings

**Day 13: Security & Testing**
- [ ] HMAC verification, rate limiting, encryption
- [ ] Unit tests (>80% coverage)
- [ ] Integration tests
- [ ] E2E tests (Playwright)
- [ ] Manual testing checklist

**Day 14: Launch Preparation**
- [ ] Lighthouse optimization (>95 score)
- [ ] Documentation (README, API docs, help center)
- [ ] Privacy policy & terms of service
- [ ] Video demo recording
- [ ] Screenshots for app listing

### Phase 2: Beta Testing (Days 15-21)

**Week 3: Private Beta**

**Day 15-16: Beta Onboarding**
- [ ] Email 9 pre-qualified merchants (from research)
- [ ] Offer: Free Growth plan for 3 months
- [ ] Schedule onboarding calls (30 minutes each)
- [ ] Provide beta testing guidelines

**Day 17-19: Active Beta Testing**
- [ ] Daily check-ins with beta users (email/Slack)
- [ ] Monitor usage analytics
- [ ] Track bugs in GitHub Issues
- [ ] Fix P0/P1 bugs within 24 hours
- [ ] Collect qualitative feedback

**Day 20-21: Iteration & Refinement**
- [ ] Implement top beta user feedback
- [ ] Polish UX based on observations
- [ ] Update help documentation
- [ ] Request testimonials from satisfied users
- [ ] Create case studies (2 merchants)

**Beta Success Criteria:**
- 80%+ satisfaction score
- 40-60% chargeback prevention rate demonstrated
- 3+ video or written testimonials
- Zero critical bugs remaining

### Phase 3: App Store Submission (Days 22-28)

**Week 4: Shopify App Store Launch**

**Day 22-23: Submission Preparation**
- [ ] Complete app listing copy (title, subtitle, description)
- [ ] Upload video demo and screenshots
- [ ] Add test store credentials for reviewers
- [ ] Write detailed testing instructions
- [ ] Review submission checklist

**Day 24: Submit for Review**
- [ ] Submit app via Shopify Partner Dashboard
- [ ] Apply for "Built for Shopify" badge
- [ ] Monitor submission status daily

**Day 25-28: Review Period & Launch**
- [ ] Respond to reviewer feedback within 24 hours
- [ ] Make required changes if requested
- [ ] Approval notification (typically 5-10 business days)
- [ ] Publish app to Shopify App Store
- [ ] Announce launch (social media, email list, communities)

**Launch Day Checklist:**
- [ ] Monitor error logs and metrics
- [ ] Respond to first installs within 1 hour
- [ ] Track initial user feedback
- [ ] Post in r/shopify, Shopify Community forums
- [ ] Email launch announcement to beta users (ask for reviews)

### Phase 4: Post-Launch Growth (Month 2+)

**Week 5-8: Early Growth**
- [ ] Direct outreach to 9 pre-qualified customers
- [ ] Content marketing: Blog posts on chargeback prevention
- [ ] Community engagement: Reddit, Facebook groups, Shopify forums
- [ ] Referral program: 1 month free for referrals
- [ ] A/B test pricing and messaging

**Month 2-3 Goals:**
- 50-100 total installs
- 20-30 paying customers
- $8K-12K MRR
- 4.7+ App Store rating
- 10+ reviews

**Month 3-6: Scale**
- Seed fundraising preparation ($2-3M target)
- Hire 2-3 team members (engineer, support, sales)
- V2 feature development (Stripe, PayPal, advanced analytics)
- Reach $100K MRR milestone

---

## Risk Mitigation

### Technical Risks

#### Risk 1: Shopify API Rate Limits
**Impact:** High | **Probability:** Medium

**Mitigation:**
- Use Bulk Operations API for large data fetches (up to 1000x more efficient)
- Implement request queuing with exponential backoff
- Cache API responses in KV (1-60 minute TTL based on data type)
- Monitor rate limit headers, pause requests when approaching limit
- Fallback: Show stale cached data if API unavailable

#### Risk 2: OpenAI API Downtime or Latency
**Impact:** Medium | **Probability:** Low

**Mitigation:**
- Set timeout: 30 seconds max per request
- Fallback to GPT-3.5-turbo if GPT-4 unavailable (cheaper, faster)
- Show "Try Manual Evidence" button if AI fails
- Cache common evidence templates for instant results
- Monitor OpenAI status page, display maintenance message proactively

#### Risk 3: Cloudflare Workers Limits (1MB script size, 128MB memory)
**Impact:** Low | **Probability:** Low

**Mitigation:**
- Modular architecture: Separate workers for API, webhooks, email parsing, scheduled jobs
- Code splitting: Lazy load heavy dependencies (OpenAI SDK)
- Monitor bundle sizes in CI/CD
- Use Durable Objects for stateful operations (not in-memory state)
- Cloudflare provides generous limits for most use cases

#### Risk 4: Database Performance at Scale
**Impact:** Medium | **Probability:** Low

**Mitigation:**
- D1 is globally replicated with sub-5ms latency (excellent for MVP)
- Proper indexes on all query columns (already implemented)
- Cache expensive queries in KV
- Monitor query performance, optimize slow queries
- Plan migration to PostgreSQL (Supabase) if D1 insufficient (unlikely for 1000+ merchants)

### Business Risks

#### Risk 5: Disputifier Recovers from Breach
**Impact:** High | **Probability:** Medium

**Mitigation:**
- **Move FAST:** 2-week launch vs 6-day aggressive sprint (balanced approach)
- **Lock in customers:** Offer beta users free Growth plan for 3 months (high switching cost)
- **Build moats:** Klarna parser (unique), payment hold prevention (unique), superior UX
- **Differentiate clearly:** "Prevention-first" vs "fight-only" approach
- Monitor competitor moves, adapt quickly

#### Risk 6: Low Merchant Adoption
**Impact:** High | **Probability:** Medium

**Mitigation:**
- **Pre-qualified customers:** 9 merchants identified from research, ready to onboard
- **Free tier:** Remove cost barrier for small merchants (viral growth)
- **App Store distribution:** 1M+ merchants browse Shopify App Store monthly
- **Beta testimonials:** Social proof drives conversions (target 3+ testimonials)
- **Clear value prop:** "Prevent payment holds" is urgent, high-value problem

#### Risk 7: Competitors Add Prevention Features
**Impact:** Medium | **Probability:** Medium

**Mitigation:**
- **Multiple moats:** Klarna, payment hold focus, customer portal, AI evidence (hard to copy all)
- **Speed of iteration:** 2-week cycles, ship V2 features within 6 weeks of V1
- **Network effects:** More merchants = better risk models (data moat)
- **Brand:** "Prevention-first" positioning, own the category
- Monitor competitors monthly, innovate continuously

### Operational Risks

#### Risk 8: Support Volume Overwhelms Team
**Impact:** Medium | **Probability:** High

**Mitigation:**
- **Comprehensive help center:** Reduce support tickets by 50%+ with good docs
- **In-app tooltips:** Explain features inline (reduce confusion)
- **Email templates:** Pre-written responses for common questions
- **Community:** Create Slack channel for beta users to help each other
- **Prioritize:** P0 within 2 hours, P1 within 24 hours, P2 within 1 week
- Plan to hire support person at $10K MRR

#### Risk 9: Critical Bug in Production
**Impact:** High | **Probability:** Medium

**Mitigation:**
- **Comprehensive testing:** Unit, integration, E2E, manual (catch 90%+ of bugs)
- **Beta testing:** 5-10 users find edge cases before public launch
- **Gradual rollout:** Beta → App Store → Marketing (staged exposure)
- **Monitoring:** Real-time alerts for errors, latency, downtime
- **Rollback capability:** Git revert + redeploy in <5 minutes
- **On-call:** Monitor Slack/email for first 2 weeks post-launch

#### Risk 10: Regulatory Compliance Issues
**Impact:** High | **Probability:** Low

**Mitigation:**
- **GDPR compliance:** Data export/deletion, clear privacy policy, minimal PII collection
- **PCI compliance:** No credit card data stored (Shopify handles payments)
- **Terms of Service:** Clear liability limitations, dispute resolution clause
- **Legal review:** Consult lawyer or use Shopify-approved templates
- **Audit trail:** 90-day logging for compliance investigations
- Monitor regulatory changes quarterly

### Market Risks

#### Risk 11: Shopify Changes Policies
**Impact:** High | **Probability:** Low

**Mitigation:**
- **Shopify Partner Program:** Official partner, advance notice of policy changes
- **Diversify platforms:** Plan V2 expansion to Stripe Direct, WooCommerce (reduce Shopify dependence)
- **Monitor announcements:** Read Shopify Partner blog weekly
- **Flexibility:** Cloudflare architecture enables fast pivots
- Build relationships with Shopify Partner managers

#### Risk 12: Payment Processors Block Access
**Impact:** High | **Probability:** Very Low

**Mitigation:**
- **Official APIs only:** Use documented Shopify, Stripe, PayPal APIs (not scraping)
- **Terms compliance:** Read and follow all API terms of service
- **Rate limiting:** Respect API limits, never abuse
- **Positive relationships:** Present ReDispute as helping merchants = helping processors
- Klarna email parsing is legitimate (no API required)

---

## Open Questions

### Product Questions

1. **Customer Portal URL Format:**
   - Option A: `portal.redispute.com/resolve?email=X&order=Y` (cleaner)
   - Option B: `redispute.com/portal/resolve?email=X&order=Y` (easier deployment)
   - **Decision:** Option A (better UX)

2. **Auto-Approval Default Threshold:**
   - Should free tier have auto-approve enabled by default? (Pros: Better UX, Cons: Merchants may want control)
   - **Recommendation:** Default OFF, show onboarding tooltip explaining benefits

3. **Evidence Generation Model:**
   - GPT-4 Turbo ($0.01/1K tokens) vs GPT-4 ($0.03/1K tokens)
   - **Decision:** GPT-4 Turbo (3x cheaper, 95% same quality)

4. **Webhook Processing Queue:**
   - Durable Objects (Cloudflare) vs external queue (Upstash, BullMQ)
   - **Decision:** Durable Objects (simpler, lower latency, already on Cloudflare)

### Technical Questions

5. **Email Delivery Service:**
   - Cloudflare Email Workers vs Resend.com vs SendGrid
   - **Decision:** Start with Cloudflare Email Workers, fallback to Resend if insufficient

6. **Photo Storage:**
   - Cloudflare R2 vs Uploadcare vs Cloudinary
   - **Decision:** R2 (cheapest, already on Cloudflare, S3-compatible)

7. **Real-Time Updates:**
   - Polling (60s interval) vs WebSockets vs Server-Sent Events
   - **Decision:** Polling for MVP (simplest), WebSockets in V2 if needed

### Business Questions

8. **Beta User Incentive:**
   - Free Growth plan for 3 months vs 50% off lifetime vs $500 credit
   - **Decision:** Free Growth for 3 months (best value, clear)

9. **App Store Keywords:**
   - Primary: "chargeback" vs "dispute" vs "fraud"
   - **Recommendation:** "chargeback" (higher search volume)

10. **Support Hours:**
    - 24/7 vs Business hours (9am-5pm EST) vs Best-effort
    - **Decision:** Business hours for MVP, 24/7 after $50K MRR

---

## Appendix

### Glossary

- **Chargeback:** Customer disputes a charge with their bank/card issuer
- **Dispute Rate:** (Number of disputes / Number of orders) over a time period, expressed as percentage
- **Payment Hold:** Payment processor holds merchant funds when dispute rate exceeds threshold (typically 0.5%)
- **Evidence Package:** Documents and data submitted to payment processor to contest a dispute
- **Prevention Layer:** Intervention before customer files chargeback (customer dispute portal)
- **Risk Score:** 0-100 score indicating likelihood of dispute for an order
- **Success Fee:** Percentage of order value charged when dispute is prevented or won

### Key Metrics Formulas

**Dispute Rate:**
```
dispute_rate = (disputes_last_30_days / orders_last_30_days) * 100
```

**Prevention Rate:**
```
prevention_rate = (customer_disputes_resolved / total_high_risk_orders) * 100
```

**Win Rate:**
```
win_rate = (disputes_won / disputes_submitted_to_processor) * 100
```

**ROI:**
```
roi = (money_saved - subscription_cost) / subscription_cost * 100
money_saved = (prevented_disputes * avg_order_value) + (won_disputes * order_value)
```

**Payment Hold Risk Score:**
```
risk_score = (current_dispute_rate / 0.5) * 100
# 0% = 0 risk, 50% = 100 risk (capped at 100)
```

### References

- [Shopify Admin API Documentation](https://shopify.dev/api/admin-graphql)
- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [Shopify Partner Program](https://www.shopify.com/partners)
- [Built for Shopify Requirements](https://shopify.dev/docs/apps/launch/built-for-shopify)
- [Disputifier Market Research](knowledge/init-research/)

---

**Document Status:** Ready for Implementation
**Next Review:** After Week 1 (Day 7) - Assess progress and adjust timeline if needed
**Questions:** Contact mladen.grozev@redispute.com

---

*This PRD represents the comprehensive plan for ReDispute MVP launch. It will be broken down into epics and user stories in Jira using the `prd-to-jira` skill.*
