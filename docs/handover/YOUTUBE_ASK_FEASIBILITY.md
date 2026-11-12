# Feasibility: YouTube teachings in Ask Kingdom Heirs

12 November 2026. Proposal only; nothing has been built. Prices are Google's list
prices as we understand them and must be confirmed before any work is ordered.

**Short answer: feasible.** Ask Kingdom Heirs already answers only from an approved
library of Kingdom Heirs books, split into sections, and cites its sources. Video
transcripts can be added as another kind of source, with each answer citing the video
title and linking to the exact moment in the video. The running cost is low. Most of
the effort is Kingdom Heirs reviewing which teachings to include.

## 1. Getting the transcripts

There are about 700 videos. If the average length is 25 minutes, that is about
17,500 minutes, or roughly 2.6 million words.

- **Videos with captions** (YouTube's automatic captions or uploaded ones). The
  YouTube Data API can download caption tracks only for videos on a channel the
  signed-in account manages. Kingdom Heirs signs in once with the channel's Google
  account to grant read-only caption access. No password is shared. Each caption
  download costs about 250 units of the daily quota of 10,000 units, so about 40 videos
  a day, or roughly 3 weeks for 700. Google usually grants a quota increase for a
  channel's own content, which would shorten this to a few days.
- **Videos without captions.** These can be transcribed. Kingdom Heirs downloads the
  original video files from YouTube Studio (its own content), and Google
  Speech-to-Text transcribes the audio with timestamps. Downloading other people's
  videos, or using unofficial download tools, is against YouTube's terms and is not
  proposed.
- **Quality.** Automatic transcripts get names, Scripture references and some words
  wrong. Priority teachings should be read by a Kingdom Heirs reviewer before they are
  approved. Music, worship and poor-audio videos should be left out.

## 2. Only approved teachings

- Kingdom Heirs keeps a list of approved videos: a YouTube playlist named, for
  example, "Ask Library", or a spreadsheet of video links.
- Only videos on that list are imported. Each one arrives as a **draft** source and
  is not used for answers until an admin approves it, as with the books today. An
  admin can withdraw a video at any time.

## 3. Citing the video and the moment

Yes. Each transcript section keeps its start time. An answer would show the video
title and a link such as `youtu.be/VIDEO_ID?t=754`, which opens the video at 12:34.
The short-quote limit Ask already uses for books also applies to transcripts.

## 4. Adding new videos

- **Simple:** an admin adds a video link to the approved list, then taps **Import**
  in the admin pages. It arrives as a draft for approval.
- **Automatic (optional):** once a week the system checks the "Ask Library" playlist
  for new videos and imports them as drafts.

## 5. YouTube API requirements and limits

- A Google Cloud project with the YouTube Data API enabled. The existing Kingdom Heirs
  project can be used.
- One-time read-only permission from the channel's Google account.
- Daily quota: 10,000 units by default. Caption list about 50 units and caption
  download about 200 units per video. A quota increase can be requested free of
  charge.
- No cost for the API itself.

## 6. Cost estimate (for 700 videos)

| Item | One-time | Monthly |
|---|---|---|
| Transcription of videos without captions (Speech-to-Text, about $0.016 per minute; batch mode can be cheaper). Worst case, all 17,500 minutes | up to about $280 | new videos only, a few dollars |
| Embeddings for search (about 9,000 sections) | under $5 | under $1 |
| Storage of transcripts and search data | none | under $1 |
| Answers | none | Same per question as today. Answers stay within the existing $50 monthly budget, which pauses Ask automatically if reached |

With 700 videos the library grows about tenfold (from about a thousand sections to
about ten thousand). At that size the search should move to Firestore's built-in
vector search, so each question stays fast. This is part of the build estimate, not
an extra running cost.

## 7. Safeguards against unsupported or inaccurate answers

All of the current Ask safeguards apply to videos too:
- answers only from approved sections, with a minimum match score; otherwise Ask says
  it does not have a Kingdom Heirs teaching on that question;
- every answer cites its sources;
- crisis, abuse, medical, legal and financial questions get the fixed safety
  responses first;
- members can report an answer, and a source can be withdrawn at once.

Additional safeguards for video:
- transcripts not yet reviewed by a person are labelled internally, and Kingdom Heirs
  can choose to use only reviewed ones;
- when a book and a video say the same thing, the book is cited first;
- the 48-question safety test is run again with videos included before going live.

## 8. Timeline

| Step | Time |
|---|---|
| Kingdom Heirs grants channel access and builds the approved list | Kingdom Heirs |
| Build: caption import, transcription, draft and approve in admin pages, timestamp links, vector search | about 2 to 3 weeks |
| Pilot with 50 approved videos; testers try Ask | 1 week |
| Remaining videos imported, in batches, as Kingdom Heirs approves them | depends on review; import itself takes days |
| Safety test re-run and Kingdom Heirs sign-off | 1 week |

A fixed price for the build can be given once Kingdom Heirs confirms the scope (for
example, captions only first, or all 700 including transcription).
