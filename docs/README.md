# Kingdom Heirs Discipleship App: handoff documentation

These docs are for Kingdom Heirs staff and future developers. They were written from
the code in this repository (`lib/`, `firebase/`, `android/`, `ios/`, `pubspec.yaml`) and
its git history. Anything that runs outside this repository, which includes most Cloud
Functions, is marked **Needs input from backend owner**. Nothing in these docs is a guess
about what that code does.

Start with the repository [README](../README.md). It covers the build-time API keys
(none in the app; API.Bible key in Secret Manager) and the Bible integration.

| Doc | Audience | What it covers |
|---|---|---|
| [architecture.md](architecture.md) | Developers | App structure, pages, data flow, **FlutterFlow sync caveat** |
| [firebase.md](firebase.md) | Developers | Firestore collections and fields, security rules, indexes, Cloud Functions (in repo and external), notifications config |
| [build-and-release.md](build-and-release.md) | Developers | Prerequisites, builds, Android signing, Play Internal Testing, iOS signing and TestFlight, versioning |
| [cms-admin-guide.md](cms-admin-guide.md) | Staff (admins) | Publishing pathways, lessons, and quizzes; CSV import; daily Scripture and encouragements; announcements |
| [import-templates.md](import-templates.md) | Staff and developers | Field dictionary, CSV templates, validation rules, recovery |
| [translations-bible-offline.md](translations-bible-offline.md) | Staff and developers | Languages (en/es/ur/lg), RTL, fallback, Bible, offline behaviour |
| [notifications-and-assistant.md](notifications-and-assistant.md) | Staff and developers | Push notifications and targeting, the "Ask Kingdom Heirs" assistant |
| [operations.md](operations.md) | Staff and developers | Backup and restore, services and costs, credentials and secret rotation |

## Key facts

| | |
|---|---|
| Firebase / GCP project | `kingdom-heirs-discipleshipapp` (region `us-central1`) |
| Android application id | `com.kingdomheirs.discipleship` |
| iOS bundle id | `com.kingdomheirs.discipleship` (plus `com.kingdomheirs.discipleship.ImageNotification` extension) |
| App display name | Kingdom Heirs |
| Languages | English `en`, Spanish `es`, Urdu `ur` (RTL), Luganda `lg` |
| Current version | `1.0.0+1` (`pubspec.yaml`) |
| Source of UI truth | FlutterFlow project (see the sync caveat in [architecture.md](architecture.md#flutterflow-sync-caveat)) |
| Git repo | `github.com/AyeshaaKhan938/flutter-flow`. **Public, personal account.** It must move to a private repo owned by Kingdom Heirs ([operations.md](operations.md#repository-ownership)). |

## Top risks

Details are in the linked docs.

1. **The repository is public** and owned by a personal account ([operations.md](operations.md#repository-ownership)).
2. **The Firestore rules in this repo are not deployed yet.** They restrict content
   writes to admins, make reflections owner-only, and stop members from giving
   themselves a role. Until they are deployed with `firebase deploy --only
   firestore:rules`, the older, open rules stay live. See [firebase.md](firebase.md#security-rules).
3. **Android release signing needs the upload keystore.** Release builds are signed with
   `android/key.properties` when that file exists, and with the debug key otherwise, which
   Play rejects. See [build-and-release.md](build-and-release.md#android-signing).
4. **Hand edits get wiped by FlutterFlow "Push to Repository"**. You must re-apply them
   after every sync. See [architecture.md](architecture.md#flutterflow-sync-caveat).
5. **Most backend logic is not in this repo.** Get the source for the external Cloud
   Functions from the backend owner ([firebase.md](firebase.md#needs-input-from-backend-owner)).
