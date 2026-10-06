# Operations

## Backup and restore

Firestore holds all content and member data. Firebase Auth accounts are stored
**separately** and must be backed up separately. The commands assume
`gcloud config set project kingdom-heirs-discipleshipapp` and a caller with the
**Cloud Datastore Import Export Admin** role plus write access to the bucket. Managed
export, backups, and PITR require the **Blaze** (pay-as-you-go) plan.

### 1. One-time setup
```sh
# A bucket in the same region as the database (check the region in Firebase console → Firestore)
gcloud storage buckets create gs://kingdom-heirs-firestore-backups --location=us-central1
# Optional: delete old exports automatically after 90 days
gcloud storage buckets update gs://kingdom-heirs-firestore-backups --lifecycle-file=lifecycle.json   # lifecycle.json: {"rule":[{"action":{"type":"Delete"},"condition":{"age":90}}]}
```

### 2. Scheduled backups (recommended)
```sh
gcloud firestore backups schedules create --database='(default)' --recurrence=daily --retention=14w
gcloud firestore backups schedules list --database='(default)'
gcloud firestore backups list
```
You restore a backup **into a new database**, then point the app at it or copy the data
back:
```sh
gcloud firestore databases restore --source-backup=projects/kingdom-heirs-discipleshipapp/locations/<loc>/backups/<id> --destination-database=restore-YYYYMMDD
```

### 3. Point-in-time recovery (PITR)
```sh
gcloud firestore databases update --database='(default)' --enable-pitr
```
PITR keeps 7 days of versions. Use it to read or export data as it was at a past minute,
for example after a bad import.

### 4. Manual export and import (before risky changes, such as a big import or a rules change)
```sh
gcloud firestore export gs://kingdom-heirs-firestore-backups/$(date +%F)
gcloud firestore export gs://kingdom-heirs-firestore-backups/$(date +%F)-content \
  --collection-ids=pathways,lessons,quizzes,dailyScripture,encouragements,announcements
# Restore: import OVERWRITES documents with the same id; others are left untouched
gcloud firestore import gs://kingdom-heirs-firestore-backups/<folder>
```

### 5. Auth users
```sh
firebase auth:export users.json --project kingdom-heirs-discipleshipapp   # contains password hashes: store securely
```

Test a restore into a scratch database at least once a quarter. The master content CSVs
are a second, human-readable backup (see [import-templates.md](import-templates.md#recovery)).

## Third-party services and costs

| Service | Used for | Cost | Owner / account | Notes |
|---|---|---|---|---|
| Firebase / Google Cloud (`kingdom-heirs-discipleshipapp`) | Auth, Firestore, Functions, FCM, Performance | Blaze pay-as-you-go. Likely low at launch scale; **set a budget alert** | **Unknown**. Confirm the billing account belongs to Kingdom Heirs | FCM is free; backups and PITR add storage cost |
| API.Bible | Scripture passages + FUMS | **Unknown plan.** Free tier with usage limits; check the dashboard | Unknown | Key `API_BIBLE_KEY` (build time) |
| bible-api.com | English KJV fallback when no key is set | Free | n/a | |
| Apple Developer Program | iOS distribution, APNs | **$99 / year** | Must be the Kingdom Heirs organisation account | Needs a D-U-N-S number for an org account |
| Google Play Console | Android distribution | **$25 one-time** | Must be the Kingdom Heirs organisation account | |
| FlutterFlow | UI editor and code generation | **Unknown plan** (a paid plan is needed for code export / GitHub push) | Unknown | Transfer the project to a Kingdom Heirs team |
| LLM / embeddings for the assistant (`ragQueryHttp`) | Answers and citations | **Unknown**. Provider not in the repo (LangChain OpenAI/Google/Anthropic packages are listed) | Unknown | Needs backend owner |
| GitHub | Source code | Free (private repo) | Currently a personal account | See below |
| Domain `kingdomheirsdiscipleshipapp.com` | Deep-link host in the Android manifest | Unknown | Unknown | Confirm it is registered and owned |

## Credentials and secret rotation

Never write secret values into the repo, docs, tickets, or chat. Store them in the Kingdom
Heirs password manager, or in **Google Secret Manager** for server-side secrets, and
reference them only by name.

| Credential | Where it lives | Rotation / notes |
|---|---|---|
| `API_BIBLE_KEY` | Google Secret Manager, project kingdom-heirs-discipleshipapp, secret `API_BIBLE_KEY`; read only by the `getBiblePassage` function (runs as kingdom-heirs-discipleshipapp@appspot.gserviceaccount.com, which needs Secret Manager Secret Accessor on the secret) | Create a new key in the API.Bible dashboard, add it as a new version of `API_BIBLE_KEY`, test a passage in the app, then revoke the old key. No app rebuild is needed |
| Firebase client config (`google-services.json`, `GoogleService-Info.plist`) | Committed | Not secret. In the Google Cloud console → Credentials, **restrict the API keys** to the Android package + SHA-1 and the iOS bundle id |
| Firebase project access | IAM, Firebase console | Give owners Kingdom Heirs accounts (at least 2). Remove personal and contractor accounts at handoff |
| Service accounts | GCP IAM | Audit keys under IAM → Service accounts. Delete unused user-managed keys, and prefer keyless (default) credentials for functions |
| Backend function secrets (LLM key, others) | Secret Manager (**names unknown**; needs backend owner) | Add a new version, redeploy the functions, then disable the old version |
| APNs key (`.p8`) | Apple Developer → Keys; uploaded to Firebase | It does not expire. Rotate by creating a new key, uploading it to Firebase, then revoking the old one. Apple allows 2 APNs keys at a time |
| Android upload keystore + `key.properties` | Password manager + offline backup (never in git) | If lost or leaked, request an upload-key reset in Play Console (requires Play App Signing) |
| Apple / Google developer accounts | Org accounts with 2FA | Add at least two Kingdom Heirs admins |
| FlutterFlow account | FlutterFlow team | Transfer project ownership; remove departing developers |

### Repository ownership

The code is currently in **`github.com/AyeshaaKhan938/flutter-flow`**, which is a
**public** repository on a personal account. Before launch:

1. Create a **private** repository under a Kingdom Heirs GitHub organisation.
2. Push all branches and tags (`git push --mirror`), then update FlutterFlow's GitHub
   integration to push to the new repo.
3. Make the old repo private, or archive or delete it.
4. Because the repo was public, **treat anything ever committed as exposed**. Scan the
   history (`git log -p`, or a tool such as gitleaks). Rotate any secret that appears,
   even in old commits.
5. Protect the main branch and give at least two Kingdom Heirs staff admin rights.

## Routine operations

- Monitor Firebase console → Functions logs for errors, and Crashlytics if it is added
  (it is not currently configured). Firebase Performance is included.
- Set a GCP budget alert (e.g. at $25 and $100 per month).
- After any FlutterFlow push, follow the checklist in [architecture.md](architecture.md#flutterflow-sync-caveat).
- Renew the Apple Developer membership every year. If it lapses, the app is removed from
  the App Store.
