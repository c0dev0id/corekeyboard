# Development Journal

## Software Stack

- **Language**: Java (app), C++ (native dictionary via JNI)
- **Build system**: Gradle 8.11, AGP 8.7.3, CMake (native), NDK r26b
- **Min/Target SDK**: 34 (Android 14)
- **Dependencies**: None at runtime (framework-only); JUnit 4.12 for tests
- **CI/CD**: GitHub Actions (build.yml, nightly.yml)

## Key Decisions

### No AndroidX migration
The `android.preference.*` framework classes are in ROM — zero APK cost, no extra class loading. AndroidX preferences pull in fragment/lifecycle/core (~1-2MB bytecode). This app is performance/latency/memory-critical. Framework APIs are preferred over library wrappers.

### Rebrand-first strategy
Order of work: rebrand → delete unused code → upgrade libraries. This avoids doing work on code that will be deleted.

### Framework Notification.Builder over NotificationCompat
With minSdk 34, the framework `Notification.Builder` API is complete. No need for `NotificationCompat` or any support library at all — the app has zero external runtime dependencies.

### Resources.updateConfiguration() still in use
`updateConfiguration()` (deprecated API 25) is used in 3 files to temporarily switch locale for resource loading. The modern replacement `createConfigurationContext()` requires a deeper refactor — each call site would need to create a new Context and load resources from it. Deferred for now.

## Core Features

- Software keyboard (IME) with full 5-row layout
- Multiple language support with language switching
- Native C++ dictionary for word suggestions and bigrams
- Multiple keyboard themes (including custom "DMD Orange")
- Configurable key height, hint display, haptic/sound feedback
