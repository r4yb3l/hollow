import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';

import 'types.dart';

/// Paints skeleton bones with a global shimmer effect.
///
/// The shimmer gradient sweeps horizontally across all bones simultaneously,
/// creating the synchronized shimmer seen in LinkedIn, Facebook, etc.
class BonePainter extends CustomPainter {
  BonePainter({
    required this.bones,
    required this.shimmerAnimation,
    required this.baseColor,
    required this.highlightColor,
  }) : super(repaint: shimmerAnimation);

  final List<Bone> bones;
  final Animation<double> shimmerAnimation;
  final Color baseColor;
  final Color highlightColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (bones.isEmpty) return;

    final shimmerX = shimmerAnimation.value * size.width * 3 - size.width;

    final shader = LinearGradient(
      colors: [baseColor, highlightColor, baseColor],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(
      Rect.fromLTWH(shimmerX, 0, size.width * 2, size.height),
    );

    final shimmerPaint = Paint()..shader = shader;

    final containerPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          _lighten(baseColor, 0.4),
          _lighten(highlightColor, 0.4),
          _lighten(baseColor, 0.4),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
        Rect.fromLTWH(shimmerX, 0, size.width * 2, size.height),
      );

    for (final bone in bones) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          bone.x / 100 * size.width,
          bone.y,
          bone.w / 100 * size.width,
          bone.h,
        ),
        Radius.circular(bone.r),
      );
      canvas.drawRRect(rect, bone.isContainer ? containerPaint : shimmerPaint);
    }
  }

  @override
  bool shouldRepaint(BonePainter oldDelegate) =>
      bones != oldDelegate.bones ||
      baseColor != oldDelegate.baseColor ||
      highlightColor != oldDelegate.highlightColor;

  static Color _lighten(Color color, double amount) {
    return Color.fromARGB(
      (color.a * 255.0).round().clamp(0, 255),
      ((color.r * 255.0).round() + ((255 - (color.r * 255.0).round()) * amount)).round().clamp(0, 255),
      ((color.g * 255.0).round() + ((255 - (color.g * 255.0).round()) * amount)).round().clamp(0, 255),
      ((color.b * 255.0).round() + ((255 - (color.b * 255.0).round()) * amount)).round().clamp(0, 255),
    );
  }
}
