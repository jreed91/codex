# CLAUDE.md - Repository Context

## Project Overview

**CodexSwiftUIApp** is a calorie and macro tracking application for iOS 26 that uses Apple Intelligence for natural language food logging. Users can chat with the app to log meals, view daily nutrition breakdowns, edit individual meals, and analyze their intake over time. All data is stored locally in SQLite.

## Project Structure

```
codex/
├── CodexSwiftUIApp/          # Main application package
│   ├── Package.swift         # Swift Package Manager configuration
│   ├── Sources/
│   │   └── CodexSwiftUIApp/
│   │       ├── CodexSwiftUIAppApp.swift  # Main app entry point
│   │       ├── ContentView.swift         # Root content view
│   │       ├── Models/
│   │       │   └── FoodEntry.swift       # Food entry data model
│   │       ├── Database/
│   │       │   └── DatabaseManager.swift # SQLite database manager
│   │       ├── Services/
│   │       │   └── FoodParserService.swift # Apple Intelligence integration
│   │       └── Views/
│   │           ├── MainTabView.swift     # Tab bar container
│   │           ├── ChatView.swift        # Chat-based food logging
│   │           ├── TodayView.swift       # Daily nutrition tracking
│   │           └── HistoryView.swift     # Historical data & charts
│   └── Tests/
│       └── CodexSwiftUIAppTests.swift    # Test suite
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions CI workflow
├── Makefile                 # Build automation tasks
├── README.md               # Project documentation
└── CLAUDE.md               # AI context & development guide
```

## Tech Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Platform**: iOS 26+
- **Build System**: Swift Package Manager (SPM)
- **Database**: SQLite (via SQLite.swift 0.15.0+)
- **AI/ML**: Apple Intelligence framework (iOS 26)
- **Charts**: SwiftUI Charts
- **Testing**: XCTest
- **Linting**: SwiftLint
- **CI/CD**: GitHub Actions

## App Features

### 1. Chat-Based Food Logging
- Natural language interface for logging meals
- Powered by Apple Intelligence for food parsing
- Automatic calorie and macro estimation
- Context-aware meal type detection (breakfast/lunch/dinner/snack)

### 2. Daily Nutrition Tracking
- Real-time daily summary of calories and macros
- Organized by meal types (Breakfast, Lunch, Dinner, Snacks)
- Swipe-to-delete for individual food entries
- Pull-to-refresh for latest data

### 3. Historical Analysis
- Weekly and monthly views
- Calorie trend charts using SwiftUI Charts
- Average daily intake statistics
- Detailed daily breakdowns

### 4. Data Persistence
- Local SQLite database storage
- Full CRUD operations for food entries
- Date-range queries for historical data
- Automatic database initialization

## Development Workflow

### Build Commands (via Makefile)

The project uses a Makefile for common development tasks:

- `make build` - Build the iOS app for simulator
- `make test` - Run tests on iPhone 16 simulator
- `make list` - List available Xcode schemes
- `make lint` - Run SwiftLint for code quality checks
- `make deploy` - Placeholder for deployment (not yet implemented)

### Manual Build Commands

If you need to run xcodebuild directly:

```bash
# Build for simulator
cd CodexSwiftUIApp && xcodebuild -scheme CodexSwiftUIApp -sdk iphonesimulator -destination 'generic/platform=iOS' build

# Run tests on iPhone 16
cd CodexSwiftUIApp && xcodebuild -scheme CodexSwiftUIApp -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' test

# List schemes
cd CodexSwiftUIApp && xcodebuild -list
```

## Package Configuration

**Package.swift** defines:
- Minimum iOS version: iOS 26
- Swift tools version: 5.9
- Single executable target: CodexSwiftUIApp
- Test target: CodexSwiftUIAppTests
- External dependencies:
  - SQLite.swift (0.15.0+) - SQLite database wrapper

## CI/CD Setup

The project uses GitHub Actions for continuous integration:

**Workflow**: `.github/workflows/ci.yml`
- Runs on: macOS (latest)
- Triggers: Push and PR to `main` and `work` branches
- Steps:
  1. Checkout code
  2. Install SwiftLint
  3. Build the app
  4. Run tests
  5. Lint the code

## Current Application State

The app is a fully functional calorie tracking application with:
- Three-tab interface (Chat, Today, History)
- SQLite database for persistent storage
- Apple Intelligence integration for food parsing (mock implementation with TODO for production)
- Real-time calorie and macro calculations
- Interactive charts for historical data
- Swipe-to-delete functionality for food entries

## Key Files

### CodexSwiftUIAppApp.swift
Main application entry point using `@main` attribute. Defines the app structure with a WindowGroup containing ContentView.

### ContentView.swift
Root view that displays the MainTabView, serving as the entry point to the app's UI.

### Models/FoodEntry.swift
Data model representing a single food entry with nutritional information (calories, protein, carbs, fat) and metadata (date, meal type).

### Database/DatabaseManager.swift
Singleton class managing SQLite operations including table creation, CRUD operations for food entries, and date-range queries. Uses SQLite.swift for database interaction.

### Services/FoodParserService.swift
Service layer for parsing natural language food descriptions using Apple Intelligence. Currently contains a mock implementation with TODO markers for production Apple Intelligence API integration.

### Views/MainTabView.swift
Tab bar container with three tabs: Chat, Today, and History. Uses SF Symbols for tab icons.

### Views/ChatView.swift
Chat-based UI for logging food through natural language. Features message bubbles, real-time responses, and integration with FoodParserService.

### Views/TodayView.swift
Displays today's nutrition summary with daily totals and breakdown by meal type. Includes swipe-to-delete and pull-to-refresh functionality.

### Views/HistoryView.swift
Shows historical nutrition data with segmented control for week/month views. Features SwiftUI Charts for calorie trends and detailed daily breakdowns.

### CodexSwiftUIAppTests.swift
Test suite for the application (check this file for current test cases).

## Development Guidelines

1. **iOS Target**: All code must support iOS 26+
2. **Testing**: Tests run on iPhone 16 simulator by default
3. **Code Quality**: SwiftLint is used and enforced in CI
4. **Branch Strategy**: Main development on `main` and `work` branches
5. **Build Verification**: All PRs must pass build, test, and lint checks

## Useful Context for AI Assistance

- This is a **SwiftUI-only** project (no UIKit)
- Uses **Swift Package Manager** (not CocoaPods or Carthage)
- Package is structured as an **executable** rather than a library
- Tests use standard **XCTest** framework
- External dependency: **SQLite.swift** for database operations
- Build system uses **xcodebuild** via Makefile abstractions
- Database file is stored in app's documents directory as `food_tracker.sqlite3`
- Apple Intelligence integration uses mock parsing (production API integration is TODO)

## Architecture Patterns

- **MVVM**: ViewModels manage state for SwiftUI views (e.g., TodayViewModel, ChatViewModel, HistoryViewModel)
- **Singleton**: DatabaseManager uses shared instance pattern for centralized database access
- **Repository Pattern**: DatabaseManager acts as data access layer
- **Service Layer**: FoodParserService handles AI parsing logic
- **ObservableObject**: ViewModels publish changes to trigger UI updates
- **@MainActor**: Ensures UI updates happen on main thread

## Common Tasks

When working on this project:

1. **Adding new views**: Create Swift files in `Sources/CodexSwiftUIApp/Views/`
2. **Adding models**: Create Swift files in `Sources/CodexSwiftUIApp/Models/`
3. **Database changes**: Modify `DatabaseManager.swift` and update schema
4. **AI parsing improvements**: Update `FoodParserService.swift` with better food detection or Apple Intelligence integration
5. **Adding tests**: Add to `Tests/CodexSwiftUIAppTests.swift` or create new test files
6. **Modifying build**: Update `Package.swift` and/or `Makefile`
7. **Changing CI**: Edit `.github/workflows/ci.yml`

## Notes

- All data is stored locally; no backend or cloud sync
- Apple Intelligence integration is mocked with TODO markers for production implementation
- Deployment functionality is a placeholder and not yet implemented
- All development and testing is simulator-based (no physical device required)
- Charts require iOS 16+ (SwiftUI Charts framework)
