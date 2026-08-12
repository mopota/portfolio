import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/project.dart';

class ProjectLoader {
  ProjectLoader._();

  static const String _projectsRoot = 'assets/projects';
  static const String _indexPath = '$_projectsRoot/index.json';

  /// Languages supported by the portfolio.
  ///
  /// English is always loaded from:
  /// project.md
  ///
  /// Other languages use:
  /// project_ar.md
  /// project_es.md
  /// etc.
  static const List<String> _supportedLanguages = <String>[
    'en',
    'ar',
    'es',
    'fr',
    'de',
    'zh',
    'ja',
  ];

  /// Loads all portfolio projects from the external project assets.
  ///
  /// Data flow:
  ///
  /// index.json
  ///     ↓
  /// project metadata
  ///     ↓
  /// project.md / project_<language>.md
  ///     ↓
  /// Project.fromJson
  ///     ↓
  /// List<Project>
  static Future<List<Project>> loadProjects() async {
    try {
      final String indexContent = await rootBundle.loadString(_indexPath);

      final dynamic decoded = jsonDecode(indexContent);

      if (decoded is! List) {
        debugPrint(
          '[ProjectLoader] Invalid index.json: expected a JSON array.',
        );
        return const <Project>[];
      }

      final List<Project> projects = <Project>[];

      for (final dynamic rawItem in decoded) {
        if (rawItem is! Map) {
          debugPrint(
            '[ProjectLoader] Skipping invalid project entry: $rawItem',
          );
          continue;
        }

        final Map<String, dynamic> item =
            Map<String, dynamic>.from(rawItem);

        final String? folder = _readString(item['folder']);

        if (folder == null || folder.isEmpty) {
          debugPrint(
            '[ProjectLoader] Skipping project without a valid folder.',
          );
          continue;
        }

        final Map<String, String> contents =
            await _loadProjectContents(folder);

        final String englishContent =
            contents['en']?.trim() ?? '';

        if (englishContent.isEmpty) {
          debugPrint(
            '[ProjectLoader] Warning: English content is empty for '
            'project "$folder".',
          );
        }

        try {
          final Project project = Project.fromJson(
            item,
            contents,
          );

          projects.add(project);
        } catch (e, stackTrace) {
          debugPrint(
            '[ProjectLoader] Failed to create Project for "$folder": $e',
          );
          debugPrintStack(stackTrace: stackTrace);
        }
      }

      debugPrint(
        '[ProjectLoader] Loaded ${projects.length} project(s).',
      );

      return List<Project>.unmodifiable(projects);
    } on FlutterError catch (e, stackTrace) {
      debugPrint(
        '[ProjectLoader] Flutter asset error while loading index: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    } on FormatException catch (e, stackTrace) {
      debugPrint(
        '[ProjectLoader] Invalid JSON in $_indexPath: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    } catch (e, stackTrace) {
      debugPrint(
        '[ProjectLoader] Unexpected error while loading projects: $e',
      );
      debugPrintStack(stackTrace: stackTrace);
      return const <Project>[];
    }
  }

  /// Loads all available Markdown content for a single project.
  ///
  /// English:
  ///   project.md
  ///
  /// Arabic:
  ///   project_ar.md
  ///
  /// Other languages:
  ///   project_<language>.md
  ///
  /// If a translated file does not exist, English is used as fallback.
  static Future<Map<String, String>> _loadProjectContents(
    String folder,
  ) async {
    final Map<String, String> contents = <String, String>{};

    // English is the primary source and MUST be loaded first.
    final String? englishContent = await _loadMarkdown(
      folder: folder,
      language: 'en',
    );

    if (englishContent != null && englishContent.trim().isNotEmpty) {
      contents['en'] = englishContent;
    } else {
      debugPrint(
        '[ProjectLoader] Missing English content: '
        '$_projectsRoot/$folder/project.md',
      );

      // Keep an empty value instead of fake content.
      contents['en'] = '';
    }

    // Load translated content.
    for (final String language in _supportedLanguages) {
      if (language == 'en') {
        continue;
      }

      final String? translatedContent = await _loadMarkdown(
        folder: folder,
        language: language,
      );

      if (translatedContent != null &&
          translatedContent.trim().isNotEmpty) {
        contents[language] = translatedContent;
      } else {
        // Fallback to English.
        contents[language] = contents['en'] ?? '';

        debugPrint(
          '[ProjectLoader] Translation "$language" not found for '
          '"$folder". Falling back to English.',
        );
      }
    }

    return contents;
  }

  /// Loads one Markdown file.
  ///
  /// Returns null when the file does not exist.
  static Future<String?> _loadMarkdown({
    required String folder,
    required String language,
  }) async {
    final String suffix = language == 'en' ? '' : '_$language';

    final String path =
        '$_projectsRoot/$folder/project$suffix.md';

    try {
      return await rootBundle.loadString(path);
    } on FlutterError {
      return null;
    } catch (e) {
      debugPrint(
        '[ProjectLoader] Failed to read "$path": $e',
      );
      return null;
    }
  }

  static String? _readString(dynamic value) {
    if (value is String) {
      final String result = value.trim();

      if (result.isNotEmpty) {
        return result;
      }
    }

    return null;
  }
}               }
            }
          }
        }
        
        projects.add(Project.fromJson(item, contents));
      }
      
      return projects;
    } catch (e) {
      debugPrint (': Error loading projects index: $e');
      return [];
    }
  }
}
