# hollow

Pixel-perfect skeleton loading screens for Flutter — extracted from your real widget tree, no manual measurement required.

```dart
Skeleton(
  name: 'blog-card',
  loading: isLoading,
  fixture: BlogCard(data: mockData),
  child: BlogCard(data: realData),
)
```

```bash
dart run hollow:build
```

Done. Every `Skeleton` shows a shimmer placeholder that matches your real layout exactly.

---

## How it works

1. Wrap your widget with `Skeleton` and give it a `name`
2. Run `dart run hollow:build` — hollow launches your app in capture mode, walks the `RenderObject` tree of each `Skeleton`, and snapshots every visible element's exact position and size
3. Import the generated registry once in `main()` — every `Skeleton` auto-resolves its bones

hollow reads `getBoundingRect()` equivalents directly from Flutter's render tree — no layout simulation, no heuristics, just what the framework already computed.

---

## Install

```yaml
dependencies:
  hollow: ^0.1.0
```

```bash
flutter pub add hollow
```

---

## Setup

### 1. Wrap your widgets

```dart
import 'package:hollow/hollow.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeleton(
      name: 'blog-card',
      loading: isLoading,
      fixture: BlogCard(data: BlogPost.mock()),  // shown during CLI capture
      child: BlogCard(data: post),
    );
  }
}
```

### 2. Run the CLI

```bash
dart run hollow:build
```

hollow detects your connected simulator or device, launches your app in capture mode, and writes bone files to `lib/bones/`.

```
  💀 hollow build
  ──────────────────────────────────────────────────
  output  lib/bones

  ✓  blog-card               18 bones
  ✓  user-profile            11 bones
  ✓  product-card            9 bones

  ──────────────────────────────────────────────────
  Writing files

  → blog-card.bones.json
  → user-profile.bones.json
  → product-card.bones.json
  → bones_registry.dart  (3 skeletons)

  💀 3 skeletons captured.
```

### 3. Register once in `main()`

```dart
import 'bones/bones_registry.dart';

void main() {
  registerAllBones();
  runApp(MyApp());
}
```

That's it. Every `Skeleton(name: '...')` automatically resolves its bones from the registry.

---

## Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `loading` | `bool` | required | Show skeleton or real content |
| `child` | `Widget` | required | Your real widget |
| `name` | `String?` | — | Name for registry lookup and CLI capture |
| `fixture` | `Widget?` | — | Mock content shown during CLI capture |
| `color` | `Color?` | theme-aware | Base bone color |
| `highlightColor` | `Color?` | theme-aware | Shimmer highlight color |
| `animate` | `bool` | `true` | Enable shimmer animation |
| `fallback` | `Widget?` | — | Shown when loading but no bones available |
| `snapshotConfig` | `SnapshotConfig?` | — | Control which render objects are captured |

---

## CLI

```bash
dart run hollow:build                          # auto-detects simulator/device
dart run hollow:build --device emulator-5554  # explicit device ID
dart run hollow:build --out lib/bones         # custom output directory
dart run hollow:build --timeout 8000          # wait longer after last capture
```

---

## How bones are captured

hollow walks Flutter's `RenderObject` tree starting from the root of each `Skeleton`:

- **`RenderParagraph`** → text leaf → captured as a single bone
- **`RenderImage`** → image leaf → captured as a single bone
- **`RenderDecoratedBox`** with a non-transparent background → container bone (rendered lighter so child bones stand out)
- **`RenderClipRRect`**, **`RenderPhysicalModel`** → border radius extracted and applied to the bone

Bone positions use percentage widths (`x`, `w` as % of container) and absolute logical pixel heights (`y`, `h`), so skeletons adapt gracefully to different screen widths.

### Shimmer

The shimmer gradient runs across all bones simultaneously in perfect sync — the same effect used by LinkedIn, Facebook, and most modern apps.

Dark mode is handled automatically via the active `ThemeData.brightness`.

---

## Advanced

### `SnapshotConfig`

```dart
Skeleton(
  name: 'nav-bar',
  loading: isLoading,
  snapshotConfig: SnapshotConfig(
    excludeTypes: [MyIconWidget],
  ),
  child: NavBar(),
)
```

### Manual registration

You can register bones programmatically without the CLI — useful for testing or custom build pipelines:

```dart
HollowRegistry.register({
  'my-card': SkeletonResult(
    name: 'my-card',
    width: 375,
    height: 200,
    bones: [
      Bone(x: 0, y: 0, w: 100, h: 200, r: 12, isContainer: true),
      Bone(x: 4, y: 16, w: 92, h: 14, r: 4),
      Bone(x: 4, y: 38, w: 60, h: 12, r: 4),
    ],
  ),
});
```

---

## Limitations

- Widgets painted via `CustomPaint` / raw `Canvas` calls are captured as their bounding box only — internal draw calls can't be introspected
- Platform views are not supported
- One breakpoint captured per build run (responsive support planned)

---

## License

MIT
