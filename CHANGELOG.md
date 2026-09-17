## 0.1.8 (Cinefly fork)

- Android: `kotlin-android` is now applied conditionally — `if (agpMajor < 9 || !builtInKotlin)` — so the module builds under AGP 9 when the consuming app runs with `android.builtInKotlin=true` (built-in Kotlin), where applying KGP is a hard error. Gating on the AGP major version alone is not enough: Flutter 3.47's own template ships AGP 9 with `builtInKotlin=false`, and that combination still needs KGP applied here. See `FORK.md`.
- Android: `kotlinOptions { jvmTarget = "17" }` inside `android {}` replaced with a guarded `kotlin { compilerOptions { jvmTarget } }` block outside it — under built-in Kotlin the `kotlin` extension does not exist, and AGP derives the target from `compileOptions.targetCompatibility`.

## 0.1.7 (Cinefly fork)

Maintenance release for the Cinefly fork — see `FORK.md`.

- Android module modernised: `plugins {}` DSL with no pinned AGP classpath (the
  consuming app's AGP governs), `compileSdk` 37, `minSdk` 24, Java 17
  source/target, `lint` block, unconditional `namespace`; the legacy
  `buildscript`/`allprojects` blocks were removed and the manifest `package`
  attribute was dropped in favour of the Gradle namespace.
- Gradle wrapper bumped 8.10 → 9.7.1 for standalone resolution.
- iOS SPM manifest aligned with the canonical Flutter plugin template: the
  `FlutterFramework` path dependency is declared (rewritten by `flutter_tools`
  at integration) and the deployment target raised to iOS 15.0.
- Podspec: deployment target 12.0 → 15.0, Swift 5.9, metadata repointed at the
  fork (kept for CocoaPods consumers).
- Dart SDK constraint raised `>=3.4.0 <4.0.0` → `>=3.10.0 <4.0.0`; Flutter
  constraint `>=3.3.0` → `>=3.32.0`.
- Swift import audit: every source file carries explicit imports (includes the
  upstream Foundation-import fix for SPM builds).

## 0.1.6

- Add `getFrame` API to extract raw RGBA8888 video frame pixels on Android and iOS.
- Preserve the source video frame rate on iOS when exporting transformed videos such as merge, scale, rotate, flip, and crop.

## 0.1.5

- Add Swift Package Manager support for the iOS plugin while keeping CocoaPods compatibility.
- Remove production `print` calls from `VideoEditorBuilder` so package analysis is clean.

## 0.1.4

- Improve video merge output on Android and iOS by preserving display orientation and fitting mixed-size videos into an even-sized canvas.
- Fix operation cleanup so completed operations are unregistered without triggering cancellation behavior.
- Add Android unit coverage for operation unregister and inactive-scope cleanup.

## 0.1.3

- Add exactFrame option for generate thumbnail

## 0.1.2

- Fix generate thumbnail issue on Android

## 0.1.1

- Fix compress video issue on Android and change logic compress video

## 0.1.0

- Fix compress video issue on Android

## 0.0.9

- Fix compress video issue

## 0.0.8

- Add flip video method

## 0.0.7

- Fix rotation issue

## 0.0.6

- Add creationDate to getVideoMetadata output
- Fix rotation issue
- Downgrade media3 version support SDK 34

## 0.0.5

- Add Progress callback when export video
- Fix lost audio when crop video

## 0.0.4

- Add method to retrieve video metadata (duration, dimensions, title, author, orientation, file size)
- Add method to cancel current operation

## 0.0.3

- Fix rotation issue
- Add option output path for export
- Add option output path for extract audio
- Add option output path for generate thumbnail
- Update README.md

## 0.0.2

- Update README.md

## 0.0.1

Initial release of Easy Video Editor - A lightweight Flutter plugin for video editing without FFmpeg dependency.

Key features:

- Video trimming

  - Cut and trim videos at specified timestamps
  - Real-time preview support

- Video compression

  - Compress videos with customizable quality
  - Multiple resolution options
  - Maintain aspect ratio

- Video cropping

  - Crop videos to desired dimensions
  - Custom aspect ratio support

- Speed adjustment

  - Change video playback speed
  - Support for both slow motion and fast forward

- Video merging

  - Combine multiple video clips
  - Seamless transition between clips

- Audio features

  - Extract audio from video
  - Mute/unmute video

- Platform support:

  - iOS implementation (iOS 13.0+)
  - Android implementation

- Example app included with all feature demonstrations
