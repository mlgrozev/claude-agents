// Shared constants

/**
 * Subscription tier pricing (monthly)
 */
export const SUBSCRIPTION_PRICING = {
  free: 0,
  growth: 299,
  scale: 699,
  enterprise: 1999,
} as const;

/**
 * Success fee percentage
 */
export const SUCCESS_FEE_PERCENTAGE = 0.12; // 12%

/**
 * Free tier limits
 */
export const FREE_TIER_LIMITS = {
  maxDisputesPerMonth: 5,
  maxAutoApprovals: 0,
  maxAIGenerations: 0,
} as const;

/**
 * Risk score thresholds
 */
export const RISK_THRESHOLDS = {
  low: 30,
  medium: 70,
  high: 100,
} as const;

/**
 * Dispute rate thresholds (percentage)
 */
export const DISPUTE_RATE_THRESHOLDS = {
  safe: 0.5,
  warning: 0.75,
  danger: 1.0,
} as const;

/**
 * API rate limits (requests per minute)
 */
export const RATE_LIMITS = {
  api: 100,
  webhook: 1000,
  public: 10,
} as const;

/**
 * Cache TTL (seconds)
 */
export const CACHE_TTL = {
  shopifyApi: 3600, // 1 hour
  disputeRate: 300, // 5 minutes
  analytics: 60, // 1 minute
  static: 31536000, // 1 year
} as const;

/**
 * OpenAI model configuration
 */
export const OPENAI_CONFIG = {
  model: 'gpt-4',
  maxTokens: 2000,
  temperature: 0.7,
} as const;

/**
 * Supported currencies
 */
export const SUPPORTED_CURRENCIES = [
  'USD',
  'EUR',
  'GBP',
  'CAD',
  'AUD',
  'JPY',
] as const;

/**
 * Shopify OAuth scopes
 */
export const SHOPIFY_SCOPES = [
  'read_orders',
  'read_customers',
  'read_disputes',
  'read_products',
  'write_disputes',
  'read_merchant_managed_fulfillment_orders',
  'read_assigned_fulfillment_orders',
] as const;
