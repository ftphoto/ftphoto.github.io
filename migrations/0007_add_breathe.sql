-- Add "Breathe" as a new product.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0007_add_breathe.sql

INSERT INTO products (id, name, location, image, description) VALUES
('breathe-australia', 'Breathe', 'Australia', 'images/australia_4.jpg', 'Framed by coastal scrub and bare branches, a sweeping beach unfolds below in pale sand and gentle surf. A single figure walks the shoreline, unhurried. From up here, the world looks exactly as simple as we sometimes need it to be.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('breathe-australia-small-whitewashed',   'breathe-australia', 'small',  'whitewashed',  24900, 10),
('breathe-australia-small-black-walnut',  'breathe-australia', 'small',  'black-walnut', 24900, 10),
('breathe-australia-small-cherry',        'breathe-australia', 'small',  'cherry',       24900, 10),
('breathe-australia-medium-whitewashed',  'breathe-australia', 'medium', 'whitewashed',  34900, 10),
('breathe-australia-medium-black-walnut', 'breathe-australia', 'medium', 'black-walnut', 34900, 10),
('breathe-australia-medium-cherry',       'breathe-australia', 'medium', 'cherry',       34900, 10);
