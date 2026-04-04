## 0.1.4

- Add `topics` to pubspec for pub.dev discoverability (skeleton, shimmer, loading, placeholder, ui)
- Improve package description for better search indexing

## 0.1.3

- Add screenshots section to pubspec for pub.dev gallery
- Add demo GIF to README with centered layout
- Add features section to README
- Improve example app with rich demo widgets (photo card, profile card with ExpansionTile, stat card, message tiles)
- Add avatar images to example cards

## 0.1.2

- Add example skeleton assets and screenshots

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
