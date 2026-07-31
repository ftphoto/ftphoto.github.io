-- Temporarily remove "Dubrovnik" from the shop — not ready to sell it yet.
-- Deactivate rather than delete: variants/order history stay intact,
-- and it's a one-line flip back to active = 1 whenever it's ready.
-- Run with: wrangler d1 execute fallingtide-shop --remote --file=migrations/0013_deactivate_dubrovnik.sql

UPDATE products SET active = 0 WHERE id = 'dubrovnik';
