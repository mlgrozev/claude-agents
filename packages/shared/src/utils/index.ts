// Shared utility functions

/**
 * Calculate dispute rate percentage
 */
export function calculateDisputeRate(disputes: number, orders: number): number {
  if (orders === 0) return 0;
  return (disputes / orders) * 100;
}

/**
 * Format currency amount
 */
export function formatCurrency(amount: number, currency: string = 'USD'): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
  }).format(amount / 100); // Amount is in cents
}

/**
 * Get risk level based on dispute rate
 */
export function getRiskLevel(
  disputeRate: number
): 'safe' | 'warning' | 'danger' {
  if (disputeRate < 0.5) return 'safe';
  if (disputeRate < 0.75) return 'warning';
  return 'danger';
}

/**
 * Calculate payment hold risk score (0-100)
 */
export function calculatePaymentHoldRisk(
  disputeRate: number,
  recentDisputes: number,
  averageOrderValue: number
): number {
  let score = 0;

  // Dispute rate factor (0-50 points)
  if (disputeRate >= 0.75) score += 50;
  else if (disputeRate >= 0.5) score += 30;
  else if (disputeRate >= 0.3) score += 15;

  // Recent disputes factor (0-30 points)
  if (recentDisputes >= 10) score += 30;
  else if (recentDisputes >= 5) score += 20;
  else if (recentDisputes >= 3) score += 10;

  // High AOV factor (0-20 points)
  if (averageOrderValue > 30000) score += 20; // >$300
  else if (averageOrderValue > 15000) score += 10; // >$150

  return Math.min(score, 100);
}

/**
 * Validate email address
 */
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

/**
 * Generate unique ID
 */
export function generateId(prefix: string = ''): string {
  const timestamp = Date.now().toString(36);
  const random = Math.random().toString(36).substring(2, 9);
  return prefix ? `${prefix}_${timestamp}${random}` : `${timestamp}${random}`;
}
