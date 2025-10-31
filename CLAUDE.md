# CLAUDE.md - Repository Context

## Project Overview

**CodexSwiftUIApp** is a minimal SwiftUI application for iOS 16 created for demonstration purposes. This serves as a template/example project showcasing a basic SwiftUI app structure with proper build tooling, testing, and CI/CD setup.

## Project Structure

```
codex/
├── CodexSwiftUIApp/          # Main application package
│   ├── Package.swift         # Swift Package Manager configuration
│   ├── Sources/
│   │   └── CodexSwiftUIApp/
│   │       ├── CodexSwiftUIAppApp.swift  # Main app entry point
│   │       └── ContentView.swift         # Main content view
│   └── Tests/
│       └── CodexSwiftUIAppTests.swift    # Test suite
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions CI workflow
├── Makefile                 # Build automation tasks
└── README.md               # Project documentation
```

## Tech Stack

- **Language**: Swift 5.9+
- **Framework**: SwiftUI
- **Platform**: iOS 16+
- **Build System**: Swift Package Manager (SPM)
- **Testing**: XCTest
- **Linting**: SwiftLint
- **CI/CD**: GitHub Actions

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
- Minimum iOS version: iOS 16
- Swift tools version: 5.9
- Single executable target: CodexSwiftUIApp
- Test target: CodexSwiftUIAppTests
- No external dependencies

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

The app is minimal and demonstrates:
- Basic SwiftUI app structure with `@main` entry point
- Simple ContentView showing "Hello, world!"
- SwiftUI preview configuration
- Standard test setup

## Key Files

### CodexSwiftUIAppApp.swift
Main application entry point using `@main` attribute. Defines the app structure with a WindowGroup containing ContentView.

### ContentView.swift
Primary UI view displaying a simple text element. Includes SwiftUI preview provider for Xcode canvas.

### CodexSwiftUIAppTests.swift
Test suite for the application (check this file for current test cases).

## Development Guidelines

1. **iOS Target**: All code must support iOS 16+
2. **Testing**: Tests run on iPhone 16 simulator by default
3. **Code Quality**: SwiftLint is used and enforced in CI
4. **Branch Strategy**: Main development on `main` and `work` branches
5. **Build Verification**: All PRs must pass build, test, and lint checks

## Useful Context for AI Assistance

- This is a **SwiftUI-only** project (no UIKit)
- Uses **Swift Package Manager** (not CocoaPods or Carthage)
- Package is structured as an **executable** rather than a library
- Tests use standard **XCTest** framework
- No external dependencies currently used
- Build system uses **xcodebuild** via Makefile abstractions

## Common Tasks

When working on this project:

1. **Adding new views**: Create Swift files in `Sources/CodexSwiftUIApp/`
2. **Adding tests**: Add to `Tests/CodexSwiftUIAppTests.swift` or create new test files
3. **Modifying build**: Update `Package.swift` and/or `Makefile`
4. **Changing CI**: Edit `.github/workflows/ci.yml`

## Notes

- The project is intentionally minimal for demonstration purposes
- Deployment functionality is a placeholder and not yet implemented
- All development and testing is simulator-based (no physical device required)
