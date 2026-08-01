// Preserves any existing links/bookmarks to the old ?id= URL pattern by
// 301-redirecting to the new crawlable /prints/{id} route. Falls through
// to the static product.html asset when there's no id to redirect on.

export async function onRequestGet({ request, env }) {
  const url = new URL(request.url);
  const id = url.searchParams.get("id");

  if (id) {
    return Response.redirect(`${url.origin}/prints/${encodeURIComponent(id)}`, 301);
  }

  return env.ASSETS.fetch(request);
}
