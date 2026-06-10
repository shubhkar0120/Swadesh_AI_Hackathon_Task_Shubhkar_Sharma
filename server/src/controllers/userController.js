const db = require('../database/db');
const { getUserBookings } = require('../services/bookingService');

/**
 * GET /users
 * Returns all hardcoded users (for the user-select screen).
 */
function getAllUsers(req, res) {
  const users = db.prepare('SELECT id, name FROM users ORDER BY name').all();
  res.json(users);
}

/**
 * GET /users/:id/bookings
 * Returns all bookings for a user with venue and slot details.
 */
function getBookings(req, res) {
  const { id } = req.params;
  const result = getUserBookings(id);

  if (!result.success) {
    if (result.reason === 'USER_NOT_FOUND') {
      return res.status(404).json({
        error: 'NOT_FOUND',
        message: 'User not found',
      });
    }
  }

  res.json(result.bookings);
}

module.exports = { getAllUsers, getBookings };
