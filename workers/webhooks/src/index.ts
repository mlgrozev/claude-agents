import { Hono } from 'hono';
import { logger } from 'hono/logger';

/**
 * Cloudflare Workers environment bindings
 */
export interface Env {
  DB: D1Database;
  WEBHOOK_LOG: KVNamespace;
  WEBHOOK_QUEUE: DurableObjectNamespace;
  SHOPIFY_WEBHOOK_SECRET: string;
  STRIPE_WEBHOOK_SECRET: string;
  PAYPAL_WEBHOOK_SECRET: string;
  ENVIRONMENT: string;
}

const app = new Hono<{ Bindings: Env }>();

// Middleware
app.use('*', logger());

// Health check
app.get('/health', (c) => {
  return c.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    environment: c.env.ENVIRONMENT,
  });
});

// Shopify webhook receiver
app.post('/webhooks/shopify/:topic', async (c) => {
  const topic = c.req.param('topic');
  const hmac = c.req.header('X-Shopify-Hmac-Sha256');
  const shopDomain = c.req.header('X-Shopify-Shop-Domain');

  console.log(`Received Shopify webhook: ${topic} from ${shopDomain}`);

  // TODO: Verify HMAC signature
  // TODO: Parse webhook payload
  // TODO: Store in webhook log
  // TODO: Queue for processing

  return c.json({ success: true, topic });
});

// Stripe webhook receiver
app.post('/webhooks/stripe', async (c) => {
  const signature = c.req.header('Stripe-Signature');

  console.log('Received Stripe webhook');

  // TODO: Verify webhook signature
  // TODO: Parse event
  // TODO: Store in webhook log
  // TODO: Queue for processing

  return c.json({ success: true });
});

// PayPal webhook receiver
app.post('/webhooks/paypal', async (c) => {
  console.log('Received PayPal webhook');

  // TODO: Verify webhook signature
  // TODO: Parse event
  // TODO: Store in webhook log
  // TODO: Queue for processing

  return c.json({ success: true });
});

// 404 handler
app.notFound((c) => {
  return c.json({ error: 'Webhook endpoint not found' }, 404);
});

// Error handler
app.onError((err, c) => {
  console.error('Webhook Error:', err);
  return c.json(
    {
      error: 'Webhook processing error',
      message: c.env.ENVIRONMENT === 'development' ? err.message : undefined,
    },
    500
  );
});

/**
 * Durable Object for webhook processing queue
 * (to be implemented in Day 2)
 */
export class WebhookQueue {
  private state: DurableObjectState;

  constructor(state: DurableObjectState) {
    this.state = state;
  }

  async fetch(request: Request): Promise<Response> {
    // TODO: Implement queue logic
    return new Response('WebhookQueue - Coming soon', { status: 200 });
  }
}

export default app;
