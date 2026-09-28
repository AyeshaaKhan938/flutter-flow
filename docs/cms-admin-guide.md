# CMS admin guide

For Kingdom Heirs staff who manage content in the app.

## Getting in

1. Sign in with an account whose `role` is **`admin`** or **`ministry_reviewer`**. A
   developer or the backend owner sets the role on the member's `users/{uid}` document in
   the Firebase console.
2. Go to **Profile → Admin**. The app checks your role with `getUserProfile` and opens
   **Manage Pathways** (`/admin/pathways`). Everyone else sees "Admin access required."

> Before launch, a developer must tighten the Firestore rules (see [firebase.md](firebase.md#security-rules)).
> Some buttons below write to Firestore directly and **fail with a permission error under
> the rules currently in the repo**. If a button does nothing or shows an error, report it.

## Content lifecycle

Every pathway, lesson, and quiz has a `status`:

```
draft ──Submit for Review──▶ in_review ──Approve & Publish──▶ published
  ▲                                                             │
  └──────────────── Back to Draft / Unpublish ◀─────────────────┘
```

Members see **only `published`** items. Unpublishing never deletes content.

## The Manage Pathways page, section by section

| Section | What it does |
|---|---|
| **Publish announcement** | Title and body in English, plus Spanish and Urdu *drafts*. **Publish + notify members** saves the announcement and sends a push. **Save announcement only (no push)** saves it without a push. Uses `publishAnnouncement`. Luganda text is not supported here yet. |
| **Translation drafts** | **Generate ES/UR pathway drafts** / **Generate ES/UR lesson drafts** fills missing Spanish and Urdu text automatically (`generateTranslationDrafts`). Always have a fluent speaker review drafts before publishing. How the drafts are produced is server-side (needs backend owner). |
| **Assessment rules (live)** | **Load active config**, edit the JSON (version, score bands, overrides, explanations, point map), then **Save & activate rules**. Changes take effect immediately for new assessments. Copy the old JSON somewhere safe before you edit. |
| **Admin report** | Counts of pathways, lessons, quizzes, and members, the last import summary, and the last assistant question. **Refresh report** reloads it. |
| **Create content** | **Create pathway (draft)**: English title plus a Stable ID (e.g. `come-and-see`). **Create lesson (draft)**: English title, Stable ID (e.g. `LESSON-COME-001`), the parent pathway's stableId, and a Scripture ref (e.g. `John 3:16`). The English title is copied into es/ur as a placeholder, and the lesson gets a default reflection prompt. Use the importer for full multilingual content. |
| **Edit content** | **Edit pathway**: new English title and/or status. **Edit lesson**: parent pathway stableId + lesson stableId, then any of title, Scripture ref, reflection prompt, status. Leave a field blank to keep its current value. Edits write the same text to en/es/ur. |
| **Pathways / Lessons / Quizzes (all statuses)** | Lists with **Submit for Review**, **Approve & Publish**, **Back to Draft**, and **Unpublish** buttons. Pathways also have **Delete**, which is permanent; prefer Unpublish. The Lessons and Quizzes lists show only the **first 20** records. |
| **Daily Scripture (all statuses)** | Read-only list (date and reference). |
| **Bulk Curriculum Importer** | See below. |

**Quizzes** cannot be created or edited on this page, or through the importer. Get them
loaded through the backend owner, and use this page only to change their status.

## Import curriculum (CSV)

1. Prepare a CSV with a **header row** (templates in [import-templates.md](import-templates.md)).
2. On **Bulk Curriculum Importer**, pick the target: **pathways**, **lessons**,
   **dailyScripture**, or **encouragements**.
3. Paste the whole CSV, header included, into **CSV content**.
4. Click **Preview Import**. Nothing is saved. The page shows **Create / Update / No
   change / Errors** counts and the first error.
5. Fix any errors and preview again. When the counts look right, click **Confirm Import**.
6. Rows are matched by **`stableId`**. An existing stableId is updated, and a new one is
   created. Re-importing the same file is safe: those rows come back as "No change".

The importer calls `importCurriculum` and times out after 120 seconds, so split very large
files. Column parsing and validation happen on the server.

## Daily Scripture and encouragements

- Each entry has a `date` (`yyyy-MM-dd`), which is the day it appears on **Today**.
  Today's content comes from `getTodayContent`.
- Load a month or a year at a time with the importer (`dailyScripture` / `encouragements`).
- For encouragements, set `rightsCleared` only when you have permission to publish the quote.
- **New Admin Content page (in progress):** a dedicated page (`lib/admin_content_page`)
  is being built to browse daily Scripture and encouragements by month and status, edit
  them, schedule them by date, and set them to `published`, `draft`, or `unpublished`.
  Until it ships, fix a single entry by re-importing a corrected row with the same stableId.

## Announcements

Announcements show on the **Today** page (latest 20). Write the English text first, then
review or enter the Spanish and Urdu versions. Use **Publish + notify members** for things
worth a push notification, and **Save only** for everything else. Targeted pushes (by
language, pathway, or timezone) are covered in
[notifications-and-assistant.md](notifications-and-assistant.md).

## Good practice

- Choose stableIds once and never reuse or rename them. Use the format
  `LESSON-<PATHWAY>-<NNN>`.
- Keep the master CSVs in a shared Kingdom Heirs drive. They are your content backup and
  change history.
- Publish in this order: pathway, then its lessons, then quizzes.
