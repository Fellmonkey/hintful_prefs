import 'package:hintful/hintful.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistent [HintStore] over `shared_preferences` — the out-of-the-box
/// "show once per app version" store.
///
/// Keys are namespaced under [prefix] so hint records never collide with the
/// app's own preferences. Semantics match the core stores exactly:
/// [HintStore.markShown] records the app version, and [HintStore.shouldShow]
/// with a `minVersion` (the version a hint targets, e.g.
/// `HintTour.minShowVersion`) returns true when the hint was never shown or
/// was last shown in an OLDER version — a version bump re-shows it.
///
/// The gate is **not reimplemented here**: [shouldShow] delegates to
/// [HintStore.shouldShowVersion] — the very function `InMemoryHintStore` and
/// `CallbackHintStore` call — so this store cannot drift from the core rule
/// (whose ordering is [compareHintVersions]).
///
/// ```dart
/// final prefs = await SharedPreferences.getInstance();
/// Hintful.configure(store: SharedPreferencesHintStore(prefs));
/// ```
class SharedPreferencesHintStore implements HintStore {
  /// Wraps [prefs]; [prefix] namespaces every hint key
  /// (default `hintful.`).
  SharedPreferencesHintStore(this._prefs, {String prefix = 'hintful.'})
      : _prefix = prefix;

  final SharedPreferences _prefs;
  final String _prefix;

  String _key(String key) => '$_prefix$key';

  @override
  bool shouldShow(String key, {String? minVersion}) =>
      HintStore.shouldShowVersion(
        lastShown: _prefs.getString(_key(key)),
        minVersion: minVersion,
      );

  @override
  void markShown(String key, String version) {
    // Fire-and-forget: the in-memory cache updates synchronously, so a
    // restart in the same session already sees it.
    _prefs.setString(_key(key), version);
  }

  /// Forget every hint record under this store's [prefix]. A debug/dev tool —
  /// the production "re-show" is a version bump (see the `HintStore` docs).
  void clear() {
    for (final key in _prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      _prefs.remove(key);
    }
  }
}
