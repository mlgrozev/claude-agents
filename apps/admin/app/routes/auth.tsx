/**
 * Shopify OAuth initiation route
 */

import { redirect, type LoaderFunctionArgs } from '@remix-run/cloudflare';
import { getShopifyConfig, buildAuthUrl, verifyHmac } from '~/lib/shopify.server';

export async function loader({ request, context }: LoaderFunctionArgs) {
  const url = new URL(request.url);
  const shop = url.searchParams.get('shop');

  // Validate shop parameter
  if (!shop || !shop.endsWith('.myshopify.com')) {
    return new Response('Invalid shop parameter', { status: 400 });
  }

  // Verify HMAC if present (embedded app installation)
  if (url.searchParams.has('hmac')) {
    const config = getShopifyConfig(context.env);
    const isValid = verifyHmac(url.searchParams, config.apiSecret);

    if (!isValid) {
      return new Response('Invalid HMAC signature', { status: 403 });
    }
  }

  // Generate state parameter for CSRF protection
  const state = crypto.randomUUID();

  // Store state in KV for verification in callback
  const stateKey = `oauth_state:${state}`;
  await (context.env as any).SESSIONS.put(stateKey, shop, {
    expirationTtl: 600, // 10 minutes
  });

  // Build OAuth authorization URL
  const config = getShopifyConfig(context.env);
  const authUrl = buildAuthUrl(shop, config, state);

  // Redirect to Shopify OAuth
  return redirect(authUrl);
}
