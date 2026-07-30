-- Falling Tide Photo — shop schema
-- Run with: wrangler d1 execute fallingtide-shop --file=db/schema.sql
--
-- Every print ships the same way: 12x18 photo, 2" white mat, 0.5" frame
-- trim, 17x23 overall. Frame color (black or white) is the only choice —
-- that's what "variants" represents here, not size.

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS variants;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id             TEXT PRIMARY KEY,
  name           TEXT NOT NULL,      -- print title, e.g. "The Long Way Home"
  location       TEXT NOT NULL,      -- shown as the subtitle, e.g. "Cannon Beach, Oregon — 2026"
  image          TEXT NOT NULL,      -- plain (unframed) photo, path relative to site root
  description    TEXT,
  active         INTEGER NOT NULL DEFAULT 1,
  sort_order     INTEGER NOT NULL DEFAULT 0,  -- higher = shown first in the shop grid
  featured_badge TEXT                          -- optional banner text, e.g. "Featured at KBM Art Gallery"
);

CREATE TABLE variants (
  id          TEXT PRIMARY KEY,
  product_id  TEXT NOT NULL REFERENCES products(id),
  frame_color TEXT NOT NULL,      -- 'black' | 'white'
  price_cents INTEGER NOT NULL,
  stock_qty   INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE orders (
  id                TEXT PRIMARY KEY,
  variant_id        TEXT NOT NULL REFERENCES variants(id),
  qty               INTEGER NOT NULL DEFAULT 1,
  buyer_name        TEXT,
  buyer_email       TEXT,
  shipping_address  TEXT,          -- JSON blob
  payment_provider  TEXT NOT NULL, -- 'paypal' | 'square'
  payment_ref       TEXT,          -- PayPal order id / Square payment id
  amount_cents      INTEGER NOT NULL,
  status            TEXT NOT NULL DEFAULT 'pending', -- pending | paid | paid_oversold | failed
  created_at        TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Seed data pulled from the existing gallery. Update prices/stock later
-- from /admin.html, or edit these INSERTs before first load.

INSERT INTO products (id, name, location, image, description) VALUES
('cannon-beach',  'The Long Way Home', 'Cannon Beach, Oregon — 2026',       'images/usa_1.jpg',        '12x18 print, 2" mat, framed 17x23.'),
('milford-sound', 'Milford Sound',     'Milford Sound, New Zealand — 2024', 'images/newzealand_1.jpg', '12x18 print, 2" mat, framed 17x23.'),
('amalfi-coast',  'Amalfi Coast',      'Amalfi Coast, Italy — 2025',        'images/italy_1.jpg',      '12x18 print, 2" mat, framed 17x23.'),
('dubrovnik',     'Dubrovnik',         'Dubrovnik, Croatia — 2025',         'images/croatia_1.jpg',    '12x18 print, 2" mat, framed 17x23.'),
('howth',         'Howth',             'Howth, Ireland — 2025',             'images/ireland_2.jpg',    '12x18 print, 2" mat, framed 17x23.'),
('fanal-forest',  'Fanal Forest',      'Fanal Forest, Portugal — 2026',     'images/portugal_4.jpg',   '12x18 print, 2" mat, framed 17x23.');

-- Placeholder pricing — update to match your actual costs. Both frame
-- colors priced the same here; change independently if you want to.
INSERT INTO variants (id, product_id, frame_color, price_cents, stock_qty) VALUES
('cannon-beach-black',  'cannon-beach',  'black', 16500, 8),
('cannon-beach-white',  'cannon-beach',  'white', 16500, 8),

('milford-sound-black', 'milford-sound', 'black', 16500, 8),
('milford-sound-white', 'milford-sound', 'white', 16500, 8),

('amalfi-coast-black',  'amalfi-coast',  'black', 16500, 8),
('amalfi-coast-white',  'amalfi-coast',  'white', 16500, 8),

('dubrovnik-black',     'dubrovnik',     'black', 16500, 8),
('dubrovnik-white',     'dubrovnik',     'white', 16500, 8),

('howth-black',         'howth',         'black', 16500, 8),
('howth-white',         'howth',         'white', 16500, 8),

('fanal-forest-black',  'fanal-forest',  'black', 16500, 8),
('fanal-forest-white',  'fanal-forest',  'white', 16500, 8);
