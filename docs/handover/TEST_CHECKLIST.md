# Release candidate test checklist: 1.0.6 (8)

For internal testers on Android (APK) and iPhone (TestFlight). Tick each line on both
platforms. Note the device, the language and what happened for anything that fails.

Build 8 is build 7 plus the admin **Notifications** page and the iOS App Store setup
(bundle id `com.kingdomheirsfoundation.kingdomheirs`, no image notification extension).

## Install and account
- [ ] Android: install `KingdomHeirs-1.0.6-build8.apk` over build 7 (sign-in is kept)
- [ ] iPhone: install from TestFlight (internal testing)
- [ ] Sign up with a new email, sign out, sign in again, reset password
- [ ] The notification permission screen appears; allow notifications
- [ ] Onboarding assessment completes and recommends a pathway

## Today and Home
- [ ] Today shows the daily Scripture and the encouragement for today's date
- [ ] Announcements appear on Today
- [ ] Home: the YouTube card opens youtube.com/@kingdomheirsco
- [ ] Home: the giving card opens the Kingdom Heirs Givebutter page
- [ ] The Kingdom Heirs logo shows on Profile, Today, Sign in and Sign up, and as the app icon

## Pathways, lessons and quizzes
- [ ] All 13 pathways are listed; 12 Steps shows "Coming Soon"
- [ ] Open a lesson, read it, mark it complete; progress updates
- [ ] Take a quiz; the score is saved and a better score replaces it
- [ ] Completing a pathway issues its certificate with the member's name and date
- [ ] Locked core pathways unlock in order after the previous one is complete

## Languages
- [ ] Switch to Spanish, Urdu (right to left) and Luganda; menus and content change
- [ ] Switch back to English

## Offline
- [ ] With content opened once, turn on airplane mode: Today and opened lessons still show
- [ ] Turn the network back on; progress made offline is saved

## Ask Kingdom Heirs (approved testers only)
- [ ] A non-tester account does not get answers
- [ ] A tester gets answers that cite Kingdom Heirs sources
- [ ] Crisis, abuse, medical, legal and financial questions get the fixed safety responses
- [ ] A Luganda question gets an answer, with the language notice

## Admin (an account with the admin role)
- [ ] Profile → admin area opens Manage Pathways
- [ ] Daily Content, Import CSV and Languages pages open
- [ ] **Notifications** (bell icon): send a test to "All", with your own phone signed in.
      It arrives on Android, and on iPhone once the APNs key is in Firebase. Recent
      notifications shows "Sent to N device(s)"
- [ ] Schedule a notification 1 to 2 hours ahead; it arrives within an hour after that time
- [ ] Send to one language only; a phone set to another language does not receive it
- [ ] Tapping a notification opens the Today page
- [ ] A member account cannot open the admin pages ("Not authorized")

## Known gap before public App Store release
The app has no in-app "Delete account" option. Apple requires one for apps that let
people create an account (App Review Guideline 5.1.1(v)). It is not needed for internal
TestFlight testing, but it must be added before the public release.
