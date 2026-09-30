/// hintful_prefs — the persistent `HintStore` for `hintful`, built on
/// `shared_preferences`.
///
/// The core `hintful` package stays dependency-free: it ships the `HintStore`
/// contract plus an in-memory default, and persistence is the app's job. This
/// package is the out-of-the-box answer — install it, configure it once, and
/// "show once per app version" just works across launches:
///
/// ```dart
/// import 'package:hintful/hintful.dart';
/// import 'package:hintful_prefs/hintful_prefs.dart';
///
/// final prefs = await SharedPreferences.getInstance();
/// Hintful.configure(store: SharedPreferencesHintStore(prefs));
/// ```
///
/// The supported import is `package:hintful_prefs/hintful_prefs.dart`.
///
/// `compareHintVersions` is re-exported from `hintful` — one version ordering for
/// the core stores, this store and any app-side `HintStore`. This store does
/// not restate the gate either: its `shouldShow` calls `hintful`'s
/// `HintStore.shouldShowVersion` (the same function the core stores call).
library;

export 'package:hintful/hintful.dart' show compareHintVersions;
export 'src/shared_preferences_hint_store.dart' show SharedPreferencesHintStore;
