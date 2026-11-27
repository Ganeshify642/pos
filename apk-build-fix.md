# APK build fix

## Goal
Restore the Android release build and produce an installable APK.

## Tasks
- [x] Reproduce the release build failure and identify the failing toolchain check.
- [x] Update the Gradle wrapper to Flutter's required minimum version.
- [x] Run static analysis after the fix; no compile errors were reported.
- [x] Run the Flutter test suite; all tests pass.
- [x] Build the release APK and verify the output file.

## Done When
- [x] `flutter build apk --release` succeeds and the APK exists in `build/app/outputs/flutter-apk/`.
