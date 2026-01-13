# Shopify Partner App Setup Guide
## PreventFlow - Chargeback Prevention Platform

**Created**: 2026-01-13
**Status**: Ready for Registration
**Deployment URLs**: Available and tested ✅

---

## 📋 QUICK REFERENCE

### Your Deployed URLs
- **Admin Dashboard**: `https://9066ffc8.redispute-admin.pages.dev`
- **API Worker**: `https://redispute-api.melioraweb-com-account.workers.dev`

### OAuth Callback URL
```
https://9066ffc8.redispute-admin.pages.dev/auth/callback
```

### Webhook URL (for Day 2)
```
https://redispute-api.melioraweb-com-account.workers.dev/webhooks/shopify
```

---

## 🚀 STEP-BY-STEP SETUP

### Step 1: Access Shopify Partners Dashboard

1. Go to: **https://partners.shopify.com/**
2. Sign in with your account (or create one if needed)
3. Complete your partner profile if prompted

---

### Step 2: Create New App

1. In the Partners Dashboard, click **Apps** in the left sidebar
2. Click **Create app** button (top right)
3. Select **Create app manually**
4. Fill in the details:

**App Name:**
```
PreventFlow
```

**App URL:**
```
https://9066ffc8.redispute-admin.pages.dev
```

Click **Create app**

---

### Step 3: Configure App URLs

After creating the app, go to **Configuration** tab:

#### App URLs Section

**App URL:**
```
https://9066ffc8.redispute-admin.pages.dev
```

**Allowed redirection URL(s):**
```
https://9066ffc8.redispute-admin.pages.dev/auth/callback
```

Click **Save**

---

### Step 4: Configure API Access Scopes

In the **Configuration** tab, scroll to **API access** section:

**Select these scopes:**

✅ **Orders**
- `read_orders` - Read orders
- `write_orders` - Write orders (for refunds)

✅ **Customers**
- `read_customers` - Read customer data

✅ **Disputes**
- `read_disputes` - Read payment disputes
- `write_disputes` - Submit evidence for disputes

✅ **Products**
- `read_products` - Read product details

✅ **Shipping**
- `read_shipping` - Read shipping information
- `read_merchant_managed_fulfillment_orders` - Read fulfillment data

✅ **Store Content**
- `read_content` - Read store policies

Click **Save**

---

### Step 5: Get API Credentials

1. In the **Configuration** tab, find **API credentials** section
2. You'll see:
   - **Client ID** (also called API key)
   - **Client secret** (click to reveal)

3. Copy both values - we'll update them next

**IMPORTANT**: Keep these secret! Don't commit them to git.

---

### Step 6: Update Secrets with Actual Credentials

Open your terminal and run these commands with your actual Shopify credentials:

```bash
# For Admin Dashboard (Pages)
cd /Users/mladen.grozev/Code/redispute/apps/admin

# When prompted, paste your actual Client ID
wrangler pages secret put SHOPIFY_CLIENT_ID --project-name redispute-admin

# When prompted, paste your actual Client Secret
wrangler pages secret put SHOPIFY_CLIENT_SECRET --project-name redispute-admin

# For API Worker
cd /Users/mladen.grozev/Code/redispute/workers/api

# When prompted, paste your actual Client ID
wrangler secret put SHOPIFY_CLIENT_ID

# When prompted, paste your actual Client Secret
wrangler secret put SHOPIFY_CLIENT_SECRET
```

---

### Step 7: Create Development Store (Testing)

1. In Partners Dashboard, click **Stores** in left sidebar
2. Click **Add store** button
3. Select **Development store**
4. Fill in details:
   - **Store name**: `preventflow-dev` (or your choice)
   - **Store purpose**: Test your app
   - **Store region**: Select your region
5. Click **Create development store**

Wait for the store to be created (takes ~1 minute)

---

### Step 8: Install App on Development Store

#### Option A: Via Partners Dashboard
1. Go to your app in Partners Dashboard
2. Click **Test on development store**
3. Select your `preventflow-dev` store
4. Click **Install app**

#### Option B: Via Direct URL
1. Get your development store URL (e.g., `preventflow-dev.myshopify.com`)
2. Visit this URL:
```
https://9066ffc8.redispute-admin.pages.dev/auth?shop=preventflow-dev.myshopify.com
```
3. Replace `preventflow-dev` with your actual store name

---

### Step 9: Test OAuth Flow

After clicking install, you should see:

1. **Shopify Permission Screen**
   - Shows your app name "PreventFlow"
   - Lists requested permissions
   - Shows your Partner organization

2. **Click "Install app"**

3. **Redirect to Dashboard**
   - You should be redirected to: `https://9066ffc8.redispute-admin.pages.dev`
   - Should see the PreventFlow dashboard
   - Should see "Connected to: your-store.myshopify.com"

---

### Step 10: Verify Installation

Check that everything is working:

**✅ OAuth Token Stored:**
- Check D1 database has merchant record
- Access token should be saved

**✅ Dashboard Loads:**
- Polaris UI renders correctly
- No console errors
- Store name displays

**✅ Session Active:**
- Reload page - still authenticated
- No redirect to login

---

## 🔧 TROUBLESHOOTING

### Error: "Invalid OAuth redirect URL"

**Solution:**
1. Go to Partners Dashboard → Your App → Configuration
2. Under "Allowed redirection URL(s)", ensure you have:
   ```
   https://9066ffc8.redispute-admin.pages.dev/auth/callback
   ```
3. Click Save
4. Try installation again

---

### Error: "Invalid HMAC signature"

**Solution:**
1. Verify your Client ID and Client Secret are correct
2. Re-enter secrets using wrangler:
   ```bash
   wrangler pages secret put SHOPIFY_CLIENT_ID --project-name redispute-admin
   wrangler pages secret put SHOPIFY_CLIENT_SECRET --project-name redispute-admin
   ```

---

### Error: "Shop parameter missing or invalid"

**Solution:**
1. Ensure the URL format is correct:
   ```
   https://9066ffc8.redispute-admin.pages.dev/auth?shop=your-store.myshopify.com
   ```
2. The shop parameter must end with `.myshopify.com`

---

### Dashboard shows blank/white screen

**Solution:**
1. Check browser console for errors
2. Verify Pages deployment is working:
   ```bash
   curl -I https://9066ffc8.redispute-admin.pages.dev
   ```
3. Redeploy if needed:
   ```bash
   cd /Users/mladen.grozev/Code/redispute/apps/admin
   npm run build
   wrangler pages deploy ./build/client --project-name redispute-admin
   ```

---

## 📊 POST-INSTALLATION CHECKS

### Check D1 Database

```bash
wrangler d1 execute redispute-dev --remote --command="SELECT id, shop_domain, subscription_tier, installed_at FROM merchants;"
```

You should see your development store listed.

### Check KV Sessions

```bash
wrangler kv:key list --namespace-id=258d57d01ffd4c46a89fc2a2dd58087b
```

You should see session keys stored.

### Check API Worker Logs

```bash
wrangler tail redispute-api
```

Should show incoming requests when you use the dashboard.

---

## 🎯 NEXT STEPS (Day 2)

Once OAuth is working, you'll implement:

1. **Shopify GraphQL API Integration**
   - Fetch orders from merchant store
   - Calculate dispute rate
   - Get dispute data from Shopify Payments

2. **Webhook Registration**
   - Register for `orders/create`, `orders/paid`, `disputes/create`
   - Handle webhook events in API worker

3. **Stripe Integration**
   - Connect merchant's Stripe account
   - Fetch Stripe disputes
   - Calculate combined dispute rate

4. **PayPal Integration**
   - Connect PayPal business account
   - Fetch PayPal disputes

5. **Klarna Email Parser**
   - Set up email forwarding
   - Parse Klarna dispute notifications

---

## 📝 CREDENTIALS CHECKLIST

Make sure you have these secrets configured:

### Admin Dashboard (Pages)
- [x] SHOPIFY_CLIENT_ID
- [x] SHOPIFY_CLIENT_SECRET

### API Worker
- [x] SHOPIFY_CLIENT_ID
- [x] SHOPIFY_CLIENT_SECRET
- [x] STRIPE_SECRET_KEY
- [x] STRIPE_WEBHOOK_SECRET
- [x] PAYPAL_CLIENT_ID
- [x] PAYPAL_CLIENT_SECRET
- [x] OPENAI_API_KEY

---

## 🚨 IMPORTANT NOTES

### For Production Deployment

When ready to submit to App Store:

1. **Get Custom Domain**
   - Register: `app.preventflow.com` or `admin.redispute.com`
   - Update all URLs in Shopify Partner Dashboard
   - Update secrets with new domain

2. **Update OAuth URLs**
   - Change from Pages preview URL to custom domain
   - Re-test OAuth flow

3. **Enable Production Billing**
   - Implement Shopify Billing API (Day 5)
   - Test subscription charges on development store

4. **Submit for Review**
   - Complete app listing
   - Add screenshots (8 required)
   - Record demo video (2-3 minutes)
   - Write app description
   - Apply for "Built for Shopify" badge

---

## 📞 SUPPORT

If you encounter issues during setup:

1. Check Cloudflare Workers logs: `wrangler tail redispute-api`
2. Check Pages deployment logs in Cloudflare Dashboard
3. Review Shopify Partner Dashboard → App → API requests
4. Check browser console for frontend errors

---

**Status**: Ready for registration
**Last Updated**: 2026-01-13
**Next Review**: After OAuth testing
