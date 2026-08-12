import '../models/project.dart';
import 'project_loader.dart';

class ProjectRepository {
  static List<Project> _projects = [];

  static Future<void> init() async {
    _projects = await ProjectLoader.loadProjects();
  }

  static List<Project> getProjects() {
    return _projects;
  }

  static Project? getProjectById(String id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
