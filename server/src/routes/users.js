const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// GET /users — list all users (for user-select screen)
router.get('/', userController.getAllUsers);

// GET /users/:id/bookings — a user's bookings
router.get('/:id/bookings', userController.getBookings);

module.exports = router;
