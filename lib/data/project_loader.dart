import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/project.dart';

class ProjectLoader {
  static Future<List<Project>> loadProjects() async {
    try {
      final String indexContent = await rootBundle.loadString('assets/projects/index.json');
      final List<dynamic> indexJson = json.decode(indexContent);
      
      List<Project> projects = [];
      
      for (var item in indexJson) {
        final folder = item['folder'] as String;
        Map<String, String> contents = {};
        
        // Supported languages for content
        final languages = ['en', 'ar', 'es', 'fr', 'de', 'zh', 'ja'];
        
        for (var lang in languages) {
          try {
            // Try specific language file, e.g., project_ar.md
            final suffix = lang == 'en' ? '' : '_$lang';
            final content = await rootBundle.loadString('assets/projects/$folder/project$suffix.md');
            contents[lang] = content;
          } catch (_) {
            // Fallback to default project.md (English)
            if (lang != 'en') {
              contents[lang] = contents['en'] ?? 'Content fallback';
            } else {
              // This shouldn't happen if project.md exists
              try {
                 contents['en'] = await rootBundle.loadString('assets/projects/$folder/project.md');
              } catch(_) {
                 contents['en'] = 'Content not available.';
              }
            }
          }
        }
        
        projects.add(Project.fromJson(item, contents));
      }
      
      return projects;
    } catch (e) {
      print('CRITICAL: Error loading projects index: $e');
      return [];
    }
  }
}
