// Shared helpers used across every /api/* function.
// Cloudflare Pages Functions auto-loads any file, but files starting with
// "_" are not treated as routes — this is a plain module, safe to import.

export function json(data, init = {}) {
  return new Response(JSON.stringify(data), {
    ...init,
    headers: {
      "content-type": "application/json",
      "access-control-allow-origin": "*", // same-site in production; loosen only if needed
      ...(init.headers || {}),
    },
  });
}

export function badRequest(message) {
  return json({ error: message }, { status: 400 });
}

export function unauthorized(message = "Unauthorized") {
  return json({ error: message }, { status: 401 });
}

export function serverError(message = "Something went wrong") {
  return json({ error: message }, { status: 500 });
}

// SECURITY NOTE: never trust a price sent from the browser. Every checkout
// route looks the variant up by id and reads price_cents + stock_qty from
// D1 itself, so a tampered client request can't change what gets charged.
export async function getVariant(db, variantId) {
  return db
    .prepare(
      `SELECT v.id, v.product_id, v.frame_color, v.size_label, v.price_cents, v.stock_qty,
              p.name, p.location, p.image
       FROM variants v JOIN products p ON p.id = v.product_id
       WHERE v.id = ?`
    )
    .bind(variantId)
    .first();
}

export async function decrementStock(db, variantId, qty) {
  // Conditional UPDATE prevents overselling if two buyers check out at once:
  // the row only changes if enough stock is still there.
  const result = await db
    .prepare(
      `UPDATE variants SET stock_qty = stock_qty - ?
       WHERE id = ? AND stock_qty >= ?`
    )
    .bind(qty, variantId, qty)
    .run();
  return result.meta.changes > 0; // true = stock was actually reserved
}

export async function recordOrder(db, order) {
  await db
    .prepare(
      `INSERT INTO orders
        (id, variant_id, qty, buyer_name, buyer_email, shipping_address,
         payment_provider, payment_ref, amount_cents, status)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
    )
    .bind(
      order.id,
      order.variantId,
      order.qty,
      order.buyerName || null,
      order.buyerEmail || null,
      order.shippingAddress ? JSON.stringify(order.shippingAddress) : null,
      order.provider,
      order.paymentRef || null,
      order.amountCents,
      order.status
    )
    .run();
}

export function requireAdmin(request, env) {
  const auth = request.headers.get("authorization") || "";
  const token = auth.replace(/^Bearer\s+/i, "");
  return token && token === env.ADMIN_PASSWORD;
}

export function newId(prefix) {
  return `${prefix}_${crypto.randomUUID()}`;
}
