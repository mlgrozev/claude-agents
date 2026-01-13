/**
 * Shopify OAuth callback route
 */

import { redirect, type LoaderFunctionArgs } from '@remix-run/cloudflare';
import {
  getShopifyConfig,
  exchangeCodeForToken,
  storeSession,
  verifyHmac,
} from '~/lib/shopify.server';

export async function loader({ request, context }: LoaderFunctionArgs) {
  const url = new URL(request.url);
  const shop = url.searchParams.get('shop');
  const code = url.searchParams.get('code');
  const state = url.searchParams.get('state');
  const hmac = url.searchParams.get('hmac');

  // Validate required parameters
  if (!shop || !code || !state) {
    return new Response('Missing required parameters', { status: 400 });
  }

  // Verify HMAC
  const config = getShopifyConfig(context.env);
  const isValidHmac = verifyHmac(url.searchParams, config.apiSecret);

  if (!isValidHmac) {
    return new Response('Invalid HMAC signature', { status: 403 });
  }

  // Verify state parameter (CSRF protection)
  const stateKey = `oauth_state:${state}`;
  const storedShop = await (context.env as any).SESSIONS.get(stateKey);

  if (storedShop !== shop) {
    return new Response('Invalid state parameter', { status: 403 });
  }

  // Clean up state
  await (context.env as any).SESSIONS.delete(stateKey);

  try {
    // Exchange code for access token
    const tokenData = await exchangeCodeForToken(shop, code, config);

    // Store session
    await storeSession((context.env as any).SESSIONS, shop, {
      shop,
      accessToken: tokenData.access_token,
      scope: tokenData.scope,
    });

    // Store merchant in database (via API worker)
    const merchantId = `mrch_${Date.now()}_${Math.random().toString(36).substring(7)}`;

    await (context.env as any).DB.prepare(`
      INSERT OR REPLACE INTO merchants (id, shop_domain, access_token, subscription_tier, subscription_status, installed_at)
      VALUES (?, ?, ?, 'free', 'active', datetime('now'))
    `)
      .bind(merchantId, shop, tokenData.access_token)
      .run();

    console.log('Merchant installed:', shop);

    // Redirect to dashboard
    const host = url.searchParams.get('host');
    const redirectUrl = host
      ? `/?shop=${shop}&host=${host}`
      : `/?shop=${shop}`;

    return redirect(redirectUrl);
  } catch (error) {
    console.error('OAuth callback error:', error);
    return new Response('Authentication failed', { status: 500 });
  }
}
