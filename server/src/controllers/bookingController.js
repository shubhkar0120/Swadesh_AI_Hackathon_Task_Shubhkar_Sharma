const { createBooking, cancelBooking } = require('../services/bookingService');

/**
 * POST /bookings
 * Body: { slotId: "..." }
 * Header: X-User-Id
 *
 * Returns:
 * - 201 Created on success
 * - 409 Conflict if slot already booked
 * - 400 Bad Request if input invalid
 * - 404 Not Found if slot doesn't exist
 */
function create(req, res) {
  const userId = req.headers['x-user-id'];
  if (!userId) {
    return res.status(400).json({
      error: 'INVALID_INPUT',
      message: 'X-User-Id header is required',
    });
  }

  const { slotId } = req.body;
  if (!slotId) {
    return res.status(400).json({
      error: 'INVALID_INPUT',
      message: 'slotId is required in request body',
    });
  }

  const result = createBooking(userId, slotId);

  if (result.success) {
    return res.status(201).json(result.booking);
  }

  switch (result.reason) {
    case 'SLOT_TAKEN':
      return res.status(409).json({
        error: 'SLOT_TAKEN',
        message: 'This slot has already been booked',
      });
    case 'SLOT_NOT_FOUND':
      return res.status(404).json({
        error: 'NOT_FOUND',
        message: 'Slot not found',
      });
    case 'INVALID_USER':
      return res.status(400).json({
        error: 'INVALID_INPUT',
        message: 'Invalid user ID',
      });
    default:
      return res.status(500).json({
        error: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred',
      });
  }
}

/**
 * DELETE /bookings/:id
 * Header: X-User-Id
 *
 * Returns:
 * - 200 OK on success
 * - 403 Forbidden if not the owner
 * - 404 Not Found if booking doesn't exist
 */
function cancel(req, res) {
  const userId = req.headers['x-user-id'];
  if (!userId) {
    return res.status(400).json({
      error: 'INVALID_INPUT',
      message: 'X-User-Id header is required',
    });
  }

  const { id } = req.params;
  const result = cancelBooking(id, userId);

  if (result.success) {
    return res.json({ message: 'Booking cancelled successfully' });
  }

  switch (result.reason) {
    case 'NOT_FOUND':
      return res.status(404).json({
        error: 'NOT_FOUND',
        message: 'Booking not found',
      });
    case 'FORBIDDEN':
      return res.status(403).json({
        error: 'FORBIDDEN',
        message: 'You can only cancel your own bookings',
      });
    default:
      return res.status(500).json({
        error: 'INTERNAL_ERROR',
        message: 'An unexpected error occurred',
      });
  }
}

module.exports = { create, cancel };
