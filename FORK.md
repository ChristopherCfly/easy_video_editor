# Fork of `iawtk2302/easy_video_editor`

This repository is a fork of [iawtk2302/easy_video_editor](https://github.com/iawtk2302/easy_video_editor) (MIT License, Copyright (c) 2024 Easy Video Editor). The original `LICENSE` and copyright notice are preserved unchanged.

**Why this fork exists:** the published pub.dev release `0.1.6` does not compile under current Xcode / Swift. Its `OperationManager.swift` had zero import statements while using `DispatchWorkItem`, `DispatchQueue`, and `UUID`; older Swift leaked Foundation across files within a module, current Swift does not, so iOS archives fail with `Cannot find type 'DispatchWorkItem' in scope` and friends. The fix exists on upstream `main` (merged as upstream PR #44, 2026-07) but has never been published to pub.dev — the last publish was `0.1.6` on 2026-06-01. We are blocked on an unresponsive publish cadence, not on an unsolved problem. The Cinefly app tracks this work as cinefly/cinefly_app_flutter_v2 issue #882.

Consumed by the app via `dependency_overrides` pinned to a full commit SHA.

## Changes vs upstream (0.1.6 published / `main` tip at fork time)

### Android (`android/`)

| Property | Upstream | Fork |
|---|---|---|
| Plugin application | `buildscript` classpath AGP `7.3.0` / Kotlin `1.7.10` + `apply plugin:` | `plugins {}` DSL, no version pinned — the consuming app's AGP governs when consumed as an included subproject; standalone builds resolve AGP `9.4.0` / Kotlin `2.4.20` via `settings.gradle` `pluginManagement` |
| `compileSdk` | 35 | 37 |
| `minSdk` | 21 | 24 (matches consuming app) |
| `compileOptions` / `jvmTarget` | Java 1.8 | Java 17 (AGP 9 JDK floor) |
| Lint | none | `lint { disable 'InvalidPackage' }` (modern `lint` block, not the deprecated `lintOptions`) |
| `namespace` | conditional on `hasProperty` | unconditional Gradle `namespace`; manifest `package` attribute removed |
| Gradle wrapper | 8.10 | 9.7.1 |
| Repositories | plugin-local `buildscript`/`allprojects` blocks | removed; standalone resolution via `dependencyResolutionManagement` in `settings.gradle` |

The legacy `buildscript {}` and `allprojects {}` blocks were deleted entirely.

#### Built-in Kotlin gate (consuming-app issue #905)

`kotlin-android` is no longer applied unconditionally. From AGP 9 onward Kotlin may be compiled by AGP's **built-in Kotlin**, and applying KGP on top of that is a hard error. The apply is now guarded:

```groovy
def agpMajor = com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION.tokenize('.')[0] as int
def builtInKotlin = project.findProperty('android.builtInKotlin')?.toString()?.toBoolean() ?: false
if (agpMajor < 9 || !builtInKotlin) {
    apply plugin: 'kotlin-android'
}
```

The `android.builtInKotlin` half of that condition is the part that matters. Gating on `agpMajor < 9` alone — which is what `stripe_android` 14.0.x does — is not enough, because a consuming app can be on AGP 9 while still running `android.builtInKotlin=false`. That is precisely what Flutter 3.47's own `flutter create` template ships. In that combination the guarded-out module leaves `jvmTarget` unset, KGP lets it track the JDK running Gradle, and AGP 9's target-consistency validation fails the consumer's build.

`kotlinOptions { jvmTarget = "17" }` inside `android {}` was replaced with a guarded `kotlin { compilerOptions { jvmTarget } }` block outside it, for the same reason: under built-in Kotlin the `kotlin` extension does not exist, and AGP derives the target from `compileOptions.targetCompatibility` instead.

**Standalone module builds are not expected to fully succeed** (same as upstream): the plugin compiles against the Flutter embedding and androidx classpath supplied by the consuming Flutter app. Verification is done through the consuming app's build (`flutter build appbundle`), not `cd android && ./gradlew assemble`. The `settings.gradle` `pluginManagement`/`dependencyResolutionManagement` blocks are provided so tooling can resolve the module in isolation (without `dependencyResolutionManagement`, AGP 9's injected `kotlin-stdlib` fails with "no repositories are defined").

### iOS — Swift Package Manager (`ios/`)

- `Package.swift` aligned with the canonical Flutter SPM plugin template: the `FlutterFramework` path dependency is declared exactly as templated (`flutter_tools` rewrites it at integration time) and wired into the target's dependencies.
- SPM `platforms` raised `.iOS("13.0")` → `.iOS("15.0")` (matches the consuming app's Podfile target).
- Podspec **kept** for CocoaPods consumers: deployment target `12.0` → `15.0`, `swift_version` `5.0` → `5.9`, version aligned to `0.1.7`, homepage/source repointed at this fork. `source_files` already matched the SPM `Sources/` layout (pure Swift, no ObjC headers, so no `include/` directory is needed).

### Swift import audit (the actual bug)

Every Swift file under `Sources/easy_video_editor/` was audited for implicit-import reliance. The upstream Foundation-import fix (upstream PR #44) is included on this fork's default branch and covers the three files that lacked any import (`OperationManager.swift`, `ProgressManager.swift`, `Command.swift`). All remaining files import `Flutter`, `AVFoundation`, or `UIKit`, which re-export Foundation through their module maps — legitimate module behaviour, not whole-module-optimisation leakage — so no further import changes were required.

### Native C dependency decision

None. This plugin has no vendored native C libraries (no libwebp-style dependency): iOS is pure Swift over AVFoundation/AVKit/UIKit, Android is Kotlin over AndroidX Media3 and the `transcoder` Maven artifact. There is no exotic-format gap between the CocoaPods and SPM integrations, so no availability-gating macro is needed — both integrations have identical format support.

### Dart package

| Property | Upstream | Fork |
|---|---|---|
| `version` | 0.1.6 | 0.1.7 |
| `environment.sdk` | `>=3.4.0 <4.0.0` | `>=3.10.0 <4.0.0` (current; satisfies the consuming app's `^3.10.3`) |
| `environment.flutter` | `>=3.3.0` | `>=3.32.0` |
| `homepage` / `repository` / `issue_tracker` | upstream URLs | this fork |

## Retiring this fork

This fork is meant to be temporary. If upstream publishes a release that includes the Foundation-import fix and modern native configuration, the app should switch back to pub.dev and this fork be retired. **No upstream PR has been opened from this fork** — the fork exists for consumption only, and contributing upstream is an owner decision that has deliberately not been taken (the fix already exists on upstream `main` anyway; the gap is publishing, not code).
