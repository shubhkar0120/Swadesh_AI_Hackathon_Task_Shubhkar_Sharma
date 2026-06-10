const Database = require('better-sqlite3');
const path = require('path');

const DB_PATH = process.env.VERCEL
  ? '/tmp/quickslot.db'
  : path.join(__dirname, '..', '..', 'quickslot.db');

const db = new Database(DB_PATH);

// Enable WAL mode for better concurrent read performance
db.pragma('journal_mode = WAL');
// Enforce foreign key constraints
db.pragma('foreign_keys = ON');

module.exports = db;
