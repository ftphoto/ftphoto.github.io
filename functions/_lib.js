// Shared across the product-page Functions (files starting with "_" are
// not treated as routes by Cloudflare Pages, so this is a plain module).

export const SITE_URL = "https://fallingtidephoto.com";

export function slugify(str) {
  return String(str)
    .toLowerCase()
    .replace(/'/g, "")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

export function escapeHtml(str) {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

// /{country}/{print-name}, e.g. /ireland/the-keepers-post — derived from
// the print's own title, not the internal id (several ids redundantly
// suffix the country already, e.g. "keepers-post-ireland", which would
// read as /ireland/keepers-post-ireland if reused directly).
export function productPath(product) {
  return `/${slugify(product.location)}/${slugify(product.name)}`;
}

export function productUrl(product) {
  return `${SITE_URL}${productPath(product)}`;
}
