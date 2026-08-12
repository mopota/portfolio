import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/project.dart';

class ProjectLoader {
  ProjectLoader._();

  static const String _projectsRoot = 'assets/projects';
  static const String _indexPath = '$_projectsRoot/index.json';

  static const List<String> _supportedLanguages = <String>[
    'en',
    'ar',
    'es',
    'fr',
    'de',
    'zh',
    'ja',
  ];

  static Future<List<Project>> loadProjects() async {
    try {
      final String indexContent =
          await rootBundle.loadString(_indexPath);

      final dynamic decoded = jsonDecode(indexContent);

      if (decoded is! List) {
        debugPrint(
          '[ProjectLoader] index.json must contain a JSON array.',
        );
        return const <Project>[];
      }

      final List<Project> projects = <Project>[];

      for (final dynamic rawItem in decoded) {
        if (rawItem is! Map) {
          debugPrint(
            '[ProjectLoader] Skipping invalid project entry.',
          );
          continue;
        }

        final Map<String, dynamic> item =
            Map<String, dynamic>.from(rawItem);

        final dynamic folderValue = item['folder'];

        if (folderValue is! String ||
            folderValue.trim().isEmpty) {
          debugPrint(
            '[ProjectLoader] Skipping project without a valid folder.',
          );
          continue;
        }

        final String folder = folderValue.trim();

        final Map<String, String> contents =
            await _loadProjectContents(folder);

        try {
          final Project project = Project.fromJson(
            item,
            contents,
          );

          projects.add(project);
        } catch (error, stackTrace) {
          debugPrint(
            '[ProjectLoader] Failed to parse project "$folder": $error',
          );
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      debugPrint(
        '[ProjectLoader] Loaded ${projects.length} project(s).',
      );

      return List<Project>.unmodifiable(projects);
    } on FlutterError catch (error, stackTrace) {
      debugPrint(
        '[ProjectLoader] Asset loading error: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        '[ProjectLoader] Invalid JSON in $_indexPath: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    } catch (error, stackTrace) {
      debugPrint(
        '[ProjectLoader] Unexpected loading error: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    }
  }

  static Future<Map<String, String>> _loadProjectContents(
    String folder,
  ) async {
    final Map<String, String> contents = <String, String>{};

    final String? english = await _loadMarkdown(
      folder: folder,
      language: 'en',
    );

    if (english != null && english.trim().isNotEmpty) {
      contents['en'] = english;
    } else {
      debugPrint(
        '[ProjectLoader] Missing English content for "$folder".',
      );

      contents['en'] = '';
    }

    for (final String language in _supportedLanguages) {
      if (language == 'en') {
        continue;
      }

      final String? translated = await _loadMarkdown(
        folder: folder,
        language: language,
      );

      if (translated != null && translated.trim().isNotEmpty) {
        contents[language] = translated;
      } else {
        contents[language] = contents['en'] ?? '';
      }
    }

    return Map<String, String>.unmodifiable(contents);
  }

  static Future<String?> _loadMarkdown({
    required String folder,
    required String language,
  }) async {
    final String suffix =
        language == 'en' ? '' : '_$language';

    final String path =
        '$_projectsRoot/$folder/project$suffix.md';

    try {
      return await rootBundle.loadString(path);
    } on FlutterError {
      return null;
    } catch (error) {
      debugPrint(
        '[ProjectLoader] Failed to read "$path": $error',
      );
      return null;
    }
  }
}
