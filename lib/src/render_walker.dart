import 'package:flutter/rendering.dart';

import 'types.dart';

/// Walk the [RenderObject] tree rooted at [root] and return a flat list of bones.
///
/// Positions are relative to [root]'s top-left corner.
/// [x] and [w] are expressed as percentages of [root]'s width so bones
/// adapt gracefully to different container widths.
List<Bone> walkRenderTree(RenderObject root, [SnapshotConfig? config]) {
  if (root is! RenderBox) return const [];

  final rootBox = root;
  final rootOffset = rootBox.localToGlobal(Offset.zero);
  final rootSize = rootBox.size;

  if (rootSize.isEmpty) return const [];

  final bones = <Bone>[];
  _walk(root, rootOffset, rootSize, bones, config);
  return bones;
}

void _walk(
  RenderObject node,
  Offset rootOffset,
  Size rootSize,
  List<Bone> bones,
  SnapshotConfig? config,
) {
  if (node is! RenderBox) {
    node.visitChildren(
      (child) => _walk(child, rootOffset, rootSize, bones, config),
    );
    return;
  }

  final box = node;

  if (!box.hasSize || box.size.isEmpty) return;

  final offset = box.localToGlobal(Offset.zero);
  final relLeft = offset.dx - rootOffset.dx;
  final relTop = offset.dy - rootOffset.dy;
  final w = box.size.width;
  final h = box.size.height;

  if (w < 1 || h < 1) return;

  final xPct = rootSize.width > 0 ? relLeft / rootSize.width * 100 : 0.0;
  final wPct = rootSize.width > 0 ? w / rootSize.width * 100 : 0.0;

  if (_isLeaf(node)) {
    bones.add(Bone(
      x: xPct,
      y: relTop,
      w: wPct,
      h: h,
      r: _extractBorderRadius(node),
    ));
    return;
  }

  if (_hasVisibleBackground(node)) {
    bones.add(Bone(
      x: xPct,
      y: relTop,
      w: wPct,
      h: h,
      r: _extractBorderRadius(node),
      isContainer: true,
    ));
  }

  node.visitChildren(
    (child) => _walk(child, rootOffset, rootSize, bones, config),
  );
}

bool _isLeaf(RenderObject node) {
  if (node is RenderParagraph) return true;
  if (node is RenderImage) return true;

  bool hasVisibleChild = false;
  node.visitChildren((child) {
    if (child is RenderBox && child.hasSize && !child.size.isEmpty) {
      hasVisibleChild = true;
    }
  });
  return !hasVisibleChild;
}

bool _hasVisibleBackground(RenderObject node) {
  if (node is RenderDecoratedBox) {
    final decoration = node.decoration;
    if (decoration is BoxDecoration) {
      final color = decoration.color;
      if (color != null && color.a > 0) return true;
      if (decoration.image != null) return true;
      if (decoration.gradient != null) return true;
    }
  }
  if (node is RenderPhysicalModel) return true;
  if (node is RenderPhysicalShape) return true;
  return false;
}

double _extractBorderRadius(RenderObject node) {
  if (node is RenderClipRRect) {
    return node.borderRadius.resolve(TextDirection.ltr).topLeft.x;
  }
  if (node is RenderDecoratedBox) {
    final decoration = node.decoration;
    if (decoration is BoxDecoration) {
      final br = decoration.borderRadius;
      if (br != null) return br.resolve(TextDirection.ltr).topLeft.x;
    }
  }
  if (node is RenderPhysicalModel) {
    return node.borderRadius?.topLeft.x ?? 8.0;
  }
  return 8.0;
}
