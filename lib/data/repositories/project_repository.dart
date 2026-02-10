import '../local/shared_prefs_service.dart';
import '../../domain/models/project_item.dart';

class ProjectRepository {
  final SharedPrefsService _prefs;

  ProjectRepository(this._prefs);

  Future<void> saveProject(ProjectItem project) async {
    final projects = _prefs.getProjectsHistory();
    // Check if exists, update or add
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = project;
    } else {
      projects.insert(0, project); // Add to top
    }
    await _prefs.saveProjectsHistory(projects);
  }

  Future<List<ProjectItem>> getProjects() async {
    return _prefs.getProjectsHistory();
  }

  Future<ProjectItem?> getProjectById(String id) async {
    final projects = _prefs.getProjectsHistory();
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteProject(String id) async {
    final projects = _prefs.getProjectsHistory();
    projects.removeWhere((p) => p.id == id);
    await _prefs.saveProjectsHistory(projects);
  }
}
