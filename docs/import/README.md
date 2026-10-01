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

## Importing a file

Imports run on the `importContentCsv` Cloud Function
(`firebase/functions/content_import.js`) from the **Import Content** page
(`/admin/import`; open **Daily Content** and tap the upload icon). Only users whose
`users/{uid}.role` is `admin` or `ministry_reviewer` can use it.

1. Choose the content type and the CSV file (saved as **CSV UTF-8**).
2. **Preview** checks the file and shows the report. Nothing is written.
3. **Import as Draft** writes the file, but only if every row is valid. If any row fails,
   nothing is written. Fix the rows listed in the report and import the corrected file again.
4. Re-importing the same file is safe. Rows are matched by `stableId` (for quizzes
   `quizStableId`, for assessment questions `questionId`):
   - existing records are updated in place, including older records created with automatic
     IDs;
   - rows identical to what is stored are reported as skipped (unchanged);
   - a second record is never created for the same ID.

What the importer checks and does:

- **Validation:**
  - required columns and values; the English text is required;
  - whole numbers (`order`, `dayNumber`, `questionNumber`, `passingScore`, `points`,
    `sequence`);
  - real `MM-dd` dates, unique within the file and not used by another record;
  - `pathwayId` and `lessonId` must already exist;
  - `correctAnswer` must be A–D and that option must have English text;
  - `status` must be draft, review, published or unpublished;
  - duplicate IDs in the file are rejected;
  - unknown columns are reported as warnings and ignored.
- **Language columns:** any `<field>_<code>` column with a 2–3 letter language code (for
  example `title_fr`) is accepted. Empty cells never erase a stored translation; only the
  languages given in the file are updated.
- **Status:** new records are always created as `draft`. Existing records keep their
  current status unless the row's `status` column is filled in.
- **Quizzes:** rows are grouped by `quizStableId` into `quizzes/{quizStableId}.questions`
  (matched by `questionNumber`). A quiz with any invalid row is rejected as a whole.
- **Assessment questions:** stored in a new `assessmentItems/{questionId}` collection
  (`question`, `options.{A..}.answer` / `points` / `triggerCode`). The legacy
  `assessmentQuestions` documents are not changed until the app is switched over.
  `question_en` is needed on at least one row per question.
- **Report:** every run, both preview and import, is saved to `importJobs` and listed under
  **Recent imports**. Each report shows:
  - the source file name and the date imported;
  - inserted, updated, skipped and failed counts;
  - the duplicate check;
  - the publication status of the affected records;
  - the translation status for each language;
  - every error and warning, with its row and column.

  **Copy report** puts the report on the clipboard as text or JSON.

Apart from `pathways.csv`, the example rows in `templates/` contain IDs only, as in the
package. They fail validation until the English text is filled in.

## Still to confirm

- **Quiz answer keys.** Quiz answer keys (`correctAnswer`) are currently stored inside the quiz
  documents, which members can read. Moving them to a server-only collection requires a
  backend change to `getQuiz` and `submitQuizAttempt`.
