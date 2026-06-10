const db = require('./db');

/**
 * Creates all tables and indexes.
 * Called once on server startup — uses IF NOT EXISTS so it's idempotent.
 */
function createSchema() {
  db.exec(`
    CREATE TABLE IF NOT EXISTS users (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL
    );

    CREATE TABLE IF NOT EXISTS venues (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      location TEXT NOT NULL,
      sport_type TEXT NOT NULL,
      image_url TEXT
    );

    CREATE TABLE IF NOT EXISTS slots (
      id TEXT PRIMARY KEY,
      venue_id TEXT NOT NULL REFERENCES venues(id),
      date TEXT NOT NULL,
      start_time TEXT NOT NULL,
      end_time TEXT NOT NULL,
      UNIQUE(venue_id, date, start_time)
    );

    CREATE TABLE IF NOT EXISTS bookings (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL REFERENCES users(id),
      slot_id TEXT NOT NULL UNIQUE,
      status TEXT NOT NULL DEFAULT 'confirmed',
      created_at TEXT NOT NULL DEFAULT (datetime('now'))
    );

    -- Performance indexes
    CREATE INDEX IF NOT EXISTS idx_slots_venue_date ON slots(venue_id, date);
    CREATE INDEX IF NOT EXISTS idx_bookings_user ON bookings(user_id);
    CREATE INDEX IF NOT EXISTS idx_bookings_slot ON bookings(slot_id);
  `);
}

module.exports = { createSchema };
