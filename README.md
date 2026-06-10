# QuickSlot 🏟️

A mini app for booking sports slots (badminton courts / turf grounds). Users browse venues, view time slots for a date, and book one — with **concurrency-safe booking** that prevents double-booking.

## Project Structure

```
quickslot/
├── app/          # Flutter mobile app (Riverpod + GoRouter + Dio + Freezed)
├── server/       # Node.js + Express + SQLite backend
├── docs/         # Architecture diagrams
└── README.md
```

## Setup

### Prerequisites
- Node.js 18+ installed
- Flutter SDK installed (`flutter doctor` clean)
- Android emulator or physical device

### Backend
```bash
cd server
npm install
npm start        # Starts on http://localhost:3000
```
The database is auto-created and seeded on first startup (3 users, 5 venues, 560+ slots).

### Flutter App
```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> **Physical device**: Update `baseUrl` in `app/lib/core/constants/app_constants.dart` to your machine's LAN IP (e.g., `http://192.168.1.5:3000`).

---

## Architecture

### Backend
```
Node.js + Express + SQLite (better-sqlite3)
├── Routes      → URL mapping
├── Controllers → Request validation + response shaping
├── Services    → Business logic (booking with concurrency safety)
└── Database    → SQLite with WAL mode, UNIQUE constraints, indexes
```

### Flutter App
```
Simplified Clean Architecture
├── core/           → Network (Dio), theme, router, errors, utils
├── features/
│   ├── auth/       → User selection (hardcoded users)
│   ├── venues/     → Venue list + slot grid + booking flow
│   └── bookings/   → My bookings + cancel
└── shared/         → Reusable widgets (loading, error, empty state)

Each feature: models/ → repository/ → providers/ → screens/ + widgets/
```

### State Management: Riverpod
- **FutureProvider** for API data (venues, slots, bookings)
- **StateNotifier** for local state (selected user)
- **AsyncValue.when()** for loading/error/data in every screen
- No business logic in widgets — providers call repositories

### Concurrency Handling (Most Important)

**How double-booking is prevented:**

1. The `bookings` table has `slot_id UNIQUE` constraint
2. When two users book the same slot simultaneously:
   - Both INSERT statements hit SQLite
   - SQLite serializes writes (single-writer model)
   - First INSERT succeeds → 201 Created
   - Second INSERT hits UNIQUE violation → caught → 409 Conflict returned
3. Flutter app catches 409 → shows "This slot was just booked by someone else!" → auto-refreshes the grid

**Why not check-then-insert?** Race condition: two requests can both pass the availability check, then both insert. We rely on **database-level constraints** as the source of truth, not application-level checks.

### Database Schema
```sql
-- Key constraint that prevents double booking:
CREATE TABLE bookings (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id),
  slot_id TEXT NOT NULL UNIQUE,  -- ← THIS LINE
  status TEXT NOT NULL DEFAULT 'confirmed',
  created_at TEXT NOT NULL
);

-- Performance indexes
CREATE INDEX idx_slots_venue_date ON slots(venue_id, date);
CREATE INDEX idx_bookings_user ON bookings(user_id);
```

---

## API Endpoints

| Method | Endpoint | Status Codes | Description |
|--------|----------|-------------|-------------|
| GET | /health | 200 | Health check |
| GET | /venues | 200 | List all venues |
| GET | /venues/:id/slots?date= | 200, 400, 404 | Slots with booking status |
| POST | /bookings | 201, 400, 404, 409 | Book a slot (concurrency-safe) |
| DELETE | /bookings/:id | 200, 403, 404 | Cancel a booking |
| GET | /users/:id/bookings | 200, 404 | User's bookings |
| GET | /users | 200 | List all users |

---

## What I Cut and Why

- **Full authentication**: Used hardcoded users + X-User-Id header as the spec explicitly allows. Saved 1+ hour.
- **Use cases layer**: Removed to reduce boilerplate. Providers call repositories directly. Still clean — just pragmatic for a hackathon.
- **WebSocket live updates**: Used polling (10s interval) instead. Simpler, works reliably, and still demonstrates the concept.
- **Offline cache**: Not implemented. Would use Hive/SQLite on the Flutter side with a cache-first strategy.

## What I'd Do With One More Day

1. **JWT Authentication** with refresh tokens
2. **WebSocket** for real-time slot status updates (replace polling)
3. **Redis caching** for venue/slot queries
4. **Integration tests** for the booking API
5. **CI/CD pipeline** with GitHub Actions
6. **Dockerized backend** with docker-compose

---

## Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Mobile App | Flutter | Cross-platform, fast development |
| State Management | Riverpod | Compile-time safety, no BuildContext dependency, testable |
| Navigation | GoRouter | Declarative routing, deep linking support |
| HTTP Client | Dio | Interceptors, timeout handling, better error management |
| Models | Freezed + json_serializable | Immutable models, copyWith, fromJson/toJson |
| Backend | Node.js + Express | Fast to prototype, familiar ecosystem |
| Database | SQLite (better-sqlite3) | Zero setup, synchronous writes = natural concurrency safety |

---

## AI Usage Note

AI tools (Claude, GitHub Copilot) were used for:
- Generating boilerplate code (Freezed models, Express routes)
- Suggesting the database schema structure
- Writing consistent error handling patterns

**One thing AI got wrong that I caught and fixed**: The initial suggestion was to use a check-then-insert pattern for booking (SELECT to check availability, then INSERT). I recognized this as a race condition — two concurrent requests could both pass the check. I replaced it with a direct INSERT relying on the UNIQUE constraint, catching `SQLITE_CONSTRAINT_UNIQUE` errors to return 409 Conflict. This is the correct approach because database constraints are the ultimate source of truth.
