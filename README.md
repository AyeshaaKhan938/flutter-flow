# Kingdom Heirs Discipleship App

A new Flutter project.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

## API keys

The API.Bible key is **not** part of the app. It is stored in Google Secret
Manager and used only by the `getBiblePassage` Cloud Function
(`firebase/functions/index.js`); the app calls that function. Set or rotate
it with:

```sh
cd firebase
firebase functions:secrets:set API_BIBLE_KEY --project kingdom-heirs-discipleshipapp
firebase deploy --only functions:getBiblePassage --project kingdom-heirs-discipleshipapp
```

Release builds therefore need no keys:

```sh
flutter build apk --release
flutter build appbundle --release
flutter build ipa --release
```

The app has no build-time keys: Bible passages come only from the
`getBiblePassage` Cloud Function.

## Bible integration

The **Bible** tab lets members read any book and chapter (66 books, 1189
chapters) in their language's approved translation, with book names,
translation name and copyright from API.Bible; the last chapter read is
remembered, and chapters already opened stay readable offline. Languages
added in the CMS use their configured `bibleId`, or the English Bible with
a notice. Scripture is never machine-translated.

Tapping a lesson's Scripture reference shows the full passage in the
member's language, with its translation and copyright notice:

| App language | Translation (API.Bible id) |
|---|---|
| English | NIV 2011 (`78a9f6124f344018-01`) |
| Spanish | Reina Valera 1909 (`592420522e16049f-01`) |
| Urdu | Biblica Open Urdu Contemporary Version (`eecbca904435fce9-01`) |
| Luganda | Biblica Open Luganda Contemporary Bible (`f276be3571f516cb-01`) |

The app asks the `getBiblePassage` Cloud Function for passages, so the API
key never ships in the app. Each displayed passage is reported to API.Bible's
Fair Use Management System (FUMS), as their terms require. Passages are saved on the device
once opened, so they stay readable offline; a passage never opened before
cannot be shown offline, and the lesson's stored Scripture text is shown
instead. If the passage can't be fetched, the reference opens BibleGateway
(bible.com for Luganda). Translation ids live in
`lib/custom_code/actions/fetch_bible_verse_api.dart`.
