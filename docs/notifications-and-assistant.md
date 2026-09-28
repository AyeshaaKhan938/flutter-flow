# Notifications and the "Ask Kingdom Heirs" assistant

## Push notifications

### How it works
1. The **Notification primer** page (`/notifications/primer`) asks for permission
   (`requestNotificationPermission`: alert, badge, sound).
2. After sign-in, the app calls the `addFcmToken` callable function, which stores the
   device token in `users/{uid}/fcm_tokens/{id}` (`fcm_token`, `device_type`, `created_at`).
3. To send a notification, write a document to the **`ff_push_notifications`**
   collection. `sendPushNotificationsTrigger` (onCreate) sends it immediately.
   `sendScheduledPushNotifications` runs every 60 minutes and sends documents whose
   `scheduled_time` fell in the last hour, so scheduled pushes can arrive up to about an
   hour late.
4. The function writes back `status` (`succeeded` / `failed`), `num_sent`, and `error`.
5. When a member taps a notification, the app opens `initial_page_name` with
   `parameter_data` (`push_notifications_handler.dart`).

Ways to create an `ff_push_notifications` document:
- **FlutterFlow → Push Notifications** tab (the simplest option for staff with FlutterFlow access).
- **Admin page → Publish + notify members**, which calls `publishAnnouncement`. Whether
  that function writes to `ff_push_notifications` or calls FCM directly is **server-side
  (needs backend owner)**.
- Manually, in the Firebase console, using the fields below.

### `ff_push_notifications` fields

Standard FlutterFlow fields:

| Field | Meaning |
|---|---|
| `notification_title`, `notification_text` | Required. Plain-text title and body |
| `notification_image_url` | Optional image (iOS needs the `ImageNotification` extension, which is included) |
| `notification_sound` | Optional |
| `target_audience` | `All`, `ios`, or `android` (matched against `device_type`) |
| `user_refs` | Optional comma-separated `users/<uid>` paths. When set, only these users receive it |
| `initial_page_name`, `parameter_data` | Page to open on tap, plus its parameters (JSON string) |
| `scheduled_time` | Optional timestamp; leave empty to send now |
| `num_batches`, `batch_index` | Split very large sends |

**Targeting fields.** Implemented in `firebase/functions/index.js` but not yet deployed
(`firebase deploy --only functions`). Every field is optional, and a document that sets
none of them behaves exactly as above.

| Field | Meaning |
|---|---|
| `target_language` | `en`/`es`/`ur`/`lg`, a list, or a comma-separated string. Matched against `users.preferredLanguage` (missing means `en`) |
| `target_pathway` | Pathway id(s). Matched against the user's `recommendedPathwayId`, `companionPathwayId`, `currentPathwayId`, and `additionalPathwayIds` |
| `target_timezone` | IANA timezone(s), e.g. `Africa/Kampala`. Matched against `users.timezone` (set on the Profile → Timezone page) |
| `notification_title_i18n`, `notification_text_i18n` | Maps `{en, es, ur, lg}`. Each user receives their language, falling back to English, then to `notification_title` / `notification_text` |
| `local_send_hour` | 0–23. Delivers at this hour in **each user's** timezone (users without a valid timezone are treated as UTC), over a 24-hour window starting at `scheduled_time` or creation. Zones already delivered to are recorded in `sent_timezones`, so no one gets it twice |

Privacy: push payloads never carry reflection content. The function sends only
whitelisted data keys, removes `reflection*` keys from `parameter_data`, and reads user
documents with a field mask.

Example of a localized morning reminder for the "come-and-see" pathway at 7 am local time:

```json
{
  "notification_title": "Today's lesson is ready",
  "notification_text": "Open Kingdom Heirs to continue.",
  "notification_title_i18n": {"en": "Today's lesson is ready", "es": "…", "ur": "…", "lg": "…"},
  "notification_text_i18n":  {"en": "Open Kingdom Heirs to continue.", "es": "…", "ur": "…", "lg": "…"},
  "target_audience": "All",
  "target_pathway": "come-and-see",
  "local_send_hour": 7,
  "scheduled_time": "<timestamp>",
  "initial_page_name": "TodayPage"
}
```

(The exact `initial_page_name` values are the `routeName`s in `lib/flutter_flow/nav/nav.dart`.)

### Configuration checklist
- **Android:** FCM works through `google-services.json`. On Android 13+, the permission
  prompt comes from the primer page.
- **iOS:** upload the APNs `.p8` key to Firebase → Cloud Messaging, enable the Push
  Notifications and Background Modes (Remote notifications) capabilities, and check
  `aps-environment` (see [build-and-release.md](build-and-release.md#ios-signing-and-testflight)).
- `firestore.indexes.json` has the `fcm_tokens.fcm_token` collection-group index; it is
  required.
- Test on real devices. The iOS Simulator cannot receive remote pushes reliably.

## "Ask Kingdom Heirs" assistant

Page: **`/search/rag`** (`lib/rag_search_page`). The "RAG" label was removed from the UI.

- The member types a question. The app reads their language from `getUserProfile` and
  POSTs `{authToken, question, locale}` to **`ragQueryHttp`**.
- The response fields it displays:

  | Field | Shown as |
  |---|---|
  | `answer` | Main answer text |
  | `citations` | A "Citations" block (a single text string listing the sources) |
  | `fallbackTriggered` / `fallbackMessage` | A message shown when the service could not answer from its sources (e.g. out of scope, or nothing relevant found) |

- It needs internet; there is no offline mode.
- The admin report shows the last question asked (`lastRagQuestion`).

### Needs input from backend owner
Everything behind `ragQueryHttp` is outside this repo:
- Which source documents are indexed (lessons? external books?), where they are stored,
  and how staff add, update, or remove them.
- The embedding/vector store and LLM provider and model. The functions `package.json`
  lists LangChain packages for OpenAI, Google GenAI, and Anthropic, but no code in this
  repo uses them. The monthly cost and the name of the API-key secret are also unknown.
- The guardrails: when the fallback triggers, doctrinal review of answers, and the
  languages supported.
- Logging and retention of member questions (a privacy policy item).
