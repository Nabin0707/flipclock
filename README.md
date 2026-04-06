# FlipClock Productivity Suite

FlipClock is a production-focused Flutter app with a flip-style clock and built-in productivity tools:

- Focus Mode (fullscreen timer + analytics)
- Timer (countdown)
- Stopwatch (laps)
- Pomodoro (work/break cycles)

The app uses Riverpod for state management, GoRouter for navigation, and SharedPreferences for local persistence.

## Current Modules

### 1) Clock

- Flip-style hour and minute display with animated middle seam
- Theme customization (card color, digit color, accent, glow, flip speed, radius)
- 12h / 24h switch

### 2) Focus Mode

- Fullscreen focus timer experience
- Category-based sessions (Study, Coding, Reading, Workout, Gaming, Meditation, and custom categories)
- Category color mapping
- Session persistence
- Analytics and charts for:
  - Day
  - Week
  - Month
  - Year
- Chart types:
  - Bar graph
  - Pie chart
  - Trend graph

### 3) Timer

- Configurable countdown timer
- Presets (5m, 15m, 25m, 45m)
- Start / Pause / Reset

### 4) Stopwatch

- Start / Pause / Reset
- Lap recording

### 5) Pomodoro

- Work and break phases
- Adjustable work and break durations
- Start / Pause / Skip phase / Reset
- Completed work session count

## Routes

Configured in GoRouter:

- /clock
- /settings
- /focus
- /timer
- /stopwatch
- /pomodoro

Main clock app bar includes a tools menu for quick access to Focus, Timer, Stopwatch, and Pomodoro.

## Project Structure

```text
lib/
├── core/
│   ├── providers/
│   └── theme/
├── features/
│   ├── clock/
│   ├── settings/
│   ├── focus/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── providers/
│   ├── timer/
│   │   ├── presentation/
│   │   └── providers/
│   ├── stopwatch/
│   │   ├── presentation/
│   │   └── providers/
│   └── pomodoro/
│       ├── presentation/
│       └── providers/
├── router/
└── widgets/
```

## Tech Stack

- Flutter (Material 3)
- flutter_riverpod
- go_router
- shared_preferences
- flutter_screenutil
- dio / dartz / freezed (available in project dependencies)

## Run Locally

1. Install dependencies:

```bash
flutter pub get
```

2. Run app:

```bash
flutter run
```

3. Run tests:

```bash
flutter test
```

## Tests

Key test files:

- test/widget_test.dart
- test/focus_analytics_test.dart
- test/productivity_modules_test.dart

## Notes

- Focus analytics are generated from saved focus sessions.
- Category colors are deterministic per category name for visual consistency.
- Existing analyzer output currently contains info-level lint/deprecation suggestions in older files; these are non-blocking for app execution.
