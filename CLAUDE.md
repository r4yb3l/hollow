# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

**hollow** is a Flutter package that generates pixel-perfect skeleton loading screens by snapshotting the real `RenderObject` tree. No manual measurement — wrap any widget in `Skeleton(...)`, run the CLI, and get shimmer skeletons that match your actual UI.

## Commands

```bash
flutter pub get          # install dependencies
dart analyze lib/ bin/   # lint + type check
flutter test test/       # run all tests
dart run hollow:build    # capture bones from running app (requires simulator)
```

## Architecture

### Package structure

| File | Responsibility |
|---|---|
| `lib/src/types.dart` | `Bone`, `SkeletonResult`, `SnapshotConfig` |
| `lib/src/render_walker.dart` | Walks `RenderObject` tree → `List<Bone>` |
| `lib/src/bone_painter.dart` | `CustomPainter` with global shimmer gradient |
| `lib/src/skeleton.dart` | `Skeleton` widget (build mode + runtime) |
| `lib/src/registry.dart` | `HollowRegistry` singleton |
| `bin/build.dart` | CLI: launches app, reads stdout, writes JSON |

### Bone format

`x`/`w` are **percentages** of container width (0–100). `y`/`h` are **logical pixels**.
This allows bones to adapt to different container widths without re-capturing.

### Build mode / CLI flow

1. CLI runs `flutter run --dart-define=HOLLOW_BUILD=true`
2. `Skeleton` detects `const bool.fromEnvironment('HOLLOW_BUILD')` and renders `fixture ?? child`
3. After first frame, walks `RenderObject` tree and prints `HOLLOW_JSON:<name>:<json>` to stdout
4. CLI parses structured stdout lines, writes `*.bones.json` + `lib/bones/bones_registry.dart`
5. CLI kills the flutter process after 5s idle timeout

### Shimmer

`BonePainter` shifts a `LinearGradient` horizontally using the `AnimationController` value. All bones share the same shader — shimmer is globally synchronized across the entire skeleton.

Container bones (`isContainer: true`) are rendered with a lighter version of the gradient so child bones stand out against them.

---

## Dart / Flutter standards

- **`///` doc comments** for all public APIs (Effective Dart style). No `//` inline explanations or action comments.
- **No commented-out code** — delete it entirely.
- **`StatefulWidget`** only for local widget state like animations (e.g., `AnimationController`). Non-trivial logic belongs in BLoC.
- **No mega-files** — keep files under 500 lines. Break down if needed.
- **No hardcoded colors** — use theme tokens (`context.colorScheme.*`, `context.textTheme.*`).
- **Atomic rebuilds** — never wrap a whole screen in a single builder. Wrap only the smallest widget that needs to change.
