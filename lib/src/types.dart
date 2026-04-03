/// A single skeleton bone — a rounded rect placeholder.
///
/// [x] and [w] are percentages of the container width (0–100),
/// allowing bones to adapt to different screen widths without re-capturing.
/// [y] and [h] are logical pixels from the top of the container.
class Bone {
  const Bone({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.r = 8.0,
    this.isContainer = false,
  });

  /// Horizontal offset as % of container width.
  final double x;

  /// Vertical offset in logical pixels.
  final double y;

  /// Width as % of container width.
  final double w;

  /// Height in logical pixels.
  final double h;

  /// Border radius in logical pixels.
  final double r;

  /// True if this is a background container bone — rendered lighter so
  /// child bones stand out against it.
  final bool isContainer;

  factory Bone.fromJson(Map<String, dynamic> json) => Bone(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        w: (json['w'] as num).toDouble(),
        h: (json['h'] as num).toDouble(),
        r: (json['r'] as num?)?.toDouble() ?? 8.0,
        isContainer: json['c'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'w': w,
        'h': h,
        'r': r,
        if (isContainer) 'c': true,
      };
}

/// Snapshot of a widget's visual structure as skeleton bones.
class SkeletonResult {
  const SkeletonResult({
    required this.name,
    required this.width,
    required this.height,
    required this.bones,
  });

  final String name;

  /// Container width at capture time in logical pixels.
  final double width;

  /// Container height at capture time in logical pixels.
  final double height;

  final List<Bone> bones;

  factory SkeletonResult.fromJson(Map<String, dynamic> json) => SkeletonResult(
        name: json['name'] as String,
        width: (json['width'] as num).toDouble(),
        height: (json['height'] as num).toDouble(),
        bones: (json['bones'] as List<dynamic>)
            .map((b) => Bone.fromJson(b as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'width': width,
        'height': height,
        'bones': bones.map((b) => b.toJson()).toList(),
      };
}

/// Controls how [walkRenderTree] extracts bones.
class SnapshotConfig {
  const SnapshotConfig({
    this.excludeTypes = const [],
  });

  /// List of [Type] runtimeTypes to skip entirely (no bone emitted, no recursion).
  final List<Type> excludeTypes;
}
