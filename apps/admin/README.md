# Redispute Admin Dashboard

Merchant-facing admin dashboard built with Remix, Shopify Polaris, and deployed to Cloudflare Pages.

## Overview

This is the main interface for merchants using PreventFlow. It provides:
- Real-time dispute rate monitoring
- Payment hold risk alerts
- Dispute management (pending, active, resolved)
- AI evidence generation
- Analytics and reporting
- Billing and subscription management

## Tech Stack

- **Framework**: [Remix v2](https://remix.run/) with Cloudflare adapter
- **UI Library**: [Shopify Polaris v12](https://polaris.shopify.com/)
- **Build Tool**: Vite
- **Deployment**: Cloudflare Pages
- **Auth**: Shopify OAuth 2.0
- **Database**: Cloudflare D1 (via bindings)
- **Sessions**: Cloudflare KV

## Development

### Prerequisites

1. Cloudflare account with Pages enabled
2. Shopify Partner account
3. Node.js 20+
4. PNPM 8+

### Setup

1. **Install dependencies**:
   ```bash
   pnpm install
   ```

2. **Create Shopify app** in Partner Dashboard:
   - App name: PreventFlow (Dev)
   - App URL: http://localhost:3000
   - Allowed redirection URL(s):
     - http://localhost:3000/auth/callback
     - https://your-cloudflare-pages-url.pages.dev/auth/callback

3. **Configure environment variables**:
   Create `.dev.vars` in the root:
   ```
   SHOPIFY_CLIENT_ID=your_client_id_here
   SHOPIFY_CLIENT_SECRET=your_client_secret_here
   APP_URL=http://localhost:3000
   ```

4. **Set up D1 database** (if not already done):
   ```bash
   # From project root
   wrangler d1 create redispute-dev
   wrangler d1 execute redispute-dev --file=packages/database/schema.sql
   ```

5. **Create KV namespace** for sessions:
   ```bash
   wrangler kv:namespace create SESSIONS
   wrangler kv:namespace create SESSIONS --preview
   ```

6. **Update wrangler.toml** with your database and KV IDs

### Run Development Server

```bash
pnpm run dev
```

This starts Remix in development mode at http://localhost:3000.

### Testing Shopify OAuth

1. Navigate to: `http://localhost:3000/auth?shop=your-dev-store.myshopify.com`
2. Complete OAuth flow
3. You'll be redirected to the dashboard

## Project Structure

```
apps/admin/
├── app/
│   ├── routes/              # Remix routes
│   │   ├── _index.tsx       # Dashboard (authenticated)
│   │   ├── auth.tsx         # OAuth initiation
│   │   └── auth.callback.tsx # OAuth callback
│   ├── components/          # React components
│   ├── lib/                 # Utilities
│   │   └── shopify.server.ts # Shopify OAuth helpers
│   ├── root.tsx             # Root layout
│   ├── entry.server.tsx     # Server entry
│   └── entry.client.tsx     # Client entry
├── public/                  # Static assets
│   ├── _headers             # Cloudflare Pages headers
│   └── _redirects           # Cloudflare Pages redirects
├── package.json
├── vite.config.ts           # Vite configuration
├── tsconfig.json            # TypeScript configuration
├── wrangler.toml            # Cloudflare configuration
└── README.md                # This file
```

## Routes

### Public Routes

- **GET /auth?shop={shop}**: Initiate Shopify OAuth
- **GET /auth/callback**: OAuth callback handler

### Authenticated Routes

- **GET /**: Main dashboard (requires session)
- **GET /disputes**: Disputes list (Day 2+)
- **GET /disputes/:id**: Dispute details (Day 2+)
- **GET /analytics**: Analytics dashboard (Day 5)
- **GET /billing**: Billing and subscription (Day 5)

## Authentication Flow

1. Merchant installs app from Shopify App Store
2. Shopify redirects to `/auth?shop={shop}&hmac={hmac}`
3. App verifies HMAC, generates state parameter
4. App redirects to Shopify OAuth authorization URL
5. Merchant grants permissions
6. Shopify redirects to `/auth/callback?code={code}&state={state}`
7. App exchanges code for access token
8. App stores session in KV and merchant in D1
9. Merchant is redirected to dashboard

## Session Management

Sessions are stored in Cloudflare KV with:
- **Key**: `session:{shop}`
- **Value**: JSON with `{ shop, accessToken, scope }`
- **TTL**: 24 hours (86400 seconds)

The `requireAuth()` middleware checks for valid session on protected routes.

## Shopify Polaris Components

This app uses Shopify Polaris for UI consistency:

- **Page**: Page container with title
- **Layout**: Grid layout system
- **Card**: Content cards
- **Text**: Typography component
- **Badge**: Status badges
- **BlockStack**: Vertical stacking
- **InlineStack**: Horizontal alignment

See [Polaris documentation](https://polaris.shopify.com/components) for full component library.

## Building for Production

```bash
pnpm run build
```

This creates an optimized build in `build/client/`.

## Deployment

### Deploy to Cloudflare Pages

1. **Create Pages project**:
   ```bash
   wrangler pages project create redispute-admin
   ```

2. **Deploy**:
   ```bash
   pnpm run deploy
   ```

3. **Set production secrets**:
   ```bash
   wrangler pages secret put SHOPIFY_CLIENT_ID
   wrangler pages secret put SHOPIFY_CLIENT_SECRET
   ```

4. **Update Shopify app URLs** in Partner Dashboard:
   - App URL: https://redispute-admin.pages.dev
   - Redirect URL: https://redispute-admin.pages.dev/auth/callback

### Continuous Deployment

Connect your GitHub repository to Cloudflare Pages for automatic deployments:
1. Go to Cloudflare Dashboard > Pages
2. Connect to Git
3. Select repository
4. Configure build settings:
   - Build command: `pnpm run build`
   - Build output directory: `build/client`

## Environment Variables

### Development (.dev.vars)

```
SHOPIFY_CLIENT_ID=your_dev_client_id
SHOPIFY_CLIENT_SECRET=your_dev_client_secret
APP_URL=http://localhost:3000
ENVIRONMENT=development
```

### Production (Cloudflare Pages)

Set via Wrangler or Cloudflare Dashboard:
- `SHOPIFY_CLIENT_ID` (secret)
- `SHOPIFY_CLIENT_SECRET` (secret)
- `APP_URL` (public)
- `ENVIRONMENT=production` (public)

## Next Steps

Day 2-6 implementation will add:
- **Day 2**: Multi-processor integration UI, webhook logs
- **Day 3**: Prevention dashboard, customer dispute portal
- **Day 4**: Evidence generation UI, quality scoring
- **Day 5**: Advanced analytics, charts, billing UI
- **Day 6**: Polish, mobile responsive, final testing

## Troubleshooting

### "Invalid HMAC signature" error

- Verify `SHOPIFY_CLIENT_SECRET` is correct
- Check that HMAC verification is implemented (currently placeholder)

### "Merchant not found" error

- Ensure D1 database is created and schema is applied
- Check that OAuth callback successfully stores merchant

### Session expired

- Sessions expire after 24 hours
- Merchant needs to re-authenticate via `/auth?shop={shop}`

### Polaris styles not loading

- Ensure `@shopify/polaris/build/esm/styles.css` is imported in root.tsx
- Check that Vite is properly bundling CSS

## Resources

- [Remix Documentation](https://remix.run/docs)
- [Shopify Polaris](https://polaris.shopify.com/)
- [Cloudflare Pages](https://developers.cloudflare.com/pages/)
- [Shopify App Development](https://shopify.dev/docs/apps)
- [Shopify OAuth](https://shopify.dev/docs/apps/auth/oauth)
