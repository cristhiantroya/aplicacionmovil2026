# CompraSegura

A secure mobile buying and selling application focused on trust and safety.

## Tech Stack

### Backend
- Node.js + TypeScript
- Express.js
- Prisma ORM
- MariaDB/MySQL
- bcrypt (password hashing)
- jsonwebtoken (JWT authentication)

### Frontend (Mobile App)
- Flutter
- Dart
- Dio (HTTP client)
- flutter_secure_storage (secure token storage)
- Provider (state management)
- Geolocator

## Project Structure

```
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma  # Database schema
│   │   └── seed.ts        # Initial data (safe points)
│   ├── src/
│   │   ├── controllers/   # Request handlers
│   │   ├── routes/        # API endpoints
│   │   ├── services/      # Business logic
│   │   ├── middlewares/   # Authentication & more
│   │   ├── utils/         # Prisma client & helpers
│   │   └── index.ts       # Entry point
│   ├── package.json
│   └── tsconfig.json
└── app/                   # Flutter application
    ├── lib/
    │   ├── constants/     # App constants & theme
    │   ├── models/        # Data models
    │   ├── providers/     # State management
    │   ├── screens/       # UI screens
    │   ├── services/      # API services
    │   └── main.dart      # Entry point
    └── pubspec.yaml
```

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd aplicacionmovil2026/backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   - Copy `.env.example` to `.env`
   - Update with your database credentials and JWT secret

4. Set up the database:
   ```bash
   npx prisma migrate dev --name init
   npx prisma generate
   npm run prisma:seed  # Load initial safe points
   ```

5. Start the development server:
   ```bash
   npm run dev
   ```

### Flutter App Setup

1. Navigate to the app directory:
   ```bash
   cd aplicacionmovil2026/app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Features

- ✅ User authentication (register/login) with JWT
- ✅ Identity verification request system
- ✅ Product listing and creation
- ✅ Escrow payment system
- ✅ Safe points map and selection
- ✅ Mutual ratings system
- ✅ Notifications
- ✅ User profiles

## API Endpoints

- `/api/auth/register` - Register a new user
- `/api/auth/login` - User login
- `/api/products` - Product CRUD
- `/api/transactions` - Transaction management
- `/api/ratings` - Rating system
- `/api/verifications` - Identity verification
- `/api/points` - Safe points
- `/api/notifications` - Notifications
