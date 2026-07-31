-- Add "The Climb" (Portugal) and set grid ordering so, from the top:
-- 1st = whatever is currently highest sort_order (untouched), 2nd = The
-- Climb, 3rd = Golden Surfer (id 'golden_surfer').
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0008_add_the_climb_and_reorder.sql

INSERT INTO products (id, name, location, image, description, sort_order) VALUES
('the-climb-portugal', 'The Climb', 'Portugal', 'images/portugal8.jpg', 'Tiny figures trace a narrow path along ancient volcanic ridges, dwarfed by cliffs that drop into shadow below.',
 (SELECT COALESCE(MAX(sort_order), 0) - 1 FROM products WHERE id NOT IN ('the-climb-portugal', 'golden_surfer')));

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('the-climb-portugal-small-whitewashed',   'the-climb-portugal', 'small',  'whitewashed',  30000, 10),
('the-climb-portugal-small-black-walnut',  'the-climb-portugal', 'small',  'black-walnut', 30000, 10),
('the-climb-portugal-small-cherry',        'the-climb-portugal', 'small',  'cherry',       30000, 10),
('the-climb-portugal-medium-whitewashed',  'the-climb-portugal', 'medium', 'whitewashed',  40000, 10),
('the-climb-portugal-medium-black-walnut', 'the-climb-portugal', 'medium', 'black-walnut', 40000, 10),
('the-climb-portugal-medium-cherry',       'the-climb-portugal', 'medium', 'cherry',       40000, 10);

UPDATE products
SET sort_order = (SELECT COALESCE(MAX(sort_order), 0) - 2 FROM products WHERE id NOT IN ('the-climb-portugal', 'golden_surfer'))
WHERE id = 'golden_surfer';
