-- Redispute Database Schema (Cloudflare D1 / SQLite)
-- Version: 0.1.0
-- Created: 2026-01-13

-- ============================================================================
-- MERCHANTS TABLE
-- Stores Shopify merchant information and subscription status
-- ============================================================================
CREATE TABLE IF NOT EXISTS merchants (
  id TEXT PRIMARY KEY,
  shop_domain TEXT NOT NULL UNIQUE,
  access_token TEXT NOT NULL, -- Encrypted with libsodium
  subscription_tier TEXT NOT NULL DEFAULT 'free', -- free, growth, scale, enterprise
  subscription_status TEXT NOT NULL DEFAULT 'active', -- active, cancelled, paused
  dispute_rate REAL NOT NULL DEFAULT 0.0, -- Calculated dispute rate (%)
  payment_hold_risk INTEGER NOT NULL DEFAULT 0, -- Risk score 0-100
  installed_at TEXT NOT NULL,
  uninstalled_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  CHECK (subscription_tier IN ('free', 'growth', 'scale', 'enterprise')),
  CHECK (subscription_status IN ('active', 'cancelled', 'paused')),
  CHECK (dispute_rate >= 0.0),
  CHECK (payment_hold_risk >= 0 AND payment_hold_risk <= 100)
);

CREATE INDEX idx_merchants_shop_domain ON merchants(shop_domain);
CREATE INDEX idx_merchants_subscription_tier ON merchants(subscription_tier);
CREATE INDEX idx_merchants_dispute_rate ON merchants(dispute_rate);

-- ============================================================================
-- ORDERS TABLE
-- Stores order data from Shopify webhooks for risk analysis
-- ============================================================================
CREATE TABLE IF NOT EXISTS orders (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  shopify_order_id TEXT NOT NULL,
  order_number TEXT NOT NULL,
  customer_email TEXT NOT NULL, -- Encrypted
  customer_name TEXT, -- Encrypted
  total_amount INTEGER NOT NULL, -- Amount in cents
  currency TEXT NOT NULL DEFAULT 'USD',
  payment_method TEXT,
  billing_address TEXT, -- JSON string
  shipping_address TEXT, -- JSON string
  risk_score INTEGER NOT NULL DEFAULT 0, -- 0-100
  prevention_triggered INTEGER NOT NULL DEFAULT 0, -- 0 or 1 (boolean)
  prevention_type TEXT, -- item_not_received, customer_confusion, etc.
  prevention_sent_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  CHECK (total_amount >= 0),
  CHECK (risk_score >= 0 AND risk_score <= 100),
  CHECK (prevention_triggered IN (0, 1))
);

CREATE INDEX idx_orders_merchant_id ON orders(merchant_id);
CREATE INDEX idx_orders_shopify_order_id ON orders(shopify_order_id);
CREATE INDEX idx_orders_risk_score ON orders(risk_score);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- ============================================================================
-- CUSTOMER_DISPUTES TABLE
-- Customer-initiated dispute resolution requests (PREVENTION LAYER)
-- ============================================================================
CREATE TABLE IF NOT EXISTS customer_disputes (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  order_id TEXT NOT NULL,
  customer_email TEXT NOT NULL, -- Encrypted
  issue_type TEXT NOT NULL, -- item_not_received, not_as_described, quality_issue, etc.
  issue_description TEXT NOT NULL,
  photos TEXT, -- JSON array of photo URLs
  status TEXT NOT NULL DEFAULT 'pending', -- pending, approved, rejected, resolved
  resolution_type TEXT, -- refund, store_credit, replacement
  resolution_amount INTEGER, -- Amount in cents
  auto_approved INTEGER NOT NULL DEFAULT 0, -- 0 or 1
  merchant_notes TEXT,
  resolved_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  CHECK (status IN ('pending', 'approved', 'rejected', 'resolved')),
  CHECK (auto_approved IN (0, 1))
);

CREATE INDEX idx_customer_disputes_merchant_id ON customer_disputes(merchant_id);
CREATE INDEX idx_customer_disputes_order_id ON customer_disputes(order_id);
CREATE INDEX idx_customer_disputes_status ON customer_disputes(status);
CREATE INDEX idx_customer_disputes_created_at ON customer_disputes(created_at);

-- ============================================================================
-- CHARGEBACKS TABLE
-- Actual chargebacks/disputes from payment processors
-- ============================================================================
CREATE TABLE IF NOT EXISTS chargebacks (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  processor TEXT NOT NULL, -- shopify, stripe, paypal, klarna
  processor_dispute_id TEXT NOT NULL,
  order_id TEXT, -- May not exist if order data not synced
  shopify_order_id TEXT,
  amount INTEGER NOT NULL, -- Amount in cents
  currency TEXT NOT NULL DEFAULT 'USD',
  reason TEXT NOT NULL, -- fraudulent, unrecognized, product_not_received, etc.
  reason_code TEXT, -- Processor-specific reason code
  status TEXT NOT NULL DEFAULT 'pending', -- pending, under_review, won, lost, accepted, evidence_required, closed
  evidence_submitted INTEGER NOT NULL DEFAULT 0, -- 0 or 1
  evidence_due_by TEXT,
  won_at TEXT,
  lost_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  CHECK (processor IN ('shopify', 'stripe', 'paypal', 'klarna')),
  CHECK (amount >= 0),
  CHECK (status IN ('pending', 'under_review', 'won', 'lost', 'accepted', 'evidence_required', 'closed')),
  CHECK (evidence_submitted IN (0, 1))
);

CREATE INDEX idx_chargebacks_merchant_id ON chargebacks(merchant_id);
CREATE INDEX idx_chargebacks_processor ON chargebacks(processor);
CREATE INDEX idx_chargebacks_status ON chargebacks(status);
CREATE INDEX idx_chargebacks_created_at ON chargebacks(created_at);
CREATE INDEX idx_chargebacks_processor_dispute_id ON chargebacks(processor_dispute_id);

-- ============================================================================
-- EVIDENCE_PACKAGES TABLE
-- AI-generated evidence for chargebacks
-- ============================================================================
CREATE TABLE IF NOT EXISTS evidence_packages (
  id TEXT PRIMARY KEY,
  chargeback_id TEXT NOT NULL,
  merchant_id TEXT NOT NULL,
  evidence_text TEXT NOT NULL, -- Generated evidence document
  evidence_format TEXT NOT NULL DEFAULT 'json', -- json, pdf, text
  shipping_proof TEXT, -- JSON with tracking details
  communication_history TEXT, -- JSON with email history
  product_details TEXT, -- JSON with product info
  store_policies TEXT, -- JSON with return/shipping policies
  quality_score INTEGER NOT NULL DEFAULT 0, -- 0-100
  win_probability INTEGER NOT NULL DEFAULT 0, -- 0-100
  generated_at TEXT NOT NULL,
  submitted_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (chargeback_id) REFERENCES chargebacks(id) ON DELETE CASCADE,
  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  CHECK (quality_score >= 0 AND quality_score <= 100),
  CHECK (win_probability >= 0 AND win_probability <= 100)
);

CREATE INDEX idx_evidence_chargeback_id ON evidence_packages(chargeback_id);
CREATE INDEX idx_evidence_merchant_id ON evidence_packages(merchant_id);
CREATE INDEX idx_evidence_generated_at ON evidence_packages(generated_at);

-- ============================================================================
-- ANALYTICS_EVENTS TABLE
-- Track user actions and prevention attempts for analytics
-- ============================================================================
CREATE TABLE IF NOT EXISTS analytics_events (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  event_type TEXT NOT NULL, -- prevention_sent, dispute_filed, dispute_won, dispute_lost, etc.
  event_data TEXT, -- JSON with event details
  order_id TEXT,
  chargeback_id TEXT,
  amount INTEGER, -- Amount in cents
  created_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE SET NULL,
  FOREIGN KEY (chargeback_id) REFERENCES chargebacks(id) ON DELETE SET NULL
);

CREATE INDEX idx_analytics_merchant_id ON analytics_events(merchant_id);
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_created_at ON analytics_events(created_at);

-- ============================================================================
-- WEBHOOK_LOG TABLE
-- Log all incoming webhooks for debugging
-- ============================================================================
CREATE TABLE IF NOT EXISTS webhook_log (
  id TEXT PRIMARY KEY,
  merchant_id TEXT,
  source TEXT NOT NULL, -- shopify, stripe, paypal
  topic TEXT NOT NULL, -- orders/create, disputes/create, etc.
  payload TEXT NOT NULL, -- Full webhook payload (JSON)
  status TEXT NOT NULL DEFAULT 'pending', -- pending, processed, failed
  error_message TEXT,
  processed_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE SET NULL,
  CHECK (status IN ('pending', 'processed', 'failed'))
);

CREATE INDEX idx_webhook_log_merchant_id ON webhook_log(merchant_id);
CREATE INDEX idx_webhook_log_source ON webhook_log(source);
CREATE INDEX idx_webhook_log_status ON webhook_log(status);
CREATE INDEX idx_webhook_log_created_at ON webhook_log(created_at);

-- ============================================================================
-- BILLING_RECORDS TABLE
-- Track subscription charges and usage fees
-- ============================================================================
CREATE TABLE IF NOT EXISTS billing_records (
  id TEXT PRIMARY KEY,
  merchant_id TEXT NOT NULL,
  billing_period_start TEXT NOT NULL,
  billing_period_end TEXT NOT NULL,
  subscription_fee INTEGER NOT NULL, -- Amount in cents
  success_fees INTEGER NOT NULL DEFAULT 0, -- Amount in cents (12% of prevented/won disputes)
  total_amount INTEGER NOT NULL, -- subscription_fee + success_fees
  currency TEXT NOT NULL DEFAULT 'USD',
  disputes_prevented INTEGER NOT NULL DEFAULT 0,
  disputes_won INTEGER NOT NULL DEFAULT 0,
  shopify_charge_id TEXT, -- Shopify Billing API charge ID
  status TEXT NOT NULL DEFAULT 'pending', -- pending, paid, failed
  paid_at TEXT,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),

  FOREIGN KEY (merchant_id) REFERENCES merchants(id) ON DELETE CASCADE,
  CHECK (subscription_fee >= 0),
  CHECK (success_fees >= 0),
  CHECK (total_amount >= 0),
  CHECK (status IN ('pending', 'paid', 'failed'))
);

CREATE INDEX idx_billing_merchant_id ON billing_records(merchant_id);
CREATE INDEX idx_billing_period_start ON billing_records(billing_period_start);
CREATE INDEX idx_billing_status ON billing_records(status);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT TIMESTAMPS
-- ============================================================================
CREATE TRIGGER IF NOT EXISTS update_merchants_timestamp
  AFTER UPDATE ON merchants
BEGIN
  UPDATE merchants SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_orders_timestamp
  AFTER UPDATE ON orders
BEGIN
  UPDATE orders SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_customer_disputes_timestamp
  AFTER UPDATE ON customer_disputes
BEGIN
  UPDATE customer_disputes SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_chargebacks_timestamp
  AFTER UPDATE ON chargebacks
BEGIN
  UPDATE chargebacks SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_evidence_packages_timestamp
  AFTER UPDATE ON evidence_packages
BEGIN
  UPDATE evidence_packages SET updated_at = datetime('now') WHERE id = NEW.id;
END;

CREATE TRIGGER IF NOT EXISTS update_billing_records_timestamp
  AFTER UPDATE ON billing_records
BEGIN
  UPDATE billing_records SET updated_at = datetime('now') WHERE id = NEW.id;
END;

-- ============================================================================
-- SCHEMA VERSION TRACKING
-- ============================================================================
CREATE TABLE IF NOT EXISTS schema_version (
  version TEXT PRIMARY KEY,
  applied_at TEXT NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO schema_version (version) VALUES ('0.1.0');
