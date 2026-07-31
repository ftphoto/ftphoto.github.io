-- Rename "Fanal Forest" to "Fading In" with a new description.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0006_rename_fanal_forest.sql

UPDATE products
SET
  name = 'Fading In',
  description = 'Figures emerge slowly from the mist, walking a path that dissolves behind them. A lone tree anchors the right, solid against the grey.'
WHERE id = 'fanal-forest';
