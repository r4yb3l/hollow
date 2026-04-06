import 'dart:io';

/// Extracts a value for [flag] from a CLI argument list.
String? argValue(List<String> args, String flag) {
  final i = args.indexOf(flag);
  if (i < 0 || i + 1 >= args.length) return null;
  return args[i + 1];
}

/// Reads the package name from `pubspec.yaml` in [dir].
Future<String> readPackageName(String dir) async {
  final file = File('$dir/pubspec.yaml');
  if (!await file.exists()) return '';
  final content = await file.readAsString();
  final match = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
  return match?.group(1)?.trim() ?? '';
}
