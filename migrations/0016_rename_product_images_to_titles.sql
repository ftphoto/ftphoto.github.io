-- Renames each active product's image file to match its print title
-- (e.g. images/ireland_4.jpg -> images/the-keepers-post.jpg), for Google
-- Images relevance and human-readable URLs. The actual files were moved
-- in the same commit as this migration — run them together, or images
-- will 404 until both land.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0016_rename_product_images_to_titles.sql

UPDATE products SET image = 'images/the-long-way-home.jpg' WHERE id = 'cannon-beach';
UPDATE products SET image = 'images/fading-in.jpg'         WHERE id = 'fanal-forest';
UPDATE products SET image = 'images/howth.jpg'              WHERE id = 'howth';
UPDATE products SET image = 'images/is-this-seat-taken.jpg' WHERE id = 'seat-taken-italy';
UPDATE products SET image = 'images/light-layers.jpg'       WHERE id = 'light-layers-australia';
UPDATE products SET image = 'images/breathe.jpg'            WHERE id = 'breathe-australia';
UPDATE products SET image = 'images/blue-amalfi.jpg'        WHERE id = 'amalfi-coast';
UPDATE products SET image = 'images/the-keepers-post.jpg'   WHERE id = 'keepers-post-ireland';
UPDATE products SET image = 'images/fracture.jpg'           WHERE id = 'fracture-tasmania';
UPDATE products SET image = 'images/the-climb.jpg'          WHERE id = 'the-climb-portugal';
