import 'package:flutter/material.dart';

/// Entry point helper that calls [setup] and runs [app].
///
/// ## Usage
/// Replace `runApp(MyApp())` in `main()` with:
/// ```dart
/// void main() {
///   HollowRunner.run(
///     app: MyApp(),
///     setup: registerAllBones,
///   );
/// }
/// ```
///
/// [setup] is called before [runApp] — use it to call
/// `registerAllBones()` once `bones_registry.dart` exists.
class HollowRunner {
  const HollowRunner._();

  static void run({
    required Widget app,
    void Function()? setup,
  }) {
    setup?.call();
    runApp(app);
  }
}
