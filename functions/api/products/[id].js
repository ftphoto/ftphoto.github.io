import { json, serverError } from "../_utils.js";

export async function onRequestGet({ env, params }) {
  try {
    const product = await env.DB.prepare(
      `SELECT id, name, location, image, description, featured_badge
       FROM products WHERE id = ? AND active = 1`
    )
      .bind(params.id)
      .first();

    if (!product) return json({ error: "Not found" }, { status: 404 });

    const { results: variants } = await env.DB.prepare(
      `SELECT id, size_label, frame_color, price_cents, stock_qty
       FROM variants WHERE product_id = ? ORDER BY size_label ASC, frame_color ASC`
    )
      .bind(params.id)
      .all();

    return json({ ...product, variants });
  } catch (err) {
    return serverError(err.message);
  }
}
