# BookSwap_App
BookSwap - Textbook Exchange Platform

A Flutter mobile application for students to exchange textbooks with each other.

## Overview

BookSwap is a marketplace app where students can:
- List textbooks they wish to exchange
- Browse available books from other students
- Initiate swap offers
- Chat with other users
- Manage their profile and preferences

## Features

### Authentication
- User registration and login
- Email verification
- Profile management

### Book Management (CRUD)
- **Create**: Post books with title, author, condition, and cover image
- **Read**: Browse all available listings
- **Update**: Edit your own book listings
- **Delete**: Remove books you no longer want to swap

### Swap System
- Request swaps on available books
- Track swap status (Pending, Accepted, Rejected)
- Real-time status updates
- View swap history

### Chat (Bonus Feature)
- Message other users after swap offers
- Real-time chat functionality
- Chat history persistence

### Settings
- Toggle notification preferences
- View and edit profile information
- App preferences management

## Architecture

```
lib/
├── main.dart/        
├── firebase_options.dart/            
```

## UI Design

The app features a modern dark theme with:
- **Primary Color**: Dark Navy (#1A1A2E)
- **Accent Color**: Golden Yellow (#FDB750)
- **Card Background**: Dark Grey (#2D3250)

All screens are designed following Material Design principles.

## State Management

Uses **Provider** for state management:
- `AppState`: Main state container
- Real-time UI updates with `ChangeNotifier`
- No global `setState` calls
- Clean separation of business logic and UI

## Database Schema

### Users
```
{
  id: String,
  email: String,
  name: String,
  notificationsEnabled: Boolean
}
```

### Books
```
{
  id: String,
  userId: String,
  title: String,
  author: String,
  condition: String,
  imageUrl: String,
  status: String,
  createdAt: DateTime
}
```

### Swap Offers
```
{
  id: String,
  bookId: String,
  senderId: String,
  receiverId: String,
  status: String,
  createdAt: DateTime
}
```

## Swap State Machine

```
Available → [Request Swap] → Pending
Pending → [Accept] → Swapped
Pending → [Reject] → Available
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or iOS Simulator

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/bookswap.git
cd bookswap
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Running the App

### Demo Mode (Current)
Simply run the app using flutterlab or use flutter run

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1        # State management
  uuid: ^4.3.3            # ID generation
  intl: ^0.18.1           # Date formatting
  # For production:
  # firebase_core: ^2.24.2
  # firebase_auth: ^4.16.0
  # cloud_firestore: ^4.14.0
  # firebase_storage: ^11.6.0
```

## Demo Video

https://www.loom.com/share/c235da0fe2a94ffe881a0b1c3e226f7e
The demo shows:
- User authentication flow
- Swap functionality with status changes
- Chat feature
- Settings and profile management

## Features Implemented

- Clean Architecture with separation of concerns
- Provider state management
- Complete CRUD operations
- Swap system with status tracking
- Chat functionality
- Settings and preferences
- Responsive UI
- Dark theme design
- Bottom navigation
- Real-time updates

## Future Enhancements

- [ ] Firebase integration for persistence
- [ ] Push notifications
- [ ] Advanced search and filters
- [ ] Book recommendations
- [ ] User ratings and reviews
- [ ] Image upload for books
- [ ] Multiple photos per book
- [ ] Payment integration (optional)

## Contributing

This is an academic project. Contributions are not being accepted at this time.

##  License

This project was created as part of a mobile development course assignment.

## Author

- Email: u.justine@alustudent.com
- GitHub: https://github.com/Justine-abc/BookSwap_App

## Acknowledgments

- Flutter team for the amazing framework
- Course instructor for guidance
- Material Design for UI inspiration
