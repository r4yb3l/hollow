# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-04-05

### Breaking Changes

- **`HollowSkeleton` renamed to `Skeleton`**. Update all imports and widget references.

- **`fixture` parameter removed**. In v0.x, a separate `fixture` widget was required for the CLI capture phase. In v1.0.0, the `child` widget is captured directly — no duplication. If you were using `fixture`, simply remove it; `child` now serves both roles.

- **`loading` semantics are direct**. The boolean controls skeleton vs. child display. There is no `fixture ?? child` fallback behavior.

### Added

- **Independent border radius per corner** via `BorderRadiusData`. Each bone can have distinct `tl`, `tr`, `bl`, and `br` radius values instead of a single uniform value:

  ```dart
  Bone(
    x: 0, y: 0, w: 100, h: 80,
    borderRadius: BorderRadiusData(tl: 16, tr: 4, bl: 4, br: 16),
  )
  ```

- **`SnapshotConfig.excludeTypes`** for surgically excluding `RenderObject` types from bone extraction. Pass a list of `Type`s to skip during capture.

- **`Skeleton.name` is now optional at runtime**. Required only when running `dart run hollow:build`. Inline skeletons registered manually via `HollowRegistry` work without a name.

### Changed

- **CLI rebuilt with `package:analyzer` (AST)**. The build CLI now uses a proper Dart AST scanner (`AstHollowScanner`) instead of heuristics, making skeleton detection significantly more robust across code patterns and Flutter versions.

- **Shimmer animation is globally synchronized** — all bones share the same `AnimationController` via `BonePainter`.

- **`HollowRunner.run()` now uses `fixtures` differently**. The `fixtures` parameter still accepts skeleton declarations, but `fixture` is no longer a `Skeleton` prop — `child` is captured directly.

### Fixed

- Container bones (`isContainer: true`) are rendered with a lighter gradient so child bones stand out clearly.
- Border radius on `RenderClipRRect` and `RenderPhysicalModel` is extracted and applied to bones correctly.

## [0.2.1] - 2025-03-10

- Simplified example app to a single self-contained file for pub.dev.

## [0.2.0] - 2025-02-20

- Added `HollowRunner.run()` — replaces `registerAllBones()` + `runApp()` with a single entry point.
- Added `fixtures` parameter to `HollowRunner.run()` for declaring all skeletons in one place.
- Added `--name` flag to CLI for targeting specific skeletons.
- Removed auto device detection — `dart run hollow:build` now requires `-d <device-id>`.

## [0.1.4] - 2025-02-10

- Added `topics` to pubspec for pub.dev discoverability.
- Improved package description for search indexing.

## [0.1.3] - 2025-01-28

- Added screenshots section to pubspec for pub.dev gallery.
- Added demo GIF to README.
- Added features section and improved example app.

## [0.1.2] - 2025-01-15

- Added example skeleton assets and screenshots.

## [0.1.1] - 2025-01-10

- Removed inline comments and fixed device detection.

## [0.1.0] - 2025-01-01

- Initial release — `Skeleton` widget, RenderObject tree walker, CLI, and `HollowRegistry`.
