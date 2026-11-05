# Legacy backend functions on Node.js 20

Status: **open Phase 1 risk.** Investigated 5 November 2026.

## The problem

The Firebase project `kingdom-heirs-discipleshipapp` runs 22 Cloud Functions (2nd gen,
Node.js 20, us-central1, 256 MB) whose source code is **not** in the Kingdom Heirs
repository. The app depends on most of them. Google decommissioned Node.js 20 for Cloud
Functions on 30 October 2026: the functions still run, but they cannot be updated or
redeployed on Node 20, and Google may stop running them. The 14 functions in this
repository (`firebase/functions/`) already run on Node.js 22.

## Recovery investigation

- `getTodayContent` was deployed on 25 September 2026 with the Firebase CLI. Its source
  archive is `gs://gcf-v2-sources-455899201651-us-central1/getTodayContent/function-source.zip`,
  and its build image is in the Artifact Registry repository `gcf-artifacts`. It has no
  secret environment variables.
- All 22 functions carry the same Firebase codebase hash, so they were very likely
  deployed together from one codebase, and one archive probably holds all of them.
- **The archives have not been downloaded yet.** That needs an account with Storage
  Object Viewer (or Owner/Editor) on the project, using either:
  - Google Cloud Console → Cloud Storage → bucket `gcf-v2-sources-455899201651-us-central1`
    → `<function>/function-source.zip` → Download; or
  - the Google Cloud SDK: `gcloud auth login`, then
    `gsutil cp gs://gcf-v2-sources-455899201651-us-central1/getTodayContent/function-source.zip .`
- Ask the original developer for the repository as well (see
  [OWNERSHIP_CHECKLIST.md](OWNERSHIP_CHECKLIST.md)).

## Dependency inventory

All are called with POST `https://us-central1-kingdom-heirs-discipleshipapp.cloudfunctions.net/<name>`
and the member's ID token. The call classes are in `lib/backend/api_requests/api_calls.dart`;
the request and response fields the app relies on are in [../firebase.md](../firebase.md).

Critical: members cannot use the app without these.
- `getUserProfile`: sign-in routing, Home, Profile, quiz, Ask, recommendation,
  pathway list, assessment, offline prefetch
- `updateUserProfile`: onboarding survey, profile and time zone
- `getTodayContent`: Home, Today, offline prefetch
- `getPathwayProgress`: pathway overview, lesson page, progression rules, prefetch
- `saveLessonProgress`: marking a lesson complete

High: important features stop working.
- `syncOfflineProgressHttp`: sending progress made offline
- `getQuiz`, `getQuizAttempt`, `submitQuizAttempt`: quizzes and best scores
- `getAssessmentQuestions`, `submitAssessment`: onboarding assessment and recommendation

Admin only:
- `getAdminReport`, `getAssessmentConfig`, `updateAssessmentConfig`,
  `publishAnnouncement`, `generateTranslationDrafts`, `logAnalyticsEvent`,
  `importCurriculum` (Manage Pathways page)

Not used by the current app:
- `ragQuery`, `ragQueryHttp` (replaced by `askKingdomHeirs`), `getLocations`,
  `syncOfflineProgress` (callable)

## Migration plan

Safety rules for every path:
- Deploy only by name (`--only functions:functions:<name>`). Never run a bare
  `firebase deploy --only functions`: if the 22 share the `functions` codebase, the CLI
  offers to delete them.
- Before replacing any function, keep its `function-source.zip` and note its Cloud Run
  revision, so traffic can be sent back to the old revision.
- Keep the same names, region and generation, so the URLs the app calls do not change.

### A. Source recovered (preferred)
1. Download the archives, compare them, and commit the code to the Kingdom Heirs
   repository as a separate codebase (for example `firebase/legacy_functions/`, codebase
   `legacy`).
2. Review it: dependencies, secrets and environment variables, server-side admin role
   checks, and the Firestore collections each function uses (needed for account deletion
   too).
3. Move it to Node.js 22 (`engines.node: "22"`), with current `firebase-functions` and
   `firebase-admin`.
4. Test in the Firebase emulator against a copy of the data, then deploy in this order:
   admin functions, then reads (`getTodayContent`, `getUserProfile`), then writes
   (progress, offline sync, quizzes, assessment). Run the acceptance checklist after each
   step.
5. Remove the four unused functions only after the logs confirm nothing calls them, and
   with Kingdom Heirs' approval.

Estimated effort: 2 to 4 days including testing.

### B. Source not recovered
1. Before changing anything, record real requests and responses from the current
   functions with a test account. They become the contract tests.
2. Rebuild the 17 functions in use inside `firebase/functions/` (Node 22), matching
   `api_calls.dart` and [../firebase.md](../firebase.md) exactly, with the same names.
3. Same deployment order and testing as in A. Offline sync must stay idempotent, so
   repeated sends do not duplicate completions.

Estimated effort: 2 to 3 weeks. This is a separate, quoted item.

## Decision needed from Kingdom Heirs

1. Download the archives (Console steps above) or grant read access to the
   `gcf-v2-sources` bucket.
2. Ask the original developer for the repository.
3. Approve path A or B.
