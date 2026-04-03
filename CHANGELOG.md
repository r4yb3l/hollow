## 0.1.1

- Remove inline comments
- Fix device detection to prefer iOS simulator over Android

## 0.1.0

- Initial release
- `Skeleton` widget with automatic shimmer animation
- RenderObject tree walker for pixel-perfect bone extraction
- CLI (`dart run hollow:build`) for pre-generating bones via `flutter run` capture mode
- `HollowRegistry` for registering pre-generated skeletons
- Dark mode support via `ThemeData.brightness`
- `SnapshotConfig` for excluding specific render object types
