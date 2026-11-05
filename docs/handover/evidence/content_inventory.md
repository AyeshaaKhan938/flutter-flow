# Content inventory evidence

Generated 2026-11-05 13:13 UTC by `tools/content_inventory.py`, reading project `kingdom-heirs-discipleshipapp` directly (read-only).

## Totals (published records)

- pathways: **13** (expected 13) — PASS
- lessons: **446** (expected 446) — PASS
- quizzes: **78** (expected 78) — PASS
- all records in Firestore, any status: 14 pathways, 446 lessons, 78 quizzes
- not published: twelve-steps-to-healing-and-recovery (draft)

## Kingdom Heirs Foundations

- `kingdom-heirs-foundations`: **20** published lessons (expected exactly 20) — PASS

## Come & See quiz unlock points

- Quiz 1: unlocks after `LESSON-COME-007` (lesson day 7)
- Quiz 2: unlocks after `LESSON-COME-014` (lesson day 14)

## Per pathway

| Order | Pathway | Lessons | Quizzes |
|---|---|---|---|
| 1 | Come & See (`come-and-see`) | 14 | 2 |
| 2 | Rooted in Christ (`rooted-in-christ`) | 30 | 4 |
| 3 | Journey Into Discipleship & Evangelism (`journey-into-discipleship-evangelism`) | 90 | 12 |
| 4 | The Holy Spirit in the Life of Every Christian (`holy-spirit-in-the-life-of-every-christian`) | 15 | 5 |
| 5 | Kingdom Heirs Foundations (`kingdom-heirs-foundations`) | 20 | 4 |
| 6 | Inner Healing & Deliverance (`inner-healing-and-deliverance`) | 15 | 4 |
| 7 | Counterfeit Gospels — The Truth Stick (`counterfeit-gospels`) | 42 | 7 |
| 101 | The New Man (`the-new-man`) | 90 | 13 |
| 102 | A Letter to My Catholic Family (`a-letter-to-my-catholic-family`) | 19 | 7 |
| 103 | Who Is Isa Al-Masih? (`who-is-isa-al-masih`) | 21 | 7 |
| 104 | The Holy Spirit & Joseph the Dreamer (`joseph-the-dreamer-and-the-holy-spirit`) | 30 | 4 |
| 105 | The Heart of a King (`the-heart-of-a-king`) | 30 | 4 |
| 106 | The Shepherd’s Lantern (`shepherds-lantern-allegory`) | 30 | 5 |

## Checks: 29 errors, 57 warnings

Each published lesson was checked for empty English title, body, Scripture reference, Reflection, Application and Prayer; PDF page numbers, form feeds, words broken across lines and encoding errors; and a body that ends mid-sentence. Each quiz was checked for questions, question text and a valid unlock lesson.

- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L001`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L003`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L005`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L007`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L009`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L011`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L013`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L015`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L016`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L018`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L019`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L020`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L021`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L022`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L024`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L025`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L026`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L028`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L030`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L034`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L036`: empty English prayer
- **error** `pathways/counterfeit-gospels/lessons/KH-CG-L038`: empty English prayer
- **error** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L001`: empty scriptureRef
- **error** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L008`: empty scriptureRef
- **error** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L015`: empty scriptureRef
- **error** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L018`: empty scriptureRef
- **error** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L022`: empty scriptureRef
- **error** `pathways/journey-into-discipleship-evangelism/lessons/KH-JDE-L036`: empty English prayer
- **error** `pathways/shepherds-lantern-allegory/lessons/KH-SL-L001`: empty English reflectionPrompt
- **warning** `pathways/a-letter-to-my-catholic-family/lessons/KH-CF-L019`: body may be truncated (ends: …'onclusion\nA Letter to My Catholic Family')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L001`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L002`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L003`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L004`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L005`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L006`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L007`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L008`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L009`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L010`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L011`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L012`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L013`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/inner-healing-and-deliverance/lessons/IHD-L014`: body may be truncated (ends: …'## A Kingdom Heirs Discipleship Resource')
- **warning** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L015`: body may be truncated (ends: …'Spirit opens doors that no man can close')
- **warning** `pathways/joseph-the-dreamer-and-the-holy-spirit/lessons/KH-JD-L018`: body may be truncated (ends: …' His promptings and acts with discipline')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L001`: body may be truncated (ends: …'aped the psalmist, the king, and the man')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L002`: body may be truncated (ends: …':8 — Power comes through the Holy Spirit')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L003`: body may be truncated (ends: …'EW 18:6 — Responsibility toward children')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L004`: body may be truncated (ends: …'LESIASTES 10:18 — Neglect leads to decay')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L005`: body may be truncated (ends: …'fession and accountability bring healing')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L006`: body may be truncated (ends: …' — Walking in the light brings cleansing')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L007`: body may be truncated (ends: …' ● EZEKIEL 36:26 — God gives a new heart')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L008`: body may be truncated (ends: …'ALM 66:18 — The danger of cherishing sin')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L009`: body may be truncated (ends: …'12:9–10 — Strength perfected in weakness')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L010`: body may be truncated (ends: …'hough he falls, he will not be cast down')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L011`: body may be truncated (ends: …' Worship keeps us filled with the Spirit')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L012`: body may be truncated (ends: …'ETER 5:10 — God restores after suffering')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L013`: body may be truncated (ends: …'LM 75:6–7 — God alone exalts and humbles')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L014`: body may be truncated (ends: …'Y 2:2 — Entrusting truth to faithful men')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L015`: body may be truncated (ends: …'–2 — Endurance in the race set before us')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L016`: body may be truncated (ends: …'PIANS 1:6 — God completes what He begins')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L017`: body may be truncated (ends: …' 41:10 — God upholds those who trust Him')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L018`: body may be truncated (ends: …'1 PETER 2:23 — Entrusting justice to God')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L019`: body may be truncated (ends: …'nner renewal through eternal perspective')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L020`: body may be truncated (ends: …'e Good Shepherd holds His sheep securely')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L021`: body may be truncated (ends: …' JAMES 1:5 — God gives wisdom generously')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L022`: body may be truncated (ends: …' — Suffering produces character and hope')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L023`: body may be truncated (ends: …'Desire gives birth to sin when unchecked')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L024`: body may be truncated (ends: …'N 5:19 — Jesus’ submission to the Father')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L025`: body may be truncated (ends: …'S 4:6–10 — God gives grace to the humble')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L026`: body may be truncated (ends: …'EWS 13:8 — God’s unchanging faithfulness')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L027`: body may be truncated (ends: …'is responses, and leaned more heavily on')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L028`: body may be truncated (ends: …'fe ➢ 1 JOHN 3:2–3 — We shall be like Him')
- **warning** `pathways/the-heart-of-a-king/lessons/KH-HK-L029`: body may be truncated (ends: …'➢ 2 TIMOTHY 4:7–8 — Finishing with faith')
- **warning** `pathways/the-new-man/lessons/KH-NM-L047`: body may be truncated (ends: …'________________________________________')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L001`: body may be truncated (ends: …'Koran.\n\nPART I | A RESPECTFUL INVITATION')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L002`: body may be truncated (ends: …'Koran.\n\nPART I | A RESPECTFUL INVITATION')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L003`: body may be truncated (ends: …' Koran.\n\nPART II | HEARING THE WITNESSES')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L015`: body may be truncated (ends: …' life.\n\nPART IV | QUESTIONS OF THE HEART')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L016`: body may be truncated (ends: …' sent.\n\nPART IV | QUESTIONS OF THE HEART')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L017`: body may be truncated (ends: …'ldren.\n\nPART IV | QUESTIONS OF THE HEART')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L018`: body may be truncated (ends: …'afety.\n\nPART IV | QUESTIONS OF THE HEART')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L019`: body may be truncated (ends: …'denial of Yeshua.\n\nPART V | COME AND SEE')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L020`: body may be truncated (ends: …'scious community.\n\nPART V | COME AND SEE')
- **warning** `pathways/who-is-isa-al-masih/lessons/KH-ISA-L021`: body may be truncated (ends: …'rter invitation.\n\nWHO IS ISA AL-MASIH? |')
