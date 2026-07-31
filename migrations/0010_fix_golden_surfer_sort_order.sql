-- Fix migration 0008: it targeted id 'golden_surfer' (underscore) for the
-- sort_order update, but the real product id is 'golden-surfer' (hyphen),
-- so that UPDATE silently matched zero rows. The Climb's own sort_order
-- was still computed correctly and is unaffected by this fix.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0010_fix_golden_surfer_sort_order.sql

UPDATE products
SET sort_order = (SELECT COALESCE(MAX(sort_order), 0) - 2 FROM products WHERE id NOT IN ('the-climb-portugal', 'golden-surfer'))
WHERE id = 'golden-surfer';
