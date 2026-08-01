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

  const { results: related } = await env.DB.prepare(
    `SELECT id, name, image, location FROM products
     WHERE active = 1 AND id != ?
     ORDER BY (location = ?) DESC, sort_order DESC, name ASC
     LIMIT 4`
  )
    .bind(params.slug, product.location)
    .all();

  let relatedVariantsByProduct = {};
  if (related.length) {
    const placeholders = related.map(() => "?").join(",");
    const { results: relatedVariants } = await env.DB.prepare(
      `SELECT product_id, size_label, frame_color, stock_qty FROM variants
       WHERE product_id IN (${placeholders})`
    )
      .bind(...related.map((r) => r.id))
      .all();
    for (const v of relatedVariants) {
      (relatedVariantsByProduct[v.product_id] ||= []).push(v);
    }
  }

  // Same "prefer Black Walnut, Small, in stock" pick shop.html's grid uses,
  // so a print's related-prints thumbnail matches its shop card exactly.
  function pickThumbVariant(productId) {
    const vs = relatedVariantsByProduct[productId] || [];
    const inStock = vs.filter((v) => v.stock_qty > 0);
    return (
      inStock.find((v) => v.size_label === "small" && v.frame_color === "black-walnut") ||
      inStock[0] ||
      vs[0] ||
      null
    );
  }

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

  html = html.replace(
    '<span class="crumb-current" id="pd-breadcrumb-current"></span>',
    `<span class="crumb-current" id="pd-breadcrumb-current">${escapeHtml(product.name)}</span>`
  );

  const relatedHtml = related.length
    ? `<div class="section-label">more prints</div>\n<div class="related-grid">\n` +
      related
        .map((r) => {
          const thumb = pickThumbVariant(r.id);
          const size = thumb ? thumb.size_label : "small";
          const frameColor = thumb ? thumb.frame_color : "black-walnut";
          return (
            `<a class="related-item" href="/prints/${encodeURIComponent(r.id)}">` +
            `<div class="frame-card">` +
            `<div class="frame-size size-${escapeHtml(size)} orient-portrait">` +
            `<div class="frame-outer ${escapeHtml(frameColor)}">` +
            `<div class="frame-mat">` +
            `<div class="frame-window">` +
            `<img src="/${escapeHtml(r.image)}" alt="${escapeHtml(r.name)} — fine art print, ${escapeHtml(r.location)}" loading="lazy">` +
            `</div></div></div></div></div>` +
            `<span>${escapeHtml(r.name)}</span>` +
            `</a>`
          );
        })
        .join("\n") +
      `\n</div>`
    : "";
  html = html.replace(
    '<div class="related-prints" id="related-prints"></div>',
    `<div class="related-prints" id="related-prints">${relatedHtml}</div>`
  );

  const breadcrumbJsonLd = {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    itemListElement: [
      { "@type": "ListItem", position: 1, name: "Home", item: `${SITE_URL}/` },
      { "@type": "ListItem", position: 2, name: "Shop", item: `${SITE_URL}/shop.html` },
      { "@type": "ListItem", position: 3, name: product.name, item: canonicalUrl },
    ],
  };

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
    `<script type="application/ld+json">${JSON.stringify(jsonLd)}</script>\n` +
    `<script type="application/ld+json">${JSON.stringify(breadcrumbJsonLd)}</script>\n`;

  html = html.replace("</head>", `${extraHead}</head>`);

  return new Response(html, {
    headers: {
      "content-type": "text/html;charset=UTF-8",
      "cache-control": "public, max-age=60, s-maxage=300",
    },
  });
}
