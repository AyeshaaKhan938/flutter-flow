# Import templates

The field dictionary and CSV templates for the **Bulk Curriculum Importer** (see
[cms-admin-guide.md](cms-admin-guide.md#import-curriculum-csv)).

> **Important: the column names are not confirmed.** The app sends only the target
> collection name and the raw CSV text to the `importCurriculum` Cloud Function, which is
> **not in this repo**. All parsing and validation happen there. The headers below mirror
> the Firestore fields the app reads (`lib/backend/schema/*.dart`), with localized fields
> split into one column per language (`<field>_en`, `_es`, `_ur`, `_lg`). **Before real
> use, run _Preview Import_ with each template.** If the preview reports unknown or missing
> columns, get the exact spec from the backend owner and update this page.

## Rules for every collection

| Rule | Detail |
|---|---|
| Header row | Required; first line of the CSV |
| Encoding | UTF-8, which Urdu (اردو) and other non-Latin text needs. In Excel choose "CSV UTF-8"; Google Sheets exports UTF-8 by default |
| Quoting | Wrap any value that contains a comma, quote, or line break in `"…"`. Write a literal quote as `""` |
| `stableId` | **Required, unique within its collection, and never changed.** It is the upsert key: an existing stableId is **updated**, and a new one is **created** |
| Languages | `en` is required. `es`, `ur`, and `lg` are optional. Blank translations fall back to English in the app |
| Dates | `yyyy-MM-dd` (e.g. `2026-10-01`) and nothing else. A value like `10/1/2026` will not match any day |
| `status` | `draft`, `in_review`, or `published` (daily Scripture and encouragements also accept `unpublished`). If you're unsure, import as `draft` and publish from the admin page |
| Booleans | `true` / `false` |

## pathways

| Column | Required | Notes |
|---|---|---|
| `stableId` | yes | e.g. `come-and-see` |
| `title_en` … `title_lg` | en | |
| `description_en` … `description_lg` | en | |
| `durationDays` | recommended | integer |
| `order` | recommended | integer; lower numbers are listed first |
| `status` | recommended | |

```csv
stableId,title_en,title_es,title_ur,title_lg,description_en,description_es,description_ur,description_lg,durationDays,order,status
come-and-see,Come and See,,,,"A 14-day introduction to Jesus.",,,,14,1,draft
```

## lessons

| Column | Required | Notes |
|---|---|---|
| `stableId` | yes | e.g. `LESSON-COME-001` |
| `pathwayId` | yes | The **stableId** of an existing pathway. Import pathways first |
| `dayNumber` | yes | integer, starting at 1 |
| `title_*` | en | |
| `scriptureRef` | recommended | e.g. `John 1:35-39`. Use English book names; the reference drives the Bible passage lookup |
| `scriptureText_*` | recommended | Shown when the Bible API can't be reached |
| `reflectionPrompt_*` | recommended | |
| `application_*`, `prayer_*` | optional | New fields; confirm the importer supports them |
| `mediaUrl` | optional | Full `https://` URL |
| `status` | recommended | |

```csv
stableId,pathwayId,dayNumber,title_en,title_es,title_ur,title_lg,scriptureRef,scriptureText_en,reflectionPrompt_en,reflectionPrompt_es,reflectionPrompt_ur,reflectionPrompt_lg,mediaUrl,status
LESSON-COME-001,come-and-see,1,Jesus Invites Us,,,,John 1:35-39,"""Come,"" he replied, ""and you will see.""",What is God showing you today?,,,,,draft
```

## dailyScripture

| Column | Required | Notes |
|---|---|---|
| `stableId` | yes | Use one id per day, e.g. `DS-2026-10-01` |
| `date` | yes | `yyyy-MM-dd`, one entry per date |
| `verseRef` | yes | e.g. `Psalm 23:1` |
| `text_en` … `text_lg` | en | |
| `status` | recommended | |

```csv
stableId,date,verseRef,text_en,text_es,text_ur,text_lg,status
DS-2026-10-01,2026-10-01,Psalm 23:1,"The Lord is my shepherd, I lack nothing.",,,,published
```

## encouragements

| Column | Required | Notes |
|---|---|---|
| `stableId` | yes | e.g. `ENC-2026-10-01` |
| `date` | yes | `yyyy-MM-dd` |
| `quote_en` … `quote_lg` | en | |
| `attribution` | recommended | Author or source |
| `rightsCleared` | yes | `true` only if you have permission to publish |
| `status` | recommended | |

```csv
stableId,date,quote_en,quote_es,quote_ur,quote_lg,attribution,rightsCleared,status
ENC-2026-10-01,2026-10-01,"Keep going. God is faithful.",,,,Kingdom Heirs,true,draft
```

## Not importable

- **Quizzes.** The importer has no quizzes target, and the `questions` structure is
  server-defined (the app shows up to 10 questions with options A–D). Ask the backend owner.
- **Onboarding and assessment questions, announcements.** These are managed on the admin
  page or by the backend.

## Recovery

| Problem | Fix |
|---|---|
| Wrong text or date in some rows | Correct the rows and re-import them with the **same stableIds**. They are updated in place |
| An entire import was wrong | Re-import the previous master CSV. Rows that were only in the bad file remain; unpublish them |
| Item should disappear for members | Set `status` to `draft` (or `unpublished`) by re-import, or use **Unpublish** on the admin page. Avoid Delete |
| Duplicate content under two stableIds | Unpublish the extra one. Don't reuse its stableId for something else |
| Changed a stableId by mistake | The importer treats it as a new record, so you get a duplicate. Unpublish the new one and restore the original id |
| Import of lessons fails with a missing pathway | Import or create the pathway first, and check that `pathwayId` matches its stableId exactly (case-sensitive) |
| Something catastrophic | Restore from the Firestore backup ([operations.md](operations.md#backup-and-restore)) |

Keep every imported CSV, dated, in a shared Kingdom Heirs folder. Those files let you roll
back by re-importing.
