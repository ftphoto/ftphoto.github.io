-- Pin the top four grid positions: Where the Cliffs Give Way, The
-- Climb, Golden Surfer, Great Ocean Road (in that order), leaving
-- every other product at its existing sort_order so their relative
-- order (alphabetical, since they're all tied) is unaffected.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0017_reorder_top_four_products.sql

UPDATE products SET sort_order = 4 WHERE id = 'where-the-cliffs-give-way';
UPDATE products SET sort_order = 3 WHERE id = 'the-climb-portugal';
UPDATE products SET sort_order = 2 WHERE id = 'golden-surfer';
UPDATE products SET sort_order = 1 WHERE id = 'great-ocean-road';
