# Translations, Bible, and offline

## Languages

| Code | Language | Direction | Notes |
|---|---|---|---|
| `en` | English | LTR | Default and fallback |
| `es` | Spanish | LTR | |
| `ur` | Urdu | **RTL** | |
| `lg` | Luganda | LTR | Flutter has no built-in Material/Cupertino strings for `lg`; FlutterFlow's fallback delegates in `internationalization.dart` handle this |

The supported locales are declared in `main.dart` and in `FFLocalizations.languages()`.
The member's choice is saved on the device (SharedPreferences key `__locale_key__`) and on
the server (`users.preferredLanguage` via `updateUserProfile`). When a member changes
language offline, the change is queued (`pending_language_sync`) and sent when the device
reconnects.

**RTL for Urdu.** When the locale is `ur`, Flutter mirrors the layout automatically.
`applyLocaleDirectionality` stores the locale and returns `rtl` or `ltr` for pages that
need it. When you add UI, use `EdgeInsetsDirectional` and `AlignmentDirectional` instead of
left/right, and test every page in Urdu.

### Two kinds of text

1. **UI strings** (buttons, labels) live in `lib/flutter_flow/internationalization.dart`
   and are edited in **FlutterFlow → Languages**. `getText` has **no English fallback**.
   An empty translation shows as blank text. At the time of writing, **96 of 268 strings
   have English but no Spanish or Urdu**, mostly admin labels plus a few member-facing
   strings such as "Pathways". Fill these in FlutterFlow.
2. **Content** (pathway, lesson, Scripture, encouragement, and announcement text) is
   stored in Firestore as `{en, es, ur, lg}` maps. `LocaleTextStruct.forLanguage(code)`
   returns the requested language and **falls back to English when it is empty**
   (`lib/backend/schema/structs/locale_text_struct.dart`). `deviceContentLanguage()` maps
   the app locale to a content language, and anything unknown becomes `en`.

### Gaps
- The admin quick create and edit actions (`admin*Pathway/Lesson`) write the same English
  text into en/es/ur and **never set `lg`**. Use the CSV importer for real translations.
- `publishAnnouncement` and `generateTranslationDrafts` handle **only en/es/ur**.
  Luganda needs backend support.

## Bible integration

The [README](../README.md#bible-integration) covers the translation per language,
FUMS reporting, caching, and deep-link fallback. It is summarised here only for context:

- Passages come from **API.Bible**: NIV (en), RVR1909 (es), Open Urdu Contemporary (ur),
  and Open Luganda Contemporary (lg). The key `API_BIBLE_KEY` is injected at build time.
  Without the key, English uses bible-api.com (KJV) and other languages use the deep link.
- Every displayed passage is reported to API.Bible **FUMS** (Fair Use Management System),
  as required by their terms, and shown with its copyright notice.
- Fallback order: live API → passage saved on the device → the lesson's stored
  `scriptureText` → a deep link (BibleGateway; bible.com LB03 for Luganda).
- Code: `lib/custom_code/actions/fetch_bible_verse_api.dart` (translation ids) and
  `lib/custom_code/bible_reference.dart` (reference parser). Write `scriptureRef` with
  **English book names** (`1 John 4:7-8`).
- Licensing: NIV text is licensed through API.Bible under its usage limits. Check the
  API.Bible dashboard for your plan's limits and the terms for each translation before
  scaling.
- **These files are deleted by FlutterFlow syncs.** See [architecture.md](architecture.md#flutterflow-sync-caveat).

## Offline

| Layer | Where | What it covers |
|---|---|---|
| Firestore persistence | `ensure_firestore_offline_persistence.dart` (called in `main.dart`) | Unlimited on-device cache of every Firestore document already read (pathways, lessons, quizzes, announcements) |
| API response cache | `lib/backend/api_requests/offline_api_cache.dart`, hooked into `api_manager.dart` | The last successful response of each `Get*` / `List*` call (except `GetAdminReport`), stored per user in SharedPreferences. It is served only when the request cannot reach the server (network error). Covers the profile, today's content, pathway progress, and quiz content |
| Last lesson | `cacheLessonForOffline` → `FFAppState().offlineLesson*` | The last opened lesson, so the lesson page is never blank |
| Bible passages | `fetch_bible_verse_api.dart` | Every passage opened once |
| Write queue | `FFAppState().pendingOfflineWrites` (`{reflections:[], progress:[]}`, persisted as `ff_pendingOfflineWrites`) | Lesson completions and reflections made offline |
| Quiz answers | `quiz_answers_store.dart` | The member's last submitted answers, for review |

**Sync on reconnect.** `main.dart` listens to `connectivity_plus`. When the device comes
back online, it calls `refreshConnectivityAndSync`, which (1) sends any pending language
change to `updateUserProfile` and (2) posts the queue to `syncOfflineProgressHttp`. The
queue is cleared only on a 2xx response. `saveLessonProgressSmart` also flushes the queue
after any successful online save. Each reflection carries a `clientWriteId`, so the server
can remove duplicates. Whether it actually does is **server-side** (needs backend owner).

### Known limitations
- **Quiz submission, the assessment, the assistant, and all admin actions need internet.**
  They are not queued and fail offline.
- Content never opened while online (a lesson, a Scripture passage, a day's Today content)
  is not available offline.
- The queue lives on one device. If the app is uninstalled, or the member signs out and
  another member signs in before the device syncs, the pending writes can be lost or
  attributed to the next account. The queue is not keyed by user.
- On a network with no internet (captive portal), sync fails quietly and retries on the
  next connectivity change or lesson save.
- The API cache keeps only the latest response per call and parameters, and has no expiry.

## Missing UI translations

Many UI strings (buttons, labels, headings) have no Spanish or Urdu text, and some have no
Luganda. They now fall back to English instead of showing blank: `FFLocalizations.getText`
in `lib/flutter_flow/internationalization.dart`.

[`missing-ui-translations.csv`](missing-ui-translations.csv) lists every string with at
least one missing language: its key, the English text, and whatever translations exist.
Give the file to a translator, then enter the results in **FlutterFlow → Languages**.
Editing `internationalization.dart` by hand doesn't work, because the next FlutterFlow
sync overwrites it.
