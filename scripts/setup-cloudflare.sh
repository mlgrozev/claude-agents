#!/bin/bash

# Redispute Cloudflare Setup Script
# This script sets up all Cloudflare resources needed for the MVP

set -e

echo "🚀 Redispute - Cloudflare Setup"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo -e "${RED}❌ Wrangler CLI not found${NC}"
    echo "Installing wrangler globally..."
    npm install -g wrangler
fi

echo -e "${GREEN}✓${NC} Wrangler CLI found"
echo ""

# Check authentication
echo "Checking Cloudflare authentication..."
if ! wrangler whoami &> /dev/null; then
    echo -e "${YELLOW}⚠ Not logged in to Cloudflare${NC}"
    echo "Opening browser for authentication..."
    wrangler login
else
    echo -e "${GREEN}✓${NC} Already authenticated"
fi

echo ""
echo "================================"
echo "Step 1: Creating D1 Database"
echo "================================"
echo ""

# Create D1 database (development)
echo "Creating development database..."
D1_DEV_OUTPUT=$(wrangler d1 create redispute-dev 2>&1 || true)

if echo "$D1_DEV_OUTPUT" | grep -q "already exists"; then
    echo -e "${YELLOW}⚠${NC} Database 'redispute-dev' already exists"
else
    echo -e "${GREEN}✓${NC} Created database 'redispute-dev'"
fi

# Get database ID from list (always works whether just created or already exists)
echo "Retrieving database ID..."
D1_LIST_OUTPUT=$(wrangler d1 list 2>&1)
D1_DEV_ID=$(echo "$D1_LIST_OUTPUT" | grep "redispute-dev" | head -1 | awk '{for(i=1;i<=NF;i++) if(match($i, /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/)) print $i}')

# If that doesn't work, try extracting from creation output
if [ -z "$D1_DEV_ID" ]; then
    D1_DEV_ID=$(echo "$D1_DEV_OUTPUT" | grep -oE '[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}' | head -1)
fi

echo "Development Database ID: $D1_DEV_ID"

# Validate database ID was extracted
if [ -z "$D1_DEV_ID" ]; then
    echo -e "${RED}❌ Failed to extract database ID${NC}"
    echo ""
    echo "Debug info:"
    echo "Create output: $D1_DEV_OUTPUT"
    echo ""
    echo "List output: $D1_LIST_OUTPUT"
    echo ""
    echo "Please manually run: wrangler d1 list"
    echo "And copy the database ID for 'redispute-dev'"
    exit 1
fi
echo ""

# Check if schema is already applied
SCHEMA_CHECK=$(wrangler d1 execute redispute-dev --command="SELECT name FROM sqlite_master WHERE type='table' AND name='merchants'" --remote --json 2>&1 || true)

if echo "$SCHEMA_CHECK" | grep -q "merchants"; then
    echo -e "${YELLOW}⚠${NC} Schema already applied, skipping..."
else
    # Apply schema
    echo "Applying database schema..."
    wrangler d1 execute redispute-dev --file=packages/database/schema.sql --remote
    echo -e "${GREEN}✓${NC} Schema applied"
    echo ""

    # Apply seed data
    echo "Applying seed data..."
    wrangler d1 execute redispute-dev --file=packages/database/seed.sql --remote
    echo -e "${GREEN}✓${NC} Seed data loaded"
fi
echo ""

echo "================================"
echo "Step 2: Creating KV Namespaces"
echo "================================"
echo ""

# Create KV namespaces
echo "Creating KV namespace: SESSIONS..."
KV_SESSIONS_OUTPUT=$(wrangler kv namespace create SESSIONS 2>&1 || true)
if echo "$KV_SESSIONS_OUTPUT" | grep -q "already exists"; then
    echo -e "${YELLOW}⚠${NC} KV namespace 'SESSIONS' already exists"
else
    echo -e "${GREEN}✓${NC} Created KV namespace 'SESSIONS'"
fi
# Extract ID (32 hex characters)
KV_SESSIONS_ID=$(echo "$KV_SESSIONS_OUTPUT" | grep -oE '[a-f0-9]{32}' | head -1)
if [ -z "$KV_SESSIONS_ID" ]; then
    KV_LIST=$(wrangler kv namespace list 2>&1)
    KV_SESSIONS_ID=$(echo "$KV_LIST" | grep "redispute-SESSIONS" | grep -oE '[a-f0-9]{32}' | head -1)
fi
echo "SESSIONS ID: $KV_SESSIONS_ID"
echo ""

echo "Creating KV namespace: CACHE..."
KV_CACHE_OUTPUT=$(wrangler kv namespace create CACHE 2>&1 || true)
if echo "$KV_CACHE_OUTPUT" | grep -q "already exists"; then
    echo -e "${YELLOW}⚠${NC} KV namespace 'CACHE' already exists"
else
    echo -e "${GREEN}✓${NC} Created KV namespace 'CACHE'"
fi
KV_CACHE_ID=$(echo "$KV_CACHE_OUTPUT" | grep -oE '[a-f0-9]{32}' | head -1)
if [ -z "$KV_CACHE_ID" ]; then
    KV_LIST=$(wrangler kv namespace list 2>&1)
    KV_CACHE_ID=$(echo "$KV_LIST" | grep "redispute-CACHE" | grep -oE '[a-f0-9]{32}' | head -1)
fi
echo "CACHE ID: $KV_CACHE_ID"
echo ""

echo "Creating KV namespace: WEBHOOK_LOG..."
KV_WEBHOOK_OUTPUT=$(wrangler kv namespace create WEBHOOK_LOG 2>&1 || true)
if echo "$KV_WEBHOOK_OUTPUT" | grep -q "already exists"; then
    echo -e "${YELLOW}⚠${NC} KV namespace 'WEBHOOK_LOG' already exists"
else
    echo -e "${GREEN}✓${NC} Created KV namespace 'WEBHOOK_LOG'"
fi
KV_WEBHOOK_ID=$(echo "$KV_WEBHOOK_OUTPUT" | grep -oE '[a-f0-9]{32}' | head -1)
if [ -z "$KV_WEBHOOK_ID" ]; then
    KV_LIST=$(wrangler kv namespace list 2>&1)
    KV_WEBHOOK_ID=$(echo "$KV_LIST" | grep "redispute-WEBHOOK_LOG" | grep -oE '[a-f0-9]{32}' | head -1)
fi
echo "WEBHOOK_LOG ID: $KV_WEBHOOK_ID"
echo ""

echo "================================"
echo "Step 3: Configuration Summary"
echo "================================"
echo ""

# Create configuration file
cat > .cloudflare-config << EOF
# Cloudflare Resource IDs (Auto-generated by setup-cloudflare.sh)
# Generated: $(date)

D1_DATABASE_ID=$D1_DEV_ID
KV_SESSIONS_ID=$KV_SESSIONS_ID
KV_CACHE_ID=$KV_CACHE_ID
KV_WEBHOOK_LOG_ID=$KV_WEBHOOK_ID
EOF

echo -e "${GREEN}✓${NC} Configuration saved to .cloudflare-config"
echo ""

echo "📋 Resource IDs:"
echo "   D1 Database:   $D1_DEV_ID"
echo "   KV SESSIONS:   $KV_SESSIONS_ID"
echo "   KV CACHE:      $KV_CACHE_ID"
echo "   KV WEBHOOK_LOG: $KV_WEBHOOK_ID"
echo ""

echo "================================"
echo "Step 4: Next Steps (Manual)"
echo "================================"
echo ""
echo "1. Update wrangler.toml files with the IDs above:"
echo "   - workers/api/wrangler.toml"
echo "   - workers/webhooks/wrangler.toml"
echo "   - workers/email-parser/wrangler.toml"
echo "   - workers/scheduled/wrangler.toml"
echo "   - apps/admin/wrangler.toml"
echo ""
echo "2. Set secrets (required for deployment):"
echo "   ${YELLOW}cd workers/api && wrangler secret put SHOPIFY_CLIENT_ID${NC}"
echo "   ${YELLOW}cd workers/api && wrangler secret put SHOPIFY_CLIENT_SECRET${NC}"
echo "   ${YELLOW}cd workers/api && wrangler secret put STRIPE_SECRET_KEY${NC}"
echo "   ${YELLOW}cd workers/api && wrangler secret put OPENAI_API_KEY${NC}"
echo ""
echo "3. Run deployment script:"
echo "   ${YELLOW}./scripts/deploy.sh${NC}"
echo ""
echo -e "${GREEN}✓${NC} Cloudflare setup complete!"
