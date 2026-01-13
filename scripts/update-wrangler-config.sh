#!/bin/bash

# Update wrangler.toml files with Cloudflare resource IDs

set -e

echo "🔧 Updating wrangler.toml files with resource IDs..."
echo ""

# Check if config file exists
if [ ! -f .cloudflare-config ]; then
    echo "❌ .cloudflare-config not found"
    echo "Run ./scripts/setup-cloudflare.sh first"
    exit 1
fi

# Load configuration
source .cloudflare-config

echo "Using configuration:"
echo "  D1_DATABASE_ID: $D1_DATABASE_ID"
echo "  KV_SESSIONS_ID: $KV_SESSIONS_ID"
echo "  KV_CACHE_ID: $KV_CACHE_ID"
echo "  KV_WEBHOOK_LOG_ID: $KV_WEBHOOK_LOG_ID"
echo ""

# Update API worker
echo "Updating workers/api/wrangler.toml..."
sed -i.bak "s/database_id = \"\"/database_id = \"$D1_DATABASE_ID\"/" workers/api/wrangler.toml
sed -i.bak "0,/id = \"\"/s//id = \"$KV_SESSIONS_ID\"/" workers/api/wrangler.toml
sed -i.bak "0,/id = \"\"/s//id = \"$KV_CACHE_ID\"/" workers/api/wrangler.toml

# Update webhooks worker
echo "Updating workers/webhooks/wrangler.toml..."
sed -i.bak "s/database_id = \"\"/database_id = \"$D1_DATABASE_ID\"/" workers/webhooks/wrangler.toml
sed -i.bak "0,/id = \"\"/s//id = \"$KV_WEBHOOK_LOG_ID\"/" workers/webhooks/wrangler.toml

# Update email-parser worker
echo "Updating workers/email-parser/wrangler.toml..."
sed -i.bak "s/database_id = \"\"/database_id = \"$D1_DATABASE_ID\"/" workers/email-parser/wrangler.toml

# Update scheduled worker
echo "Updating workers/scheduled/wrangler.toml..."
sed -i.bak "s/database_id = \"\"/database_id = \"$D1_DATABASE_ID\"/" workers/scheduled/wrangler.toml
sed -i.bak "0,/id = \"\"/s//id = \"$KV_CACHE_ID\"/" workers/scheduled/wrangler.toml

# Update admin app
echo "Updating apps/admin/wrangler.toml..."
sed -i.bak "s/database_id = \"\"/database_id = \"$D1_DATABASE_ID\"/" apps/admin/wrangler.toml
sed -i.bak "0,/id = \"\"/s//id = \"$KV_SESSIONS_ID\"/" apps/admin/wrangler.toml

# Clean up backup files
find . -name "*.bak" -delete

echo ""
echo "✓ All wrangler.toml files updated!"
echo ""
echo "Next: Set secrets before deploying"
