# Development Journal

## Software Stack

- **Language**: Java (app), C++ (native dictionary via JNI)
- **Build system**: Gradle 6.7.1, AGP 4.2.2, CMake (native)
- **Min/Target SDK**: 34 (Android 14)
- **Dependencies**: None at runtime (framework-only); JUnit 4.12 for tests
- **CI/CD**: GitHub Actions (build.yml, nightly.yml)

## Key Decisions

### No AndroidX migration
The `android.preference.*` framework classes are in ROM — zero APK cost, no extra class loading. AndroidX preferences pull in fragment/lifecycle/core (~1-2MB bytecode). This app is performance/latency/memory-critical. Framework APIs are preferred over library wrappers.

### Rebrand-first strategy
Order of work: rebrand → delete unused code → upgrade libraries. This avoids doing work on code that will be deleted. The AGP/Gradle/NDK upgrade is deferred until after cleanup.

### Framework Notification.Builder over NotificationCompat
With minSdk 34, the framework `Notification.Builder` API is complete. No need for `NotificationCompat` or any support library at all — the app has zero external runtime dependencies.

### NDK version not pinned
NDK 21.4 (runner default) warns about platform 34 but compiles fine. Will pin a newer NDK during the AGP upgrade phase to avoid compatibility issues.

## Core Features

- Software keyboard (IME) with full 5-row layout
- Multiple language support with language switching
- Native C++ dictionary for word suggestions and bigrams
- Multiple keyboard themes (including custom "DMD Orange")
- Configurable key height, hint display, haptic/sound feedback
