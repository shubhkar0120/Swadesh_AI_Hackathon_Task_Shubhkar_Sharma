const db = require('../database/db');
const { v4: uuidv4 } = require('uuid');

/**
 * Creates a booking for a slot.
 *
 * CONCURRENCY SAFETY:
 * - The bookings table has a UNIQUE constraint on slot_id.
 * - If two users try to book the same slot simultaneously,
 *   the first INSERT succeeds, and the second hits a
 *   SQLITE_CONSTRAINT_UNIQUE error.
 * - We catch that specific error and return { success: false, reason: 'SLOT_TAKEN' }.
 *
 * WHY NOT CHECK-THEN-INSERT?
 * - Race condition: two requests can both pass the availability check,
 *   then both try to insert. With UNIQUE constraint, the database
 *   is the source of truth, not application-level checks.
 */
function createBooking(userId, slotId) {
  // Validate the slot exists
  const slot = db.prepare('SELECT id, venue_id FROM slots WHERE id = ?').get(slotId);
  if (!slot) {
    return { success: false, reason: 'SLOT_NOT_FOUND' };
  }

  try {
    const bookingId = uuidv4();
    db.prepare(`
      INSERT INTO bookings (id, user_id, slot_id, status, created_at)
      VALUES (?, ?, ?, 'confirmed', datetime('now'))
    `).run(bookingId, userId, slotId);

    return {
      success: true,
      booking: {
        id: bookingId,
        userId,
        slotId,
        status: 'confirmed',
      },
    };
  } catch (err) {
    // UNIQUE constraint violation = slot already booked
    if (err.code === 'SQLITE_CONSTRAINT_UNIQUE') {
      return { success: false, reason: 'SLOT_TAKEN' };
    }
    // Foreign key violation = invalid user
    if (err.code === 'SQLITE_CONSTRAINT_FOREIGNKEY') {
      return { success: false, reason: 'INVALID_USER' };
    }
    throw err; // Re-throw unexpected errors
  }
}

/**
 * Cancels a booking by deleting it.
 * Only the booking owner can cancel.
 */
function cancelBooking(bookingId, userId) {
  const booking = db.prepare('SELECT id, user_id FROM bookings WHERE id = ?').get(bookingId);

  if (!booking) {
    return { success: false, reason: 'NOT_FOUND' };
  }

  if (booking.user_id !== userId) {
    return { success: false, reason: 'FORBIDDEN' };
  }

  db.prepare('DELETE FROM bookings WHERE id = ?').run(bookingId);
  return { success: true };
}

/**
 * Gets all bookings for a user, with venue and slot details.
 */
function getUserBookings(userId) {
  // Validate user exists
  const user = db.prepare('SELECT id FROM users WHERE id = ?').get(userId);
  if (!user) {
    return { success: false, reason: 'USER_NOT_FOUND' };
  }

  const bookings = db.prepare(`
    SELECT
      b.id,
      b.slot_id AS slotId,
      b.status,
      b.created_at AS createdAt,
      s.date,
      s.start_time AS startTime,
      s.end_time AS endTime,
      v.id AS venueId,
      v.name AS venueName,
      v.sport_type AS sportType,
      v.location AS venueLocation
    FROM bookings b
    JOIN slots s ON s.id = b.slot_id
    JOIN venues v ON v.id = s.venue_id
    WHERE b.user_id = ?
    ORDER BY s.date DESC, s.start_time DESC
  `).all(userId);

  // Shape the response with nested objects
  return {
    success: true,
    bookings: bookings.map(b => ({
      id: b.id,
      slotId: b.slotId,
      status: b.status,
      createdAt: b.createdAt,
      slot: {
        date: b.date,
        startTime: b.startTime,
        endTime: b.endTime,
      },
      venue: {
        id: b.venueId,
        name: b.venueName,
        sportType: b.sportType,
        location: b.venueLocation,
      },
    })),
  };
}

module.exports = { createBooking, cancelBooking, getUserBookings };
