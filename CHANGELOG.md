# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Paste key: the special key slot (previously settings-only) now shows a paste key when the preference is set to "Paste key". Tapping it pastes from the clipboard via the current InputConnection. The settings key still takes precedence when set to "Settings key" or "Auto".
- "DMD Orange" keyboard theme with dark background and orange accents
- Nightly CI workflow (`.github/workflows/nightly.yml`): builds a signed release APK daily at 02:00 UTC and publishes it to the `nightly` pre-release on GitHub.
- ProGuard/R8 keep rules in `app/proguard-rules.pro` for JNI entry points (`BinaryDictionary`), XML-inflated views (`LatinKeyboardView`, `CandidateView`), and custom preference widgets.

### Fixed
- Empty gap above keyboard when suggestions are disabled: the framework's candidates area wrapper could retain residual height in the inset calculation, causing apps (notably Firefox) to miscalculate viewport size and partially hide focused form fields behind the gap
- Toggling the "Show suggestions" preference while the keyboard is visible now immediately updates the candidates strip visibility
- Paste key bottom row missing on all non-default keyboard locales: the `_with_paste_key` row variants were only defined in the default layout but absent from all 33 locale-specific `kbd_qwerty.xml` files, causing the entire bottom row to vanish when "Paste key" was selected in settings
- Crash when enabling the persistent notification setting: missing `RECEIVER_NOT_EXPORTED` flag on dynamically registered broadcast receiver (required on API 34), missing `POST_NOTIFICATIONS` runtime permission request, and missing `FLAG_ACTIVITY_NEW_TASK` when opening settings from the notification action
- Crash when pressing the Options key on the keyboard: `startActivity()` from IME service context was missing `FLAG_ACTIVITY_NEW_TASK`
- Crash when opening View, Feedback, Actions, or Language sub-screens in settings: implicit intents cannot start non-exported activities on API 31+ (even within the same app); preference XML intents are now explicit (package + class)
- Settings key on keyboard no longer opens settings: `launchSettings()` was calling `requestHideSelf()` before `startActivity()`, causing Android 12+ background activity start restriction to silently block the launch; now starts the activity while the IME window is still visible
- DMD Orange theme: keys had no visible borders, making it hard to distinguish individual keys; key drawables now use shapes with a 1dp stroke
- CI workflow was naming release APKs `hackerskeyboard-*`; renamed to `corekeyboard-*`

### Changed
- Replaced old grey "Esc" launcher icon with adaptive vector icon matching codevoid brand identity (orange key grid with spacebar on dark background)
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
