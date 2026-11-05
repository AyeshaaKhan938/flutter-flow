# Content findings for Kingdom Heirs review

From the automated inventory ([content_inventory.md](content_inventory.md)), checked by
hand on 5 November 2026. The teaching text has not been changed. Each item needs a
Kingdom Heirs decision: correct the text in the CMS, or accept it as it is.

## Needs correction

1. **Lesson ends mid-sentence.** The Heart of a King, `KH-HK-L027`: the body ends
   "...He guarded his speech, measured his responses, and leaned more heavily on".
   The rest of the paragraph is missing from the import. Please send the full text.
2. **Running footer at the end of 14 lessons.** Inner Healing & Deliverance
   `IHD-L001` to `IHD-L014` end with the line "A Kingdom Heirs Discipleship Resource"
   (shown as a heading). It is a PDF page footer, not lesson text. Recommended: remove it.
3. **Next section's header at the end of a lesson.** Who Is Isa Al-Masih?
   `KH-ISA-L001`, `L002`, `L003`, `L015` to `L020` end with a part title such as
   "PART I | A RESPECTFUL INVITATION". A Letter to My Catholic Family `KH-CF-L019` ends
   with "Conclusion / A Letter to My Catholic Family". Recommended: move the part
   title to the start of the next lesson, or remove it.
4. **Decorative separator.** The New Man `KH-NM-L047` ends with a line of underscores.
   Recommended: remove it.

## Missing sections (the app hides an empty section)

5. **No Prayer** in 23 lessons: Counterfeit Gospels `KH-CG-L001`, `L003`, `L005`,
   `L007`, `L009`, `L011`, `L013`, `L015`, `L016`, `L018` to `L022`, `L024` to `L026`,
   `L028`, `L030`, `L034`, `L036`, `L038`, and Journey Into Discipleship & Evangelism
   `KH-JDE-L036`. In several of these the prayer appears inside the lesson body instead.
6. **No Scripture reference** in 5 lessons of The Holy Spirit & Joseph the Dreamer:
   `KH-JD-L001`, `L008`, `L015`, `L018`, `L022`. The Scripture card does not show for
   these lessons.
7. **No Reflection** in The Shepherd's Lantern `KH-SL-L001`.

## Not a problem

- 427 lessons have no stored Scripture text. This is by design: the lesson shows the
  reference and loads the passage from API.Bible in the member's language.
- Lines broken in the middle of a sentence by the PDF are joined when the app displays
  the lesson, including Reflection, Application and Prayer (fixed in 1.0.6 (9)).
- About 30 lessons end with a list of Scripture references without a full stop. That
  is how the source is written.
