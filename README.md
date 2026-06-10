# QuickSlot

A mini app for booking sports slots (badminton courts / turf grounds). Users browse venues, view time slots for a date, and book one — with concurrency-safe booking that prevents double-booking.

## Project Structure

```
quickslot/
├── app/          # Flutter mobile app
├── server/       # Node.js + Express + SQLite backend
├── docs/         # Architecture diagrams
└── README.md
```

## Setup

### Backend
```bash
cd server
npm install
npm start        # Starts on http://localhost:3000
```

### Flutter App
```bash
cd app
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

> **Note**: For physical device testing, update the API base URL in `app/lib/core/constants/app_constants.dart` to your machine's local IP.

## Architecture

_To be completed after implementation._

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Mobile App | Flutter + Riverpod + GoRouter + Dio + Freezed |
| Backend | Node.js + Express |
| Database | SQLite (better-sqlite3) |
| Concurrency | UNIQUE constraint on slot_id + SQLite serialized writes |

## What I'd Do With One More Day

_To be completed after implementation._

## AI Usage Note

_To be completed after implementation._
