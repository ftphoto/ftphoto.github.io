import {
  json,
  badRequest,
  serverError,
  getVariant,
  decrementStock,
  recordOrder,
  newId,
} from "../_utils.js";
import { paypalBase, getPaypalAccessToken } from "./_paypal.js";

export async function onRequestPost({ request, env }) {
  try {
    const { orderId, variantId, qty } = await request.json();
    if (!orderId || !variantId || !qty) return badRequest("Missing order details");

    const variant = await getVariant(env.DB, variantId);
    if (!variant) return badRequest("Unknown product");

    const accessToken = await getPaypalAccessToken(env);
    const res = await fetch(
      `${paypalBase(env)}/v2/checkout/orders/${orderId}/capture`,
      {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
      }
    );

    const capture = await res.json();
    const captureStatus = capture?.purchase_units?.[0]?.payments?.captures?.[0]?.status;

    if (!res.ok || captureStatus !== "COMPLETED") {
      return serverError("PayPal payment was not completed");
    }

    // Buyer name, email, and shipping address come straight from PayPal's
    // own response — never from the browser — since PayPal collected them
    // during their checkout flow (GET_FROM_FILE shipping preference).
    const payer = capture?.payer || {};
    const buyerName = payer.name
      ? `${payer.name.given_name || ""} ${payer.name.surname || ""}`.trim()
      : null;
    const buyerEmail = payer.email_address || null;
    const shipping = capture?.purchase_units?.[0]?.shipping;
    const shippingAddress = shipping
      ? { recipient: shipping.name?.full_name, ...shipping.address }
      : null;

    // Only decrement stock AFTER payment is confirmed successful.
    const reserved = await decrementStock(env.DB, variantId, qty);

    await recordOrder(env.DB, {
      id: newId("order"),
      variantId,
      qty,
      buyerName,
      buyerEmail,
      shippingAddress,
      provider: "paypal",
      paymentRef: orderId,
      amountCents: variant.price_cents * qty,
      status: reserved ? "paid" : "paid_oversold", // flag for manual follow-up if stock ran out mid-checkout
    });

    return json({ status: "paid", oversold: !reserved });
  } catch (err) {
    return serverError(err.message);
  }
}
