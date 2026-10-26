import 'package:flutter/material.dart';
import 'package:hintful/hintful.dart';
import 'package:hintful_prefs/hintful_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // One persistent store for every controller in the app. The store is
  // version-gated: a hint/tour shows once per app version, and a version
  // bump re-shows it.
  final prefs = await SharedPreferences.getInstance();
  Hintful.configure(store: SharedPreferencesHintStore(prefs));

  runApp(const HintfulPrefsExample());
}

class HintfulPrefsExample extends StatelessWidget {
  const HintfulPrefsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hintful_prefs example',
      theme: ThemeData(colorSchemeSeed: Colors.indigo),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = HintController();

  /// The version of the app. Bump it to re-show the intro tour.
  static const _appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _showIntroIfNew();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showIntroIfNew() async {
    // Shows only if this tour was never shown for `_appVersion`. The
    // SharedPreferencesHintStore remembers the version — verified in the
    // store's own tests.
    await _controller.tryShowTour(
      HintTour(
        id: 'intro',
        minShowVersion: _appVersion,
        steps: [
          HintStep(
            targetId: 'demoButton',
            content: HintStepContent(
              title: 'Once per app version',
              description:
                  'Restart the app: no tour. Bump the app version: the tour is back.',
            ),
          ),
        ],
      ),
      mark: HintMarkPolicy.onAnyExit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('hintful_prefs')),
      body: Center(
        child: HintTarget(
          id: 'demoButton',
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Demo target'),
          ),
        ),
      ),
    );
  }
}
