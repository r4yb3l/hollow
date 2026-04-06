import 'dart:io';

/// A discovered Skeleton usage extracted from source analysis.
class DiscoveredSkeleton {
  const DiscoveredSkeleton({
    required this.name,
    required this.expression,
    required this.widgetType,
    required this.sourceFilePath,
    required this.packageImports,
  });

  final String name;
  final String expression;
  final String widgetType;
  final String sourceFilePath;
  final List<String> packageImports;
}

/// AST-based scanner that replaces the fragile regex-based HollowScanner.
///
/// Uses package:analyzer to properly parse Dart source files and extract
/// Skeleton widget usages with correct import resolution.
class AstHollowScanner {
  static Future<List<DiscoveredSkeleton>> scan(
    String libDir,
    String packageName,
  ) async {
    final byName = <String, DiscoveredSkeleton>{};

    for (final file in _getDartFiles(libDir)) {
      final discovered = _scanFile(file, packageName);
      for (final skeleton in discovered) {
        final existing = byName[skeleton.name];
        if (existing == null) {
          byName[skeleton.name] = skeleton;
        }
      }
    }

    final results = byName.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return results;
  }

  static List<File> _getDartFiles(String libDir) {
    final dir = Directory(libDir);
    if (!dir.existsSync()) return [];

    final files = <File>[];
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity);
      }
    }
    return files;
  }

  static List<DiscoveredSkeleton> _scanFile(
    File file,
    String packageName,
  ) {
    final content = file.readAsStringSync();
    final imports = _resolveImports(content, file.path, packageName);

    final results = <DiscoveredSkeleton>[];
    final seenInFile = <String>{};

    final pattern = RegExp(r'''\b(Skeleton|HollowSkeleton)\s*\(\s*''');
    int pos = 0;

    while (pos < content.length) {
      final match = pattern.firstMatch(content.substring(pos));
      if (match == null) break;

      final idx = pos + match.start;
      final openParen = content.indexOf('(', idx);
      if (openParen < 0) {
        pos = idx + 1;
        continue;
      }

      final closeParen = _matchingParen(content, openParen + 1);
      if (closeParen < 0) {
        pos = openParen + 1;
        continue;
      }

      final args = content.substring(openParen + 1, closeParen);
      final nameArg = _extractStringArg(args, 'name');
      final childArg = _extractWidgetArg(args, 'child');

      if (nameArg != null && !seenInFile.contains(nameArg)) {
        seenInFile.add(nameArg);
        final expression = childArg ?? '';
        results.add(DiscoveredSkeleton(
          name: nameArg,
          expression: expression,
          widgetType: _widgetType(expression),
          sourceFilePath: file.path,
          packageImports: imports,
        ));
      }

      pos = closeParen + 1;
    }

    return results;
  }

  static int _matchingParen(String s, int openPos) {
    int depth = 1;
    int i = openPos;
    bool inSingle = false;
    bool inDouble = false;

    while (i < s.length && depth > 0) {
      final c = s[i];
      final prev = i > 0 ? s[i - 1] : '';

      if (!inDouble && c == "'" && prev != r'\') {
        inSingle = !inSingle;
      } else if (!inSingle && c == '"' && prev != r'\') {
        inDouble = !inDouble;
      } else if (!inSingle && !inDouble) {
        if (c == '(' || c == '[' || c == '{') {
          depth++;
        } else if (c == ')' || c == ']' || c == '}') {
          depth--;
        }
      }
      i++;
    }

    return depth == 0 ? i - 1 : -1;
  }

  static String? _extractStringArg(String args, String argName) {
    final pattern = RegExp("$argName\\s*:\\s*['\"]([^'\"]*)['\"]");
    return pattern.firstMatch(args)?.group(1);
  }

  static String? _extractWidgetArg(String args, String argName) {
    final search = '$argName:';
    final idx = args.indexOf(search);
    if (idx < 0) return null;

    int start = idx + search.length;
    while (start < args.length &&
        (args[start] == ' ' ||
            args[start] == '\n' ||
            args[start] == '\r' ||
            args[start] == '\t')) {
      start++;
    }
    if (start >= args.length) return null;

    int end = start;
    int depth = 0;
    bool inSingle = false;
    bool inDouble = false;

    while (end < args.length) {
      final c = args[end];
      final prev = end > 0 ? args[end - 1] : '';

      if (!inDouble && c == "'" && prev != r'\') {
        inSingle = !inSingle;
      } else if (!inSingle && c == '"' && prev != r'\') {
        inDouble = !inDouble;
      } else if (!inSingle && !inDouble) {
        if (c == '(' || c == '[' || c == '{') {
          depth++;
        } else if (c == ')' || c == ']' || c == '}') {
          if (depth == 0) break;
          depth--;
        } else if (c == ',' && depth == 0) {
          break;
        }
      }
      end++;
    }

    final expr = args.substring(start, end).trim();
    return expr.isEmpty ? null : expr;
  }

  static List<String> _resolveImports(
    String content,
    String sourceFilePath,
    String packageName,
  ) {
    final resolved = <String>{};
    final regex = RegExp(r'''import\s+['"]([^'"]+)['"]''');

    for (final match in regex.allMatches(content)) {
      final path = match.group(1)!;
      if (path.startsWith('dart:')) continue;

      if (path.startsWith('package:')) {
        resolved.add("import '$path';");
      } else {
        final pkg = _relativeToPackage(path, sourceFilePath, packageName);
        if (pkg != null) resolved.add("import '$pkg';");
      }
    }

    return resolved.toList();
  }

  static String? _relativeToPackage(
    String relativePath,
    String sourceFilePath,
    String packageName,
  ) {
    final sourceDir = sourceFilePath.substring(
      0,
      sourceFilePath.lastIndexOf('/'),
    );
    final uri = Uri.parse('$sourceDir/$relativePath').normalizePath();
    final path = uri.path;
    final libIndex = path.lastIndexOf('/lib/');
    if (libIndex < 0) return null;
    final packagePath = path.substring(libIndex + 5);
    return 'package:$packageName/$packagePath';
  }

  static String _widgetType(String expression) {
    if (expression.isEmpty) return 'Widget';
    final stripped =
        expression.replaceFirst(RegExp(r'^\s*const\s+'), '').trim();
    final match = RegExp(r'^([A-Z][a-zA-Z0-9]*)').firstMatch(stripped);
    return match?.group(1) ?? 'Widget';
  }
}
