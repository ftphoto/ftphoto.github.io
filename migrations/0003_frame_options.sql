-- Rename legacy frame names where they still exist.
UPDATE variants
SET frame_color = 'black-flat'
WHERE frame_color = 'black';

UPDATE variants
SET frame_color = 'white-flat'
WHERE frame_color = 'white';

-- Add Blonde Maple only where the exact variant does not already exist.
INSERT INTO variants (
  id,
  product_id,
  size_label,
  frame_color,
  price_cents,
  stock_qty
)
SELECT
  v.product_id || '-' || v.size_label || '-blonde-maple',
  v.product_id,
  v.size_label,
  'blonde-maple',
  v.price_cents,
  0
FROM variants v
WHERE v.frame_color = 'black-flat'
  AND NOT EXISTS (
    SELECT 1
    FROM variants existing
    WHERE existing.id =
      v.product_id || '-' || v.size_label || '-blonde-maple'
  );