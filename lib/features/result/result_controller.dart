import 'package:flutter/material.dart';
import '../../data/repositories/project_repository.dart';
import '../../domain/models/project_item.dart';

class ResultController extends ChangeNotifier {
  final ProjectRepository _projectRepo;
  ProjectItem? _project;
  bool _isLoading = true;

  ResultController(this._projectRepo);

  ProjectItem? get project => _project;
  bool get isLoading => _isLoading;

  Future<void> loadProject(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _project = await _projectRepo.getProjectById(id);
    } catch (_) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveVideo() async {
    // Mock save
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> shareVideo() async {
    // Mock share
    await Future.delayed(const Duration(seconds: 1));
  }
}
