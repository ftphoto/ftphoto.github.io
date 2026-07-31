-- Relabel existing variants from the old frame lineup to the new one.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0005_rename_legacy_frame_colors.sql
--
-- Mapping (old -> new), matched by tone/depth:
--   black-flat    -> black-walnut   (dark)
--   white-flat    -> whitewashed    (light; displayed as "Bleached Maple")
--   blonde-maple  -> cherry         (medium warm wood)

UPDATE variants SET frame_color = 'black-walnut' WHERE frame_color = 'black-flat';
UPDATE variants SET frame_color = 'whitewashed'  WHERE frame_color = 'white-flat';
UPDATE variants SET frame_color = 'cherry'       WHERE frame_color = 'blonde-maple';
