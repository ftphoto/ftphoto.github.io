-- Standardize the "location" byline shown under each product to just
-- the country (previously a mix of "City, Country — Year", "Region,
-- Country", and bare country).
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0011_standardize_location_to_country.sql

UPDATE products SET location = 'USA'         WHERE id = 'cannon-beach';
UPDATE products SET location = 'New Zealand' WHERE id = 'milford-sound';
UPDATE products SET location = 'Italy'       WHERE id = 'amalfi-coast';
UPDATE products SET location = 'Croatia'     WHERE id = 'dubrovnik';
UPDATE products SET location = 'Ireland'     WHERE id = 'howth';
UPDATE products SET location = 'Portugal'    WHERE id = 'fanal-forest';
UPDATE products SET location = 'Australia'   WHERE id = 'golden-surfer';
UPDATE products SET location = 'Ireland'     WHERE id = 'sunset-cruise';
UPDATE products SET location = 'Australia'   WHERE id = 'great-ocean-road';
UPDATE products SET location = 'Portugal'    WHERE id = 'where-the-cliffs-give-way';
UPDATE products SET location = 'Australia'   WHERE id = 'fracture-tasmania';
