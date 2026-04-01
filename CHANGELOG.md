# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Added
- Nightly CI workflow (`.github/workflows/nightly.yml`): builds a signed release APK daily at 02:00 UTC and publishes it to the `nightly` pre-release on GitHub.
- ProGuard/R8 keep rules in `app/proguard-rules.pro` for JNI entry points (`BinaryDictionary`), XML-inflated views (`LatinKeyboardView`, `CandidateView`), and custom preference widgets.

### Changed
- Release build now has `minifyEnabled true` with `proguard-android-optimize.txt` (previously shrinking was disabled).
- Signing config reads from environment variables (`KEYSTORE_PATH`, `KEYSTORE_PASSWORD`, `KEY_ALIAS`, `KEY_PASSWORD`); unsigned local builds continue to work without those variables set.
