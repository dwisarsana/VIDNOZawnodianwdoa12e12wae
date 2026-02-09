class AppPreferences {
  final bool hapticsEnabled;
  final bool autoSaveDrafts;
  final bool reducedMotion;

  const AppPreferences({
    this.hapticsEnabled = true,
    this.autoSaveDrafts = true,
    this.reducedMotion = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'hapticsEnabled': hapticsEnabled,
      'autoSaveDrafts': autoSaveDrafts,
      'reducedMotion': reducedMotion,
    };
  }

  factory AppPreferences.fromJson(Map<String, dynamic> json) {
    return AppPreferences(
      hapticsEnabled: json['hapticsEnabled'] ?? true,
      autoSaveDrafts: json['autoSaveDrafts'] ?? true,
      reducedMotion: json['reducedMotion'] ?? false,
    );
  }
}
