import { json, serverError } from "../_utils.js";

export async function onRequestGet({ env }) {
  try {
    const { results: products } = await env.DB.prepare(
      `SELECT id, name, location, image, description, sort_order, featured_badge
       FROM products WHERE active = 1
       ORDER BY sort_order DESC, name ASC`
    ).all();

    const { results: variants } = await env.DB.prepare(
      `SELECT id, product_id, frame_color, price_cents, stock_qty
       FROM variants ORDER BY frame_color ASC`
    ).all();

    const byProduct = {};
    for (const v of variants) {
      (byProduct[v.product_id] ||= []).push(v);
    }

    const shaped = products.map((p) => ({
      ...p,
      variants: byProduct[p.id] || [],
    }));

    return json({ products: shaped });
  } catch (err) {
    return serverError(err.message);
  }
}
