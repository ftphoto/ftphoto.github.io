-- Adds updated_at to products so the sitemap can report an honest <lastmod>.
-- D1 doesn't allow a non-constant default (e.g. date('now')) directly on
-- ALTER TABLE ADD COLUMN, so the column is added plain and backfilled with
-- an explicit UPDATE instead. Two triggers keep it current from here on —
-- one on INSERT, one on UPDATE — so later migrations (and any admin edits
-- to products) don't have to remember to set it by hand. A bare
-- `UPDATE products SET name = ...` or `INSERT INTO products (...)` is
-- enough; the triggers do the rest. An INSERT/UPDATE that sets updated_at
-- itself is left alone (WHEN guards below).
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0015_add_updated_at_to_products.sql

ALTER TABLE products ADD COLUMN updated_at TEXT;

UPDATE products SET updated_at = date('now') WHERE updated_at IS NULL;

DROP TRIGGER IF EXISTS products_updated_at_on_insert;

CREATE TRIGGER products_updated_at_on_insert
AFTER INSERT ON products
FOR EACH ROW
WHEN NEW.updated_at IS NULL
BEGIN
  UPDATE products SET updated_at = date('now') WHERE id = NEW.id;
END;

DROP TRIGGER IF EXISTS products_updated_at_on_update;

CREATE TRIGGER products_updated_at_on_update
AFTER UPDATE ON products
FOR EACH ROW
WHEN NEW.updated_at IS OLD.updated_at
BEGIN
  UPDATE products SET updated_at = date('now') WHERE id = NEW.id;
END;
