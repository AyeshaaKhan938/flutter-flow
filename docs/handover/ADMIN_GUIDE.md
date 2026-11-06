# Admin guide

For Kingdom Heirs staff who manage the app. No programming needed, except where a step
says to ask a developer. Written 2 November 2026 from the app code.

Two places are used:

- **The app's admin pages** (on your phone or tablet, signed in as an admin).
- **Firebase console** (console.firebase.google.com, project
  `kingdom-heirs-discipleshipapp`) for a few settings that have no admin page yet.

## 1. Becoming an admin

1. Create a normal account in the app (email and password).
2. Someone with Firebase console access opens **Firestore Database → `users` → your
   account's document** and sets the field **`role`** to `admin` (or `ministry_reviewer`).
   Members cannot give themselves a role; the security rules block it.
3. Sign out and back in. **Profile** now shows **Manage Content (Admin)**, visible only to
   admins and ministry reviewers. Everyone else gets "Admin access required."

`admin` and `ministry_reviewer` currently have **the same powers**, including
publishing. If reviewers should not publish, a developer must change the code and rules.

**Content reviewers (review mode).** To let someone check every pathway without
completing the earlier ones, set their `role` to **`content_reviewer`** in the same way.
They can then open every core pathway, every lesson in any order and every quiz. They
have no admin rights and cannot change content. Admins and ministry reviewers have review
mode too. Progress, completion and certificates are still earned the normal way. Remove
the role (set it to empty) when the review is finished. Ask the member to close and
reopen the app after a role change.

## 2. Where the admin pages are

| Page | How to get there | What it is for |
|---|---|---|
| **Manage Pathways** | Profile → Manage Content (Admin) | Pathways, lessons and quizzes; announcements; assessment rules; admin report |
| **Daily Content** | Manage Pathways → calendar icon (top right) | Daily Scripture and Encouragements |
| **Import Content** | Daily Content → upload icon | Bulk import from CSV or Excel |
| **Languages** | Daily Content → translate icon | Languages offered to members, and translation review |

## 3. Draft and published

Members only ever see content whose status is **published**. Everything else is hidden
from them and nothing is deleted.

| Status | Meaning |
|---|---|
| `draft` | Being written. Imports always create new records as draft. |
| `review` (or `in_review` on Manage Pathways) | Ready for ministry review |
| `published` | Visible to members |
| `unpublished` | Taken down. Can be published again. |

Publish in this order: the pathway, then its lessons, then its quizzes.

## 4. Manage Pathways page

Sections, top to bottom:

- **Publish announcement.** Title and text in English, with optional Spanish and Urdu
  versions. **Publish + notify members** saves it and sends a push notification.
  **Save announcement only (no push)** saves it without a push. Announcements appear on
  the Today page. Luganda text cannot be entered here.
- **Translation drafts.** **Generate ES/UR pathway drafts** and **Generate ES/UR lesson
  drafts** fill in missing Spanish and Urdu text. Have a fluent speaker check them.
- **Assessment rules (live).** **Load active config**, edit the score bands, overrides,
  explanations and point map, then **Save & activate rules**. Changes apply to new
  assessments at once. Copy the old text somewhere safe before editing.
- **Admin report.** **Refresh report** shows counts of pathways, lessons, quizzes and
  members, and the last import.
- **Create content.** Create a draft pathway (English title + Stable ID such as
  `come-and-see`) or a draft lesson (title, Stable ID such as `LESSON-COME-001`, parent
  pathway's Stable ID, Scripture reference). For full multilingual content, use Import.
- **Edit content.** Change a pathway's English title or status, or a lesson's title,
  Scripture reference, reflection prompt or status, by Stable ID. Blank fields are left
  unchanged.
- **Pathways / Lessons / Quizzes (all statuses).** Buttons to **Submit for Review**,
  **Approve & Publish**, **Back to Draft** and **Unpublish**. Pathways also have
  **Delete**, which is permanent; use Unpublish instead. The lessons and quizzes lists
  show only the first 20 records.
- **Daily Scripture (all statuses).** A read-only list.
- **Bulk Curriculum Importer.** The older paste-in importer. Use the **Import Content**
  page instead (section 6).

## 5. Daily Content page (Daily Scripture and Encouragements)

- Switch between **Daily Scripture** and **Encouragements**. Filter by **month** and
  **status**, or search by date or text.
- **New record** or **Edit** opens a form: scheduled date, verse reference (Scripture) or
  attribution and **Rights cleared** (Encouragements), the text in English (required),
  Spanish, Urdu and Luganda (optional; English is shown if empty), and status.
- **Publish** / **Unpublish** on each row.
- Each date can have only one record. Dates repeat every year.
- Bible verse text itself always comes from the licensed Bible in the member's language.
  The text you write here is Kingdom Heirs' own commentary ("Daily Truth").

## 6. Importing content

Use this for anything more than a few edits.

1. Open **Import Content**.
2. Choose the **content type**: Pathways, Lessons, Quiz questions, Daily Scripture,
   Encouragements, or Assessment questions.
3. **Choose file**: a `.csv` saved as **CSV UTF-8** (needed for Urdu and Spanish), the
   original Excel master (`.xlsx`), or the handoff `.zip`.
4. Tap **Preview**. Nothing is saved. The report shows how many rows would be inserted,
   updated or skipped, plus any errors and warnings.
5. Fix errors in your file and preview again.
6. Tap **Import as Draft** and confirm. If any row has an error, **nothing** is written.
7. Publish the new records (sections 4 and 5).

Rows are matched by **Stable ID**. Importing the same file twice is safe: existing records
are updated and unchanged rows are skipped. Never reuse a Stable ID for different
content. **Recent imports** lists past runs; **Copy report** copies a report to share.
Column templates are in `docs/import/templates/` and the rules in
[../import/README.md](../import/README.md).

When English text changes, the import also creates machine-translated drafts in the other
languages for review (section 7).

## 7. Languages and translation review

- **Languages.** Add, edit or switch off a language without an app update: native and
  English name, order in the picker, right-to-left, and the API.Bible id of its Bible
  (leave empty to show the English Bible with a note). Tier **Released** means Kingdom
  Heirs has reviewed it; **Machine** languages show a "machine-translated" notice.
  **Seed default languages** creates English, Spanish, Urdu and Luganda if none exist.
- **Generate translations for all published content** pre-translates everything for one
  language using Google Translate.
- **Translation review.** Filter by language and status, correct the text, then
  **Save approved** (or **Approve** as is). **Reject** deletes the machine text. Approved
  text replaces the machine text everywhere and removes the notice.
- Scripture is never machine-translated.

## 8. Push notifications

- **Send a notification:** Manage Pathways → bell icon (top right) opens **Notifications**.
  1. Enter a **Title** and **Message**. Members receive exactly this text.
  2. Optionally choose **Devices** (iPhone or Android), **Language** and **Pathway**.
     Leave them on "All" to reach every member who allowed notifications.
  3. Choose **Send now**, or **Schedule…** and pick a date and time. Scheduled
     notifications go out within about 5 minutes of that time.
  4. Tap **Send notification** and confirm.
  **Recent notifications** shows each one with its status and how many devices it reached.
  Tapping a notification opens the app on the Today page.
- **Announcement on the Today page with a push:** Manage Pathways →
  **Publish + notify members**.
- **Advanced** (each member's local time, e.g. 7 am everywhere): create a document in
  **`ff_push_notifications`** in Firebase console. The fields are listed in
  [../notifications-and-assistant.md](../notifications-and-assistant.md#push-notifications).
- Notifications are text only. Pictures in notifications are a possible future
  enhancement.
- iPhones receive notifications only after the APNs key is uploaded in Firebase →
  Project settings → Cloud Messaging.

## 9. Ask Kingdom Heirs

Ask answers questions only from Kingdom Heirs' own books and the App Help guide, and cites
its sources. Crisis, abuse, medical, legal and financial questions get fixed safety
responses first.

**Current state:** not live for members. Only admins, ministry reviewers and the listed
testers can use it. Everyone else sees "Ask Kingdom Heirs is coming soon."

All settings are in **Firebase console → Firestore → `config` → `askKingdomHeirs`**:

| To do this | Change |
|---|---|
| Add or remove a tester | Edit the **`testerEmails`** list (the email they sign in with) |
| Go live for all members | Set **`enabled`** to `true` (only after Kingdom Heirs approval) |
| Stop Ask immediately | Set **`paused`** to `true` |
| Resume after a pause | Set **`paused`** to `false` |
| Change the daily question limit | **`dailyLimitPerMember`** (default 100) |
| Answer in the member's language | **`answerInMemberLanguage`** = `true`. Otherwise answers are in English with a notice |

**Budget pause.** Ask stops automatically when Google Cloud costs reach the **$50 monthly
budget**. Members then see "Ask Kingdom Heirs is resting for a little while." It does
**not** restart on its own. Check the bill, then set `paused` to `false`. The reason is
recorded in `pausedReason`.

**Reports from members.** "Report an issue" on an answer saves to the **`askReports`**
collection (Firebase console). Member questions are not otherwise stored.

**Adding or updating books.** A developer loads them (see
[BUILD_AND_DEPLOY.md](BUILD_AND_DEPLOY.md#9-ask-kingdom-heirs)). Send the developer the
final manuscript and its title, author, edition and pathway.

## 10. Certificates

Certificates are issued **automatically** by the app. There is nothing for admins to do
day to day.

- **Pathway Certificate of Completion:** when a member finishes every published lesson in
  a pathway and passes every required quiz (default pass mark 80%; a pathway can have its
  own `passingScore`, set in Firebase console).
- **Kingdom Heirs Commissioning Certificate:** when a member completes all seven required
  core pathways. The commissioning wording is the text Kingdom Heirs approved on
  14 October 2026, in English only.
- Members see them under My Certificates and can download or share a PDF.
- A certificate's name, date and ID never change once issued. Admins cannot issue, edit or
  revoke certificates in the app. They are stored in `users/{uid}/certificates` in
  Firestore.

## 11. Getting help

If a button shows an error or does nothing, take a screenshot and send it to the
developer, with the time and the account you were signed in with.
