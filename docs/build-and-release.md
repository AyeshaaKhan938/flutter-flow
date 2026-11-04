# Build and release

## Prerequisites

| Tool | Version / notes |
|---|---|
| Flutter | Stable channel. Last verified with Flutter 3.44.3. Dart SDK `>=3.0.0 <4.0.0` |
| Android | Android Studio + SDK; compileSdk/targetSdk **36**; NDK `28.2.13676358`; JDK 17 |
| iOS | macOS + Xcode (current), CocoaPods; deployment target **iOS 14.0** |
| Firebase CLI | `npm i -g firebase-tools` (only needed to deploy rules or functions) |
| Accounts | Google Play Console (Kingdom Heirs org), Apple Developer Program (Kingdom Heirs org), Firebase project access |
| Secrets | None in the app. The API.Bible key is in Secret Manager (`API_BIBLE_KEY`), read only by the `getBiblePassage` Cloud Function. |

```sh
flutter pub get
cd ios && pod install && cd ..        # iOS only
flutter run
```

## Build commands

The app needs no build-time keys (see the [README](../README.md#api-keys)):

```sh
flutter build apk        --release   # sideload / testing
flutter build appbundle  --release   # Google Play (.aab)
flutter build ipa        --release   # App Store / TestFlight
```

Outputs: `build/app/outputs/flutter-apk/app-release.apk`,
`build/app/outputs/bundle/release/app-release.aab`, and `build/ios/ipa/*.ipa`.

## Versioning

`pubspec.yaml` → `version: 1.0.0+1`. The part before `+` is the user-visible version
(Android `versionName`, iOS `CFBundleShortVersionString`). The part after it is the build
number (Android `versionCode`, iOS `CFBundleVersion`).

- **Raise the build number for every upload.** Both stores reject a build number they
  have already seen.
- You can override it per build: `--build-name=1.0.1 --build-number=7`.
- Record each release in a tag: `git tag v1.0.1+7`.
- FlutterFlow may overwrite `version` on a sync, so check it before each build.

## Android signing

The upload keystore is **not in the repo** and must never be committed. Store it, and its
passwords, in the Kingdom Heirs password manager, with an offline backup.

1. Create the keystore (once):
   ```sh
   keytool -genkey -v -keystore ~/kingdom-heirs-upload.jks -keyalg RSA -keysize 2048 \
     -validity 10000 -alias upload
   ```
2. Create `android/key.properties`. It is **not committed**, but it is currently **not in
   `.gitignore`**, so add `android/key.properties` and `*.jks` there before creating it.
   ```properties
   storePassword=<from password manager>
   keyPassword=<from password manager>
   keyAlias=upload
   storeFile=/absolute/path/to/kingdom-heirs-upload.jks
   ```
   (A relative `storeFile` path is resolved from `android/app/`.)
3. `android/app/build.gradle` signs release builds with `signingConfigs.release` when
   `android/key.properties` exists, and falls back to the debug key otherwise, which Play
   rejects. `key.properties`, `*.jks` and `*.keystore` are gitignored. FlutterFlow syncs
   may revert the Gradle change (see [architecture.md](architecture.md#flutterflow-sync-caveat)).
4. Verify the signature: `keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab`.
5. Turn on **Play App Signing** (the default for new apps). Google keeps the app signing
   key, and your keystore is only the *upload* key. If the upload key is lost, you can
   reset it through Play Console support.
6. Add the upload and app-signing SHA-1/SHA-256 fingerprints (Play Console → App integrity)
   to the Firebase Android app. Some Firebase features need them.

## Google Play: Internal Testing

1. Play Console → **Create app** (name "Kingdom Heirs", package `com.kingdomheirs.discipleship`). Once set, the package name cannot change.
2. Complete **App content**: privacy policy URL, data safety (email, name, reflections,
   survey answers, push tokens), content rating, target audience, and ads (none).
3. **Testing → Internal testing → Create new release**, then upload `app-release.aab`, add release notes, and save.
4. **Testers**: create an email list (up to 100) and share the opt-in link.
5. Review and roll out. Internal testing builds are usually available within minutes.
6. To promote, go to Closed/Open testing → Production. New personal developer accounts must
   run a closed test before production. Organisation accounts are exempt; check your
   account type.

## iOS signing and TestFlight

The iOS app uses the bundle id of the existing App Store Connect record
**Kingdom Heirs Discipleship** (Apple ID 6807216829): **`com.kingdomheirsfoundation.kingdomheirs`**.
Never create another app record or bundle id. The Android application id stays
`com.kingdomheirs.discipleship`. The Firebase iOS app for this bundle id is
"Kingdom Heirs Discipleship App Store", and `ios/Runner/GoogleService-Info.plist` comes
from it.

Capabilities: **Push Notifications** (on the App ID) and **Background Modes → Remote
notifications** (set in `Info.plist`). Nothing else: no Sign in with Apple (email login
only), Associated Domains, App Groups or iCloud. The project has one target, Runner; the
image notification extension was removed for Phase 1.

Steps:
1. Apple Developer (Kingdom Heirs team) → Identifiers: enable **Push Notifications** on
   `com.kingdomheirsfoundation.kingdomheirs`.
2. **APNs key**: Keys → create a key with Apple Push Notifications service. Download the
   `.p8` file (you can download it only once). Store it with its Key ID and your Team ID in
   the password manager. Upload it in Firebase console → Project settings → Cloud Messaging
   → Apple app configuration.
3. Signing is manual. Kingdom Heirs creates an **Apple Distribution** certificate from the
   build Mac's CSR and an App Store profile named **Kingdom Heirs Discipleship App Store**,
   and sends the `.cer` and `.mobileprovision` files. The private key never leaves the
   build Mac. No App Store Connect API key is used.
4. `ios/Runner/Runner.entitlements` has `aps-environment = development`. When you archive
   with App Store distribution, Xcode sets it to `production` in the exported build. If
   push works in debug but not in TestFlight, check this setting and the APNs key upload
   first.
5. The App Store Connect record already exists. Upload to it; do not create a new one.
6. Build and upload: run `flutter build ipa --release`,
   then upload `build/ios/ipa/*.ipa` with **Transporter** or `xcrun altool`. You can also
   archive in Xcode (Product → Archive → Distribute App → App Store Connect).
7. TestFlight: `Info.plist` sets `ITSAppUsesNonExemptEncryption = false` (standard HTTPS
   only), so there is no export-compliance question. Keep builds in **internal** testing
   until Kingdom Heirs approves a release in writing. Add internal testers (team members) right away. **External** testers require Beta App
   Review.
8. For App Store submission you also need screenshots, a privacy policy URL, App Privacy
   answers, a **demo account** for Apple review (email and password for a test member), and
   the Sign in with Apple rule. That rule applies only if you add third-party login;
   email-only login is fine.

## Release checklist

- [ ] `git pull`. If a FlutterFlow sync landed, re-apply the hand edits ([architecture.md](architecture.md#flutterflow-sync-caveat))
- [ ] Bump `version` in `pubspec.yaml`
- [ ] `android/key.properties` exists, so release builds use the upload key
- [ ] Smoke test in all four languages (Urdu RTL), and test offline mode
- [ ] Build the `.aab` and `.ipa`, then upload to Internal Testing and TestFlight
- [ ] Tag the commit
