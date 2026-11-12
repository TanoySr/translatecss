# Android-এ Build করার সহজ গাইড (BUILD_ANDROID)

## যা যা লাগবে

1. **Flutter (Stable)** — Windows গাইডের মতোই Install করুন
   ([BUILD_WINDOWS.md](BUILD_WINDOWS.md))।
2. **Android Studio (ফ্রি)** — https://developer.android.com/studio
   Install করার সময় Android SDK, Platform-Tools ও Emulator আসবে।
3. Android Studio খুলে SDK Manager থেকে একটি Android SDK
   (API 34 বা তার উপরে) Install আছে কিনা দেখুন।

```bat
flutter doctor
```

Android toolchain-এর পাশে ✓ এলে প্রস্তুত। License চাইলে:

```bat
flutter doctor --android-licenses
```

সবগুলোতে `y` চাপুন।

## প্রথমবার Project চালানো

```bat
cd garment_pos
flutter create --platforms=android,windows --project-name garment_pos .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

ফোন USB দিয়ে PC-তে লাগিয়ে (USB Debugging ON করে) বা Emulator
দিয়ে চালাতে পারবেন।

## Final Android Build (APK)

```bat
flutter build apk --release
```

APK পাবেন এখানে:

```
build\app\outputs\flutter-apk\app-release.apk
```

এই ফাইলটি ফোন/ট্যাবে কপি করে Install করলেই App চলবে — কোনো
Internet লাগবে না।

## দ্রষ্টব্য

- Play Store-এ দেওয়ার আগে Release Signing দরকার হয়; দোকানের
  নিজের ফোনে সরাসরি APK Install করতে Signing লাগে না (Debug
  key দিয়েই Build হয়)।
- কোনো লাল Error এলে পুরো লেখাটি কপি করে Agent-কে পাঠান।
