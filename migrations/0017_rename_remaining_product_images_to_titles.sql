-- Follow-up to 0016: six active products weren't covered by that
-- migration because they aren't in any tracked migration file in this
-- repo (added directly against the live database, outside the migrations/
-- folder). Same treatment: rename each image to match its print title.
-- The actual files were moved in the same commit as this migration — run
-- them together, or images will 404 until both land.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0017_rename_remaining_product_images_to_titles.sql

UPDATE products SET image = 'images/first-light.jpg'                WHERE id = 'first-light-australia';
UPDATE products SET image = 'images/golden-surfer.jpg'              WHERE id = 'golden-surfer';
UPDATE products SET image = 'images/great-ocean-road.jpg'           WHERE id = 'great-ocean-road';
UPDATE products SET image = 'images/painted-harbor.jpg'             WHERE id = 'painted-harbor-denmark';
UPDATE products SET image = 'images/sunset-cruise.jpg'              WHERE id = 'sunset-cruise';
UPDATE products SET image = 'images/where-the-cliffs-give-way.jpg'  WHERE id = 'where-the-cliffs-give-way';
