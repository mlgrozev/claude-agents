import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';

/**
 * Cloudflare Workers environment bindings
 */
export interface Env {
  DB: D1Database;
  SESSIONS: KVNamespace;
  CACHE: KVNamespace;
  SHOPIFY_CLIENT_ID: string;
  SHOPIFY_CLIENT_SECRET: string;
  STRIPE_SECRET_KEY: string;
  STRIPE_WEBHOOK_SECRET: string;
  PAYPAL_CLIENT_ID: string;
  PAYPAL_CLIENT_SECRET: string;
  OPENAI_API_KEY: string;
  ENVIRONMENT: string;
}

const app = new Hono<{ Bindings: Env }>();

// Middleware
app.use('*', logger());
app.use(
  '*',
  cors({
    origin: ['https://admin.shopify.com', 'http://localhost:3000'],
    credentials: true,
  })
);

// Health check
app.get('/health', (c) => {
  return c.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    environment: c.env.ENVIRONMENT,
  });
});

// API routes
app.get('/api/v1', (c) => {
  return c.json({
    message: 'Redispute API v1',
    version: '0.1.0',
    endpoints: {
      health: '/health',
      merchants: '/api/v1/merchants',
      disputes: '/api/v1/disputes',
      evidence: '/api/v1/evidence',
      analytics: '/api/v1/analytics',
    },
  });
});

// Placeholder routes (to be implemented in Day 2-6)
app.get('/api/v1/merchants/:id', (c) => {
  return c.json({ message: 'Merchant endpoint - Coming soon' });
});

app.get('/api/v1/disputes', (c) => {
  return c.json({ message: 'Disputes endpoint - Coming soon' });
});

app.post('/api/v1/evidence/generate', (c) => {
  return c.json({ message: 'Evidence generation - Coming soon' });
});

app.get('/api/v1/analytics', (c) => {
  return c.json({ message: 'Analytics endpoint - Coming soon' });
});

// 404 handler
app.notFound((c) => {
  return c.json({ error: 'Not found', path: c.req.path }, 404);
});

// Error handler
app.onError((err, c) => {
  console.error('API Error:', err);
  return c.json(
    {
      error: 'Internal server error',
      message: c.env.ENVIRONMENT === 'development' ? err.message : undefined,
    },
    500
  );
});

export default app;
