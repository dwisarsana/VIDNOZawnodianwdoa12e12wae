import '../enums/project_status.dart';
import '../enums/generation_quality.dart';

class ProjectItem {
  final String id;
  final String title;
  final String thumbnailPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String styleId;
  final String styleName;
  final int durationSeconds;
  final GenerationQuality quality;
  final int tokenCostEstimated;
  final int tokenCostCharged;
  final ProjectStatus status;
  final bool favorite;
  final String? mockVideoUrlOrPath;
  final Map<String, dynamic>? settingsSnapshotJson;

  ProjectItem({
    required this.id,
    required this.title,
    required this.thumbnailPath,
    required this.createdAt,
    required this.updatedAt,
    required this.styleId,
    required this.styleName,
    required this.durationSeconds,
    this.quality = GenerationQuality.standard,
    required this.tokenCostEstimated,
    required this.tokenCostCharged,
    required this.status,
    this.favorite = false,
    this.mockVideoUrlOrPath,
    this.settingsSnapshotJson,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'thumbnailPath': thumbnailPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'styleId': styleId,
      'styleName': styleName,
      'durationSeconds': durationSeconds,
      'quality': quality.index,
      'tokenCostEstimated': tokenCostEstimated,
      'tokenCostCharged': tokenCostCharged,
      'status': status.index,
      'favorite': favorite,
      'mockVideoUrlOrPath': mockVideoUrlOrPath,
      'settingsSnapshotJson': settingsSnapshotJson,
    };
  }

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'],
      title: json['title'],
      thumbnailPath: json['thumbnailPath'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      styleId: json['styleId'],
      styleName: json['styleName'],
      durationSeconds: json['durationSeconds'],
      quality: GenerationQuality.values[json['quality'] ?? 0],
      tokenCostEstimated: json['tokenCostEstimated'],
      tokenCostCharged: json['tokenCostCharged'],
      status: ProjectStatus.values[json['status'] ?? 0],
      favorite: json['favorite'] ?? false,
      mockVideoUrlOrPath: json['mockVideoUrlOrPath'],
      settingsSnapshotJson: json['settingsSnapshotJson'],
    );
  }

  ProjectItem copyWith({
    String? title,
    String? thumbnailPath,
    DateTime? updatedAt,
    ProjectStatus? status,
    bool? favorite,
    String? mockVideoUrlOrPath,
  }) {
    return ProjectItem(
      id: this.id,
      title: title ?? this.title,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      styleId: this.styleId,
      styleName: this.styleName,
      durationSeconds: this.durationSeconds,
      quality: this.quality,
      tokenCostEstimated: this.tokenCostEstimated,
      tokenCostCharged: this.tokenCostCharged,
      status: status ?? this.status,
      favorite: favorite ?? this.favorite,
      mockVideoUrlOrPath: mockVideoUrlOrPath ?? this.mockVideoUrlOrPath,
      settingsSnapshotJson: this.settingsSnapshotJson,
    );
  }
}
