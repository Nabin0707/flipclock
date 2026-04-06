# Flutter Clean Architecture Template

A comprehensive template for Flutter applications following Clean Architecture principles with a complete component library, theme system, and state management integration. This template provides a structured foundation with 80+ reusable widgets and example implementations of each architectural layer.

## 🚀 NEW: Python Code Generator!

**Generate complete clean architecture features in seconds!**

This template now includes a **powerful Python GUI tool** that generates:

- ✅ Complete feature structure (data/domain/presentation layers)
- ✅ Entity, Model, Repository, UseCases, Providers
- ✅ Remote & Local Data Sources
- ✅ Full package integration (Freezed, Dartz, Riverpod, Retrofit, Hive)

### Quick Start Generator

```bash
cd generator
pip install -r requirements.txt
python flutter_clean_arch_generator.py
```

**Features:**

- 🎨 Modern GUI with tabs and live preview
- 🔍 Smart field parsing from existing code
- 📋 Pre-built templates (Auth, Product, Blog, Order)
- 💾 Save/load configurations
- 📁 Ready-to-use example configs

**Documentation:**

- [Generator Overview](generator/README.md)
- [Complete Setup Guide](generator/SETUP_GUIDE.md) - Step-by-step tutorial
- [Quick Start Card](generator/QUICK_START_CARD.md) - 2-minute reference
- [Examples](generator/examples/) - Ready-to-use configs

**Watch it in action:**

1. Load `examples/user_profile_config.json`
2. Click "Generate Files"
3. Complete feature ready! 🎉

## 🏗️ Architecture Overview

> **Note:** For small projects or MVPs, implementing this full architecture might be overengineering. Consider a simpler structure if your project has minimal business logic or a small feature set.

The architecture follows Clean Architecture principles with a feature-first organization:

```text
lib/
├── core/               # App-wide utilities, errors, and configurations
│   ├── theme/         # Theme system (colors, typography, themes)
│   └── providers/     # Global providers (theme provider)
├── features/          # Feature modules following Clean Architecture
│   ├── demo/          # Component showcase demo page (NEW!)
│   ├── auth/          # Authentication feature example
│   └── home/          # Home feature example
├── shared/            # Shared components across features
│   └── widgets/       # 40+ reusable component library (NEW!)
│       ├── buttons/
│       ├── inputs/
│       ├── cards/
│       ├── app_bars/
│       ├── bottom_sheets/
│       ├── dialogs/
│       └── common/
└── router/            # Navigation configuration
```

### Key Features

- **✨ Complete Clean Architecture Implementation**

  - Clear separation between data, domain, and presentation layers
  - Example implementations for each architectural component
  - Proper dependency injection setup

- **🎨 Comprehensive Component Library (80+ Components!)**

  - **Buttons**: Primary, Secondary, Outline, Text, Icon buttons
  - **Form Inputs**: Text fields, Password, Email, Phone, Search, Multiline
  - **Cards**: Product, Info, Custom, Expandable, Header cards
  - **App Bars**: Custom, Search, Theme toggle, Tab bars
  - **Bottom Sheets**: Modal, Scrollable, List bottom sheets
  - **Dialogs & Snackbars**: Info, Success, Error, Warning, Confirm
  - **Loading States**: Indicators, Overlays, Shimmer, Skeleton, Progress
  - **Empty & Error States**: Customizable placeholders
  - **Avatar**: User avatars, Avatar groups, Online indicators
  - **Badge**: Notification badges, Status badges, Count badges
  - **Chip**: Filter chips, Choice chips, Input chips, Chip groups
  - **Divider**: Horizontal, Vertical, Dashed, Section dividers
  - **Rating**: Star ratings, Rating breakdown, Rating with count
  - **Tag**: Status tags, Outlined tags, Category tags
  - **Timeline**: Vertical timeline, Custom indicators
  - **Stepper**: Multi-step processes with progress indicator
  - **Pagination**: Load more, Page numbers, Pagination info

- **🌓 Advanced Theme System (NEW!)**

  - Custom light and dark theme support
  - Indigo/Emerald color palette with 50+ colors
  - Material Design 3 typography system
  - Riverpod-powered theme switching with persistence
  - Gradient support
  - Status colors (success, warning, error, info)

- **� Response Management System (NEW!)**

  - Generic `ApiResponse<T>` wrapper for API calls
  - Functional error handling with `Result<T>` type (Either pattern)
  - Comprehensive `Failure` classes (Network, Server, Cache, Validation, Auth)
  - Type-safe response handling with Freezed
  - Metadata support for API responses

- **📄 Pagination System (NEW!)**

  - Complete pagination models (`PaginationMeta`, `PaginatedResponse<T>`)
  - State management for pagination (`PaginationState<T>`)
  - Ready-to-use pagination widgets (LoadMore, PageNumbers, Info)
  - Configurable pagination parameters with search & filters

- **🎯 Page Templates (NEW!)**

  - **ListPageTemplate**: Search, filter, pagination, pull-to-refresh
  - **DetailPageTemplate**: Structured detail view with actions
  - **FormPageTemplate**: Complete form with validation & submission
  - **ProfilePageTemplate**: User profile with stats and actions
  - **SettingsPageTemplate**: Settings with toggle, navigation, selection items

- **📱 Responsive Design (NEW!)**

  - `flutter_screenutil` v5.9.0 integration
  - Adaptive sizing with .w, .h, .sp, .r extensions
  - Helper classes for consistent spacing (`ResponsiveSpacing`)
  - Helper classes for text sizes (`ResponsiveFontSizes`)
  - Design size: 375x812 (iPhone 11 Pro baseline)
  - Works across phones, tablets, and different orientations
  - **Status**: Core widgets responsive, screens in progress
  - See [`docs/RESPONSIVE_DESIGN_GUIDE.md`](./docs/RESPONSIVE_DESIGN_GUIDE.md) for details

- **�🛠️ Modern Flutter Development**

  - Null safety
  - Route management with GoRouter
  - State management with Riverpod
  - Immutable programming with Freezed
  - Functional programming with Dartz
  - Interactive demo page at `/demo` route

- **🧰 Built-in Tools**
  - Error handling infrastructure
  - Dependency injection setup
  - Navigation service with demo route
  - Route guards
  - Theme persistence

## 🚀 Getting Started

1. Clone this template
2. Run `flutter pub get`
3. Run `flutter pub run build_runner build` to generate code
4. Run `flutter run` to see the app
5. Navigate to `/demo` route to explore all 40+ components
6. Start implementing your features following the auth feature example
7. Use the component library from `lib/shared/widgets/`

## 📖 Component Documentation

**Full documentation available in:**

- [`COMPONENTS_DOCUMENTATION.md`](./COMPONENTS_DOCUMENTATION.md) - Complete component reference
- [`NEW_COMPONENTS.md`](./NEW_COMPONENTS.md) - Section Headers, Drawers, FABs (Latest additions!)

Quick access to component categories:

### Core Components

- **Buttons**: Primary, Secondary, Outline, Text, Icon buttons
- **Inputs**: Text, Password, Email, Phone, Search, Multiline fields
- **Cards**: Product, Info, Custom, Expandable, Header cards (with overflow fix!)
- **App Bars**: Custom, Search, Theme toggle, Tab bars
- **Bottom Sheets**: Modal, Scrollable, List sheets
- **Dialogs & Snackbars**: Info, Success, Error, Warning, Confirm

### Navigation Components (NEW! 🎉)

- **Section Headers**: Basic, Large, Divider section headers
- **Drawers**: AppDrawer, ProfileDrawer with badges and selection state
- **FABs**: Basic, Extended, Badged, SpeedDial (animated), Morphing FABs

### Display Components (NEW!)

- **Avatar**: User avatars, Avatar groups, Online indicators
- **Badge**: Notification badges, Status badges, Count badges
- **Chip**: Filter chips, Choice chips, Input chips, Chip groups
- **Divider**: Horizontal, Vertical, Dashed, Section dividers
- **Rating**: Star ratings, Rating breakdown, Rating with count
- **Tag**: Status tags, Outlined tags, Category tags
- **Timeline**: Vertical timeline, Custom indicators
- **Stepper**: Multi-step processes with progress indicator

### Utility Components

- **Loading States**: Indicators, Overlays, Shimmer, Skeleton, Progress
- **Empty & Error States**: Customizable placeholders
- **Pagination**: Load more, Page numbers, Pagination info

### Page Templates (NEW!)

- **ListPageTemplate**: Complete list page with search, filter, pagination
- **DetailPageTemplate**: Structured detail view with actions
- **FormPageTemplate**: Form with validation & submission
- **ProfilePageTemplate**: User profile with stats and actions
- **SettingsPageTemplate**: Settings with multiple item types
- **Cards**: Product cards, Info cards, Custom cards
- **App Bars**: Custom, Search, Theme toggle, Tab bars
- **Bottom Sheets**: Modal, Scrollable, List bottom sheets
- **Dialogs**: Info, Success, Error, Warning, Confirm dialogs
- **Snackbars**: Info, Success, Error, Warning snackbars
- **Loading**: Indicators, Overlays, Shimmer, Skeleton loaders
- **Empty States**: Generic, Search, List, No data, No internet
- **Error Widgets**: Network, Server, Generic errors

### Demo Page

Access the interactive demo page to see all components:

```dart
context.go(Routes.demo);
```

The demo page includes:

- 7 tabbed sections showcasing all components
- Interactive examples with live code
- Theme switching demonstration
- Component state variations

## 📚 Template Usage Guide

### Adding a New Feature

1. Create a new directory under `lib/features/`
2. Follow the layer structure:
   - `domain/` for business logic
   - `data/` for data handling
   - `presentation/` for UI

### Implementation Steps

1. **Domain Layer**

   - Define entities
   - Create repository interfaces
   - Implement use cases

2. **Data Layer**

   - Create data models (DTOs)
   - Implement repositories
   - Set up data sources

3. **Presentation Layer**
   - Create state management (Riverpod)
   - Build UI components
   - Handle navigation

### Example Implementation

The `auth` feature demonstrates:

- Clean Architecture principles
- Error handling
- State management
- Navigation
- Dependency injection

## 🧪 Testing

The template includes examples of:

- Unit tests for use cases
- Repository tests
- Widget tests
- Integration tests

## 📦 Recommended Dependencies

Pre-configured with best-practice packages:

- `flutter_riverpod` for state management
- `freezed` for immutable classes
- `go_router` for navigation
- `dartz` for functional programming
- `dio` for networking
