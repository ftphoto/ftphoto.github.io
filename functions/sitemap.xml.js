// Dynamic sitemap: static pages plus one <url> per active print, generated
// from D1 so it never drifts from what's actually in the catalog.

const SITE_URL = "https://fallingtidephoto.com";

const STATIC_PAGES = [
  { path: "/", priority: "1.0" },
  { path: "/shop.html", priority: "0.9" },
  { path: "/about/", priority: "0.5" },
];

function escapeXml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

function urlEntry(loc, priority, lastmod) {
  const lastmodTag = lastmod ? `\n    <lastmod>${lastmod}</lastmod>` : "";
  return `  <url>\n    <loc>${escapeXml(loc)}</loc>${lastmodTag}\n    <priority>${priority}</priority>\n  </url>`;
}

export async function onRequestGet({ env }) {
  const { results: products } = await env.DB.prepare(
    `SELECT id, updated_at FROM products WHERE active = 1`
  ).all();

  const entries = [
    ...STATIC_PAGES.map((p) => urlEntry(`${SITE_URL}${p.path}`, p.priority)),
    ...products.map((p) =>
      urlEntry(`${SITE_URL}/prints/${encodeURIComponent(p.id)}`, "0.8", p.updated_at)
    ),
  ];

  const xml =
    `<?xml version="1.0" encoding="UTF-8"?>\n` +
    `<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n` +
    entries.join("\n") +
    `\n</urlset>\n`;

  return new Response(xml, {
    headers: {
      "content-type": "application/xml;charset=UTF-8",
      "cache-control": "public, max-age=300, s-maxage=3600",
    },
  });
}
