-- Add "Painted Harbor" (Denmark) and "First Light" (Australia), copy
-- and keyword targeting drawn from the SEO & Copy Strategy doc.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0018_add_painted_harbor_and_first_light.sql

INSERT INTO products (id, name, location, image, description) VALUES
('painted-harbor-denmark', 'Painted Harbor', 'Denmark', 'images/denmark_1.jpg', 'A wooden sailboat rests at anchor in Nyhavn''s calm water, its orange mast rising past a row of cream, powder-blue, and butter-yellow townhouses strung with lantern lights. Copenhagen at its most photographed — a colorful travel photography print for a wall that wants a little Scandinavian charm.'),
('first-light-australia', 'First Light', 'Australia', 'images/australia_7.jpg', 'Cape Byron''s lighthouse catches the first color of dawn, its dome glowing above a grassy headland where a white fence traces the path up from the sea. The easternmost point of mainland Australia — a lighthouse wall art print for anyone who wants their room to feel like sunrise.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('painted-harbor-denmark-small-whitewashed',   'painted-harbor-denmark', 'small',  'whitewashed',  24900, 10),
('painted-harbor-denmark-small-black-walnut',  'painted-harbor-denmark', 'small',  'black-walnut', 24900, 10),
('painted-harbor-denmark-small-cherry',        'painted-harbor-denmark', 'small',  'cherry',       24900, 10),
('painted-harbor-denmark-medium-whitewashed',  'painted-harbor-denmark', 'medium', 'whitewashed',  34900, 10),
('painted-harbor-denmark-medium-black-walnut', 'painted-harbor-denmark', 'medium', 'black-walnut', 34900, 10),
('painted-harbor-denmark-medium-cherry',       'painted-harbor-denmark', 'medium', 'cherry',       34900, 10),

('first-light-australia-small-whitewashed',    'first-light-australia', 'small',  'whitewashed',  24900, 10),
('first-light-australia-small-black-walnut',   'first-light-australia', 'small',  'black-walnut', 24900, 10),
('first-light-australia-small-cherry',         'first-light-australia', 'small',  'cherry',       24900, 10),
('first-light-australia-medium-whitewashed',   'first-light-australia', 'medium', 'whitewashed',  34900, 10),
('first-light-australia-medium-black-walnut',  'first-light-australia', 'medium', 'black-walnut', 34900, 10),
('first-light-australia-medium-cherry',        'first-light-australia', 'medium', 'cherry',       34900, 10);
