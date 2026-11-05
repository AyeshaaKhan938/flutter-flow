# Build and deploy

Phase 1 handover, Kingdom Heirs Discipleship app. Written 2 November 2026 from the code on
`main`. More detail on store setup is in [../build-and-release.md](../build-and-release.md).

| | |
|---|---|
| Android application id | `com.kingdomheirs.discipleship` |
| iOS bundle id | `com.kingdomheirsfoundation.kingdomheirs` (existing App Store Connect record, Apple ID 6807216829) |
| Firebase / Google Cloud project | `kingdom-heirs-discipleshipapp`, region `us-central1` |
| Version | Release candidate **1.0.6 (8)**. `pubspec.yaml` still says `1.0.0+1`, so pass `--build-name 1.0.6 --build-number 8` (raise the number for every upload) |
| Repository | `github.com/AyeshaaKhan938/flutter-flow` (public; must move to Kingdom Heirs, see [OWNERSHIP_CHECKLIST.md](OWNERSHIP_CHECKLIST.md)) |

## 1. Prerequisites

| Tool | Version |
|---|---|
| Flutter | Stable channel, last built with **Flutter 3.44.3**. Dart SDK `>=3.0.0 <4.0.0` (`pubspec.yaml`). The repo has no `.metadata` file, so the version is not pinned. |
| Xcode | **26.x**, on macOS, for iOS builds |
| CocoaPods | Any recent version (1.17.0 was used). iOS deployment target is **14.0** (`ios/Podfile`) |
| Android | Android Studio + SDK, compileSdk/targetSdk **36**, JDK 17 |
| Node.js | **22** (`firebase/functions/package.json` → `engines.node`). Only needed to deploy functions |
| Firebase CLI | `firebase-tools`, run with `npx firebase-tools …` or `npm i -g firebase-tools`. Sign in with a Kingdom Heirs account that has Owner or Editor on the project |
| Python 3 | Only for the helper scripts in `tools/` |

First run:

```sh
flutter pub get
cd ios && pod install && cd ..
flutter run
```

**Secrets.** The app has no build-time keys. Never commit secrets. Where they live:

- API.Bible key: Google Secret Manager, secret **`API_BIBLE_KEY`**, read only by the
  `getBiblePassage` function.
- `api_keys.json`: an old local key file. It is gitignored and the current code no longer
  reads it.
- Android upload keystore and `android/key.properties`: not created yet (see 4).
- APNs key (`.p8`): Apple Developer account, uploaded to Firebase Cloud Messaging.
- Firebase client config (`android/app/google-services.json`,
  `ios/Runner/GoogleService-Info.plist`) is committed. It is not secret, but restrict the
  API keys in Google Cloud console → Credentials.

## 2. Branch workflow (read before touching FlutterFlow)

There are two branches:

| Branch | What goes there |
|---|---|
| `flutterflow` | Only FlutterFlow's **Push to Repository** output. Never commit to it by hand. |
| `main` | All hand-written code: Bible, offline cache, admin pages, Ask Kingdom Heirs, certificates, Cloud Functions, rules, docs. **Build releases from `main`.** |

FlutterFlow regenerates the whole project on every push. It overwrites hand edits and
**deletes files it does not know about**. This wiped hand-written code three times before
the two-branch setup. After each FlutterFlow push:

```sh
git checkout main
git pull origin main
git fetch origin
git merge origin/flutterflow
```

Then review the merge carefully. If the merge deletes or reverts hand-written files
(anything in `lib/custom_code/`, `lib/admin_*`, `lib/rag_search_page/`,
`lib/certificate_page/`, `firebase/`, `docs/`, `android/app/build.gradle`), keep the `main`
version. Build, smoke test, then push `main`.

Do not deploy Firestore rules or Cloud Functions from FlutterFlow. FlutterFlow would
replace them with its own generated versions. Deploy them with the Firebase CLI (sections
6 and 7).

## 3. Version number

Raise the build number (after `+`) for every store upload, either in `pubspec.yaml` or
per build with `--build-name=1.0.1 --build-number=7`. A FlutterFlow merge can reset
`version`, so check it before each build.

## 4. Android

```sh
flutter build apk --release         # APK for sideloading and testers
flutter build appbundle --release   # AAB for Google Play
```

Outputs: `build/app/outputs/flutter-apk/app-release.apk` and
`build/app/outputs/bundle/release/app-release.aab`.

**Signing: action needed.** `android/app/build.gradle` signs release builds with
`android/key.properties` when that file exists, and with the **debug key** otherwise.
`android/key.properties` does not exist yet, so current release builds are debug-signed.
That is fine for testers, but **Google Play rejects it**. Before the first Play upload,
Kingdom Heirs must:

1. Create an upload keystore (once):
   ```sh
   keytool -genkey -v -keystore ~/kingdom-heirs-upload.jks -keyalg RSA -keysize 2048 \
     -validity 10000 -alias upload
   ```
2. Create `android/key.properties` (already gitignored, as is `*.jks`):
   ```properties
   storePassword=<from the Kingdom Heirs password manager>
   keyPassword=<from the Kingdom Heirs password manager>
   keyAlias=upload
   storeFile=/absolute/path/to/kingdom-heirs-upload.jks
   ```
3. Keep the keystore and passwords in the Kingdom Heirs password manager plus an offline
   backup. Turn on Play App Signing, so a lost upload key can be reset.
4. Add the SHA-1 and SHA-256 fingerprints from Play Console → App integrity to the
   Firebase Android app.

Play Console setup and Internal Testing steps:
[../build-and-release.md](../build-and-release.md#google-play-internal-testing).

## 5. iOS and TestFlight

1. Signing is manual: Kingdom Heirs creates the Apple Distribution certificate and the
   **Kingdom Heirs Discipleship App Store** provisioning profile and sends the `.cer` and
   `.mobileprovision` files; the private key stays on the build Mac. The project has a
   single target (**Runner**). There is no notification extension (see
   [../notifications-and-assistant.md](../notifications-and-assistant.md#future-enhancement-image-notifications)).
2. Confirm the Push Notifications and Background Modes → Remote notifications capabilities,
   and that the APNs key is uploaded in Firebase → Project settings → Cloud Messaging.
3. Build:
   ```sh
   flutter build ipa --release --build-name 1.0.6 --build-number 8
   ```
   Output: `build/ios/ipa/*.ipa`.
4. Upload with Apple's **Transporter** app, or archive in Xcode (Product → Archive →
   Distribute App → App Store Connect).
5. In App Store Connect → TestFlight, add internal testers. `Info.plist` already declares
   standard encryption only, so there is no export compliance question. Builds stay in
   **internal** testing until Kingdom Heirs approves a release in writing.

Full steps (bundle ids, APNs key, App Store review needs):
[../build-and-release.md](../build-and-release.md#ios-signing-and-testflight).

## 6. Cloud Functions

Source: `firebase/functions/` (Node 22, codebase name **`functions`** in
`firebase/firebase.json`). Deploy from the `firebase/` folder, **one function at a time by
name**:

```sh
cd firebase
npx firebase-tools deploy --only functions:functions:<name> --project kingdom-heirs-discipleshipapp
# several at once:
npx firebase-tools deploy --only functions:functions:askKingdomHeirs,functions:functions:askConfig --project kingdom-heirs-discipleshipapp
```

The first `functions` is the product, the second is the codebase name, and the third
part is the function name.

Functions in this repo (all deployed as of 2 November 2026):

| Function | Type | Purpose |
|---|---|---|
| `addFcmToken` | callable | Saves a device's push token |
| `sendPushNotificationsTrigger` | Firestore trigger on `ff_push_notifications` | Sends a push (with language, pathway and timezone targeting) |
| `sendScheduledPushNotifications` | scheduled, hourly | Sends scheduled pushes |
| `onUserDeleted` | Auth trigger | Deletes `users/{uid}` when an account is deleted |
| `getBiblePassage` | callable | Fetches Scripture from API.Bible using `API_BIBLE_KEY` |
| `importContentCsv` | callable | CMS import (CSV, Excel, ZIP) |
| `translateTexts` | callable | Machine translation via Google Cloud Translation |
| `askKingdomHeirs` | callable | Ask Kingdom Heirs answers |
| `ingestResearchSections` | callable, admin only | Adds a source to the Ask library |
| `setResearchSourceStatus` | callable, admin only | Approves or withdraws a library source |
| `askConfig` | callable, admin only | Reads or changes `config/askKingdomHeirs` |
| `reportAskIssue` | callable | Saves a member's "Report an issue" to `askReports` |
| `onAskBudgetAlert` | Pub/Sub `ask-kingdom-heirs-budget` | Pauses Ask when the budget is reached |

**Other functions in the same project are not in this repo.** The Firebase project also
runs 22 older functions (v2, Node 20), most of which the app still calls, for example
`getUserProfile`, `getTodayContent`, `getPathwayProgress`, `saveLessonProgress`, `getQuiz`,
`submitQuizAttempt`, `submitAssessment`, `publishAnnouncement`, `getAdminReport` and
`importCurriculum`. List them with `npx firebase-tools functions:list`. Their source code
must be obtained from whoever wrote them (see [OWNERSHIP_CHECKLIST.md](OWNERSHIP_CHECKLIST.md)).
Deploying by name, as above, never touches them. Do **not** run a bare
`firebase deploy --only functions`.

**Runtime risk.** All 22 of these run on Node.js 20, which Google decommissioned for Cloud
Functions on 30 October 2026. They were still deployed on 5 November 2026, but they cannot
be changed or redeployed on Node 20, and Google may stop running them. Recovering their
source and moving them to Node 22 (or replacing them with functions in this repo) is the
most important follow-up after Phase 1.

## 7. Firestore rules and indexes

Source: `firebase/firestore.rules` and `firebase/firestore.indexes.json`.

```sh
cd firebase
npx firebase-tools deploy --only firestore:rules --project kingdom-heirs-discipleshipapp
npx firebase-tools deploy --only firestore:indexes --project kingdom-heirs-discipleshipapp
```

The rules make content writable only by admins (`users/{uid}.role` = `admin` or
`ministry_reviewer`), keep reflections and certificates private to their owner, and block
all client access to the Ask library, Ask logs, reports and `config/askKingdomHeirs`.
Compare with Firebase console → Firestore → Rules before deploying, in case someone
changed the live rules there.

## 8. Content import

Staff import content in the app: **Profile → Manage Content (Admin) → calendar icon (Daily
Content) → upload icon (Import Content)**, or route `/admin/import`. The page calls the
`importContentCsv` callable. It accepts UTF-8 CSV, the original Excel master (`.xlsx`) and
the CSV handoff `.zip`, for pathways, lessons, quiz questions, Daily Scripture,
encouragements and assessment questions. Every run is logged in `importJobs`. Templates
and rules: [../import/README.md](../import/README.md). Staff steps:
[ADMIN_GUIDE.md](ADMIN_GUIDE.md#importing-content).

## 9. Ask Kingdom Heirs

### The library

Answers come only from sections stored in `researchSources` and `researchSections`
(server-only; clients cannot read them). Each section is embedded with Vertex AI
`text-multilingual-embedding-002`. Answers use `gemini-2.5-flash`, with
`gemini-2.5-flash-lite` as the fallback.

Source material lives in **`content_private/`**, which is **gitignored** and not in the
repository. Kingdom Heirs must keep its own copy:

- Book manuscripts: `content_private/manuscripts/`. Split them into sections with
  `python3 tools/manuscript_sections.py` (needs `pypdf`). The output goes to
  `content_private/manuscripts/sections/<sourceId>.jsonl`.
- App Help (how the app works, plus Safety & Boundaries):
  `content_private/app_help/app_help.json`, source id `kh-app-help`.

Load a source with the **`ingestResearchSections`** callable. It is admin only (the
caller must be signed in as an `admin` or `ministry_reviewer` user). The request is:

```json
{
  "source": {"sourceId": "kh-app-help", "title": "App Help", "author": "…",
             "rightsHolder": "Kingdom Heirs Foundation", "edition": "…",
             "pathwayId": "", "track": "help", "language": "en", "status": "approved"},
  "replace": true,
  "sections": [{"sectionIndex": 0, "chapterTitle": "…", "sectionTitle": "…", "text": "…"}]
}
```

`app_help.json` is already in this shape. `"replace": true` deletes the old sections of
that source first, so use it for a new edition. `status` is `approved` (searchable) or
`draft`. Use `setResearchSourceStatus` to approve or withdraw a source later. There is no
admin page or script in the repo for these two calls. A developer runs them as a signed-in
admin, for example from a small script that uses the Firebase client SDK.

### Settings: `config/askKingdomHeirs`

One Firestore document. Change it in Firebase console → Firestore, or with the
admin-only `askConfig` callable (`{"set": {"paused": false}}`).

| Field | Meaning |
|---|---|
| `enabled` | `false` until Kingdom Heirs approves launch. While `false`, only admins and testers can use Ask; everyone else sees "coming soon". Set to `true` to go live for all members. |
| `paused` | `true` stops all answers ("resting for a little while"). Set by the budget alert; set it back to `false` to resume. `pausedAt` and `pausedReason` record why. |
| `testerEmails` | List of email addresses that may use Ask before launch |
| `dailyLimitPerMember` | Questions per member per day (default 100 when empty). Admins are not limited. |
| `answerInMemberLanguage` | `true` answers in the member's language. When `false` or missing, answers are in English with a notice. |

### $50 budget pause

A Cloud Billing budget of **$50/month** sends alerts to the Pub/Sub topic
**`ask-kingdom-heirs-budget`**. The `onAskBudgetAlert` function sets `paused: true` when
cost reaches 100% of the budget. Ask does **not** resume by itself; an admin sets
`paused` back to `false` (for example at the start of the next month, or after raising the
budget). Check that the budget exists and is linked to the topic in Google Cloud console →
Billing → Budgets & alerts. The budget covers the whole billing account it is set on, not
only Ask.

Member questions are not stored. `askLogs` keeps only the date, sources used and token
counts. Reports from members are in `askReports` (Firebase console).

## 10. Release checklist

- [ ] On `main`, merged with the latest `flutterflow` and checked for lost code
- [ ] Version and build number raised
- [ ] Android: `android/key.properties` present (Play builds only)
- [ ] Smoke test in English, Spanish, Urdu (right to left) and Luganda, and offline
- [ ] Build `.aab` and `.ipa`, upload to Play Internal Testing and TestFlight
- [ ] Tag the commit, for example `git tag v1.0.1+7`
