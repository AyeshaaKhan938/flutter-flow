# Languages, machine translation and review

Languages are managed in the CMS, not in the app code. An administrator can
add and activate a language without changing or republishing the app.

## Concepts

| Term | Meaning |
| --- | --- |
| **Master source** | English. All content is written in English first; every translation is a translation of the English text. |
| **Approved languages** | Languages whose content Kingdom Heirs has reviewed (tier `approved`). Shown first in the language picker. |
| **More languages** | Languages served by Google Cloud Translation (tier `machine`). Shown under "More languages (machine-translated)". |
| **Machine-translation notice** | "Machine-translated — not yet reviewed by Kingdom Heirs". Shown on the lesson, Today and Pathways screens wherever unreviewed machine text is displayed. Approved translations show no notice. |
| **Scripture** | Never machine-translated. Bible passages come from API.Bible in the language's approved Bible, or in English with the note "Bible shown in English — no approved translation for this language". |

## The `languages` collection

One document per language, id = language code:

| Field | Example | Notes |
| --- | --- | --- |
| `code` | `fr` | ISO 639-1 code (or `zh_hant` style). |
| `name` | `Français` | Native name, shown in the picker. |
| `englishName` | `French` | |
| `tier` | `machine` / `approved` | Section of the picker; `approved` means content is reviewed. |
| `active` | `true` | Only active languages are offered and translated. |
| `rtl` | `false` | Right-to-left layout for this language (Arabic, Farsi, Hebrew, Urdu…). |
| `order` | `10` | Position in the picker. |
| `bibleId` | `a93a92589195411f-01` | API.Bible id for Scripture. Empty = English Bible with a note. |
| `bibleName` | `LSG` | Abbreviation shown with the passage. |
| `googleCode` | `zh-TW` | Optional, only if Google uses a different code. |

If the collection is empty or unreachable, the app uses its built-in English,
Spanish, Urdu (RTL) and Luganda. **Admin › Daily Content › translate icon ›
Languages › "Seed default languages"** creates those four documents (it never
overwrites existing ones).

## Adding a language

1. Admin › Daily Content › translate icon (Languages & translations).
2. **Add language**: code, native and English names, tier `machine`,
   Active on, RTL if the script is right-to-left, order.
3. Optional: the language's API.Bible id and abbreviation. Only Bibles the
   project's API.Bible key is licensed for will work. The `getBiblePassage`
   function accepts any `bibleId` set on an active language (refreshed
   every 5 minutes), plus the four built-in Bibles.
4. Optional: **Translation review › Generate translations for all published
   content** to translate everything up front (otherwise texts are
   translated the first time a member opens them).

Members see the language in Profile › Language and in onboarding right away
(the list is read from Firestore and cached on the device).

## How translation works

- Content fields are `LocaleText` maps (`{en, es, ur, lg, …}`). Any language
  key stored in the map (e.g. `title.fr`) is used as-is and is treated as
  reviewed text.
- When a language has no stored text, the app asks the `translateTexts`
  Cloud Function (firebase/functions/translation.js) for the English text in
  that language. The function:
  1. checks `machineTranslations/{lang}_{sha256(english)}`: approved text
     first, then machine text;
  2. sends only texts never translated before to Google Cloud Translation
     (v2, English source) and stores the result with `status: machine`.
- The app keeps every translation on the device (SharedPreferences), so a
  text is requested once per device and is readable offline. The background
  offline download translates lessons, pathways, announcements, the next 7
  days of Daily Truth and encouragements, quiz and assessment questions and
  UI labels for the member's language. On reconnect it refreshes machine
  entries so newly approved corrections reach members.
- UI labels: Spanish, Urdu and Luganda are compiled into the app. Other
  languages get UI labels as translations of the English labels.
- The backend functions (getTodayContent, getQuiz, getAssessmentQuestions)
  answer languages they don't know in English; the app translates that text
  on the device (question text only, never answer keys).

What is machine-translated: lesson titles, reflection prompts, applications,
prayers, quiz/assessment questions, Daily Truth commentary, encouragements,
announcements, pathway titles/descriptions and UI labels.
What is never machine-translated: Scripture (lesson `scriptureText` and all
API.Bible passages).

## Review workflow

Admin › Languages › **Translation review**:

1. Choose the language; the default filter is "Awaiting review"
   (`status: machine`).
2. For each entry: English source, machine translation, and an editable
   "Corrected translation".
3. **Approve** stores `status: approved` and `approvedText` (your
   correction). Members get the approved text on their next refresh, with no
   notice. Approved entries can be edited again under "Approved".
4. **Reject** deletes the entry; members see English until it is translated
   again.

When every text of a language has been reviewed, set the language's tier to
`approved` so it moves to "Approved languages".

## Costs

Google Cloud Translation (Basic, v2) is billed per character sent
(currently USD 20 per million characters after the monthly free tier of
500,000 characters; check current pricing at
https://cloud.google.com/translate/pricing). Characters are counted on the
English source.

Costs are controlled by caching:

- Each distinct text is translated once per language for all members
  (`machineTranslations`), and once per device on the app side.
- "Generate translations for all published content" only sends texts not
  yet in the cache; running it twice costs nothing extra.
- Editing English text creates a new source text (new cache entry), so only
  the edited text is re-translated.
- Rejecting an entry deletes it; the next request pays again.

Rough sizing: if all published content plus UI labels is ~400,000
characters, one new language costs about USD 8 (or nothing within the free
tier).

## Bible per language

Set `bibleId` (and `bibleName`) on the language. If empty, the reader shows
the English Bible (NIV, or KJV fallback) with the note "Bible shown in
English — no approved translation for this language". Scripture is never
sent to machine translation.

## RTL

Set `rtl: true`. Urdu is compiled into the app and uses Flutter's RTL
locale. For a CMS-added RTL language the app keeps an English framework
locale (Flutter only ships the compiled locales) and applies right-to-left
directionality to the whole app from the `rtl` flag.

## Setup (one time, in the Firebase project's Google Cloud console)

1. Enable the **Cloud Translation API**:
   https://console.cloud.google.com/apis/library/translate.googleapis.com
   (project `kingdom-heirs-discipleshipapp`). Billing must be enabled.
2. The Cloud Functions runtime service account needs permission to call it
   (role **Cloud Translation API User**, `roles/cloudtranslate.user`; the
   default compute service account with Editor already has it).
3. Deploy:
   ```
   cd firebase/functions && npm install
   firebase deploy --only functions:translateTexts,functions:getBiblePassage
   firebase deploy --only firestore:rules
   ```
4. In the app: Admin › Languages › **Seed default languages**.

## Limitations

- Language names in the picker come from the CMS; the remaining compiled UI
  translations for Spanish/Urdu/Luganda are unchanged.
- Backend-generated text (Today, quizzes, assessment) for CMS-added
  languages is translated on the device; a member offline before the first
  download sees English for text not yet cached.
- Machine translation of UI labels can be long; review short labels first.
- The external `updateUserProfile` function must accept any language code
  for the profile to keep it; the device's choice is used regardless.
