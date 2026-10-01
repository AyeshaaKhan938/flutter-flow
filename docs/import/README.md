# Content import: developer response to the CSV handoff package

Response to `Kingdom_Heirs_Developer_CSV_Handoff_v1.zip` (Master Content
Handoff v2). Prepared 2026-10-01.

## Files

- `10_Field_Mapping_Developer_Response.csv`: the proposed field mapping,
  with **Developer Confirmed?** and **Developer Notes** filled in against the
  production Firestore schema:
  - **Yes:** the proposed field matches production. 8 fields.
  - **Changed:** the field exists under a different name or structure (see the notes). 16 fields.
  - **Not built:** the feature does not exist in the app yet. 10 fields: lesson body, pathway
    completion records, certificates, field practice, leader verification, commissioning
    and version. These need a scope decision.
- `templates/`: one CSV header template per collection, using the exact
  production field names, with one example row:
  - `pathways.csv`
  - `lessons.csv`
  - `quiz_questions.csv` (one row per question)
  - `daily_scripture.csv`
  - `encouragements.csv`
  - `assessment_questions.csv` (one row per answer option, as in the package)

## Rules for every file

- **Encoding:** UTF-8. This is required for Urdu and Spanish characters.
- **Language columns:** one column per language, named `<field>_<language>`, for example
  `title_en`, `title_es`, `title_ur`, `title_lg`.
  - English is the master copy and is required.
  - Leave other languages empty if they are not translated yet. The app shows English, with a
    clear fallback notice.
- **IDs:** `stableId` is the unique key.
  - Re-importing a row with the same `stableId` updates that record and never creates a
    second one.
  - Never reuse a `stableId` for different content.
- **Linking:**
  - Lessons and quizzes link to a pathway through `pathwayId`, which is the pathway's
    `stableId`.
  - Quizzes link to the lesson they follow through `lessonId`, which is the lesson's
    `stableId`.
- **Dates:**
  - Daily Scripture and Encouragements use month-day `MM-dd` (for example `01-31`), because
    they repeat every year.
  - Each date must be unique within its file.
- **Status:**
  - Import everything as `draft`.
  - Kingdom Heirs reviews it (`review`) and then publishes it (`published`).
  - Only `published` records are shown to members.
- **Scripture:**
  - The verse text members read comes from API.Bible in their language.
  - `dailyScripture.text` is Kingdom Heirs commentary and is shown separately as
    "Daily Truth".
  - Bible text must never be machine-translated.

## Findings from the package (as received)

- The lesson rows (344) and daily-content rows (365) contain **IDs only**. Their text columns
  are empty, as the package README states.
- The records currently in production did **not** come from this package:
  - 365 Daily Scripture records, last updated 2026-09-18
  - 365 Encouragements, last updated 2026-09-18
  - 19 lessons, last updated 2026-09-25

  Kingdom Heirs should confirm whether that text is approved, or supply the final files.
- **The assessment questions, answers and recommendation rules are complete in English** and
  can be imported once the backend scoring is confirmed to use the same trigger codes.
- **Pathway IDs differ:**
  - The package uses `KH-PATH-CS`; production uses `come-and-see`.
  - The other pathways follow the same pattern: `rooted-in-christ`,
    `journey-into-discipleship-evangelism`, `the-new-man`, `kingdom-heirs-foundations`.
  - Counterfeit Gospels does not exist yet.
- **The planned lesson counts are larger than what production currently has:**
  - Rooted in Christ: 30
  - Journey into Discipleship & Evangelism: 90
  - The New Man: 90
  - Kingdom Heirs Foundations: 120
  - The pathway records currently say 14 days; they will be updated with the import.

## Still to confirm

- **The importer.** Imports run on the backend `importCurriculum` function, whose source is not
  in this repository. Before production, each template must be checked with **Preview Import**
  on the admin page. That preview shows inserted, updated, skipped and failed rows, and any
  differences in the accepted headers will be corrected here.
- **Quiz answer keys.** Quiz answer keys (`correctAnswer`) are currently stored inside the quiz
  documents, which members can read. Moving them to a server-only collection requires a
  backend change to `getQuiz` and `submitQuizAttempt`.
