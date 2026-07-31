-- Add "Light Layers" (Australia) and "Is This Seat Taken?" (Italy),
-- following established naming/SEO conventions: country-only location,
-- sensory description + one keyword-bearing closing clause.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0014_add_light_layers_and_seat_taken.sql

INSERT INTO products (id, name, location, image, description) VALUES
('light-layers-australia', 'Light Layers', 'Australia', 'images/australia_5.jpg', 'Waves fold in layer after pale layer beneath a soft, overcast sky, a single distant rock breaking the line where sea meets fog. A quiet study in light and water — the kind of relaxing beach photography print built for a room that just wants to breathe.'),
('seat-taken-italy', 'Is This Seat Taken?', 'Italy', 'images/italy_3.jpg', 'An empty chairlift swings out over Capri, the town and coastline unfolding far below in hazy blue. A playful, high-up moment above the Tyrrhenian Sea — fine art Italy travel photography for anyone who still feels that Euro-summer pull.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('light-layers-australia-small-whitewashed',   'light-layers-australia', 'small',  'whitewashed',  24900, 10),
('light-layers-australia-small-black-walnut',  'light-layers-australia', 'small',  'black-walnut', 24900, 10),
('light-layers-australia-small-cherry',        'light-layers-australia', 'small',  'cherry',       24900, 10),
('light-layers-australia-medium-whitewashed',  'light-layers-australia', 'medium', 'whitewashed',  34900, 10),
('light-layers-australia-medium-black-walnut', 'light-layers-australia', 'medium', 'black-walnut', 34900, 10),
('light-layers-australia-medium-cherry',       'light-layers-australia', 'medium', 'cherry',       34900, 10),

('seat-taken-italy-small-whitewashed',   'seat-taken-italy', 'small',  'whitewashed',  24900, 10),
('seat-taken-italy-small-black-walnut',  'seat-taken-italy', 'small',  'black-walnut', 24900, 10),
('seat-taken-italy-small-cherry',        'seat-taken-italy', 'small',  'cherry',       24900, 10),
('seat-taken-italy-medium-whitewashed',  'seat-taken-italy', 'medium', 'whitewashed',  34900, 10),
('seat-taken-italy-medium-black-walnut', 'seat-taken-italy', 'medium', 'black-walnut', 34900, 10),
('seat-taken-italy-medium-cherry',       'seat-taken-italy', 'medium', 'cherry',       34900, 10);
