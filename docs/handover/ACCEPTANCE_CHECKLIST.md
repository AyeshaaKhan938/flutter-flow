# Phase 1 acceptance checklist

Kingdom Heirs Discipleship app, final Phase 1 release candidate 1.0.7 (12), Android and
iPhone. Build 1.0.6 (11) is the initial iPhone testing build only.

**How to use it**
- Run every item on **both** an Android phone and an iPhone (TestFlight), unless the
  item says otherwise. Tick A (Android) and I (iPhone).
- **Evidence** says what to keep: a screenshot (S), a screen recording (R), or an
  automated result (Auto). Name each file with the item id, for example
  `C3_android.mp4`, and put it in the shared evidence folder.
- If anything fails, write down the device, the app language, the account used and
  what happened, and attach the screenshot or recording.
- Use a fresh test member account unless an item asks for an admin account. For B1 (one lesson from every pathway), use a `content_reviewer` account (D6) so all pathways open.

**Changes in 1.0.6 (9) to (11)**
- Quiz locking is now enforced (C2).
- Percentage-only quiz scores round down (C4).
- Reflection, Application and Prayer join broken PDF lines (B2).
- Notifications show while the app is open (J1).
- The permission screen reports a denied permission correctly (J4).
- Scheduled notifications arrive within about 5 minutes (J7).
- The giving card passes the chosen amount and frequency to Givebutter (H2).
- Offline sync no longer sends duplicates or loses queued work (G3, G4).
- Profile has Delete my account (L).
- Build 10: the long blank space above and below lesson text and between lesson cards is removed (D7), and content reviewers can open every pathway (D6).
- Build 11 (tester feedback): after a quiz is submitted, a review shows each question,
  the member's answer, correct or incorrect, the correct answer and the explanation
  (C8); each choice shows one letter only (C9); Application and action steps are shown
  in their own card, with numbered steps as a list (B5); Home explains the
  Commissioning Certificate (D8, for approval).

**Changes in 1.0.7 (12) (approved by Kingdom Heirs)**
- Simpler first experience: sign up, choose a language, then Home (E3).
- The time zone comes from the phone; nobody types it (E4).
- Notification permission is asked after the first finished lesson, not at sign-up
  (E5, J4).
- The assessment is offered by a card on Home after the first lesson or from the
  second day; it can be dismissed and is always in Profile (E6, E7).
- Certificate title: Kingdom Heirs School of Ministry Commissioning Certificate (D5,
  D8).
- Approved School Clubs and Sports Tournaments information pages (H4, H5).

---

## A. Automated evidence

| Id | Check | Expected | Evidence |
|---|---|---|---|
| A1 | Content inventory (`tools/content_inventory.py`, read-only against production) | 13 published pathways, 446 published lessons, 78 published quizzes | Auto: [evidence/content_inventory.md](evidence/content_inventory.md) |
| A2 | Kingdom Heirs Foundations lesson count | Exactly 20 | Auto: A1 report |
| A3 | No empty records | No published lesson without English title, body, Reflection or Application, and no quiz without questions. Prayer and Scripture reference gaps are listed in A1 for a content decision | Auto: A1 report |
| A4 | Come & See quiz unlock points in the data | Quiz 1 after LESSON-COME-007, Quiz 2 after LESSON-COME-014 | Auto: A1 report |
| A5 | Unit tests: passing standard, best score, completion, core order, grading, lesson formatting, quiz choice labels, quiz review answers, Application steps, time zone, assessment invitation, approved wording | All pass, including 79.9% fails / 80% passes | Auto: `flutter test` output in [evidence/](evidence/) |
| A6 | Static analysis of the release code | No errors | Auto: `flutter analyze` output |

## B. Lessons and formatting

| Id | Check | Expected | Evidence |
|---|---|---|---|
| B1 | Open at least one lesson from **each** of the 13 pathways. Include the longest lesson of Journey Into Discipleship & Evangelism and of The New Man, and one with a bulleted list | Headings, paragraphs, lists and Scripture quotes render correctly; nothing overlaps | S per pathway |
| B2 | In each lesson from B1, read Scripture, Reflection, Application and Prayer | All present where the source has them. No PDF page numbers, running headers or footers, lines broken mid-sentence, missing text or truncated endings | S |
| B3 | Tap the Scripture card ("Tap to open full passage") | The full passage opens in the member's language, with its translation name | S |
| B4 | Check the lessons listed under "Content findings" in A1 | Each one is corrected or accepted by Kingdom Heirs | Kingdom Heirs sign-off |
| B5 | Application and action steps: one lesson each from The Shepherd's Lantern, Inner Healing & Deliverance, Kingdom Heirs Foundations and Counterfeit Gospels | The Application section, and headings such as "This Week's Practice", "Personal Response" or "Application for Today" inside the teaching, are in a gold-edged card. Numbered steps show as a numbered list, one step per line. Wording unchanged | S per pathway |

## C. Quizzes and progression

| Id | Check | Expected | Evidence |
|---|---|---|---|
| C1 | Come & See, before Lesson 7 | Quiz 1 and Quiz 2 buttons are greyed out with a lock icon and cannot be tapped | S |
| C2 | Try to open Quiz 1 another way (for example a notification or a saved link) before Lesson 7 | "Quiz locked: This quiz opens after you complete Lesson 7." The quiz does not open | R |
| C3 | Complete Lesson 7, then Lesson 14 | Quiz 1 unlocks after Lesson 7 and opens from the lesson. Quiz 2 stays locked until Lesson 14 | R |
| C4 | Score below 80% (for example 7 of 10), then exactly 80% (8 of 10) | 7/10 fails; 8/10 passes. Automated: 79.9% fails (A5) | S |
| C5 | Pass a quiz, then retake it and score lower | The best score is kept. The pathway and certificate use the best score | S |
| C6 | Finish every lesson of a pathway but leave one quiz unpassed | The pathway is **not** complete and no certificate is issued | S |
| C7 | Pass the last quiz | The pathway is complete and its Pathway Certificate is issued | S |
| C8 | Submit a quiz with some wrong answers. Then open the same quiz again later | Before submitting, no answers are shown. After submitting, "Review my answers" lists each question, your answer, Correct or Incorrect, the correct answer when yours was wrong, and the explanation when the quiz has one. Retake still works and the best score is kept (C5) | S |
| C9 | Look at the choices of quizzes in at least three pathways | Each choice shows one letter only ("A. text"), never "A. A." | S per pathway |

## D. Pathways and certificates

| Id | Check | Expected | Evidence |
|---|---|---|---|
| D1 | Core order on the pathway list: Come & See → Rooted in Christ → Journey Into Discipleship & Evangelism → The Holy Spirit in the Life of Every Christian → Kingdom Heirs Foundations → Inner Healing & Deliverance → Counterfeit Gospels | Each core pathway is locked until the one before it is complete | S |
| D2 | Additional pathways: The New Man, A Letter to My Catholic Family, Who Is Isa Al-Masih?, The Holy Spirit & Joseph the Dreamer, The Heart of a King, The Shepherd's Lantern | Open at any time; never needed for the Commissioning Certificate | S |
| D3 | 12 Steps to Healing and Recovery | Shown as Coming Soon, cannot be opened | S |
| D4 | Pathway Certificate for each completed pathway | Shows the member's name, pathway, completion date, certificate id and grade. No commissioning wording | S per pathway tested |
| D5 | Kingdom Heirs School of Ministry Commissioning Certificate after all seven core pathways | Issued only after the seventh; carries the approved commissioning wording and the member's name | S |
| D6 | Review mode: an account with role `content_reviewer` | Every core pathway, lesson and quiz opens without completing the earlier ones; no admin pages. A member account is still locked | S |
| D7 | No blank space in lessons or lesson lists | The title follows the header image directly; the reflection box and Mark Complete follow the last section; lesson cards in a pathway list are evenly spaced | S per pathway |
| D8 | New account, first visit to Home | The journey card says: "Complete all seven required discipleship pathways to earn a Kingdom Heirs School of Ministry Commissioning Certificate." No mention of a degree or licence. Certificate titles in the app read "Kingdom Heirs School of Ministry Commissioning Certificate" | S |

## E. Onboarding recommendation

| Id | Check | Expected | Evidence |
|---|---|---|---|
| E1 | Complete the onboarding assessment with answers that point to a later pathway | The result screen may *suggest* a pathway, but **Start** always opens Come & See | R |
| E2 | After E1, open the suggested later core pathway | It is still locked. The recommendation never unlocks or skips a pathway | S |
| E3 | New account: sign up | One language screen follows, with the phone's language selected. **Continue** opens Home. No survey, time zone or notification screen | R |
| E4 | After E3, Profile → Profile and time zone | The time zone field already shows the phone's time zone (for example Africa/Kampala). It can be changed and saved | S |
| E5 | After E3, finish the first lesson | "Would you like a daily reminder?" appears once. **Yes, remind me** shows the phone's permission question; **Not now** does not ask again | R |
| E6 | Home on the first day before any lesson, then after the first lesson | No assessment card before; after the lesson, "Help us get to know you" appears. Tap ✕: it disappears and stays hidden | S |
| E7 | Profile → Help us get to know you | The assessment opens, with the two optional questions (how you heard about Kingdom Heirs, what you hope to grow in) above **Start** | S |

## F. Today and Bible

| Id | Check | Expected | Evidence |
|---|---|---|---|
| F1 | Today shows title, Scripture reference, full verse text, Daily Truth and Encouragement | All present and complete | S |
| F2 | Read in Context | Opens the context passage in the app | S |
| F3 | Bible Gateway link | Opens the same reference on Bible Gateway | S |
| F4 | A date whose Scripture has several verses or ranges | Every part is shown, none missing | S |
| F5 | Set the phone to a different time zone (for example Kampala and Los Angeles) around midnight | Today follows the phone's local date | S per zone |
| F6 | Bible tab in English, Spanish, Urdu and Luganda: pick a book and chapter, use next/previous across a book boundary | Chapters load in that language's Bible; Urdu reads right to left; reopening returns to the last chapter | S per language |
| F7 | Bible offline after reading a chapter online | The saved chapter still shows | S |

## G. Offline

| Id | Check | Expected | Evidence |
|---|---|---|---|
| G1 | Open Today and two lessons online, then turn on airplane mode | Today and those lessons still show | S |
| G2 | Offline: complete a lesson and write a reflection | "Saved offline. Progress will sync when you reconnect." | S |
| G3 | Close the app completely, reopen it offline, then reconnect | The queued completion survives the restart and syncs. The lesson shows complete once, not twice | R |
| G4 | Complete a lesson on phone A online. On phone B, offline, complete an earlier lesson, then reconnect | Both completions are kept; phone B does not erase phone A's newer progress | R |
| G5 | Take a quiz offline, then reconnect | The attempt is sent once and the best score is kept | S |

## H. Home links

| Id | Check | Expected | Evidence |
|---|---|---|---|
| H1 | YouTube card | Opens youtube.com/@kingdomheirsco | S |
| H2 | Giving card: choose Monthly and $25, tap Give. Repeat with One-time and $10 | Givebutter opens with $25 monthly, then $10 one-time, already selected | S each |
| H3 | If H2 does not pre-select | Report it. The amount and frequency must be enabled on the Givebutter campaign; Kingdom Heirs checks the campaign settings | Note |
| H4 | Home → Kingdom Heirs School Clubs | Information page: "Kingdom Heirs School Clubs will meet at schools, churches and other approved locations. Each club will follow about 35 weekly lessons led by a trained club leader, and every club member will also be welcomed into the Kingdom Heirs discipleship pathways. Coming soon." Close returns to Home | S |
| H5 | Home → Sports Tournaments | Information page: "Young people will be able to register for Kingdom Heirs sporting events here. After each tournament, players are invited into the Kingdom Heirs discipleship pathways so the relationship continues beyond the game. Coming soon." Close returns to Home | S |

## I. Languages and display

| Id | Check | Expected | Evidence |
|---|---|---|---|
| I1 | Switch the app to Spanish, Urdu and Luganda | Menus, buttons, Today, lessons and quizzes change language; no English controls left except approved English-only items (certificates, admin pages) | S per language |
| I2 | Urdu | Whole layout is right to left: back arrows, lists, cards and text alignment | S |
| I3 | Long words and long translations | No clipped or overlapping text on any screen | S |
| I4 | Ask Kingdom Heirs in each language (tester account) | The language notice shows when the answer is not in the member's language | S |
| I5 | Targeted notification language | The language a member picks in the app is the one used for "Language" targeting (J6) | S |
| I6 | Small phone (about 5 inch, for example iPhone SE) and large phone (Pro Max class) | No overlapping, clipping or unreadable text | S per device |
| I7 | Largest system text size on both platforms | Screens stay readable and scroll; buttons are not cut off | S |

## J. Notifications

Use the admin **Notifications** page (Manage Pathways, bell icon).

On iPhone, notifications need the APNs authentication key uploaded in Firebase (Project
settings → Cloud Messaging → Apple app configuration). Run J1 to J3 and J7 on iPhone only
after it is uploaded.

| Id | Check | Expected | Evidence |
|---|---|---|---|
| J1 | Send while the app is **open** | iPhone shows the banner; Android shows an in-app banner with Open | R |
| J2 | Send while the app is in the **background** | System notification arrives; tapping opens Today | R |
| J3 | Send while the app is **closed** (swiped away) | System notification arrives; tapping opens the app on Today | R |
| J4 | New account: finish the first lesson, tap **Yes, remind me**, then deny the phone's permission | "Notifications are off. You can turn them on later in your phone's Settings." Nothing is delivered to that phone. Profile → Daily reminders opens the same screen | S |
| J5 | Same account on two phones, sign out and in again | Each phone receives a notification once; no duplicates | S |
| J6 | Targeting: iPhone only, Android only, one language, one pathway | Only matching phones receive it; Recent notifications shows the device count | S each |
| J7 | Schedule a notification 15 minutes ahead | Arrives within about 5 minutes of the chosen time | S with clock |
| J8 | A member account opens the admin pages | "Not authorized" | S |

## K. Ask Kingdom Heirs

| Id | Check | Expected | Evidence |
|---|---|---|---|
| K1 | Non-tester account | No answers | S |
| K2 | Tester account | Answers cite Kingdom Heirs sources (primary and supporting) | S |
| K3 | Crisis, abuse, medical (including stopping medication), legal and financial questions | The approved safety response only, once | Auto: KH_Ask_Safety_Test_Results_v2.xlsx and S |

## L. Delete my account (public-release blocker)

| Id | Check | Expected | Evidence |
|---|---|---|---|
| L1 | Profile → Delete my account → confirm → enter password | Account deleted; the app returns to Sign in with "Your account and data have been deleted." | R |
| L2 | Wrong password | "That password is not correct. Your account was not deleted." | S |
| L3 | After L1, try to sign in with the same email | Sign-in fails | S |
| L4 | After L1, in Firebase (admin) | No `users/{uid}` document, certificates, notification tokens or reflections remain for that member | S |

## M. Release and handover

| Id | Check | Expected |
|---|---|---|
| M1 | Android 1.0.7 (12) and TestFlight 1.0.7 (12) pass sections B to L | Kingdom Heirs sign-off |
| M2 | All source code in a Kingdom Heirs-owned repository | Kingdom Heirs confirms access |
| M3 | Handover documents delivered: build and deploy, admin guide, services and costs, ownership checklist, this checklist with evidence | Kingdom Heirs confirms |
| M4 | Legacy Node.js 20 functions: recovery investigation, dependency inventory and migration plan delivered ([NODE20_FUNCTIONS.md](NODE20_FUNCTIONS.md)); decision on path A or B recorded | Kingdom Heirs decision |
| M5 | No public App Store or Google Play submission without Kingdom Heirs' written approval | Confirmed |

## Known risks at handover

1. **22 backend functions on Node.js 20** (sign-in profile, Today, progress, quizzes,
   assessment). Google retired Node.js 20 for Cloud Functions on 30 October 2026. They still run,
   but cannot be updated and may stop. Their source is not in the repository. See
   [NODE20_FUNCTIONS.md](NODE20_FUNCTIONS.md).
2. **Best quiz score across devices.** The best score is kept on the phone and on issued
   certificates. Whether the server keeps the best attempt is decided by the legacy
   `getQuizAttempt` function (risk 1). C5 tests it.
3. **Progress conflicts between devices** are merged by the legacy
   `syncOfflineProgressHttp` function (risk 1). G4 tests it.
