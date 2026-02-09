class OnboardingProfile {
  // Can expand later based on onboarding questions if any.
  // Currently just a flag container or basic profile info.
  final bool completed;
  final DateTime? completedAt;

  OnboardingProfile({
    this.completed = false,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory OnboardingProfile.fromJson(Map<String, dynamic> json) {
    return OnboardingProfile(
      completed: json['completed'] ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }
}
