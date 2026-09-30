import 'package:flutter_test/flutter_test.dart';
import 'package:hintful/hintful.dart';
import 'package:hintful_prefs/hintful_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late SharedPreferencesHintStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    store = SharedPreferencesHintStore(prefs);
  });

  test('never-shown key shows; markShown gates it', () {
    expect(store.shouldShow('intro'), isTrue);

    store.markShown('intro', '1.0.0');

    expect(store.shouldShow('intro'), isFalse);
  });

  test('once ever: no minVersion — shown means hidden', () {
    store.markShown('tip', '1.2.0');

    expect(store.shouldShow('tip'), isFalse);
    expect(store.shouldShow('tip', minVersion: '1.2.0'), isFalse);
    expect(store.shouldShow('tip', minVersion: '9.9.9'), isTrue);
  });

  test('version bump re-shows; older target version does not', () {
    store.markShown('intro', '2.0.0');

    // Same version: gated.
    expect(store.shouldShow('intro', minVersion: '2.0.0'), isFalse);
    // Hint targets an older version than last shown: still gated.
    expect(store.shouldShow('intro', minVersion: '1.9.0'), isFalse);
    // A bump re-shows.
    expect(store.shouldShow('intro', minVersion: '2.1.0'), isTrue);
  });

  test('versions compare segment-wise: 1.10.0 > 1.9.0', () {
    store.markShown('intro', '1.9.0');

    expect(store.shouldShow('intro', minVersion: '1.10.0'), isTrue);

    store.markShown('intro', '1.10.0');
    expect(store.shouldShow('intro', minVersion: '1.10.0'), isFalse);
    expect(compareHintVersions('1.10.0', '1.9.0'), greaterThan(0));
    expect(compareHintVersions('2.3', '2.3.0'), 0); // missing segment == 0
  });

  test('keys are namespaced under the prefix', () {
    store.markShown('intro', '1.0.0');

    expect(prefs.getString('hintful.intro'), '1.0.0');
    expect(prefs.getKeys(), isNot(contains('intro')));
  });

  test('custom prefix', () async {
    final custom = SharedPreferencesHintStore(prefs, prefix: 'tours.');
    custom.markShown('intro', '1.0.0');

    expect(prefs.getString('tours.intro'), '1.0.0');
    expect(store.shouldShow('intro'), isTrue); // other prefix is untouched
  });

  test('clear() wipes only this store namespace', () {
    store.markShown('intro', '1.0.0');
    store.markShown('offer:tour@page', '1.0.0');
    prefs.setString('app.setting', 'keep-me');

    store.clear();

    expect(store.shouldShow('intro'), isTrue);
    expect(store.shouldShow('offer:tour@page'), isTrue);
    expect(prefs.getString('app.setting'), 'keep-me');
  });

  test('the gate IS the core rule — a matrix, not a second copy', () {
    for (final last in ['1.0.0', '1.10.0', '2.3']) {
      store.markShown('k', last);
      for (final min in [null, '0.9.0', '1.0.0', '1.9.0', '1.10.0', '2.3']) {
        expect(
          store.shouldShow('k', minVersion: min),
          HintStore.shouldShowVersion(lastShown: last, minVersion: min),
          reason: 'last=$last min=$min',
        );
      }
    }
  });

  test('implements the two-member HintStore contract', () {
    final HintStore contract = store;
    contract.markShown('intro', '1.0.0');
    expect(contract.shouldShow('intro'), isFalse);
  });
}
