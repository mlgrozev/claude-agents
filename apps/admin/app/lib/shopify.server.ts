/**
 * Shopify OAuth and session management (server-side)
 */

import { redirect } from '@remix-run/cloudflare';

export interface ShopifyConfig {
  apiKey: string;
  apiSecret: string;
  scopes: string[];
  hostName: string;
}

export interface SessionData {
  shop: string;
  accessToken: string;
  scope: string;
  expiresAt?: number;
}

/**
 * Get Shopify configuration from environment
 */
export function getShopifyConfig(env: any): ShopifyConfig {
  return {
    apiKey: env.SHOPIFY_CLIENT_ID || '',
    apiSecret: env.SHOPIFY_CLIENT_SECRET || '',
    scopes: [
      'read_orders',
      'read_customers',
      'read_disputes',
      'read_products',
      'write_disputes',
      'read_merchant_managed_fulfillment_orders',
    ],
    hostName: env.APP_URL || 'https://redispute.com',
  };
}

/**
 * Build Shopify OAuth authorization URL
 */
export function buildAuthUrl(shop: string, config: ShopifyConfig, state: string): string {
  const scopes = config.scopes.join(',');
  const redirectUri = `${config.hostName}/auth/callback`;

  return `https://${shop}/admin/oauth/authorize?client_id=${config.apiKey}&scope=${scopes}&redirect_uri=${encodeURIComponent(redirectUri)}&state=${state}`;
}

/**
 * Exchange authorization code for access token
 */
export async function exchangeCodeForToken(
  shop: string,
  code: string,
  config: ShopifyConfig
): Promise<{ access_token: string; scope: string }> {
  const response = await fetch(`https://${shop}/admin/oauth/access_token`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      client_id: config.apiKey,
      client_secret: config.apiSecret,
      code,
    }),
  });

  if (!response.ok) {
    throw new Error('Failed to exchange code for token');
  }

  return response.json();
}

/**
 * Verify HMAC signature from Shopify
 */
export function verifyHmac(query: URLSearchParams, secret: string): boolean {
  const hmac = query.get('hmac');
  if (!hmac) return false;

  // Remove hmac and signature from query params
  const params = new URLSearchParams(query);
  params.delete('hmac');
  params.delete('signature');

  // Sort params alphabetically
  const sortedParams = Array.from(params.entries())
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([key, value]) => `${key}=${value}`)
    .join('&');

  // TODO: Implement HMAC verification with crypto.subtle
  // For now, returning true for development
  console.log('HMAC verification - to be implemented');
  return true;
}

/**
 * Store session in KV
 */
export async function storeSession(
  kv: KVNamespace,
  shop: string,
  sessionData: SessionData
): Promise<void> {
  const sessionKey = `session:${shop}`;
  await kv.put(sessionKey, JSON.stringify(sessionData), {
    expirationTtl: 86400, // 24 hours
  });
}

/**
 * Get session from KV
 */
export async function getSession(
  kv: KVNamespace,
  shop: string
): Promise<SessionData | null> {
  const sessionKey = `session:${shop}`;
  const data = await kv.get(sessionKey);
  return data ? JSON.parse(data) : null;
}

/**
 * Delete session from KV
 */
export async function deleteSession(kv: KVNamespace, shop: string): Promise<void> {
  const sessionKey = `session:${shop}`;
  await kv.delete(sessionKey);
}

/**
 * Require authenticated session (middleware)
 */
export async function requireAuth(
  request: Request,
  kv: KVNamespace
): Promise<SessionData> {
  const url = new URL(request.url);
  const shop = url.searchParams.get('shop');

  if (!shop) {
    throw redirect('/auth?error=missing_shop');
  }

  const session = await getSession(kv, shop);

  if (!session) {
    throw redirect(`/auth?shop=${shop}`);
  }

  return session;
}
