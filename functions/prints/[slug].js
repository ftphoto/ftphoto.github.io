// Old URL shape (/prints/{product-id}) — kept alive as a 301 to the
// current /{country}/{print-name} URL so nothing that already linked or
// bookmarked the old path breaks. See functions/[country]/[slug].js for
// the real page and functions/_lib.js for how the new URL is built.

import { productUrl } from "../_lib.js";

export async function onRequestGet({ env, params }) {
  const product = await env.DB.prepare(
    `SELECT name, location FROM products WHERE id = ? AND active = 1`
  )
    .bind(params.slug)
    .first();

  if (!product) {
    return new Response("Not found", { status: 404 });
  }

  return Response.redirect(productUrl(product), 301);
}
