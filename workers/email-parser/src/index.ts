/**
 * Cloudflare Email Workers - Klarna Dispute Email Parser
 *
 * This worker receives forwarded Klarna dispute notification emails,
 * parses them to extract dispute details, and stores them in the database.
 *
 * UNIQUE DIFFERENTIATOR: First platform to handle Klarna disputes automatically.
 */

export interface Env {
  DB: D1Database;
  OPENAI_API_KEY: string;
  ENVIRONMENT: string;
  FORWARDING_EMAIL: string;
}

/**
 * Email message interface
 */
interface EmailMessage {
  from: string;
  to: string;
  subject: string;
  text: string;
  html?: string;
  headers: Map<string, string>;
}

/**
 * Parsed Klarna dispute
 */
interface KlarnaDispute {
  disputeId: string;
  orderId: string;
  reason: string;
  amount: number;
  currency: string;
  deadline: string;
  customerEmail: string;
}

/**
 * Parse Klarna dispute email using regex patterns
 */
function parseKlarnaEmail(email: EmailMessage): KlarnaDispute | null {
  const text = email.text;

  // Pattern 1: Standard Klarna dispute notification
  const disputeIdMatch = text.match(/Dispute ID:?\s*([A-Z0-9-]+)/i);
  const orderIdMatch = text.match(/Order (?:ID|Number):?\s*([A-Z0-9-]+)/i);
  const amountMatch = text.match(/Amount:?\s*\$?([\d,]+\.?\d*)/);
  const deadlineMatch = text.match(/Deadline:?\s*(\d{4}-\d{2}-\d{2})/);

  // Pattern 2: Alternative format
  const altDisputeMatch = text.match(/Case\s*#:?\s*([A-Z0-9-]+)/i);
  const altOrderMatch = text.match(/Transaction:?\s*([A-Z0-9-]+)/i);

  const disputeId = disputeIdMatch?.[1] || altDisputeMatch?.[1];
  const orderId = orderIdMatch?.[1] || altOrderMatch?.[1];
  const amount = amountMatch?.[1];
  const deadline = deadlineMatch?.[1];

  if (!disputeId || !orderId) {
    console.log('Failed to parse Klarna email: Missing required fields');
    return null;
  }

  // Extract reason (common patterns)
  let reason = 'general';
  if (text.match(/not received|didn't receive/i)) {
    reason = 'product_not_received';
  } else if (text.match(/not as described|defective|damaged/i)) {
    reason = 'product_unacceptable';
  } else if (text.match(/unauthorized|didn't authorize|fraud/i)) {
    reason = 'fraudulent';
  } else if (text.match(/cancelled|cancel/i)) {
    reason = 'subscription_canceled';
  }

  return {
    disputeId,
    orderId,
    reason,
    amount: amount ? parseFloat(amount.replace(/,/g, '')) * 100 : 0, // Convert to cents
    currency: 'USD', // Default, can be improved
    deadline: deadline || new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(), // 30 days default
    customerEmail: email.from,
  };
}

/**
 * Fallback to OpenAI NLP for unusual email formats
 * (to be implemented in Day 2)
 */
async function parseWithAI(email: EmailMessage, env: Env): Promise<KlarnaDispute | null> {
  // TODO: Implement OpenAI API call
  console.log('AI parsing fallback - Coming soon');
  return null;
}

/**
 * Store parsed Klarna dispute in database
 */
async function storeKlarnaDispute(dispute: KlarnaDispute, env: Env): Promise<void> {
  // TODO: Implement database insertion
  console.log('Storing Klarna dispute:', dispute);

  // Placeholder query (to be implemented with schema)
  // await env.DB.prepare(`
  //   INSERT INTO chargebacks (processor, processor_dispute_id, order_id, reason, amount, currency, status)
  //   VALUES ('klarna', ?, ?, ?, ?, ?, 'pending')
  // `).bind(dispute.disputeId, dispute.orderId, dispute.reason, dispute.amount, dispute.currency).run();
}

/**
 * Send merchant alert
 */
async function sendMerchantAlert(dispute: KlarnaDispute): Promise<void> {
  // TODO: Implement email notification
  console.log('Sending merchant alert for Klarna dispute:', dispute.disputeId);
}

/**
 * Email handler
 */
export default {
  async email(message: EmailMessage, env: Env): Promise<void> {
    console.log('Received email to:', message.to);
    console.log('From:', message.from);
    console.log('Subject:', message.subject);

    // Check if email is from Klarna (common domains)
    const isFromKlarna =
      message.from.includes('@klarna.com') ||
      message.from.includes('@klarna.co') ||
      message.subject.toLowerCase().includes('klarna') ||
      message.subject.toLowerCase().includes('dispute');

    if (!isFromKlarna) {
      console.log('Email not from Klarna, ignoring');
      return;
    }

    // Try regex parsing first
    let dispute = parseKlarnaEmail(message);

    // Fallback to AI if regex fails
    if (!dispute) {
      console.log('Regex parsing failed, trying AI fallback');
      dispute = await parseWithAI(message, env);
    }

    if (!dispute) {
      console.error('Failed to parse Klarna email with both methods');
      return;
    }

    // Store in database
    await storeKlarnaDispute(dispute, env);

    // Send merchant alert
    await sendMerchantAlert(dispute);

    console.log('Successfully processed Klarna dispute email');
  },
};
