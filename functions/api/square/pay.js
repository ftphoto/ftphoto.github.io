import {
  json,
  badRequest,
  serverError,
  getVariant,
  decrementStock,
  recordOrder,
  newId,
} from "../_utils.js";

function squareBase(env) {
  return env.SQUARE_ENV === "production"
    ? "https://connect.squareup.com"
    : "https://connect.squareupsandbox.com";
}

export async function onRequestPost({ request, env }) {
  try {
    const { sourceId, variantId, qty, buyer } = await request.json();
    if (!sourceId || !variantId || !qty) return badRequest("Missing payment details");

    const variant = await getVariant(env.DB, variantId);
    if (!variant) return badRequest("Unknown product");
    if (variant.stock_qty < qty) return badRequest("Not enough stock available");

    const amountCents = variant.price_cents * qty;
    const idempotencyKey = newId("pay"); // guarantees a retry never double-charges

    const res = await fetch(`${squareBase(env)}/v2/payments`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${env.SQUARE_ACCESS_TOKEN}`,
        "Content-Type": "application/json",
        "Square-Version": "2024-10-17",
      },
      body: JSON.stringify({
        source_id: sourceId,
        idempotency_key: idempotencyKey,
        location_id: env.SQUARE_LOCATION_ID,
        amount_money: { amount: amountCents, currency: "USD" },
        note: `${variant.name} — ${variant.size_label} — ${variant.frame_color} frame`,
      }),
    });

    const payment = await res.json();
    const status = payment?.payment?.status;

    if (!res.ok || status !== "COMPLETED") {
      return serverError(payment?.errors?.[0]?.detail || "Square payment failed");
    }

    const reserved = await decrementStock(env.DB, variantId, qty);

    await recordOrder(env.DB, {
      id: newId("order"),
      variantId,
      qty,
      buyerName: buyer?.name,
      buyerEmail: buyer?.email,
      shippingAddress: buyer?.address,
      provider: "square",
      paymentRef: payment.payment.id,
      amountCents,
      status: reserved ? "paid" : "paid_oversold",
    });

    return json({ status: "paid", oversold: !reserved });
  } catch (err) {
    return serverError(err.message);
  }
}
