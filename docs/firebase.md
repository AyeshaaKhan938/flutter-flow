# Firebase

Project: **`kingdom-heirs-discipleshipapp`**. Region: `us-central1`. Client config is in
`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`. These client
keys are not secrets, but you should restrict them in the Google Cloud console (see
[operations.md](operations.md#credentials-and-secret-rotation)).

## Firestore collections

The field lists come from `lib/backend/schema/*_record.dart`. *Loc* means a localized map
`{en, es, ur, lg}` (`LocaleTextStruct`). The server may write more fields than the app
reads; see "Needs input" at the end.

### `pathways/{id}`
| Field | Type | Notes |
|---|---|---|
| `stableId` | string | Human id, e.g. `come-and-see`. Used to find, update, and upsert. Must be unique. |
| `title` | Loc | |
| `description` | Loc | |
| `durationDays` | int | Admin "create" defaults to 14 |
| `order` | int | Sort order. Admin "create" defaults to 99 |
| `status` | string | `draft` / `in_review` / `published` (members see only `published`) |

### `pathways/{id}/lessons/{id}` (the app also uses the `lessons` collection group)
| Field | Type | Notes |
|---|---|---|
| `stableId` | string | e.g. `LESSON-COME-001` |
| `pathwayId` | string | The **stableId** of the parent pathway |
| `dayNumber` | int | Day within the pathway |
| `title` | Loc | |
| `scriptureRef` | string | e.g. `John 3:16`. Parsed for Bible lookup |
| `scriptureText` | Loc | Stored text, used when the Bible API can't be reached |
| `reflectionPrompt` | Loc | |
| `application` | Loc | How to live out the lesson; shown as its own section |
| `prayer` | Loc | Closing prayer; shown as its own section |
| `mediaUrl` | string | Optional external URL |
| `status` | string | `draft` / `in_review` / `published` |

### `pathways/{id}/quizzes/{id}` (collection group `quizzes`)
| Field | Type | Notes |
|---|---|---|
| `stableId` | string | |
| `lessonId` | string | Lesson stableId |
| `questions` | map/array (dynamic) | Structure defined server-side. `getQuiz` returns up to 10 questions with options A–D |
| `status` | string | `draft` / `in_review` / `published` |

### `dailyScripture/{id}`
| Field | Type | Notes |
|---|---|---|
| `stableId` | string | |
| `date` | string | `MM-dd` (month-day, repeats every year) |
| `verseRef` | string | |
| `text` | Loc | |
| `status` | string | `published` / `draft` / `unpublished` (the new admin page uses these three) |

### `encouragements/{id}`
| Field | Type | Notes |
|---|---|---|
| `stableId` | string | |
| `date` | string | `MM-dd` (month-day, repeats every year) |
| `quote` | Loc | |
| `attribution` | string | |
| `rightsCleared` | bool | Confirms you have the right to publish the quote |
| `status` | string | As for dailyScripture |

### `announcements/{id}`
| Field | Type | Notes |
|---|---|---|
| `title` | Loc | |
| `body` | Loc | |
| `publishedAt` | timestamp | |
| `audience` | string | Set by `publishAnnouncement`; the allowed values are server-defined |

### `onboardingQuestions/{id}` and `assessmentQuestions/{id}`
Fields: `stableId`, `fieldKey`, `label` (Loc), `status`. `assessmentQuestions` also has
`questionId` and `optionA`–`optionD` (Loc). Scoring rules (score bands, point map,
overrides, explanations) are edited as JSON on the admin page through
`getAssessmentConfig` and `updateAssessmentConfig`. Where they are stored is
**server-side and unknown**.

### `reflections/{id}`
| Field | Type | Notes |
|---|---|---|
| `userId` | string | Owner uid |
| `lessonId` | string | |
| `text` | string | Member's private reflection |
| `createdAt` | timestamp | |
| `clientWriteId` | string | Dedup key for offline-queued writes |

### `users/{uid}`
Fields the app reads: `uid`, `email`, `display_name`, `photo_url`, `phone_number`,
`created_time`, `fullName`, `preferredLanguage` (`en`/`es`/`ur`/`lg`), `role` (`member` /
`admin` / `ministry_reviewer`), `createdAt`, `surveyResponses`. The API returns more fields
(`onboardingCompleted`, `recommendedPathwayId`, `companionPathwayId`,
`additionalPathwayIds`, `latestAssessmentScore`), and the push code reads `timezone` and
`currentPathwayId`. Those fields are written by the external functions.

- `users/{uid}/fcm_tokens/{id}`: `fcm_token`, `device_type`, `created_at` (written by `addFcmToken`).

### `ff_push_notifications/{id}`
The FlutterFlow push queue. See [notifications-and-assistant.md](notifications-and-assistant.md).

### Collections that are probably server-only (unconfirmed)
Progress, quiz attempts, assessment results, analytics events, and import logs are handled
by the external functions (`getPathwayProgress`, `getQuizAttempt`, `logAnalyticsEvent`,
`getAdminReport.lastImportSummary`). Their collection names are **unknown**.

## Security rules

Source: `firebase/firestore.rules`. Deploy with `firebase deploy --only firestore:rules`
from `firebase/`. FlutterFlow can also deploy rules; decide which of the two is the owner.

| Collection | Read | Create | Update/Delete |
|---|---|---|---|
| `users/{uid}` | own doc | own doc, with `role` empty | own doc; `role` cannot change |
| `pathways`, `lessons`, `quizzes` | anyone | content admin | content admin |
| `dailyScripture`, `encouragements`, `announcements` | anyone | content admin | content admin |
| `onboardingQuestions`, `assessmentQuestions` | anyone | content admin | content admin |
| `reflections` | owner only | signed in, `userId == auth.uid` | denied |

A **content admin** is a user whose `users/{uid}.role` is `admin` or `ministry_reviewer`
(the `isContentAdmin()` helper). Only the backend (Admin SDK) can set `role`.

The Admin SDK (Cloud Functions) bypasses these rules.

**Before launch:**
1. **Deploy these rules.** Until then the older, open rules stay live. Also compare with
   the Firebase console, since the deployed rules may have drifted from this file.
2. **Check reflections first.** Confirm the backend stores `reflections.userId` as the
   Firebase Auth uid. The owner-only read rule and the lesson page's reflection lookup
   both depend on it.
3. **Unpublished content is still readable.** Reads stay open (`if true`) so the admin
   pages can list drafts, so draft or unpublished content can be read by querying
   Firestore directly. Members only see published content because the app filters by
   `status`.
4. **Decide on `ministry_reviewer`.** If this role should review but not publish, remove it
   from `isContentAdmin()` and from `kContentAdminRoles` in
   `lib/admin_content_page/admin_content_page_model.dart`.

## Indexes

`firebase/firestore.indexes.json` has no composite indexes. It has two single-field
**collection-group** overrides:
- `fcm_tokens.fcm_token` (ASC), used by `addFcmToken` dedup and push fan-out.
- `lessons.status` (ASC), used by collection-group lesson queries.

If a query fails with "requires an index", the error contains a link that creates it. Then
add the index to this file and deploy with `firebase deploy --only firestore:indexes`.

## Cloud Functions in this repo

`firebase/functions/index.js` (Node 20, codebase `functions`) contains only FlutterFlow's
generated push and auth functions:

| Function | Trigger | What it does |
|---|---|---|
| `addFcmToken` | callable | Saves the device token to `users/{uid}/fcm_tokens`, removing the same token from other users |
| `sendPushNotificationsTrigger` | Firestore onCreate `ff_push_notifications/{id}` | Sends immediately unless `scheduled_time` is set |
| `sendScheduledPushNotifications` | Pub/Sub, every 60 min | Sends docs whose `scheduled_time` fell in the last hour |
| `onUserDeleted` | Auth user delete | Deletes `users/{uid}` (other user data such as reflections is **not** deleted) |

`firebase/functions/api_manager.js` is FlutterFlow's private-API proxy, and its call map is
empty. `package.json` lists unused FlutterFlow defaults (Stripe, Braintree, Razorpay, Mux,
OneSignal, LangChain). Push targeting work is in progress in `index.js` (see
[notifications-and-assistant.md](notifications-and-assistant.md)).

Deploy: `cd firebase && firebase deploy --only functions:addFcmToken,functions:sendPushNotificationsTrigger,functions:sendScheduledPushNotifications,functions:onUserDeleted`.
Name the functions explicitly so you never touch the external functions below. **Caution:**
FlutterFlow also deploys `index.js`, and it regenerates the file when it does.

## External Cloud Functions (not in this repo)

The app calls these at `https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/<name>`.
Each call is a POST with a JSON body that includes `authToken`. Callers are in
`lib/backend/api_requests/api_calls.dart` and `lib/custom_code/actions/`.

| Endpoint | Called from | Request fields (from client) | Response fields read |
|---|---|---|---|
| `getUserProfile` | home, profile, pathways, quiz, assistant, assessment | `authToken` | role, preferredLanguage, onboardingCompleted, recommendedPathwayId, … |
| `updateUserProfile` | onboarding, profile, timezone, offline language sync | `preferredLanguage`, profile, survey, timezone fields | |
| `getTodayContent` | today page | `authToken` | date, language, scriptureRef, scriptureTheme, scriptureText, encouragementText, encouragementRef |
| `getPathwayProgress` | pathway overview, lesson | `pathwayId` | currentDay, completedLessonsCsv, completedCount, totalLessons, pathwayTitle |
| `saveLessonProgress` | lesson (`saveLessonProgressSmart`) | pathwayId, lessonId, dayNumber, reflectionText, clientWriteId | |
| `syncOfflineProgressHttp` | reconnect sync | `reflections[]`, `progress[]` | status only |
| `getQuiz`, `getQuizAttempt`, `submitQuizAttempt` | quiz page | quizId, locale, answers | quizTitle, passingScore, q1..q10 text/options; correctCount, total, percentage, passed |
| `getAssessmentQuestions`, `submitAssessment` | assessment | answers | primaryPathwayId, companionPathwayId, additionalPathwayIds, explanationText, … |
| `getAssessmentConfig`, `updateAssessmentConfig` | admin | version, score bands, overrides, explanations, point map (JSON) | |
| `importCurriculum` | admin CSV importer | collection, csvText, previewOnly | created, updated, unchanged, errorCount, firstErrorMessage |
| `publishAnnouncement` | admin | titleEn/Es/Ur, bodyEn/Es/Ur, audience, sendPush | success, announcementId, note |
| `generateTranslationDrafts` | admin | target (pathways/lessons) | success, target, updated, skipped, note |
| `getAdminReport` | admin | | pathwayCount, lessonCount, quizCount, memberCount, lastImportSummary, lastRagQuestion |
| `logAnalyticsEvent` | admin (after publishing an announcement) | event fields | |
| `ragQueryHttp` | assistant | question, locale | answer, citations, fallbackTriggered, fallbackMessage |

`ListPathways`, `ListDailyScripture`, `ListEncouragements`, `ListAnnouncements`,
`GetUserProfile`, and `CreateUserProfile` point at `https://mock.kingdomheirs.app/…`. These
are FlutterFlow mock/demo calls, not production endpoints.

## Storage

The app does **not** use Firebase Storage (`firebase_storage` is not a dependency).
`lessons.mediaUrl` is a plain external URL.

## Needs input from backend owner

- Source code, repo location, and deploy process for every function in the external table.
- Whether each function checks `role` (admin/ministry_reviewer) on the server, especially
  `importCurriculum`, `publishAnnouncement`, `updateAssessmentConfig`,
  `generateTranslationDrafts`, and `getAdminReport`.
- The CSV column spec and upsert logic of `importCurriculum` (see [import-templates.md](import-templates.md)).
- The collections these functions write (progress, attempts, assessments, analytics, import logs).
- The `quizzes.questions` structure and the `announcements.audience` values.
- Secrets these functions use (Secret Manager names), including any LLM provider for `ragQueryHttp`.
- Whether the deployed Firestore rules match `firebase/firestore.rules`.
