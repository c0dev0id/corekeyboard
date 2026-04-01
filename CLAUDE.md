# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Constraints

**Do not attempt to build this project locally.** All builds are handled by CI/CD. AGP (Android Gradle Plugin) cannot be accessed due to firewall restrictions — do not try to work around this.

## Project Overview

Hacker's Keyboard is an Android IME (Input Method Editor) — a soft keyboard app. It provides a desktop-style 5-row layout with number row, arrow keys, and function keys. The codebase is legacy Java (Java 7 style, Android API 14+) with native C++ for dictionary operations. Package: `org.pocketworkstation.pckeyboard`.

## Architecture

The app follows a layered IME architecture:

### Core Input Flow
1. **`LatinIME.java`** — The `InputMethodService` subclass. Central hub: receives all key events, manages suggestion state, dispatches vibration/sound feedback, reads settings. Most feature work touches this file.
2. **`LatinKeyboardSwitcher.java`** — Manages transitions between keyboard modes (alpha, symbols, phone, etc.) and layout variants (full/compact, 4-row/5-row).
3. **`PointerTracker.java`** — Handles raw multitouch events; tracks individual fingers, detects long-press and slide-off behaviors. Feeds into `LatinKeyboardView`.

### Keyboard Model & Rendering
- **`Keyboard.java`** — Parses keyboard layout XML into `Key` objects. Base class shared across layout variants.
- **`LatinKeyboard.java`** — Extends `Keyboard` with rendering-specific state: shift/caps indicators, Enter key label changes (Go/Search/Send/Done), language display on space bar.
- **`LatinKeyboardBaseView.java`** / **`LatinKeyboardView.java`** — Custom `View` subclasses that draw the keyboard and dispatch touch events to `PointerTracker`.

### Suggestion Engine
- **`Suggest.java`** — Orchestrates word suggestions: queries dictionaries, applies proximity correction, ranks candidates.
- **`BinaryDictionary.java`** — JNI wrapper around the native dictionary. Loads the binary trie from `res/raw/main.dict`.
- **`dictionary.cpp`** — Native C++ trie search with frequency scoring and bigram support. Built as `libjni_pckeyboard.so` via CMake (`app/CMakeLists.txt`).
- `UserDictionary`, `AutoDictionary`, `ContactsDictionary`, `UserBigramDictionary` — supplementary dictionary sources merged by `Suggest`.

### Text Composition
- **`WordComposer.java`** — Accumulates key strokes into the current word being typed; tracks proximity data for correction.
- **`ComposeSequence.java`** / **`DeadAccentSequence.java`** — Handle multi-keypress composition sequences (dead keys, accent combinations). `LatinIME` implements `ComposeSequencing`.

### Settings & Configuration
- **`GlobalKeyboardSettings.java`** — Singleton holding all runtime-readable preferences; loaded from `SharedPreferences`.
- **`LatinIMESettings.java`** — `PreferenceActivity` for the settings screen.
- **`LanguageSwitcher.java`** — Resolves the active input language and maps it to keyboard layout resources.

### Native Build
CMake target defined in `app/CMakeLists.txt`. Sources are in `app/src/main/jni/`. The JNI entry point is `org_pocketworkstation_pckeyboard_BinaryDictionary.cpp`.

## Key Resource Conventions

**Keyboard layouts** live in `app/src/main/res/xml/`:
- `kbd_full.xml` — 5-row desktop layout (primary)
- `kbd_compact.xml` — 4-row compact variant
- `kbd_extension_full.xml` / `kbd_extension.xml` — Extended key rows
- `kbd_popup_*.xml` — Long-press popup character sets per key

**Per-language overrides** use `xml-<locale>/` resource directories (e.g., `xml-ru/` for Russian). These override the default XML layouts for that locale.

**Themes** are declared as separate input view layouts: `res/layout/input_material_light.xml`, `input_material_dark.xml`, etc. The active theme is selected by `LatinKeyboard` at inflation time.

## Validation Scripts

The `java/` directory contains helper scripts for validating keyboard layout maps:
- `CheckMaps.sh` / `CheckMap.pl` — Verify that key popup maps are consistent across layout files.
- `AddMissing.pl` — Identifies missing characters in dictionary coverage.

Run these directly with `perl` / `sh` if verifying layout changes.

## CI / Nightly Releases

`.github/workflows/nightly.yml` runs daily at 02:00 UTC and publishes a signed release APK to the `nightly` pre-release tag on GitHub. It requires four repository secrets:

| Secret | Content |
|---|---|
| `KEYSTORE_BASE64` | Base64-encoded `.jks` keystore file |
| `KEYSTORE_PASSWORD` | Keystore store password |
| `KEY_ALIAS` | Key alias within the keystore |
| `KEY_PASSWORD` | Key password |

The release build has `minifyEnabled true` with `proguard-android-optimize.txt`. Keep rules for JNI entry points and XML-instantiated views/preferences are in `app/proguard-rules.pro`.

## Known Constraints

- `minSdkVersion 14`, `targetSdkVersion 26` — The codebase uses pre-AndroidX support libraries (`android.support.*`). Do not migrate to AndroidX without a full audit.
- Lint is disabled for release builds (`checkReleaseBuilds false`). Running `./gradlew lint` will still produce reports for debug builds.
- There are no unit tests in the repository. Instrumented test infrastructure (`espresso-core`) is declared but no test classes exist.
