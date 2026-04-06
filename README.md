# hollow

[![pub version](https://img.shields.io/pub/v/hollow.svg)](https://pub.dev/packages/hollow)
[![license](https://img.shields.io/github/license/r4yb3l/hollow.svg)](https://github.com/r4yb3l/hollow/blob/main/LICENSE)

Pixel-perfect skeleton loading screens for Flutter — extracted from your real `RenderObject` tree, no manual measurement required.

<p align="center">
  <img src="https://raw.githubusercontent.com/r4yb3l/hollow/main/assets/hollow.gif" alt="Demo of Hollow">
</p>

## Features

- Pixel-perfect skeletons from your real `RenderObject` tree — no manual measurement
- Globally synchronized shimmer animation
- One-command CLI: `dart run hollow:build`
- Independent border radius per corner
- Dark mode support out of the box
- Adaptive bone widths (percentage-based) for different screen sizes

---

## Concept

hollow bridges the gap between loading states and real UI by capturing the actual layout of your widgets. Instead of hand-crafting skeleton placeholders that drift from reality, wrap any widget in `Skeleton(...)`, run the CLI, and get pixel-perfect shimmer placeholders that match your real layout — automatically.

---

## Install

```yaml
dependencies:
  hollow: ^1.0.0
```

```bash
flutter pub add hollow
```

---

## Usage

### 1. Wrap widgets with `Skeleton`

```dart
import 'package:hollow/hollow.dart';

Skeleton(
  name: 'blog-card',
  loading: isLoading,
  child: BlogCard(data: post),
)
```

### 2. Run the CLI to capture

```bash
flutter devices                        # find your device id
dart run hollow:build -d iPhone        # scan, capture, generate
```

The CLI scans your source files via Dart AST analysis, launches your app in capture mode, walks the `RenderObject` tree for each `Skeleton`, and writes bone data to `lib/bones/`.

```
  💀 hollow build
  ──────────────────────────────────────────────────
  output  lib/bones

  ✓  blog-card               18 bones
  ✓  user-profile           11 bones

  ──────────────────────────────────────────────────
  Writing files

  → blog-card.bones.json
  → user-profile.bones.json
  → bones_registry.dart  (2 skeletons)

  💀 2 skeletons captured.
```

### 3. Register bones in `main.dart`

```dart
import 'package:hollow/hollow.dart';
import 'bones/bones_registry.dart';

void main() {
  registerAllBones();
  runApp(MyApp());
}
```

Every `Skeleton(name: 'blog-card')` automatically resolves its bones from the registry and displays the shimmer — no extra configuration needed.

---

## How it works

The CLI runs your app with `HOLLOW_BUILD=true`, which makes every `Skeleton` render its `child` directly (bypassing the loading state). After the first frame, hollow walks the `RenderObject` tree and prints structured JSON to stdout. The CLI parses this output, writes `*.bones.json` files, and generates `lib/bones/bones_registry.dart`.

Bone positions use percentage widths (`x`, `w` as 0–100% of container) and absolute logical pixel heights (`y`, `h`) — so skeletons adapt to different screen widths without re-capturing.

### Shimmer

All bones share the same `AnimationController` via `BonePainter`, producing a globally synchronized shimmer gradient. Dark mode adapts automatically via `Theme.of(context).brightness`.

---

## Migration Guide (v0.x → v1.0.0)

### 1. Rename `HollowSkeleton` → `Skeleton`

```dart
// Before
HollowSkeleton(
  fixture: MyWidget(),    // <-- separate fixture widget
  loading: isLoading,
  child: MyWidget(),
)

// After
Skeleton(
  loading: isLoading,
  child: MyWidget(),      // <-- child used directly
)
```

### 2. Remove `fixture`

The `fixture` parameter is gone. The `child` widget is now captured directly during the build phase. If you had a separate mock/fixture widget, simply pass your real widget as `child` — hollow will capture it during `dart run hollow:build`.

### 3. Update `HollowRunner.run` fixtures (if using)

```dart
// Before
HollowRunner.run(
  fixtures: () => [
    Skeleton(name: 'card', fixture: CardWidget(), loading: false, child: SizedBox.shrink()),
  ],
)

// After — fixtures now declare child widgets directly
HollowRunner.run(
  fixtures: () => [
    Skeleton(name: 'card', loading: false, child: CardWidget()),
  ],
)
```

### 4. Update `bones_registry.dart` import

The generated registry path remains `lib/bones/bones_registry.dart`. Just re-run `dart run hollow:build` to regenerate it.

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `loading` | `bool` | required | Show skeleton shimmer or real `child` |
| `child` | `Widget` | required | Your real widget — also captured for bone generation |
| `name` | `String?` | — | Registry lookup key and CLI capture identifier |
| `color` | `Color?` | theme-aware | Base bone color |
| `highlightColor` | `Color?` | theme-aware | Shimmer highlight color |
| `animate` | `bool` | `true` | Enable shimmer animation |
| `fallback` | `Widget?` | — | Shown when loading but no bones are registered |
| `snapshotConfig` | `SnapshotConfig?` | — | Control which render objects to exclude |

---

## CLI

```bash
flutter devices                              # list available devices
dart run hollow:build -d <device-id>         # capture all skeletons
dart run hollow:build -d iPhone --out lib/bones        # custom output dir
dart run hollow:build -d emulator-5554 --timeout 8000  # longer idle wait
```

The CLI uses `package:analyzer` (Dart AST) to find all `Skeleton` usages in your source code before launching the app — making it robust across different code patterns and Flutter versions.

---

## Advanced

### Exclude render object types

```dart
Skeleton(
  name: 'nav-bar',
  loading: isLoading,
  snapshotConfig: SnapshotConfig(
    excludeTypes: [MyIconWidget, CustomPaint],
  ),
  child: NavBar(),
)
```

### Manual registration

You can register bones programmatically without the CLI:

```dart
HollowRegistry.register({
  'my-card': SkeletonResult(
    name: 'my-card',
    width: 375,
    height: 200,
    bones: [
      Bone(x: 0, y: 0, w: 100, h: 200, borderRadius: BorderRadiusData(tl: 12, tr: 12, bl: 0, br: 0)),
      Bone(x: 4, y: 16, w: 92, h: 14, borderRadius: BorderRadiusData.uniform(4)),
      Bone(x: 4, y: 38, w: 60, h: 12, borderRadius: BorderRadiusData.uniform(4)),
    ],
  ),
});
```

---

## Limitations

- Widgets painted via `CustomPaint` / raw `Canvas` are captured as their bounding box only
- Platform views are not supported
- One breakpoint captured per build run

---

## License

MIT
