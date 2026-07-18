import { json, badRequest, serverError, getVariant } from "../_utils.js";
import { paypalBase, getPaypalAccessToken } from "./_paypal.js";

export async function onRequestPost({ request, env }) {
  try {
    const { variantId, qty } = await request.json();
    if (!variantId || !qty || qty < 1) return badRequest("variantId and qty are required");

    const variant = await getVariant(env.DB, variantId);
    if (!variant) return badRequest("Unknown product");
    if (variant.stock_qty < qty) return badRequest("Not enough stock available");

    const amount = ((variant.price_cents * qty) / 100).toFixed(2);
    const accessToken = await getPaypalAccessToken(env);

    const res = await fetch(`${paypalBase(env)}/v2/checkout/orders`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        intent: "CAPTURE",
        purchase_units: [
          {
            reference_id: variantId,
            description: `${variant.name} — ${variant.frame_color} frame`,
            amount: { currency_code: "USD", value: amount },
          },
        ],
      }),
    });

    if (!res.ok) throw new Error(`PayPal order create failed: ${await res.text()}`);
    const order = await res.json();

    return json({ id: order.id });
  } catch (err) {
    return serverError(err.message);
  }
}
