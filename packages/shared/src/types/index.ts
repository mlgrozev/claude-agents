// Shared TypeScript types and interfaces

/**
 * Payment processor types
 */
export type PaymentProcessor = 'shopify' | 'stripe' | 'paypal' | 'klarna';

/**
 * Dispute status
 */
export type DisputeStatus =
  | 'pending'
  | 'under_review'
  | 'won'
  | 'lost'
  | 'accepted'
  | 'evidence_required'
  | 'closed';

/**
 * Dispute reason codes
 */
export type DisputeReason =
  | 'fraudulent'
  | 'unrecognized'
  | 'duplicate'
  | 'subscription_canceled'
  | 'product_unacceptable'
  | 'product_not_received'
  | 'credit_not_processed'
  | 'general';

/**
 * Merchant subscription tier
 */
export type SubscriptionTier = 'free' | 'growth' | 'scale' | 'enterprise';

/**
 * Merchant entity
 */
export interface Merchant {
  id: string;
  shop_domain: string;
  access_token: string;
  subscription_tier: SubscriptionTier;
  subscription_status: 'active' | 'cancelled' | 'paused';
  dispute_rate: number;
  installed_at: string;
  uninstalled_at: string | null;
  created_at: string;
  updated_at: string;
}

/**
 * Chargeback entity
 */
export interface Chargeback {
  id: string;
  merchant_id: string;
  processor: PaymentProcessor;
  processor_dispute_id: string;
  order_id: string;
  amount: number;
  currency: string;
  reason: DisputeReason;
  status: DisputeStatus;
  evidence_submitted: boolean;
  evidence_due_by: string | null;
  won_at: string | null;
  lost_at: string | null;
  created_at: string;
  updated_at: string;
}

/**
 * Order entity
 */
export interface Order {
  id: string;
  merchant_id: string;
  shopify_order_id: string;
  order_number: string;
  customer_email: string;
  total_amount: number;
  currency: string;
  risk_score: number;
  prevention_triggered: boolean;
  created_at: string;
  updated_at: string;
}

/**
 * Evidence package entity
 */
export interface EvidencePackage {
  id: string;
  chargeback_id: string;
  merchant_id: string;
  evidence_text: string;
  quality_score: number;
  win_probability: number;
  generated_at: string;
  submitted_at: string | null;
  created_at: string;
  updated_at: string;
}
