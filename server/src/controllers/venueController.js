const db = require('../database/db');

/**
 * GET /venues
 * Returns all venues.
 */
function getAllVenues(req, res) {
  const venues = db.prepare(`
    SELECT id, name, location, sport_type AS sportType, image_url AS imageUrl
    FROM venues
    ORDER BY name
  `).all();

  res.json(venues);
}

/**
 * GET /venues/:id/slots?date=YYYY-MM-DD
 * Returns slots for a venue on a specific date, with booking status.
 *
 * If no slots exist for that date, generates them on the fly (lazy slot generation).
 * This ensures the system works for any future date without manual seeding.
 */
function getVenueSlots(req, res) {
  const { id: venueId } = req.params;
  const { date } = req.query;

  // Validate venue exists
  const venue = db.prepare('SELECT id FROM venues WHERE id = ?').get(venueId);
  if (!venue) {
    return res.status(404).json({ error: 'NOT_FOUND', message: 'Venue not found' });
  }

  // Validate date format
  if (!date || !/^\d{4}-\d{2}-\d{2}$/.test(date)) {
    return res.status(400).json({
      error: 'INVALID_INPUT',
      message: 'date query parameter is required in YYYY-MM-DD format',
    });
  }

  // Lazy slot generation: if no slots for this venue+date, create them
  const existingCount = db.prepare(
    'SELECT COUNT(*) as count FROM slots WHERE venue_id = ? AND date = ?'
  ).get(venueId, date).count;

  if (existingCount === 0) {
    const insertSlot = db.prepare(
      'INSERT OR IGNORE INTO slots (id, venue_id, date, start_time, end_time) VALUES (?, ?, ?, ?, ?)'
    );
    const generateSlots = db.transaction(() => {
      for (let h = 6; h < 22; h++) {
        const start = String(h).padStart(2, '0') + ':00';
        const end = String(h + 1).padStart(2, '0') + ':00';
        const slotId = `slot-${venueId}-${date}-${start}`;
        insertSlot.run(slotId, venueId, date, start, end);
      }
    });
    generateSlots();
  }

  // Fetch slots with booking status using LEFT JOIN
  const slots = db.prepare(`
    SELECT
      s.id,
      s.venue_id AS venueId,
      s.date,
      s.start_time AS startTime,
      s.end_time AS endTime,
      CASE WHEN b.id IS NULL THEN 0 ELSE 1 END AS isBooked,
      b.user_id AS bookedByUserId
    FROM slots s
    LEFT JOIN bookings b ON b.slot_id = s.id AND b.status = 'confirmed'
    WHERE s.venue_id = ? AND s.date = ?
    ORDER BY s.start_time
  `).all(venueId, date);

  // Convert isBooked from 0/1 to boolean
  const result = slots.map(slot => ({
    ...slot,
    isBooked: slot.isBooked === 1,
    bookedByUserId: slot.bookedByUserId || null,
  }));

  res.json(result);
}

module.exports = { getAllVenues, getVenueSlots };
