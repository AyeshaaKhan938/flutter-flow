# Services and costs

Every outside service the app uses, found by reading the code on `main` on 2 November 2026.
All accounts should be owned by Kingdom Heirs, not by a developer (see
[OWNERSHIP_CHECKLIST.md](OWNERSHIP_CHECKLIST.md)). Where a price is not certain, check
the provider's billing page; prices below are not quotes.

## Google Cloud / Firebase (project `kingdom-heirs-discipleshipapp`)

All of these bill to the Google Cloud billing account linked to the project, on the
**Blaze (pay-as-you-go)** plan. At current usage, most fall inside free tiers. Verify
actual spend in Google Cloud console → Billing.

| Service | Used for | Where in code | Cost |
|---|---|---|---|
| Firebase Authentication | Email and password sign-in | `lib/auth/firebase_auth/` | Free for email sign-in |
| Cloud Firestore | All content and member data (pathways, lessons, progress, reflections, certificates, imports, Ask library and settings) | `lib/backend/`, `firebase/firestore.rules` | Pay-as-you-go; free daily quota. Backups and point-in-time recovery cost extra if turned on |
| Cloud Functions | Server logic: Bible, import, translation, push, Ask Kingdom Heirs, plus 22 older functions not in this repo | `firebase/functions/`, `lib/backend/api_requests/api_calls.dart` | Pay-as-you-go; free monthly quota |
| Cloud Scheduler | Runs `sendScheduledPushNotifications` every 5 minutes | `firebase/functions/index.js:130` | Pay-as-you-go; a few jobs are free per billing account |
| Pub/Sub | Budget alert topic `ask-kingdom-heirs-budget` → `onAskBudgetAlert` | `firebase/functions/research_library.js:799` | Pay-as-you-go; negligible |
| Firebase Cloud Messaging | Push notifications | `lib/backend/push_notifications/`, `firebase/functions/index.js` | Free |
| Cloud Storage for Firebase | Branding photos and the country/city list the app downloads (bucket `kingdom-heirs-discipleshipapp.firebasestorage.app`) | `lib/today_page/today_page_widget.dart:524`, `lib/custom_code/widgets/country_city_picker.dart:16` | Pay-as-you-go; small |
| Firebase Performance Monitoring | Package is in `pubspec.yaml`; no calls seen in the code | `pubspec.yaml` | Free |
| Firebase Hosting | Configured in `firebase/firebase.json`, but there is no `public/` folder in the repo. Probably unused; verify in Firebase console | `firebase/firebase.json` | Free tier |
| Vertex AI: `gemini-2.5-flash` (fallback `gemini-2.5-flash-lite`) | Ask Kingdom Heirs answers, and translating non-English questions into English | `firebase/functions/research_library.js:26-28` | Pay-as-you-go per token. **Ask is capped by a $50/month budget** that pauses it |
| Vertex AI: `text-multilingual-embedding-002` | Search index for the Ask library | `firebase/functions/research_library.js:25` | Pay-as-you-go; small (charged when books are loaded and per question). Included in the $50 cap |
| Cloud Translation API (v2) | Machine translation of Kingdom Heirs text (never Scripture). Each text is translated once and cached in `machineTranslations` | `firebase/functions/translation_core.js:25`, `firebase/functions/translation.js` | Pay-as-you-go per character, with a monthly free allowance. Verify in billing console |
| Secret Manager | Holds `API_BIBLE_KEY` | `firebase/functions/index.js:685` | Pay-as-you-go; cents per month |
| Cloud Billing budget | $50/month budget that pauses Ask | Google Cloud console → Billing → Budgets & alerts | Free. The budget watches the whole billing account |

**Older Cloud Functions not in this repo.** The project also runs 22 older functions
(v2, Node.js 20), most of which the app still calls, at
`https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/<name>`. Examples:
`getUserProfile`, `updateUserProfile`, `getTodayContent`, `getPathwayProgress`,
`saveLessonProgress`, `getQuiz`, `getQuizAttempt`, `submitQuizAttempt`,
`getAssessmentQuestions`, `submitAssessment`, `publishAnnouncement`, `getAdminReport`,
`generateTranslationDrafts`, `syncOfflineProgressHttp`, `importCurriculum`. Callers:
`lib/backend/api_requests/api_calls.dart` and `lib/custom_code/actions/`. They are billed
to the same project. Kingdom Heirs needs their source code, and they should be moved to a
supported Node.js version: Node.js 20 was due to be decommissioned by Google on
30 October 2026. Check the Cloud Functions runtime support page. `ragQueryHttp`, one of these, is no longer called by
the app (Ask uses `askKingdomHeirs` now).

## Scripture

| Service | Used for | Where in code | Owner | Cost |
|---|---|---|---|---|
| **API.Bible** (`api.scripture.api.bible`) | Bible passages in each language (NIV in English, Reina Valera 1909, Urdu and Luganda Biblica versions). The key is in Secret Manager as `API_BIBLE_KEY` | `firebase/functions/index.js:717` | Kingdom Heirs | Plan not known. Check the API.Bible dashboard and the licence terms for each Bible (NIV in particular) |
| API.Bible FUMS (`fums.api.bible`) | Required usage reporting for each passage shown | `lib/custom_code/actions/fetch_bible_verse_api.dart:248` | Same account | Free; required by API.Bible terms |
| bible-api.com | English KJV fallback when API.Bible cannot be reached | `lib/custom_code/actions/fetch_bible_verse_api.dart:221` | None (public, no account) | Free |
| Bible Gateway (`www.biblegateway.com`) | Opens a reference in the browser when a passage cannot be loaded | `lib/custom_code/actions/open_scripture_reference.dart:28`, `open_scripture_reference_safe.dart:48` | None (link only) | Free |
| Bible.com | Same, for Luganda | `lib/custom_code/actions/open_scripture_reference_safe.dart:46` | None (link only) | Free |

## Links inside the app

| Link | Where | Owner | Cost |
|---|---|---|---|
| Givebutter donation page `https://givebutter.com/kingdom-heirs-foundation-100-pzxizs` | `lib/home_page/home_page_widget.dart:32` | Kingdom Heirs | Platform fees apply to donations; verify with Givebutter |
| YouTube channel `https://youtube.com/@kingdomheirsco` | `lib/home_page/home_page_widget.dart:36` | Kingdom Heirs | Free |
| Partner page `https://kingdomheirsfoundation.com/partner-with-us` | `lib/profile_page/profile_page_widget.dart:33` | Kingdom Heirs (website domain) | Domain and website hosting; verify |
| Deep-link domain `kingdomheirsdiscipleshipapp.com` | `android/app/src/main/AndroidManifest.xml:48`, `ios/Runner/Info.plist:47` | To confirm | Domain renewal, if registered |

## Development and distribution

| Service | Used for | Owner | Cost |
|---|---|---|---|
| **Apple Developer Program** | iOS builds, TestFlight, App Store, push (APNs key) | Kingdom Heirs organisation account | **$99 per year**. If it lapses, the app is removed from the App Store |
| **Google Play Console** | Android distribution | Kingdom Heirs organisation account | **$25 one time** |
| **FlutterFlow** | Visual editor that generates the app's screens; pushes to the `flutterflow` branch | Kingdom Heirs team | A paid plan is needed for GitHub push and code export. Verify the current plan |
| **GitHub** | Source code. Currently `github.com/AyeshaaKhan938/flutter-flow`, **public**, on a personal account | Must move to a private Kingdom Heirs repository | Free for a private repository on the free plan |

## Not used, despite appearing in the code

- `https://mock.kingdomheirs.app/…` (`lib/backend/api_requests/api_calls.dart:26-156`):
  FlutterFlow demo calls. Nothing in the app calls them.
- Stripe, Braintree, Razorpay, Mux, OneSignal and LangChain (OpenAI, Anthropic, Google)
  packages in `firebase/functions/package.json`: FlutterFlow defaults. No code uses them,
  so there are no accounts or costs.
- Google Sign-In and Sign in with Apple packages in `pubspec.yaml`: the sign-in screens
  use email and password only.

## Cost control

1. Keep the **$50/month budget** linked to the `ask-kingdom-heirs-budget` Pub/Sub topic.
   It pauses Ask Kingdom Heirs, not the rest of the app.
2. Add a second budget alert (email only) for the whole project, for example at $25 and
   $100.
3. Review Billing → Reports monthly. The largest variable costs are Vertex AI (Ask) and
   Cloud Translation.
