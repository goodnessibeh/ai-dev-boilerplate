---
name: stripe-integration
description: Integrate Stripe payment processing into web applications. Use when working with payment flows, subscriptions, checkout sessions, webhooks, billing, invoicing, or any payment-related functionality in Stripe.
---

# Stripe Integration

This skill provides guidance for integrating Stripe payments into web applications.

## Quick Start

### Installation

```bash
# Node.js
npm install stripe @stripe/stripe-js

# Python
pip install stripe
```

### Initialize Stripe

```javascript
// Node.js (server-side)
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);

// Client-side
import { loadStripe } from '@stripe/stripe-js';
const stripe = await loadStripe(process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY);
```

```python
# Python
import stripe
stripe.api_key = os.environ['STRIPE_SECRET_KEY']
```

## Core Payment Flows

### 1. One-time Payments (Checkout Session)

Create a checkout session for one-time purchases:

```javascript
const session = await stripe.checkout.sessions.create({
  payment_method_types: ['card'],
  line_items: [{
    price_data: {
      currency: 'usd',
      product_data: { name: 'Product Name' },
      unit_amount: 2000, // $20.00 in cents
    },
    quantity: 1,
  }],
  mode: 'payment',
  success_url: `${BASE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${BASE_URL}/cancel`,
});
```

### 2. Subscriptions

Create subscription checkout:

```javascript
const session = await stripe.checkout.sessions.create({
  customer: customerId,
  payment_method_types: ['card'],
  line_items: [{
    price: 'price_123', // Price ID from Dashboard
  }],
  mode: 'subscription',
  success_url: `${BASE_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${BASE_URL}/cancel`,
});
```

### 3. Customer Portal

Create a billing portal session:

```javascript
const portalSession = await stripe.billingPortal.sessions.create({
  customer: customerId,
  return_url: `${BASE_URL}/account`,
});
```

## Webhooks

### Setup

```javascript
// Express webhook handler
app.post('/webhook', express.raw({type: 'application/json'}), (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;
  
  try {
    event = stripe.webhooks.constructEvent(req.body, sig, endpointSecret);
  } catch (err) {
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }
  
  // Handle events
  switch (event.type) {
    case 'checkout.session.completed':
      handleCheckoutComplete(event.data.object);
      break;
    case 'invoice.paid':
      handleInvoicePaid(event.data.object);
      break;
    case 'customer.subscription.deleted':
      handleSubscriptionCanceled(event.data.object);
      break;
  }
  
  res.json({received: true});
});
```

### Important Webhook Events

- `checkout.session.completed` - Payment succeeded
- `invoice.paid` - Subscription invoice paid
- `invoice.payment_failed` - Payment failed
- `customer.subscription.updated` - Subscription changed
- `customer.subscription.deleted` - Subscription canceled

## Security Best Practices

1. **Never expose secret keys client-side**
   - Use publishable keys (`pk_`) in frontend
   - Keep secret keys (`sk_`) server-side only

2. **Verify webhooks**
   - Always verify webhook signatures
   - Use the webhook signing secret

3. **Idempotency**
   - Use idempotency keys for critical operations:
   ```javascript
   await stripe.paymentIntents.create({...}, {
     idempotencyKey: req.headers['idempotency-key']
   });
   ```

4. **PCI Compliance**
   - Use Stripe Elements or Checkout for card input
   - Never send raw card data to your server

## Common Patterns

### Create Customer on Signup

```javascript
const customer = await stripe.customers.create({
  email: user.email,
  metadata: { userId: user.id }
});
```

### Update Subscription

```javascript
await stripe.subscriptions.update(subscriptionId, {
  items: [{
    id: itemId,
    price: newPriceId,
  }],
  proration_behavior: 'create_prorations',
});
```

### Refund Payment

```javascript
await stripe.refunds.create({
  payment_intent: paymentIntentId,
  amount: 1000, // Partial refund (optional)
});
```

## Testing

Use test card numbers:
- `4242 4242 4242 4242` - Successful payment
- `4000 0000 0000 0002` - Card declined
- `4000 0000 0000 3220` - 3D Secure required

Set test API keys via environment:
```bash
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

## Error Handling

```javascript
try {
  const paymentIntent = await stripe.paymentIntents.create({...});
} catch (error) {
  if (error.type === 'StripeCardError') {
    // Card was declined
    console.log(error.decline_code);
  } else if (error.type === 'StripeInvalidRequestError') {
    // Invalid parameters
    console.log(error.message);
  }
}
```

## Resources

- [Stripe Docs](https://stripe.com/docs)
- [API Reference](https://stripe.com/docs/api)
- [Testing](https://stripe.com/docs/testing)
