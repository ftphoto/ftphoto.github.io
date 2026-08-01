// Server-rendered product page: /prints/{product-id}
//
// Fetches product.html as a static asset and rewrites both the <head>
// tags (title, meta description, OG, canonical, Product JSON-LD) and the
// visible body content (image, name, location, description) with real
// values before the response ever reaches the browser. Everything else
// on the page (price, size/frame selection, checkout) stays client-
// rendered — that's interactive commerce state, not indexable content.

const SITE_URL = "https://fallingtidephoto.com";

function escapeHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function replaceMetaContent(html, id, content) {
  const pattern = new RegExp(`(id="${id}"[^>]*content=")[^"]*(")`);
  return html.replace(pattern, `$1${escapeHtml(content)}$2`);
}

function availability(variant) {
  return variant.stock_qty > 0
    ? "https://schema.org/InStock"
    : "https://schema.org/OutOfStock";
}

export async function onRequestGet({ request, env, params }) {
  const product = await env.DB.prepare(
    `SELECT id, name, location, image, description, featured_badge
     FROM products WHERE id = ? AND active = 1`
  )
    .bind(params.slug)
    .first();

  if (!product) {
    return new Response(
      `<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8">` +
        `<title>Print not found | Falling Tide Photo</title>` +
        `<meta name="robots" content="noindex"></head>` +
        `<body><p>That print isn't available. <a href="/shop.html">Browse the shop</a>.</p></body></html>`,
      { status: 404, headers: { "content-type": "text/html;charset=UTF-8" } }
    );
  }

  const { results: variants } = await env.DB.prepare(
    `SELECT id, size_label, frame_color, price_cents, stock_qty
     FROM variants WHERE product_id = ? ORDER BY size_label ASC, frame_color ASC`
  )
    .bind(params.slug)
    .all();

  const templateRes = await env.ASSETS.fetch(new URL("/product.html", request.url));
  let html = await templateRes.text();

  const canonicalUrl = `${SITE_URL}/prints/${encodeURIComponent(product.id)}`;
  const imageUrl = new URL(product.image, `${SITE_URL}/`).href;

  const seoTitle = `${product.name} — Fine Art Print, ${product.location} | Falling Tide Photo`;
  const seoDescription = product.description
    ? `${product.description} Archival fine art print, framed and matted — ${product.location}.`
    : `Fine art print from ${product.location}, archival printed and framed — Falling Tide Photo.`;

  html = html.replace(/<title>[^<]*<\/title>/, `<title>${escapeHtml(seoTitle)}</title>`);
  html = replaceMetaContent(html, "meta-description", seoDescription);
  html = replaceMetaContent(html, "og-title", seoTitle);
  html = replaceMetaContent(html, "og-description", seoDescription);
  html = replaceMetaContent(html, "og-image", imageUrl);
  html = replaceMetaContent(html, "og-url", canonicalUrl);

  // Visible body content — root-relative image path since this route sits
  // one segment deeper than where product.html normally resolves "images/...".
  const imageAlt = `${product.name} — fine art print, ${product.location}`;
  html = html.replace(
    '<img id="pd-image" src="" alt="">',
    `<img id="pd-image" src="/${escapeHtml(product.image)}" alt="${escapeHtml(imageAlt)}">`
  );
  html = html.replace(
    '<h1 class="product-name" id="pd-name"></h1>',
    `<h1 class="product-name" id="pd-name">${escapeHtml(product.name)}</h1>`
  );
  html = html.replace(
    '<div class="product-location" id="pd-location"></div>',
    `<div class="product-location" id="pd-location">${escapeHtml(product.location)}</div>`
  );
  html = html.replace(
    '<div class="product-description" id="pd-description"></div>',
    `<div class="product-description" id="pd-description">${escapeHtml(product.description || "")}</div>`
  );
  if (product.featured_badge) {
    html = html.replace(
      '<div class="featured-banner" id="pd-badge" style="display:none;"></div>',
      `<div class="featured-banner" id="pd-badge">${escapeHtml(product.featured_badge)}</div>`
    );
  }

  const jsonLd = {
    "@context": "https://schema.org",
    "@type": "Product",
    name: product.name,
    description: seoDescription,
    image: imageUrl,
    url: canonicalUrl,
    ...(product.featured_badge ? { award: product.featured_badge } : {}),
    offers: variants.map((v) => ({
      "@type": "Offer",
      sku: v.id,
      url: canonicalUrl,
      priceCurrency: "USD",
      price: (v.price_cents / 100).toFixed(2),
      availability: availability(v),
      itemCondition: "https://schema.org/NewCondition",
    })),
  };

  const extraHead =
    `<link rel="canonical" href="${canonicalUrl}">\n` +
    `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>\n`;

  html = html.replace("</head>", `${extraHead}</head>`);

  return new Response(html, {
    headers: {
      "content-type": "text/html;charset=UTF-8",
      "cache-control": "public, max-age=60, s-maxage=300",
    },
  });
}
