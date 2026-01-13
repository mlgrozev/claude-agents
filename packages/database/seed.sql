-- Redispute Development Database Seed Data
-- Version: 0.1.0
-- Created: 2026-01-13

-- ============================================================================
-- SEED: Test Merchants
-- ============================================================================
INSERT INTO merchants (id, shop_domain, access_token, subscription_tier, subscription_status, dispute_rate, payment_hold_risk, installed_at)
VALUES
  ('mrch_test_001', 'test-store-1.myshopify.com', 'encrypted_token_placeholder_1', 'growth', 'active', 0.42, 25, datetime('now', '-30 days')),
  ('mrch_test_002', 'test-store-2.myshopify.com', 'encrypted_token_placeholder_2', 'scale', 'active', 0.68, 65, datetime('now', '-60 days')),
  ('mrch_test_003', 'test-store-3.myshopify.com', 'encrypted_token_placeholder_3', 'free', 'active', 0.15, 10, datetime('now', '-7 days'));

-- ============================================================================
-- SEED: Test Orders
-- ============================================================================
INSERT INTO orders (id, merchant_id, shopify_order_id, order_number, customer_email, customer_name, total_amount, currency, risk_score, prevention_triggered, created_at)
VALUES
  ('ord_001', 'mrch_test_001', '5432109876543210', '1001', 'customer1@example.com', 'John Doe', 9999, 'USD', 85, 1, datetime('now', '-5 days')),
  ('ord_002', 'mrch_test_001', '5432109876543211', '1002', 'customer2@example.com', 'Jane Smith', 15000, 'USD', 45, 0, datetime('now', '-4 days')),
  ('ord_003', 'mrch_test_002', '5432109876543212', '2001', 'customer3@example.com', 'Bob Johnson', 29999, 'USD', 92, 1, datetime('now', '-10 days')),
  ('ord_004', 'mrch_test_002', '5432109876543213', '2002', 'customer4@example.com', 'Alice Brown', 7500, 'USD', 20, 0, datetime('now', '-8 days')),
  ('ord_005', 'mrch_test_003', '5432109876543214', '3001', 'customer5@example.com', 'Charlie Wilson', 12500, 'USD', 55, 0, datetime('now', '-2 days'));

-- ============================================================================
-- SEED: Test Customer Disputes (Prevention Layer)
-- ============================================================================
INSERT INTO customer_disputes (id, merchant_id, order_id, customer_email, issue_type, issue_description, status, resolution_type, resolution_amount, auto_approved, created_at)
VALUES
  ('cust_disp_001', 'mrch_test_001', 'ord_001', 'customer1@example.com', 'item_not_received', 'Package shows delivered but I never received it', 'approved', 'refund', 9999, 1, datetime('now', '-4 days')),
  ('cust_disp_002', 'mrch_test_002', 'ord_003', 'customer3@example.com', 'quality_issue', 'Product arrived damaged, photos attached', 'pending', NULL, NULL, 0, datetime('now', '-1 day'));

-- ============================================================================
-- SEED: Test Chargebacks
-- ============================================================================
INSERT INTO chargebacks (id, merchant_id, processor, processor_dispute_id, order_id, shopify_order_id, amount, currency, reason, status, evidence_submitted, created_at)
VALUES
  ('cb_001', 'mrch_test_001', 'stripe', 'dp_1234567890', 'ord_002', '5432109876543211', 15000, 'USD', 'product_not_received', 'evidence_required', 0, datetime('now', '-2 days')),
  ('cb_002', 'mrch_test_002', 'shopify', 'shopify_dispute_5678', 'ord_004', '5432109876543213', 7500, 'USD', 'fraudulent', 'under_review', 1, datetime('now', '-15 days')),
  ('cb_003', 'mrch_test_002', 'klarna', 'klarna_case_9012', NULL, NULL, 29999, 'USD', 'product_not_received', 'pending', 0, datetime('now', '-1 day'));

-- ============================================================================
-- SEED: Test Evidence Packages
-- ============================================================================
INSERT INTO evidence_packages (id, chargeback_id, merchant_id, evidence_text, quality_score, win_probability, generated_at)
VALUES
  ('evid_001', 'cb_002', 'mrch_test_002', 'AI-generated evidence package: Order #2002 was delivered on 2026-01-05 with tracking confirmation. Customer signed for delivery. Product matches description and photos...', 85, 92, datetime('now', '-14 days'));

-- ============================================================================
-- SEED: Test Analytics Events
-- ============================================================================
INSERT INTO analytics_events (id, merchant_id, event_type, event_data, order_id, amount, created_at)
VALUES
  ('evt_001', 'mrch_test_001', 'prevention_sent', '{"type": "item_not_received", "email_sent": true}', 'ord_001', 9999, datetime('now', '-5 days')),
  ('evt_002', 'mrch_test_001', 'dispute_prevented', '{"resolved_via": "customer_portal"}', 'ord_001', 9999, datetime('now', '-4 days')),
  ('evt_003', 'mrch_test_002', 'dispute_filed', '{"processor": "stripe"}', 'ord_002', 15000, datetime('now', '-2 days')),
  ('evt_004', 'mrch_test_002', 'evidence_generated', '{"quality_score": 85}', 'ord_004', 7500, datetime('now', '-14 days'));

-- ============================================================================
-- SEED: Test Webhook Log
-- ============================================================================
INSERT INTO webhook_log (id, merchant_id, source, topic, payload, status, processed_at, created_at)
VALUES
  ('wh_001', 'mrch_test_001', 'shopify', 'orders/create', '{"id": 5432109876543210, "order_number": 1001, "total_price": "99.99"}', 'processed', datetime('now', '-5 days'), datetime('now', '-5 days')),
  ('wh_002', 'mrch_test_002', 'stripe', 'dispute.created', '{"id": "dp_1234567890", "amount": 15000, "reason": "product_not_received"}', 'processed', datetime('now', '-2 days'), datetime('now', '-2 days')),
  ('wh_003', 'mrch_test_002', 'shopify', 'disputes/create', '{"id": "shopify_dispute_5678", "amount": "75.00"}', 'processed', datetime('now', '-15 days'), datetime('now', '-15 days'));

-- ============================================================================
-- SEED: Test Billing Records
-- ============================================================================
INSERT INTO billing_records (id, merchant_id, billing_period_start, billing_period_end, subscription_fee, success_fees, total_amount, disputes_prevented, disputes_won, status, paid_at, created_at)
VALUES
  ('bill_001', 'mrch_test_001', datetime('now', '-60 days'), datetime('now', '-30 days'), 29900, 1200, 31100, 2, 1, 'paid', datetime('now', '-29 days'), datetime('now', '-30 days')),
  ('bill_002', 'mrch_test_002', datetime('now', '-60 days'), datetime('now', '-30 days'), 69900, 3600, 73500, 5, 3, 'paid', datetime('now', '-29 days'), datetime('now', '-30 days')),
  ('bill_003', 'mrch_test_001', datetime('now', '-30 days'), datetime('now'), 29900, 0, 29900, 0, 0, 'pending', NULL, datetime('now'));

-- ============================================================================
-- Summary
-- ============================================================================
-- Total seed data:
-- - 3 test merchants (free, growth, scale tiers)
-- - 5 test orders (various risk scores)
-- - 2 customer disputes (1 auto-approved, 1 pending)
-- - 3 chargebacks (Stripe, Shopify, Klarna)
-- - 1 evidence package (high quality)
-- - 4 analytics events (prevention sent, dispute prevented, etc.)
-- - 3 webhook logs (Shopify, Stripe)
-- - 3 billing records (2 paid, 1 pending)
