const express = require('express');
const cors = require('cors');

const { createSchema } = require('./database/schema');
const { seedDatabase } = require('./database/seed');
const errorHandler = require('./middleware/errorHandler');

// Route imports
const venueRoutes = require('./routes/venues');
const bookingRoutes = require('./routes/bookings');
const userRoutes = require('./routes/users');

const app = express();
const PORT = process.env.PORT || 3000;

// --- Middleware ---
app.use(cors());                    // Allow cross-origin (Flutter app)
app.use(express.json());            // Parse JSON request bodies

// Request logging (simple, no external deps)
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.url} → ${res.statusCode} (${duration}ms)`);
  });
  next();
});

// --- Routes ---
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use('/venues', venueRoutes);
app.use('/bookings', bookingRoutes);
app.use('/users', userRoutes);

// 404 handler for unknown routes
app.use((req, res) => {
  res.status(404).json({
    error: 'NOT_FOUND',
    message: `Route ${req.method} ${req.url} not found`,
  });
});

// Global error handler (must be last)
app.use(errorHandler);

// --- Initialize database and start server ---
createSchema();
seedDatabase();

if (!process.env.VERCEL) {
  app.listen(PORT, () => {
    console.log(`\n🏟️  QuickSlot server running at http://localhost:${PORT}`);
    console.log(`   Health check: http://localhost:${PORT}/health\n`);
  });
}

module.exports = app;
