const db = require('./db');
const { v4: uuidv4 } = require('uuid');

/**
 * Seeds the database with initial data:
 * - 3 hardcoded users
 * - 5 sports venues
 * - Hourly slots from 6 AM to 10 PM (16 slots) for today and tomorrow
 *
 * Idempotent: uses INSERT OR IGNORE so re-running is safe.
 */
function seedDatabase() {
  const insertUser = db.prepare(
    'INSERT OR IGNORE INTO users (id, name) VALUES (?, ?)'
  );
  const insertVenue = db.prepare(
    'INSERT OR IGNORE INTO venues (id, name, location, sport_type, image_url) VALUES (?, ?, ?, ?, ?)'
  );
  const insertSlot = db.prepare(
    'INSERT OR IGNORE INTO slots (id, venue_id, date, start_time, end_time) VALUES (?, ?, ?, ?, ?)'
  );

  // --- Users ---
  const users = [
    { id: 'user-1', name: 'Shubhkar' },
    { id: 'user-2', name: 'Judge A' },
    { id: 'user-3', name: 'Judge B' },
  ];

  // --- Venues ---
  const venues = [
    { id: 'venue-1', name: 'Shuttle Zone', location: 'Sector 62, Noida', sportType: 'Badminton', imageUrl: null },
    { id: 'venue-2', name: 'Green Turf Arena', location: 'Connaught Place, Delhi', sportType: 'Football', imageUrl: null },
    { id: 'venue-3', name: 'Cricket Hub', location: 'Indirapuram, Ghaziabad', sportType: 'Cricket', imageUrl: null },
    { id: 'venue-4', name: 'NetPlay Courts', location: 'Sector 18, Noida', sportType: 'Tennis', imageUrl: null },
    { id: 'venue-5', name: 'Slam Dunk Center', location: 'Rajouri Garden, Delhi', sportType: 'Basketball', imageUrl: null },
  ];

  // --- Generate slots for today and the next 6 days ---
  const today = new Date();
  const dates = [];
  for (let i = 0; i < 7; i++) {
    const d = new Date(today);
    d.setDate(d.getDate() + i);
    dates.push(d.toISOString().split('T')[0]); // 'YYYY-MM-DD'
  }

  // Hourly slots: 6 AM to 10 PM (06:00–22:00)
  const hours = [];
  for (let h = 6; h < 22; h++) {
    const start = String(h).padStart(2, '0') + ':00';
    const end = String(h + 1).padStart(2, '0') + ':00';
    hours.push({ start, end });
  }

  // Run all inserts in a transaction for speed
  const seedAll = db.transaction(() => {
    for (const u of users) {
      insertUser.run(u.id, u.name);
    }

    for (const v of venues) {
      insertVenue.run(v.id, v.name, v.location, v.sportType, v.imageUrl);
    }

    for (const v of venues) {
      for (const date of dates) {
        for (const hour of hours) {
          const slotId = `slot-${v.id}-${date}-${hour.start}`;
          insertSlot.run(slotId, v.id, date, hour.start, hour.end);
        }
      }
    }
  });

  seedAll();

  const userCount = db.prepare('SELECT COUNT(*) as count FROM users').get().count;
  const venueCount = db.prepare('SELECT COUNT(*) as count FROM venues').get().count;
  const slotCount = db.prepare('SELECT COUNT(*) as count FROM slots').get().count;
  console.log(`Seeded: ${userCount} users, ${venueCount} venues, ${slotCount} slots`);
}

module.exports = { seedDatabase };
