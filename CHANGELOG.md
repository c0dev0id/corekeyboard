# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- "DMD Orange" keyboard theme with dark background and orange accents
- Nightly CI workflow (`.github/workflows/nightly.yml`): builds a signed release APK daily at 02:00 UTC and publishes it to the `nightly` pre-release on GitHub.
- ProGuard/R8 keep rules in `app/proguard-rules.pro` for JNI entry points (`BinaryDictionary`), XML-inflated views (`LatinKeyboardView`, `CandidateView`), and custom preference widgets.

### Changed
- Rebranded from "Hacker's Keyboard" to "Core Keyboard" (UI text, package name `de.codevoid.corekeyboard`, internal `hk` abbreviations → `ck`)
- Raised minSdk/targetSdk to API 34 (Android 14)
- Replaced support library `NotificationCompat` with framework `Notification.Builder`; removed all `com.android.support` dependencies
- Removed dead version guards (pre-API 9 `Normalizer`, pre-API 28 clipping, pre-API 24 options key, pre-API 26 notification channel)
- Fixed `PendingIntent` flags (added `FLAG_IMMUTABLE`, required since targetSdk 31)
- Added `android:exported` attributes to all manifest components (required since targetSdk 31)
- Fixed C++ compiler warnings in native dictionary (empty LOGI macro → variadic no-op)
- AGP upgraded from 3.2.1 to 8.7.3, Gradle from 4.10.3 to 8.11, NDK pinned to r26b
- Replaced deprecated `Configuration.locale` field access with `getLocales()`/`setLocale()`
- Deleted `SharedPreferencesCompat` (reflection shim for `Editor.apply()`, dead since API 9)
- Replaced `jcenter()` with `mavenCentral()` in build configuration
- Release build now has `minifyEnabled true` with `proguard-android-optimize.txt` (previously shrinking was disabled).
- Signing config reads from environment variables (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`); unsigned local builds continue to work without those variables set.
