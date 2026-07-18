import { json, badRequest, unauthorized, serverError, requireAdmin } from "../_utils.js";

export async function onRequestGet({ request, env }) {
  if (!requireAdmin(request, env)) return unauthorized();
  try {
    const { results } = await env.DB.prepare(
      `SELECT v.id, v.frame_color, v.stock_qty, v.price_cents, p.name, p.location
       FROM variants v JOIN products p ON p.id = v.product_id
       ORDER BY p.name, v.frame_color`
    ).all();
    return json({ variants: results });
  } catch (err) {
    return serverError(err.message);
  }
}

export async function onRequestPost({ request, env }) {
  if (!requireAdmin(request, env)) return unauthorized();
  try {
    const { variantId, stockQty } = await request.json();
    if (!variantId || stockQty === undefined || stockQty < 0) {
      return badRequest("variantId and a non-negative stockQty are required");
    }
    await env.DB.prepare(`UPDATE variants SET stock_qty = ? WHERE id = ?`)
      .bind(stockQty, variantId)
      .run();
    return json({ ok: true });
  } catch (err) {
    return serverError(err.message);
  }
}
