-- SEO/copy refresh: rename "Amalfi Coast" to "Blue Amalfi", temporarily
-- deactivate Milford Sound (image is being reworked), and update every
-- product description with the enhanced copy from the SEO strategy doc.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0012_copy_refresh_and_catalog_changes.sql

UPDATE products SET name = 'Blue Amalfi' WHERE id = 'amalfi-coast';

-- Deactivate rather than delete — variants/order history stay intact,
-- and it's easy to flip `active` back to 1 once the image is replaced.
UPDATE products SET active = 0 WHERE id = 'milford-sound';

UPDATE products SET description = 'Fog settles low over Cannon Beach as the sea stacks hold their ground against the tide. A quiet, moody stretch of Pacific coastline — the kind of ocean photography print that turns a room contemplative rather than loud.'
WHERE id = 'cannon-beach';

UPDATE products SET description = 'Pastel houses stack up a cliffside above a stone bridge, the Tyrrhenian Sea turning turquoise where it meets the rock. The Amalfi Coast at its most postcard-true — a fine art print for anyone chasing that Euro-summer feeling year-round.'
WHERE id = 'amalfi-coast';

UPDATE products SET description = 'Terracotta rooftops crowd inside centuries-old walls above the Adriatic. A Mediterranean fine art print for a wall that wants to feel like a memory of somewhere warm.'
WHERE id = 'dubrovnik';

UPDATE products SET description = 'Waves break hard against the headland at Howth, spray catching the light where the Irish Sea meets the cliffs. A wilder kind of coastal art — for a room that wants some weather in it.'
WHERE id = 'howth';

UPDATE products SET description = 'Figures emerge slowly from the mist, walking a path that dissolves behind them. A lone tree anchors the right, solid against the grey. A quiet, black-and-white fine art print for a space that wants stillness over statement.'
WHERE id = 'fanal-forest';

UPDATE products SET description = 'A surfer catches the last warm light at Torquay Beach, silhouette gone gold against the water. Beach photography with real motion in it — for anyone who wants their wall to feel like sunset, not just show it.'
WHERE id = 'golden-surfer';

UPDATE products SET description = 'A boat cuts a slow line across Howth harbor as the sky turns over into evening. Relaxed, warm-toned coastal art for a room built around unwinding.'
WHERE id = 'sunset-cruise';

UPDATE products SET description = 'Limestone sea stacks stand alone against the Southern Ocean along one of the world''s great coastal drives. Big, dramatic ocean photography for a wall that can hold scale.'
WHERE id = 'great-ocean-road';

UPDATE products SET description = 'The PR8 trail traces a narrow line between green cliffs and open Atlantic air, Madeira falling away on both sides. A fine art print for anyone who''s felt small in the best way, somewhere beautiful.'
WHERE id = 'where-the-cliffs-give-way';

UPDATE products SET description = 'Ancient rock faces rise on either side, their surfaces mapped with cracks and veins laid down over millennia. Between them, a narrow glimpse of sea and hillside — soft, distant, unreachable. The monochrome strips away everything but structure and time. A striking black-and-white fine art print for a space built around quiet drama.'
WHERE id = 'fracture-tasmania';

UPDATE products SET description = 'Framed by coastal scrub and bare branches, a sweeping beach unfolds below in pale sand and gentle surf. A single figure walks the shoreline, unhurried. From up here, the world looks exactly as simple as we sometimes need it to be. A calming beach photography print for anyone who needs a room to slow down in.'
WHERE id = 'breathe-australia';

UPDATE products SET description = 'Tiny figures trace a narrow path along ancient volcanic ridges, dwarfed by cliffs that drop into shadow below. A fine art landscape print with real scale — for a wall that wants to remind you how big the world still is.'
WHERE id = 'the-climb-portugal';

UPDATE products SET description = 'A lighthouse and its cottage sit at the headland''s edge, small and certain against a pale endless sea. A quiet coastal fine art print — the kind that makes an entryway or reading nook feel like it''s always looked out at water.'
WHERE id = 'keepers-post-ireland';
