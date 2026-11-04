# Ownership checklist

Every account and asset Kingdom Heirs must own and control before Phase 1 is signed off.
"To confirm" means the current owner could not be checked from the code. Fill in the
**Confirmed by / date** column as each item is done.

Rules for every account:
- The owner is a **Kingdom Heirs organisation account** (for example an `@kingdomheirsfoundation.com`
  address), not a developer's personal account.
- At least **two** Kingdom Heirs staff have admin access, with two-factor sign-in.
- Passwords, keys and recovery codes are in the Kingdom Heirs password manager.
- Developers and contractors keep only the access they need, and are removed when their
  work ends.

## Accounts and services

| # | Account / asset | Current owner | Action needed | Confirmed by / date |
|---|---|---|---|---|
| 1 | **Firebase / Google Cloud project** `kingdom-heirs-discipleshipapp` (Owner role) | To confirm | Make two Kingdom Heirs accounts **Owner** in IAM. Review all other IAM members and remove personal or contractor accounts that no longer need access | |
| 2 | **Google Cloud billing account** linked to the project | To confirm | Confirm the billing account and payment card belong to Kingdom Heirs. Confirm the $50/month Ask budget exists and publishes to `ask-kingdom-heirs-budget`. Add a project-wide budget email alert | |
| 3 | **Secret Manager** secret `API_BIBLE_KEY` | Kingdom Heirs project (key holder to confirm) | Confirm the key belongs to Kingdom Heirs' API.Bible account. Rotate it if it was ever shared outside Kingdom Heirs | |
| 4 | **Apple Developer Program** (team for `com.kingdomheirsfoundation.kingdomheirs`) | To confirm | Organisation account in Kingdom Heirs' name (needs a D-U-N-S number). Two admins. Renew yearly ($99) | |
| 5 | **App Store Connect** app record and **APNs key** (`.p8`) | To confirm | App record under the Kingdom Heirs team. APNs key created by that team and uploaded to Firebase Cloud Messaging; `.p8`, Key ID and Team ID in the password manager | |
| 6 | **Google Play Console** (app `com.kingdomheirs.discipleship`) | To confirm | Organisation developer account in Kingdom Heirs' name ($25 once). Two admins | |
| 7 | **Android upload keystore** and `android/key.properties` | Does not exist yet | Kingdom Heirs creates it (see [BUILD_AND_DEPLOY.md](BUILD_AND_DEPLOY.md#4-android)), stores it and its passwords in the password manager with an offline backup, and turns on Play App Signing. Until then release builds are debug-signed and Play will reject them | |
| 8 | **GitHub repository**, currently `github.com/AyeshaaKhan938/flutter-flow`, **PUBLIC, personal account** | Developer's personal account | Create a **private** repository in a Kingdom Heirs GitHub organisation. Push all branches and tags (`git push --mirror`). Point FlutterFlow's GitHub integration at it. Then make the old repository private, archive or delete it. Because it was public, scan the history for secrets and rotate any found. Protect `main` | |
| 9 | **FlutterFlow project** | To confirm | Move the project to a Kingdom Heirs FlutterFlow team on a plan that allows GitHub push. Remove departing developers | |
| 10 | **Source code of the 22 older Cloud Functions** (`getUserProfile`, `getTodayContent`, `saveLessonProgress`, `submitQuizAttempt`, `publishAnnouncement`, etc.) | Not in this repository; author to confirm | Obtain the source and deployment instructions and add them to the Kingdom Heirs repository. They run on Node.js 20, which needs upgrading | |
| 11 | **API.Bible account** | To confirm | Account registered to Kingdom Heirs. Confirm the plan and that the licences for each Bible version used (NIV, Reina Valera 1909, Biblica Urdu and Luganda) cover this app | |
| 12 | **Domain `kingdomheirsdiscipleshipapp.com`** (used for app links in Android and iOS) | To confirm | Confirm it is registered to Kingdom Heirs, or register it. Set auto-renew | |
| 13 | **Domain `kingdomheirsfoundation.com`** (Partner page link) | To confirm | Confirm registrar account and auto-renew are in Kingdom Heirs' name | |
| 14 | **YouTube channel** `@kingdomheirsco` | To confirm | Confirm Kingdom Heirs owns the channel (Brand Account with two owners) | |
| 15 | **Givebutter** donation page `kingdom-heirs-foundation-100-pzxizs` | To confirm | Confirm the Givebutter account and payout bank account belong to Kingdom Heirs Foundation | |
| 16 | **Firebase Storage files** (branding photos, `locations` country/city list) | Kingdom Heirs project | Keep a copy of the files outside Firebase | |
| 17 | **Ask Kingdom Heirs source material** in `content_private/` (manuscripts, `app_help/app_help.json`, import sheets) | Developer's computer only (gitignored) | Hand over a copy to Kingdom Heirs and store it in a private Kingdom Heirs drive. Needed to rebuild or update the Ask library | |
| 18 | **Master content files** (CSV and Excel for pathways, lessons, quizzes, Daily Scripture, encouragements) | Kingdom Heirs (to confirm) | Keep them in a shared Kingdom Heirs drive; they are the content backup | |
| 19 | **Admin users in the app** (`users/{uid}.role` = `admin` / `ministry_reviewer`) | To confirm | Review who has a role in Firestore. Remove developer and test accounts before launch | |
| 20 | **Ask Kingdom Heirs testers** (`config/askKingdomHeirs.testerEmails`) | Kingdom Heirs | Review the list. Remove developer emails before launch | |

## Before sign-off

- [ ] Rows 1–9 confirmed (these block store release)
- [ ] Repository is private and owned by Kingdom Heirs (row 8)
- [ ] Older Cloud Functions source received (row 10)
- [ ] `content_private/` copy received (row 17)
- [ ] Every personal or contractor account removed from Firebase, Apple, Play, GitHub and FlutterFlow, or kept on purpose and recorded here
