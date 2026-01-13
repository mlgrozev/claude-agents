/**
 * Main dashboard route
 */

import { json, type LoaderFunctionArgs } from '@remix-run/cloudflare';
import { useLoaderData } from '@remix-run/react';
import { Page, Layout, Card, Text, BlockStack, InlineStack, Badge } from '@shopify/polaris';
import { requireAuth } from '~/lib/shopify.server';

export async function loader({ request, context }: LoaderFunctionArgs) {
  // Require authentication
  const session = await requireAuth(request, (context.env as any).SESSIONS);

  // Fetch merchant data from database
  const merchant = await (context.env as any).DB.prepare(
    'SELECT * FROM merchants WHERE shop_domain = ?'
  )
    .bind(session.shop)
    .first();

  if (!merchant) {
    throw new Response('Merchant not found', { status: 404 });
  }

  // Fetch dispute statistics
  const stats = await (context.env as any).DB.prepare(`
    SELECT
      (SELECT COUNT(*) FROM chargebacks WHERE merchant_id = ? AND created_at > datetime('now', '-30 days')) as total_disputes,
      (SELECT COUNT(*) FROM orders WHERE merchant_id = ? AND created_at > datetime('now', '-30 days')) as total_orders,
      (SELECT COUNT(*) FROM customer_disputes WHERE merchant_id = ? AND status = 'pending') as pending_disputes
  `)
    .bind(merchant.id, merchant.id, merchant.id)
    .first();

  // Calculate dispute rate
  const disputeRate =
    stats && stats.total_orders > 0
      ? ((stats.total_disputes / stats.total_orders) * 100).toFixed(2)
      : '0.00';

  // Determine risk level
  let riskLevel: 'safe' | 'warning' | 'danger' = 'safe';
  let riskBadge: 'success' | 'warning' | 'critical' = 'success';

  if (parseFloat(disputeRate) >= 0.75) {
    riskLevel = 'danger';
    riskBadge = 'critical';
  } else if (parseFloat(disputeRate) >= 0.5) {
    riskLevel = 'warning';
    riskBadge = 'warning';
  }

  return json({
    merchant: {
      shop: merchant.shop_domain,
      tier: merchant.subscription_tier,
      disputeRate: parseFloat(disputeRate),
      paymentHoldRisk: merchant.payment_hold_risk || 0,
    },
    stats: {
      totalDisputes: stats?.total_disputes || 0,
      totalOrders: stats?.total_orders || 0,
      pendingDisputes: stats?.pending_disputes || 0,
      disputeRate,
      riskLevel,
      riskBadge,
    },
  });
}

export default function Index() {
  const { merchant, stats } = useLoaderData<typeof loader>();

  const getRiskEmoji = () => {
    if (stats.riskLevel === 'safe') return '🟢';
    if (stats.riskLevel === 'warning') return '🟡';
    return '🔴';
  };

  const getRiskLabel = () => {
    if (stats.riskLevel === 'safe') return 'SAFE';
    if (stats.riskLevel === 'warning') return 'WARNING';
    return 'DANGER';
  };

  return (
    <Page title="PreventFlow Dashboard">
      <Layout>
        <Layout.Section>
          <BlockStack gap="500">
            {/* Dispute Rate Card */}
            <Card>
              <BlockStack gap="400">
                <InlineStack align="space-between" blockAlign="center">
                  <Text as="h2" variant="headingMd">
                    Current Dispute Rate
                  </Text>
                  <Badge tone={stats.riskBadge}>
                    {getRiskEmoji()} {getRiskLabel()}
                  </Badge>
                </InlineStack>
                <Text as="p" variant="heading2xl">
                  {stats.disputeRate}%
                </Text>
                <Text as="p" variant="bodyMd" tone="subdued">
                  Target: Below 0.5% to avoid payment holds
                </Text>
              </BlockStack>
            </Card>

            {/* Stats Grid */}
            <Layout>
              <Layout.Section variant="oneThird">
                <Card>
                  <BlockStack gap="200">
                    <Text as="h3" variant="headingSm" tone="subdued">
                      Total Disputes (30 days)
                    </Text>
                    <Text as="p" variant="headingLg">
                      {stats.totalDisputes}
                    </Text>
                  </BlockStack>
                </Card>
              </Layout.Section>

              <Layout.Section variant="oneThird">
                <Card>
                  <BlockStack gap="200">
                    <Text as="h3" variant="headingSm" tone="subdued">
                      Total Orders (30 days)
                    </Text>
                    <Text as="p" variant="headingLg">
                      {stats.totalOrders}
                    </Text>
                  </BlockStack>
                </Card>
              </Layout.Section>

              <Layout.Section variant="oneThird">
                <Card>
                  <BlockStack gap="200">
                    <Text as="h3" variant="headingSm" tone="subdued">
                      Pending Disputes
                    </Text>
                    <Text as="p" variant="headingLg">
                      {stats.pendingDisputes}
                    </Text>
                  </BlockStack>
                </Card>
              </Layout.Section>
            </Layout>

            {/* Payment Hold Risk */}
            <Card>
              <BlockStack gap="400">
                <Text as="h2" variant="headingMd">
                  Payment Hold Risk Score
                </Text>
                <Text as="p" variant="heading2xl">
                  {merchant.paymentHoldRisk}/100
                </Text>
                <Text as="p" variant="bodyMd" tone="subdued">
                  {merchant.paymentHoldRisk < 60 && 'Low risk - You are in good standing'}
                  {merchant.paymentHoldRisk >= 60 &&
                    merchant.paymentHoldRisk < 80 &&
                    'Moderate risk - Monitor your dispute rate closely'}
                  {merchant.paymentHoldRisk >= 80 &&
                    'High risk - Take immediate action to prevent payment holds'}
                </Text>
              </BlockStack>
            </Card>

            {/* Subscription Info */}
            <Card>
              <BlockStack gap="200">
                <InlineStack align="space-between" blockAlign="center">
                  <Text as="h3" variant="headingMd">
                    Current Plan
                  </Text>
                  <Badge>
                    {merchant.tier.charAt(0).toUpperCase() + merchant.tier.slice(1)}
                  </Badge>
                </InlineStack>
                {merchant.tier === 'free' && (
                  <Text as="p" variant="bodyMd" tone="subdued">
                    Upgrade to Growth plan to unlock AI evidence generation and unlimited
                    disputes
                  </Text>
                )}
              </BlockStack>
            </Card>

            {/* Welcome Message */}
            <Card>
              <BlockStack gap="400">
                <Text as="h2" variant="headingMd">
                  Welcome to PreventFlow! 🎉
                </Text>
                <Text as="p" variant="bodyMd">
                  Your payment hold prevention platform is ready. We'll monitor your dispute
                  rate in real-time and help you stay below the critical 0.5% threshold.
                </Text>
                <BlockStack gap="200">
                  <Text as="p" variant="bodyMd" fontWeight="semibold">
                    Next steps:
                  </Text>
                  <ul style={{ marginLeft: '1.5rem' }}>
                    <li>
                      <Text as="span" variant="bodyMd">
                        Connect your payment processors (Stripe, PayPal)
                      </Text>
                    </li>
                    <li>
                      <Text as="span" variant="bodyMd">
                        Set up Klarna email forwarding to disputes@redispute.com
                      </Text>
                    </li>
                    <li>
                      <Text as="span" variant="bodyMd">
                        Configure auto-approval rules for customer disputes
                      </Text>
                    </li>
                  </ul>
                </BlockStack>
              </BlockStack>
            </Card>
          </BlockStack>
        </Layout.Section>
      </Layout>
    </Page>
  );
}
