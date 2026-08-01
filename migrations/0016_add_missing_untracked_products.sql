-- Recreate four products that existed in production but were never
-- captured in a committed migration (created via ad hoc SQL at some
-- point, outside this history): Golden Surfer, Sunset Cruise, Great
-- Ocean Road, and Where the Cliffs Give Way. Descriptions/locations
-- match what migrations 0011/0012 already expected for these ids;
-- images, prices, and the featured badge were confirmed directly by
-- the site owner since no committed migration ever recorded them.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0016_add_missing_untracked_products.sql

INSERT INTO products (id, name, location, image, description, featured_badge) VALUES
('golden-surfer', 'Golden Surfer', 'Australia', 'images/australia_3.jpg',
 'A surfer catches the last warm light at Torquay Beach, silhouette gone gold against the water. Beach photography with real motion in it — for anyone who wants their wall to feel like sunset, not just show it.',
 NULL),
('sunset-cruise', 'Sunset Cruise', 'Ireland', 'images/ireland_3.jpg',
 'A boat cuts a slow line across Howth harbor as the sky turns over into evening. Relaxed, warm-toned coastal art for a room built around unwinding.',
 NULL),
('great-ocean-road', 'Great Ocean Road', 'Australia', 'images/australia_2.jpg',
 'Limestone sea stacks stand alone against the Southern Ocean along one of the world''s great coastal drives. Big, dramatic ocean photography for a wall that can hold scale.',
 NULL),
('where-the-cliffs-give-way', 'Where the Cliffs Give Way', 'Portugal', 'images/portugal_5.jpg',
 'The PR8 trail traces a narrow line between green cliffs and open Atlantic air, Madeira falling away on both sides. A fine art print for anyone who''s felt small in the best way, somewhere beautiful.',
 'Featured at KBM Gallery');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('golden-surfer-small-whitewashed',    'golden-surfer', 'small',  'whitewashed',  24900, 10),
('golden-surfer-small-black-walnut',   'golden-surfer', 'small',  'black-walnut', 24900, 10),
('golden-surfer-small-cherry',         'golden-surfer', 'small',  'cherry',       24900, 10),
('golden-surfer-medium-whitewashed',   'golden-surfer', 'medium', 'whitewashed',  34900, 10),
('golden-surfer-medium-black-walnut',  'golden-surfer', 'medium', 'black-walnut', 34900, 10),
('golden-surfer-medium-cherry',        'golden-surfer', 'medium', 'cherry',       34900, 10),

('sunset-cruise-small-whitewashed',    'sunset-cruise', 'small',  'whitewashed',  24900, 10),
('sunset-cruise-small-black-walnut',   'sunset-cruise', 'small',  'black-walnut', 24900, 10),
('sunset-cruise-small-cherry',         'sunset-cruise', 'small',  'cherry',       24900, 10),
('sunset-cruise-medium-whitewashed',   'sunset-cruise', 'medium', 'whitewashed',  34900, 10),
('sunset-cruise-medium-black-walnut',  'sunset-cruise', 'medium', 'black-walnut', 34900, 10),
('sunset-cruise-medium-cherry',        'sunset-cruise', 'medium', 'cherry',       34900, 10),

('great-ocean-road-small-whitewashed',   'great-ocean-road', 'small',  'whitewashed',  24900, 10),
('great-ocean-road-small-black-walnut',  'great-ocean-road', 'small',  'black-walnut', 24900, 10),
('great-ocean-road-small-cherry',        'great-ocean-road', 'small',  'cherry',       24900, 10),
('great-ocean-road-medium-whitewashed',  'great-ocean-road', 'medium', 'whitewashed',  34900, 10),
('great-ocean-road-medium-black-walnut', 'great-ocean-road', 'medium', 'black-walnut', 34900, 10),
('great-ocean-road-medium-cherry',       'great-ocean-road', 'medium', 'cherry',       34900, 10),

('where-the-cliffs-give-way-small-whitewashed',   'where-the-cliffs-give-way', 'small',  'whitewashed',  30000, 10),
('where-the-cliffs-give-way-small-black-walnut',  'where-the-cliffs-give-way', 'small',  'black-walnut', 30000, 10),
('where-the-cliffs-give-way-small-cherry',        'where-the-cliffs-give-way', 'small',  'cherry',       30000, 10),
('where-the-cliffs-give-way-medium-whitewashed',  'where-the-cliffs-give-way', 'medium', 'whitewashed',  40000, 10),
('where-the-cliffs-give-way-medium-black-walnut', 'where-the-cliffs-give-way', 'medium', 'black-walnut', 40000, 10),
('where-the-cliffs-give-way-medium-cherry',       'where-the-cliffs-give-way', 'medium', 'cherry',       40000, 10);
