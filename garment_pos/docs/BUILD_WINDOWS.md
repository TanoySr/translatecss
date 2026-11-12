# Windows-এ Build করার সহজ গাইড (BUILD_WINDOWS)

এই App-টি আপনি আপনার নিজের Windows PC-তে Build করবেন। নিচের ধাপগুলো
একবার করলেই হবে।

## যা যা লাগবে

1. **Flutter (Stable)** — https://docs.flutter.dev/get-started/install/windows
   থেকে Download করে `C:\flutter` -এ রাখুন এবং PATH-এ `C:\flutter\bin` যোগ করুন।
2. **Visual Studio 2022 (Community — ফ্রি)** —
   https://visualstudio.microsoft.com থেকে Installer চালানোর সময়
   অবশ্যই **"Desktop development with C++"** Workload-টি টিক দিন।
   এটা ছাড়া Windows Build হবে না।
3. **Git** — https://git-scm.com/download/win

## পরীক্ষা করুন সব ঠিক আছে কিনা

Command Prompt-এ লিখুন:

```bat
flutter doctor
```

Windows ও Visual Studio-র পাশে ✓ দেখালে সব প্রস্তুত।

## প্রথমবার Project চালানো

```bat
cd garment_pos
flutter create --platforms=android,windows --project-name garment_pos .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d windows
```

> `flutter create .` শুধু `windows/` ও `android/` Folder তৈরি করে —
> আপনার `lib/`-এর কোনো Code বদলায় না।

## Final Windows Build (দোকানের PC-র জন্য)

```bat
flutter build windows --release
```

তৈরি হওয়া App পাবেন এখানে:

```
build\windows\x64\runner\Release\garment_pos.exe
```

`Release` Folder-টি পুরোটা কপি করে দোকানের PC-তে রাখলেই চলবে
(সঙ্গে থাকা .dll ফাইলগুলো বাদ দেবেন না)।

## সমস্যা হলে

- "Visual Studio not found" → Visual Studio Installer থেকে
  "Desktop development with C++" যোগ করুন।
- কোনো লাল Error এলে পুরো লেখাটি কপি করে Agent-কে পাঠান।
