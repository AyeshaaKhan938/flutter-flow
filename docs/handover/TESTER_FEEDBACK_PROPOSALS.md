# Tester feedback (Tim): what is done and what needs a decision

12 November 2026. Answers Kingdom Heirs' request of the same date. Items 3 to 5 are in
Android build 1.0.6 (11) for internal testing. Items 1, 2 and 6 need Kingdom Heirs
approval before anything is finalised. Item 7 is a separate feasibility proposal
([YOUTUBE_ASK_FEASIBILITY.md](YOUTUBE_ASK_FEASIBILITY.md)).

## 1. A simpler first experience (proposal, not built)

### Today

After sign-up a new member goes through four screens before Home:

1. Survey: preferred language, how they heard about Kingdom Heirs, growth goal.
2. Profile: display name, phone, country, city and a time zone typed by hand
   ("America/New_York").
3. Notification permission.
4. Assessment introduction, with **Start** or **Maybe Later**.

The assessment can already be skipped, but only at the fourth screen. The time zone
field is the hardest step for most people.

### Proposed

1. **Sign up → choose language → Home.** One short language screen (the phone's
   language is pre-selected), then Home. Name, phone, country and city are already
   asked on the sign-up form.
2. From Home the member can immediately use Today's Scripture and Encouragement, the
   Bible, and **Start Come & See** (Lesson 1).
3. **Time zone is set automatically** from the phone. It can be changed later in
   Profile.
4. **Notification permission is asked after the member finishes their first lesson**,
   when the request makes sense ("Would you like a daily reminder?").
5. **Assessment invitation.** After the first lesson (or from the second day), Home
   shows a card: "Help us get to know you. Answer a few questions so we can recommend
   content for you." It can be dismissed and is always available from Profile. The
   "how did you hear about us" and "growth goal" questions move into the assessment.

### What does not change

- The seven-pathway order and every lock. The assessment only suggests content. It
  never unlocks a pathway, never skips Come & See and never changes the order. This
  is already true today and is covered by checklist E1 and E2.
- The assessment questions, scoring, rules and recommendation screen.
- All server functions. Only the order of the app's screens changes.

### Effect on schedule and cost

- No running cost. No new services. The automatic time zone needs one free package.
- About 2 to 3 working days, including translations, testing on both phones and new
  checklist items. It can go in the next internal build after approval.
- Existing members are not affected.

## 2. Certificate message (placed for approval)

Text, exactly as given: "Complete all seven required discipleship pathways to earn a
Kingdom Heirs School of Ministry Commissioning Certificate."

**Placement in build 11:** on Home, inside the "Your Discipleship Journey" card,
directly under the seven steps, in a soft gold box with a certificate icon. A new
member sees it on the first visit. Checklist item D8 asks testers for a screenshot.
It does not mention a degree, accreditation or licence.

Possible second placement, if wanted: the same sentence at the top of the Pathways
list, above the seven core pathways.

**Decision needed.** The issued certificate is titled "Kingdom Heirs Commissioning
Certificate" (approved wording of 14 October 2026). The new sentence says "Kingdom
Heirs School of Ministry Commissioning Certificate". Should the certificate title change
to match, or should the sentence use the current title?

## 3. Quiz review after submission (done, build 11)

- After a quiz is submitted, **Review my answers** opens automatically and lists each
  question with:
  - the member's answer;
  - Correct or Incorrect, with a green or red mark;
  - the correct answer, when the member's answer was wrong;
  - the explanation stored with the question. All 682 questions in the 78 published
    quizzes have one. Kingdom Heirs can change an explanation, or add a Scripture
    reference or approved source to it, through Import Content (`explanation_en` and
    the other languages); no app update is needed.
- Nothing is shown before submission. Retakes and the best-score rule work as before.
- Safety check: the correct answers are shown only if they give exactly the score the
  server gave. If the two ever disagree, the review shows the member's answers and
  explanations without marking them, so a member is never shown a wrong "correct
  answer".
- Labels in English, Spanish, Urdu and Luganda.
- Checklist items C8 and C9. Unit tests are in `test/quiz_review_test.dart`.

## 4. Duplicated answer labels (done, build 11)

The stored choices have no letter. The letter is added when the quiz is shown, and in
places it was added twice ("A. A."). The app now removes any repeated letter label
wherever a choice is shown, so each choice reads "A. text". Text such as "A.D. 70" is left alone. The stored content is
not changed.

## 5. Application and action steps (done, build 11)

- Every published lesson (446) has an Application section. It is now shown in its own
  warm card with a gold edge and a walking icon, distinct from the teaching, the grey
  Reflection box and the green Prayer box.
- Headings inside the teaching that tell the member what to do ("Application for
  Today", "Personal Response", "This Week's Practice", "The Disciple's Response",
  "Truth Stick Challenge", "Reflection Practice", "Responding to the Gospel",
  "Applying the Truth Stick to Ourselves") are shown in the same card, together with
  the text under them.
- The Shepherd's Lantern's Application sections are numbered steps. They used to run
  together as one paragraph; each step is now on its own line as a numbered list.
- No wording is changed. Checklist item B5.

## 6. Tester access

Tim's account (klaus234@hotmail.com) has Ask Kingdom Heirs and review mode (all
pathways), as does Joel (joeljuedes@globalrecordings.net). Review mode is a role on the
tester's own account only. General members and release settings are unchanged; Ask is
still limited to the tester list.

## 7. Future modules: School Clubs and Sports Tournaments

**Phase 1 answer: yes.** Both Coming Soon cards on Home already open a short
information page (a sheet with the vision text and a Close button). No club or
tournament system is built. Kingdom Heirs only needs to approve the text. Proposed text:

- **Kingdom Heirs School Clubs.** "Kingdom Heirs School Clubs will meet at schools,
  churches and other approved locations. Each club will follow about 35 weekly
  lessons led by a trained club leader, and every club member will also be welcomed
  into the Kingdom Heirs discipleship pathways. Coming soon."
- **Sports Tournaments.** "Young people will be able to register for Kingdom Heirs
  sporting events here. After each tournament, players are invited into the Kingdom
  Heirs discipleship pathways so the relationship continues beyond the game. Coming
  soon."

### Intended future function: School Clubs (for a later proposal)

- Registration for students and club leaders, with leader approval by Kingdom Heirs.
- About 35 weekly club lessons, released one per week or opened by the leader.
- Each club: location (school, church or other approved place), leader and
  co-leaders, meeting day and time.
- Attendance and lesson progress per member, visible to the club leader.
- Club members get the main discipleship pathways in the same app, with the same
  locks and certificates.
- Youth safeguarding: parental consent for under-18s (and under-13 rules for app
  stores and privacy law: COPPA in the US, GDPR-K in Europe), no private messaging
  between adults and minors, leader background-check status recorded, minimum data
  collected, and clear data deletion.

### Intended future function: Sports Tournaments (for a later proposal)

- Event listing: dates, times, location, age groups.
- Team and player registration by coaches, with parental consent forms for minors.
- Team management (rosters, contact for the coach only).
- Event details and updates through the existing notifications.
- After the event, players are invited to create an account and start Come & See.
- The same youth safeguarding rules as School Clubs.

Both modules need their own scope, design and estimate, and a safeguarding review,
before any build. They are not part of Phase 1.
