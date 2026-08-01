-- Adds updated_at to products so the sitemap can report an honest <lastmod>.
-- Existing rows are backfilled to today. A trigger stamps updated_at on
-- every future UPDATE automatically, so later migrations (and any admin
-- edits to products) don't have to remember to set it by hand — a bare
-- `UPDATE products SET name = ...` is enough; the trigger does the rest.
-- An UPDATE that sets updated_at itself is left alone (WHEN guard below).
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0015_add_updated_at_to_products.sql

ALTER TABLE products ADD COLUMN updated_at TEXT NOT NULL DEFAULT (date('now'));

DROP TRIGGER IF EXISTS products_updated_at;

CREATE TRIGGER products_updated_at
AFTER UPDATE ON products
FOR EACH ROW
WHEN NEW.updated_at IS OLD.updated_at
BEGIN
  UPDATE products SET updated_at = date('now') WHERE id = NEW.id;
END;
