/// Represents border radius for a single corner or uniform across all corners.
class BorderRadiusData {
  const BorderRadiusData({
    this.tl = 8.0,
    this.tr = 8.0,
    this.bl = 8.0,
    this.br = 8.0,
  });

  const BorderRadiusData.uniform(double radius)
      : tl = radius,
        tr = radius,
        bl = radius,
        br = radius;

  final double tl;
  final double tr;
  final double bl;
  final double br;

  factory BorderRadiusData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('r')) {
      final r = (json['r'] as num).toDouble();
      return BorderRadiusData.uniform(r);
    }
    return BorderRadiusData(
      tl: (json['tl'] as num?)?.toDouble() ?? 8.0,
      tr: (json['tr'] as num?)?.toDouble() ?? 8.0,
      bl: (json['bl'] as num?)?.toDouble() ?? 8.0,
      br: (json['br'] as num?)?.toDouble() ?? 8.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'tl': tl,
        'tr': tr,
        'bl': bl,
        'br': br,
      };
}

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
    this.borderRadius,
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

  /// Border radius data. Defaults to uniform 8px if null.
  final BorderRadiusData? borderRadius;

  /// True if this is a background container bone — rendered lighter so
  /// child bones stand out against it.
  final bool isContainer;

  factory Bone.fromJson(Map<String, dynamic> json) => Bone(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        w: (json['w'] as num).toDouble(),
        h: (json['h'] as num).toDouble(),
        borderRadius: json.containsKey('br')
            ? BorderRadiusData.fromJson(json['br'] as Map<String, dynamic>)
            : json.containsKey('r')
                ? BorderRadiusData.uniform((json['r'] as num).toDouble())
                : null,
        isContainer: json['c'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'w': w,
        'h': h,
        if (borderRadius != null)
          'br': borderRadius!.toJson(),
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
