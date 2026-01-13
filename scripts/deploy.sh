#!/bin/bash

# Redispute Deployment Script
# Deploys all workers and the admin app to Cloudflare

set -e

echo "🚀 Redispute - Deployment"
echo "========================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check if wrangler is authenticated
if ! wrangler whoami &> /dev/null; then
    echo -e "${RED}❌ Not logged in to Cloudflare${NC}"
    echo "Run: wrangler login"
    exit 1
fi

echo -e "${GREEN}✓${NC} Authenticated with Cloudflare"
echo ""

# Check if configuration exists
if [ ! -f .cloudflare-config ]; then
    echo -e "${YELLOW}⚠ .cloudflare-config not found${NC}"
    echo "Run: ./scripts/setup-cloudflare.sh first"
    exit 1
fi

echo "================================"
echo "Step 1: Building Packages"
echo "================================"
echo ""

echo "Running type checks..."
pnpm run type-check || true
echo ""

echo "Running linter..."
pnpm run lint || true
echo ""

echo "================================"
echo "Step 2: Deploying Workers"
echo "================================"
echo ""

# Deploy API Worker
echo -e "${BLUE}Deploying API Worker...${NC}"
cd workers/api
wrangler deploy
cd ../..
echo -e "${GREEN}✓${NC} API Worker deployed"
echo ""

# Deploy Webhooks Worker
echo -e "${BLUE}Deploying Webhooks Worker...${NC}"
cd workers/webhooks
wrangler deploy
cd ../..
echo -e "${GREEN}✓${NC} Webhooks Worker deployed"
echo ""

# Deploy Email Parser Worker
echo -e "${BLUE}Deploying Email Parser Worker...${NC}"
cd workers/email-parser
wrangler deploy
cd ../..
echo -e "${GREEN}✓${NC} Email Parser Worker deployed"
echo ""

# Deploy Scheduled Worker
echo -e "${BLUE}Deploying Scheduled Worker...${NC}"
cd workers/scheduled
wrangler deploy
cd ../..
echo -e "${GREEN}✓${NC} Scheduled Worker deployed"
echo ""

echo "================================"
echo "Step 3: Deploying Admin App"
echo "================================"
echo ""

# Build admin app
echo "Building Remix admin app..."
cd apps/admin
pnpm run build
echo -e "${GREEN}✓${NC} Admin app built"
echo ""

# Deploy to Cloudflare Pages
echo -e "${BLUE}Deploying to Cloudflare Pages...${NC}"
wrangler pages deploy ./build/client --project-name=redispute-admin
cd ../..
echo -e "${GREEN}✓${NC} Admin app deployed"
echo ""

echo "================================"
echo "✅ Deployment Complete!"
echo "================================"
echo ""

# Get deployment URLs
API_URL=$(cd workers/api && wrangler deployments list --name=redispute-api-dev 2>/dev/null | head -1 || echo "Check Cloudflare dashboard")
ADMIN_URL="https://redispute-admin.pages.dev"

echo "📍 Deployment URLs:"
echo ""
echo "   Admin Dashboard: ${GREEN}$ADMIN_URL${NC}"
echo "   API Worker:      ${GREEN}$API_URL${NC}"
echo ""
echo "🔐 Next Steps:"
echo ""
echo "1. Update Shopify Partner app URLs:"
echo "   - App URL: $ADMIN_URL"
echo "   - Redirect URL: $ADMIN_URL/auth/callback"
echo ""
echo "2. Set production secrets:"
echo "   cd workers/api"
echo "   wrangler secret put SHOPIFY_CLIENT_ID"
echo "   wrangler secret put SHOPIFY_CLIENT_SECRET"
echo "   wrangler secret put STRIPE_SECRET_KEY"
echo "   wrangler secret put OPENAI_API_KEY"
echo ""
echo "3. Test OAuth flow:"
echo "   $ADMIN_URL/auth?shop=your-store.myshopify.com"
echo ""
echo "🎉 Happy deploying!"
