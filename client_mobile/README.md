# Waypoint

Waypoint is a Flutter social app concept where shared moments sit alongside a user's real world activity. The current build focuses on the foundation and core social experience: a content first feed, post creation, likes, reposts, discovery, a message inbox, activity notifications, a content preferences hub, a playable profile music preview, activity and social tendency summaries, and system/light/dark appearance modes.

## Run

```sh
flutter pub get
flutter run
```

## Current scope

The app uses Riverpod and a repository boundary. `DemoFeedRepository` supplies local sample content so the screens can be explored without an API. User interactions are held in memory and reset when the app restarts. Location graphics and activity totals are illustrative only; the app does not request location permission or track a device.

Authentication, remote persistence, media upload, real follower relationships, ephemeral story storage, messaging, realtime activity, and production privacy enforcement still need backend and platform work before release. The current screens are an extensible product foundation, not a connected social network service.
