-- Raise every small-size price below $249 up to $249, and price the
-- medium size of those same products at $349. The six original launch
-- products (cannon-beach, milford-sound, amalfi-coast, dubrovnik, howth,
-- fanal-forest) only ever had a small size at $165, so this also creates
-- their medium variants -- one per existing frame color -- rather than
-- just updating a price that isn't there yet.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0015_raise_small_prices_and_add_medium.sql

UPDATE variants
SET price_cents = 24900
WHERE size_label = 'small'
  AND price_cents < 24900;

INSERT INTO variants (id, product_id, size_label, frame_color, price_cents, stock_qty)
SELECT
  v.product_id || '-medium-' || v.frame_color,
  v.product_id,
  'medium',
  v.frame_color,
  34900,
  v.stock_qty
FROM variants v
WHERE v.size_label = 'small'
  AND v.product_id IN (
    'cannon-beach', 'milford-sound', 'amalfi-coast',
    'dubrovnik', 'howth', 'fanal-forest'
  )
ON CONFLICT(id) DO UPDATE SET price_cents = 34900;
