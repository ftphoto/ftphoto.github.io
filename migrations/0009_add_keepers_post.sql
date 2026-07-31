-- Add "The Keeper's Post" as a new product.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0009_add_keepers_post.sql

INSERT INTO products (id, name, location, image, description) VALUES
('keepers-post-ireland', 'The Keeper''s Post', 'Ireland', 'images/ireland_4.jpg', 'A lighthouse and its cottage sit at the headland''s edge, small and certain against a pale endless sea.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('keepers-post-ireland-small-whitewashed',   'keepers-post-ireland', 'small',  'whitewashed',  24900, 10),
('keepers-post-ireland-small-black-walnut',  'keepers-post-ireland', 'small',  'black-walnut', 24900, 10),
('keepers-post-ireland-small-cherry',        'keepers-post-ireland', 'small',  'cherry',       24900, 10),
('keepers-post-ireland-medium-whitewashed',  'keepers-post-ireland', 'medium', 'whitewashed',  34900, 10),
('keepers-post-ireland-medium-black-walnut', 'keepers-post-ireland', 'medium', 'black-walnut', 34900, 10),
('keepers-post-ireland-medium-cherry',       'keepers-post-ireland', 'medium', 'cherry',       34900, 10);
