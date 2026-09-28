# Kingdom Heirs Discipleship App

A new Flutter project.

## Getting Started

FlutterFlow projects are built to run on the Flutter _stable_ release.

## API keys

Keys are supplied at build time and are never committed (this repo is
public). Copy `api_keys.example.json` to `api_keys.json`, fill in the
values, and pass the file to every run/build:

```sh
flutter run --dart-define-from-file=api_keys.json
flutter build apk --release --dart-define-from-file=api_keys.json
flutter build ipa --release --dart-define-from-file=api_keys.json
```

| Key | Used for |
|---|---|
| `API_BIBLE_KEY` | Full Scripture passages from [API.Bible](https://scripture.api.bible) in the lesson page |

Without `API_BIBLE_KEY` the app still builds: English passages come from
bible-api.com (KJV) and other languages open the Bible deep link.

## Bible integration

Tapping a lesson's Scripture reference shows the full passage in the
member's language, with its translation and copyright notice:

| App language | Translation (API.Bible id) |
|---|---|
| English | NIV 2011 (`78a9f6124f344018-01`) |
| Spanish | Reina Valera 1909 (`592420522e16049f-01`) |
| Urdu | Biblica Open Urdu Contemporary Version (`eecbca904435fce9-01`) |
| Luganda | Biblica Open Luganda Contemporary Bible (`f276be3571f516cb-01`) |

Each displayed passage is reported to API.Bible's Fair Use Management
System (FUMS), as their terms require. Passages are saved on the device
once opened, so they stay readable offline; a passage never opened before
cannot be shown offline, and the lesson's stored Scripture text is shown
instead. If the passage can't be fetched, the reference opens BibleGateway
(bible.com for Luganda). Translation ids live in
`lib/custom_code/actions/fetch_bible_verse_api.dart`.
