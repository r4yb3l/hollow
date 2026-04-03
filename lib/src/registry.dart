import 'types.dart';

/// Global registry of pre-generated skeleton results.
///
/// Populated by the generated `bones_registry.dart` file produced by
/// `dart run hollow:build`. Import and call [registerAllBones] once in
/// your `main()` before [runApp].
class HollowRegistry {
  HollowRegistry._();

  static final Map<String, SkeletonResult> _map = {};

  /// Register a map of skeleton results by name.
  static void register(Map<String, SkeletonResult> bones) {
    _map.addAll(bones);
  }

  /// Look up pre-generated bones by [name]. Returns null if not registered.
  static SkeletonResult? get(String name) => _map[name];

  /// Remove all registered bones. Useful for testing.
  static void clear() => _map.clear();
}
