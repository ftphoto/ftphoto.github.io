-- Add "Fracture" (Tasmania, Australia) as a new product.
-- Run with: wrangler d1 execute fallingtide-shop --file=migrations/0004_add_fracture.sql

INSERT INTO products (id, name, location, image, description) VALUES
('fracture-tasmania', 'Fracture', 'Tasmania, Australia', 'images/australia_10.jpg', 'Ancient rock faces rise on either side, their surfaces mapped with cracks and veins laid down over millennia. Between them, a narrow glimpse of sea and hillside — soft, distant, unreachable. The monochrome strips away everything but structure and time.');

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty) VALUES
('fracture-tasmania-small-whitewashed',   'fracture-tasmania', 'small',  'whitewashed',  24900, 10),
('fracture-tasmania-small-black-walnut',  'fracture-tasmania', 'small',  'black-walnut', 24900, 10),
('fracture-tasmania-small-cherry',        'fracture-tasmania', 'small',  'cherry',       24900, 10),
('fracture-tasmania-medium-whitewashed',  'fracture-tasmania', 'medium', 'whitewashed',  34900, 10),
('fracture-tasmania-medium-black-walnut', 'fracture-tasmania', 'medium', 'black-walnut', 34900, 10),
('fracture-tasmania-medium-cherry',       'fracture-tasmania', 'medium', 'cherry',       34900, 10);
