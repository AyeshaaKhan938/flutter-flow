# Architecture

## Overview

This is a Flutter app exported from **FlutterFlow**. It runs on Android and iOS, and a
web target also exists under `web/`. The backend is Firebase project
`kingdom-heirs-discipleshipapp`:

- **Firebase Auth**: email/password sign-in (`authManager.signInWithEmail`,
  `createAccountWithEmail`, `resetPassword`). Google, Apple, and other providers have
  generated code in `lib/auth/firebase_auth/`, but no page uses them.
- **Cloud Firestore** holds content (pathways, lessons, quizzes, daily Scripture,
  encouragements, announcements) and user records. The app reads content **directly**
  from Firestore.
- **Cloud Functions (HTTP)** handle profiles, progress, quizzes, assessments, import,
  announcements, reports, and the assistant. The app calls them with plain HTTPS POSTs
  and puts the Firebase ID token in the JSON body as `authToken`. Most of these functions
  **are not in this repo** (see [firebase.md](firebase.md#external-cloud-functions-not-in-this-repo)).
- **Firebase Cloud Messaging** handles push notifications, using FlutterFlow's standard
  `ff_push_notifications` pipeline.
- **API.Bible** provides Scripture passages (see the [README](../README.md#bible-integration)).

```
lib/
  main.dart                 app entry; Firestore persistence, locale, reconnect-sync listener
  app_state.dart            FFAppState (persisted to SharedPreferences with ff_ prefix)
  index.dart                page exports
  flutter_flow/             FlutterFlow runtime: theme, nav (go_router), internationalization, widgets
  auth/                     Firebase Auth wrappers (generated)
  backend/
    schema/                 Firestore record classes (*_record.dart) + structs/ (API response types)
    api_requests/           api_calls.dart (all HTTP endpoints), api_manager.dart, offline_api_cache.dart
    push_notifications/     FCM token registration + notification tap handling
    mock/                   mock seed data / debug overlay (demo mode)
  custom_code/
    actions/                custom actions (admin CRUD, import, offline sync, Bible, locale...)
    functions/              pure helper functions
    widgets/                country_city_picker
    bible_reference.dart    Scripture reference parser (hand-written)
  <page>_page/              one folder per page: *_widget.dart (UI) + *_model.dart (state)
firebase/                   firestore.rules, firestore.indexes.json, functions/ (push only)
```

## Pages

| Route | Folder | Purpose | Backend used |
|---|---|---|---|
| `/sign-in`, `/sign-up`, `/reset-password` | `sign_in_page`, `sign_up_page`, `reset_password_page` | Email auth; sign-up saves profile | Firebase Auth, `saveSignupProfile` |
| `/onboarding` | `onboarding_survey_page` | Language and survey | `updateUserProfile` |
| `/assessment/intro`, `/assessment/questions`, `/assessment/recommendation` | `assessment_*`, `recommendation_result_page` | Spiritual assessment → recommended pathway | `getAssessmentQuestions`, `submitAssessment`, `getUserProfile` |
| `/notifications/primer` | `notification_permission_primer_page` | Asks for push permission | FCM |
| `/homePage` | `home_page` | Home | `getUserProfile` |
| `/today` | `today_page` | Today's Scripture, encouragement, announcements | `getTodayContent`, Firestore `announcements` |
| `/pathways` | `pathway_list_page` | Published pathways, localized | Firestore `pathways`, `getUserProfile` |
| `/pathway/overview` | `pathway_overview_page` | Lessons and progress for a pathway | Firestore `lessons`, `getPathwayProgress` |
| `/pathway/lesson` | `daily_lesson_page` | Lesson, Scripture passage, reflection, mark complete | Firestore `lessons`/`quizzes`, `saveLessonProgress`, `syncOfflineProgressHttp`, API.Bible |
| `/pathway/quiz` | `quiz_page` | Up to 10 A–D questions; review a past attempt | `getQuiz`, `getQuizAttempt`, `submitQuizAttempt` |
| `/search/rag` | `rag_search_page` | "Ask Kingdom Heirs" assistant | `ragQueryHttp` |
| `/profile`, `/profile/timezone` | `profile_page`, `profile_timezone_page` | Profile, language, timezone, admin entry | `getUserProfile`, `updateUserProfile` |
| `/admin/pathways` | `admin_pathways_page` | Admin CMS (see [cms-admin-guide.md](cms-admin-guide.md)) | Firestore + several admin functions |
| (in progress) | `admin_content_page` | New CMS for daily Scripture and encouragements (edit, schedule, unpublish) | Firestore |

**Admin access** is enforced in the client only. The profile page calls `getUserProfile`
and opens the admin page only when `role` is `admin` or `ministry_reviewer`. Server-side
enforcement depends on the Firestore rules and on each Cloud Function. See
[firebase.md](firebase.md#security-rules).

## Data flow

- **Content reads.** Pages query Firestore directly (for example, `queryPathwaysRecordOnce`)
  and show only `status == 'published'` to members. Multilingual text fields are maps
  `{en, es, ur, lg}` (`LocaleTextStruct`). They are rendered with
  `forLanguage(code)`, which falls back to English.
- **User actions** go through HTTP Cloud Functions: progress, quiz and assessment
  submission, and profile changes. Every call is a POST with a JSON body that includes
  `authToken` (the Firebase ID token). Definitions are in
  `lib/backend/api_requests/api_calls.dart`, and some calls are made directly from
  custom actions.
- **Offline.** Firestore disk persistence is enabled at startup. Successful `Get*` and
  `List*` API responses are cached on the device. Lesson progress and reflections made
  while offline are queued in `FFAppState().pendingOfflineWrites` and sent to
  `syncOfflineProgressHttp` when the device reconnects. The listener is in `main.dart`.
  See [translations-bible-offline.md](translations-bible-offline.md#offline).
- **Push.** On sign-in, the app registers its FCM token through the `addFcmToken` callable,
  which writes `users/{uid}/fcm_tokens`. A document written to `ff_push_notifications`
  triggers the send. See [notifications-and-assistant.md](notifications-and-assistant.md).

API request bodies are built from string templates in `api_calls.dart`. Every value is
escaped with `_jsonEsc`, so quotes and line breaks in member text are safe. FlutterFlow
regenerates that file, so re-apply the escaping after a sync.

## FlutterFlow sync caveat

FlutterFlow is the source of truth for generated code. When anyone uses FlutterFlow's
**"Push to Repository"**, the resulting commit ("Updating to latest FlutterFlow output.")
**regenerates files from FlutterFlow's project state**. That overwrites hand edits and
**deletes files FlutterFlow doesn't know about**. This has happened at least three times:
`e8a1d22`, `43b22ff`, and `d7bcf6c` ("Restore" and "Re-restore Bible integration and build
fixes after another FlutterFlow sync").

**Rule:** after every FlutterFlow push, run `git diff <previous-commit> HEAD --stat`, then
re-apply the items below, rebuild, and test. Better still, move each item into FlutterFlow:
as a Custom Action or Function, a custom dependency, or visual action wiring. Then it
survives syncs.

Files hand-edited or created outside FlutterFlow since the last sync (`5c1cfe9`):

| File | Hand change | How to make it survive |
|---|---|---|
| `lib/custom_code/actions/fetch_bible_verse_api.dart` | API.Bible passages, FUMS, and caching (deleted by every past sync) | Add it as a Custom Action in FlutterFlow |
| `lib/custom_code/bible_reference.dart` | Scripture reference parser | Custom code file in FlutterFlow, or inline it into the action |
| `lib/custom_code/actions/index.dart` | Exports for the new actions | Regenerated by FlutterFlow once the actions exist there |
| `lib/custom_code/actions/load_saved_reflection.dart`, `quiz_answers_store.dart` | New actions (restore reflection, review a quiz) | Add them as Custom Actions |
| `lib/custom_code/actions/refresh_connectivity_and_sync.dart`, `set_preferred_language.dart`, `device_content_language.dart`, `open_scripture_reference_safe.dart` | Offline language sync, Luganda support, Android link fix | Paste the updated code into the FlutterFlow Custom Actions |
| `lib/backend/api_requests/offline_api_cache.dart` and the hook in `api_manager.dart` | Offline API response cache | **Cannot be done in FlutterFlow** (generated file). Re-apply after each sync, or wrap the calls in a Custom Action |
| `lib/backend/schema/structs/locale_text_struct.dart` | `lg` field and `forLanguage()` fallback | Add `lg` to the struct in FlutterFlow; re-apply `forLanguage` |
| `lib/backend/schema/lessons_record.dart` | `application`, `prayer` fields (in progress) | Add the fields to the `lessons` schema in FlutterFlow |
| `lib/main.dart` | Reconnect listener that calls `refreshConnectivityAndSync` | Re-apply, or use an app-level action in FlutterFlow |
| `lib/daily_lesson_page/daily_lesson_page_widget.dart`, `lib/quiz_page/quiz_page_widget.dart` (+ model), `lib/today_page/today_page_widget.dart`, `lib/pathway_list_page/…`, `lib/pathway_overview_page/…` | Bible passage sheet, saved reflection, quiz review, date filter, language display | Rebuild the wiring in FlutterFlow's Action editor |
| `lib/flutter_flow/flutter_flow_widgets.dart` | `FaIcon` → `Icon` (compile fix) | Re-apply; FlutterFlow regenerates this file |
| `lib/flutter_flow/internationalization.dart` | Small fix | Re-apply, or fix the translation in FlutterFlow |
| `pubspec.yaml` | `font_awesome_flutter: 11.0.0`, `page_transition: 2.2.2` (older pins don't compile) | Set these versions in FlutterFlow's dependency settings |
| `android/app/build.gradle`, `android/build.gradle`, `android/gradle.properties` | AGP/Kotlin modernisation, minSdk | Re-apply |
| `android/app/src/main/AndroidManifest.xml` | `<queries>` for https so Bible links open on Android 11+ | Re-apply, or add it in FlutterFlow's Android manifest settings |
| `firebase/firestore.rules` | Private reflections rule | Edit the rules in FlutterFlow (Firestore → Rules), or stop FlutterFlow from deploying rules |
| `lib/admin_content_page/` | New admin CMS page (in progress) | Build it in FlutterFlow, or keep it as custom code and re-apply |
| `firebase/functions/index.js` | Push targeting (in progress) | FlutterFlow regenerates this file; keep the code in a separate functions codebase |

Also watch `README.md`, `.gitignore`, `api_keys.example.json`, and `docs/`. FlutterFlow
normally leaves unknown top-level files alone, but check after each sync.
