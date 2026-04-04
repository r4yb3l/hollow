import 'package:flutter/material.dart';

const bool _kBuildMode = bool.fromEnvironment('HOLLOW_BUILD');

/// Entry point helper that switches between your real app and the
/// hollow capture screen based on whether `HOLLOW_BUILD` is set.
///
/// ## Usage
/// Replace `runApp(MyApp())` in `main()` with:
/// ```dart
/// void main() {
///   HollowRunner.run(
///     app: MyApp(),
///     fixtures: () => [
///       Skeleton(
///         name: 'blog-card',
///         fixture: BlogCard(data: mockData),
///         loading: false,
///         child: SizedBox.shrink(),
///       ),
///     ],
///   );
/// }
/// ```
///
/// All fixtures are mounted simultaneously on a single screen, so
/// `dart run hollow:build` captures every skeleton in one pass —
/// no navigation required.
class HollowRunner {
  const HollowRunner._();

  /// Runs [app] normally, or mounts all [fixtures] for hollow capture
  /// when `--dart-define=HOLLOW_BUILD=true` is active.
  ///
  /// [setup] is called before [runApp] in normal mode only — use it to
  /// call `registerAllBones()` once `bones_registry.dart` exists.
  /// It is skipped in build mode so the file doesn't need to exist yet.
  ///
  /// [fixtures] is a factory so it is only evaluated in build mode,
  /// keeping mock data out of production builds.
  static void run({
    required Widget app,
    required List<Widget> Function() fixtures,
    void Function()? setup,
  }) {
    if (_kBuildMode) {
      runApp(_HollowFixturesApp(fixtures: fixtures()));
    } else {
      setup?.call();
      runApp(app);
    }
  }
}

class _HollowFixturesApp extends StatelessWidget {
  const _HollowFixturesApp({required this.fixtures});

  final List<Widget> fixtures;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: fixtures,
          ),
        ),
      ),
    );
  }
}
