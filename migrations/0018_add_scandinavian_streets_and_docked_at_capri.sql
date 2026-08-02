-- Add "Scandinavian Streets" (Denmark) and "Docked at Capri" (Italy),
-- following established naming/SEO conventions: country-only location,
-- sensory description + one keyword-bearing closing clause.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0018_add_scandinavian_streets_and_docked_at_capri.sql

INSERT INTO products (id, name, location, image, description) VALUES
('scandinavian-streets', 'Scandinavian Streets', 'Denmark', 'images/scandinavian-streets.jpg', 'Gabled rowhouses in yellow, blue, and brick red line Copenhagen''s old harbor, chimneys catching the last of an overcast afternoon. The city''s most photographed street corner — fine art Scandinavian travel photography for a wall that wants a little color in it.'),
('docked-at-capri', 'Docked at Capri', 'Italy', 'images/docked-at-capri.jpg', 'Small fishing boats crowd the harbor at Capri, the whitewashed town rising up the cliffside behind them in the midday haze. A quieter, working-harbor moment on an island better known for its glamour — fine art Italy travel photography for a room that wants some texture in it.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('scandinavian-streets-small-whitewashed',   'scandinavian-streets', 'small',  'whitewashed',  24900, 10),
('scandinavian-streets-small-black-walnut',  'scandinavian-streets', 'small',  'black-walnut', 24900, 10),
('scandinavian-streets-small-cherry',        'scandinavian-streets', 'small',  'cherry',       24900, 10),
('scandinavian-streets-medium-whitewashed',  'scandinavian-streets', 'medium', 'whitewashed',  34900, 10),
('scandinavian-streets-medium-black-walnut', 'scandinavian-streets', 'medium', 'black-walnut', 34900, 10),
('scandinavian-streets-medium-cherry',       'scandinavian-streets', 'medium', 'cherry',       34900, 10),

('docked-at-capri-small-whitewashed',   'docked-at-capri', 'small',  'whitewashed',  24900, 10),
('docked-at-capri-small-black-walnut',  'docked-at-capri', 'small',  'black-walnut', 24900, 10),
('docked-at-capri-small-cherry',        'docked-at-capri', 'small',  'cherry',       24900, 10),
('docked-at-capri-medium-whitewashed',  'docked-at-capri', 'medium', 'whitewashed',  34900, 10),
('docked-at-capri-medium-black-walnut', 'docked-at-capri', 'medium', 'black-walnut', 34900, 10),
('docked-at-capri-medium-cherry',       'docked-at-capri', 'medium', 'cherry',       34900, 10);
