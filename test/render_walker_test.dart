import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hollow/hollow.dart';

void main() {
  group('Bone serialization', () {
    test('toJson / fromJson roundtrip', () {
      const bone = Bone(x: 10, y: 20, w: 80, h: 40);
      final json = bone.toJson();
      final restored = Bone.fromJson(json);
      expect(restored.x, bone.x);
      expect(restored.y, bone.y);
      expect(restored.w, bone.w);
      expect(restored.h, bone.h);
      expect(restored.isContainer, false);
    });

    test('container bone roundtrip', () {
      const bone = Bone(x: 0, y: 0, w: 100, h: 200, isContainer: true);
      final restored = Bone.fromJson(bone.toJson());
      expect(restored.isContainer, true);
    });

    test('isContainer defaults to false when key absent', () {
      final bone = Bone.fromJson({'x': 0, 'y': 0, 'w': 100, 'h': 50});
      expect(bone.isContainer, false);
    });

    test('backward compat: r field creates uniform BorderRadiusData', () {
      final bone = Bone.fromJson({'x': 0, 'y': 0, 'w': 100, 'h': 50, 'r': 12});
      expect(bone.borderRadius?.tl, 12);
      expect(bone.borderRadius?.tr, 12);
      expect(bone.borderRadius?.bl, 12);
      expect(bone.borderRadius?.br, 12);
    });

    test('new format: br with individual corners', () {
      final bone = Bone.fromJson({
        'x': 0,
        'y': 0,
        'w': 100,
        'h': 50,
        'br': {'tl': 4, 'tr': 8, 'bl': 12, 'br': 16}
      });
      expect(bone.borderRadius?.tl, 4);
      expect(bone.borderRadius?.tr, 8);
      expect(bone.borderRadius?.bl, 12);
      expect(bone.borderRadius?.br, 16);
    });

    test('BorderRadiusData serialization', () {
      const br = BorderRadiusData(tl: 4, tr: 8, bl: 12, br: 16);
      final json = br.toJson();
      final restored = BorderRadiusData.fromJson(json);
      expect(restored.tl, 4);
      expect(restored.tr, 8);
      expect(restored.bl, 12);
      expect(restored.br, 16);
    });

    test('BorderRadiusData uniform constructor', () {
      const br = BorderRadiusData.uniform(8);
      expect(br.tl, 8);
      expect(br.tr, 8);
      expect(br.bl, 8);
      expect(br.br, 8);
    });
  });

  group('SkeletonResult serialization', () {
    test('toJson / fromJson roundtrip', () {
      const result = SkeletonResult(
        name: 'card',
        width: 375,
        height: 200,
        bones: [
          Bone(x: 0, y: 0, w: 100, h: 200, isContainer: true),
          Bone(x: 5, y: 16, w: 90, h: 14),
        ],
      );
      final restored = SkeletonResult.fromJson(result.toJson());
      expect(restored.name, 'card');
      expect(restored.width, 375);
      expect(restored.height, 200);
      expect(restored.bones.length, 2);
      expect(restored.bones[0].isContainer, true);
    });
  });

  group('HollowRegistry', () {
    setUp(HollowRegistry.clear);

    test('register and get', () {
      const result = SkeletonResult(
        name: 'test', width: 100, height: 50, bones: [],
      );
      HollowRegistry.register({'test': result});
      expect(HollowRegistry.get('test'), result);
    });

    test('returns null for unknown name', () {
      expect(HollowRegistry.get('unknown'), isNull);
    });
  });

  group('Skeleton widget', () {
    testWidgets('shows child when not loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeleton(
            loading: false,
            child: Text('real content'),
          ),
        ),
      );
      expect(find.text('real content'), findsOneWidget);
    });

    testWidgets('shows fallback when loading and no bones', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Skeleton(
            loading: true,
            fallback: Text('loading...'),
            child: Text('real content'),
          ),
        ),
      );
      expect(find.text('loading...'), findsOneWidget);
      expect(find.text('real content'), findsNothing);
    });

    testWidgets('shows skeleton when loading and bones available',
        (tester) async {
      HollowRegistry.register({
        'my-card': const SkeletonResult(
          name: 'my-card',
          width: 375,
          height: 150,
          bones: [Bone(x: 0, y: 0, w: 100, h: 150)],
        ),
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Skeleton(
            name: 'my-card',
            loading: true,
            child: Text('real content'),
          ),
        ),
      );

      expect(find.text('real content'), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.painter is BonePainter,
        ),
        findsOneWidget,
      );

      HollowRegistry.clear();
    });
  });
}
