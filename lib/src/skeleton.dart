import 'dart:convert';

import 'package:flutter/material.dart';

import 'bone_painter.dart';
import 'registry.dart';
import 'render_walker.dart';
import 'types.dart';

const bool _kBuildMode = bool.fromEnvironment('HOLLOW_BUILD');

/// Wraps any widget to provide automatic skeleton loading screens.
///
/// ## Usage
/// ```dart
/// Skeleton(
///   name: 'blog-card',
///   loading: isLoading,
///   child: BlogCard(data: post.data),
/// )
/// ```
///
/// ## Build mode
/// Run `dart run hollow:build -d <device>` to snapshot bone positions from your
/// running app and generate `lib/bones/bones_registry.dart`. Import it once in
/// `main`:
/// ```dart
/// import 'bones/bones_registry.dart';
/// void main() {
///   registerAllBones();
///   runApp(MyApp());
/// }
/// ```
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    required this.loading,
    required this.child,
    this.name,
    this.color,
    this.highlightColor,
    this.animate = true,
    this.fallback,
    this.snapshotConfig,
  });

  /// When true, shows the skeleton shimmer. When false, shows [child].
  final bool loading;

  /// Your real widget — shown when [loading] is false.
  final Widget child;

  /// Unique name used to look up pre-generated bones from the registry
  /// and to identify this skeleton during `dart run hollow:build`.
  final String? name;

  /// Base bone color. Defaults to a light gray appropriate for light mode.
  final Color? color;

  /// Shimmer highlight color. Defaults to a lighter version of [color].
  final Color? highlightColor;

  /// Whether to animate the shimmer. Defaults to true.
  final bool animate;

  /// Shown when [loading] is true but no bones are available yet.
  final Widget? fallback;

  /// Controls how the CLI extracts bones from [child] during build mode.
  final SnapshotConfig? snapshotConfig;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  SkeletonResult? _capturedBones;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.animate) _controller.repeat();

    if (_kBuildMode && widget.name != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _captureBones());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _captureBones() {
    final renderObject = context.findRenderObject();
    if (renderObject == null) return;

    try {
      final bones = walkRenderTree(renderObject, widget.snapshotConfig);
      final box = renderObject as RenderBox;
      final result = SkeletonResult(
        name: widget.name!,
        width: box.size.width,
        height: box.size.height,
        bones: bones,
      );
      debugPrint('HOLLOW_JSON:${widget.name}:${jsonEncode(result.toJson())}');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_kBuildMode) {
      return widget.child;
    }

    final activeBones = _capturedBones ??
        (widget.name != null ? HollowRegistry.get(widget.name!) : null);

    if (!widget.loading) return widget.child;

    if (activeBones == null) {
      return widget.fallback ?? widget.child;
    }

    final baseColor = widget.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withAlpha(15)
            : Colors.black.withAlpha(20));

    final highlightColor = widget.highlightColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withAlpha(10)
            : Colors.black.withAlpha(5));

    return SizedBox(
      width: double.infinity,
      height: activeBones.height,
      child: widget.animate
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => CustomPaint(
                painter: BonePainter(
                  bones: activeBones.bones,
                  shimmerAnimation: _controller,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ),
            )
          : CustomPaint(
              painter: BonePainter(
                bones: activeBones.bones,
                shimmerAnimation: _controller,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
            ),
    );
  }
}
