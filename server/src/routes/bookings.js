const express = require('express');
const router = express.Router();
const bookingController = require('../controllers/bookingController');

// POST /bookings — book a slot (concurrency-safe)
router.post('/', bookingController.create);

// DELETE /bookings/:id — cancel a booking
router.delete('/:id', bookingController.cancel);

module.exports = router;
