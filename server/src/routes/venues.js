const express = require('express');
const router = express.Router();
const { getAllVenues, getVenueSlots } = require('../controllers/venueController');

// GET /venues — list all venues
router.get('/', getAllVenues);

// GET /venues/:id/slots?date=YYYY-MM-DD — slots for a venue on a date
router.get('/:id/slots', getVenueSlots);

module.exports = router;
