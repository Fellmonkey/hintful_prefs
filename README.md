# hintful_prefs

[![pub.dev](https://img.shields.io/pub/v/hintful_prefs.svg)](https://pub.dev/packages/hintful_prefs)
[![license](https://img.shields.io/github/license/Fellmonkey/hintful_prefs.svg)](https://github.com/Fellmonkey/hintful_prefs/blob/main/LICENSE)

**`shared_preferences`-backed persistent store for
[`hintful`](https://pub.dev/packages/hintful)** — show a hint or tour once
per app version, out of the box.

The `hintful` core stays dependency-free ("dart:ui + widgets only"): the
`HintStore` contract lives there, storage implementations live outside it.
This companion package ships the ready-made persistent store so a product app
does not have to write even the three-line `CallbackHintStore`.

## Getting started

```yaml
dependencies:
  hintful: ^1.0.0
  hintful_prefs: ^1.0.0
```

```dart
import 'package:hintful/hintful.dart';
import 'package:hintful_prefs/hintful_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // One call at startup: every controller reads this store — no per-call
  // store:, no controller field.
  Hintful.configure(store: SharedPreferencesHintStore(prefs));
  runApp(const MyApp());
}
```

```dart
final controller = HintController();

// Shows once per app version: a version bump re-shows it. `mark:` arms the
// version gate and records the tour on the exit you pick.
await controller.tryShowTour(
  HintTour(
    id: 'intro',
    minShowVersion: '1.2.0', // "new in 1.2.0"
    steps: [
      HintStep(
        targetId: 'addSet',
        content: HintStepContent(title: 'Log your set'),
      ),
    ],
  ),
  mark: HintMarkPolicy.onAnyExit,
);
```

## What it provides

- **`SharedPreferencesHintStore`** — implements the two-member `HintStore`
  contract (`shouldShow` / `markShown`). Keys are namespaced under `prefix`
  (default `hintful.`) so hint records never collide with the app's own
  preferences. `markShown` is fire-and-forget: the in-memory cache updates
  synchronously, so a restart in the same session already sees it.
  `shouldShow` does **not** restate the rule: it calls `hintful`'s
  `HintStore.shouldShowVersion` — the same gate `InMemoryHintStore` and
  `CallbackHintStore` call.
- **`clear()`** — a debug/dev tool that forgets every hint record under this
  store's prefix (the production "show again" is a version bump — see the
  `HintStore` docs in `hintful`). Not part of the abstract contract: a
  concrete store may expose its own.
- **`compareHintVersions(a, b)`** — re-exported from `hintful`: the one
  segment-wise version ordering the core stores, this store and any app-side
  store gate on (`"1.10.0" > "1.9.0"`, missing segments count as `0`). It is
  the comparison inside `HintStore.shouldShowVersion` (from
  `package:hintful/hintful.dart`), which is the whole rule — prefer it over
  composing `compareHintVersions` by hand.

## Development

Requires Dart ≥ 3.2 / Flutter ≥ 3.16 (same floor as `hintful`) and
`shared_preferences ^2.3.0`.

See the [`hintful`](https://pub.dev/packages/hintful) documentation for the
full API, best practices and FAQ. MIT licensed.
