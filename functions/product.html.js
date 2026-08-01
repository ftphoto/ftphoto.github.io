// Preserves any existing links/bookmarks to the old ?id= URL pattern by
// 301-redirecting straight to the current /{country}/{print-name} route
// (not via the /prints/{id} shim, to avoid a double redirect). Falls
// through to the static product.html asset when there's no id to redirect on.

import { productUrl } from "./_lib.js";

export async function onRequestGet({ request, env }) {
  const url = new URL(request.url);
  const id = url.searchParams.get("id");

  if (id) {
    const product = await env.DB.prepare(
      `SELECT name, location FROM products WHERE id = ? AND active = 1`
    )
      .bind(id)
      .first();

    if (product) {
      return Response.redirect(productUrl(product), 301);
    }
  }

  return env.ASSETS.fetch(request);
}
