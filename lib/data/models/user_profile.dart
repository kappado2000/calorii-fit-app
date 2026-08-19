enum Sex { male, female }

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

extension ActivityLevelLabel on ActivityLevel {
  String get label {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentar (muncă de birou, fără sport)';
      case ActivityLevel.light:
        return 'Activitate ușoară (sport 1-3 zile/săpt.)';
      case ActivityLevel.moderate:
        return 'Activitate moderată (sport 3-5 zile/săpt.)';
      case ActivityLevel.active:
        return 'Activ (sport 6-7 zile/săpt.)';
      case ActivityLevel.veryActive:
        return 'Foarte activ (sport intens zilnic / muncă fizică)';
    }
  }

  /// Standard Mifflin-St Jeor activity multipliers.
  double get factor {
    switch (this) {
      case ActivityLevel.sedentary:
        return 1.2;
      case ActivityLevel.light:
        return 1.375;
      case ActivityLevel.moderate:
        return 1.55;
      case ActivityLevel.active:
        return 1.725;
      case ActivityLevel.veryActive:
        return 1.9;
    }
  }
}

enum Goal { lose, maintain, gain }

extension GoalLabel on Goal {
  String get label {
    switch (this) {
      case Goal.lose:
        return 'Slăbit';
      case Goal.maintain:
        return 'Menținere';
      case Goal.gain:
        return 'Masă musculară';
    }
  }
}

class UserProfile {
  const UserProfile({
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.sex,
    required this.activityLevel,
    required this.goal,
    required this.targetRateKgPerWeek,
    required this.programStartDate,
    this.disclaimerAcceptedAt,
    this.useAdaptiveTdee = false,
  });

  final double heightCm;
  final double weightKg;
  final int age;
  final Sex sex;
  final ActivityLevel activityLevel;
  final Goal goal;

  /// Positive number of kg/week — direction is implied by [goal].
  final double targetRateKgPerWeek;

  /// Set once, the first time the profile is created — the anchor date
  /// for "since the weight-loss program started" charts.
  final DateTime programStartDate;

  /// When the user acknowledged the "this isn't medical advice" disclaimer
  /// shown once during first-time onboarding — null for profiles created
  /// before that step existed. Kept as a timestamp (not a bool) so there's
  /// a real record of when consent was given, not just that it was.
  final DateTime? disclaimerAcceptedAt;

  /// Opt-in: when true and enough weight/log history exists, the daily
  /// calorie target is derived from the user's actual logged energy
  /// balance (see AdaptiveTdeeCalculator) instead of the static
  /// Mifflin-St Jeor formula alone. Defaults false — a brand-new profile
  /// has no history to adapt from anyway, and switching the target's
  /// basis should be a deliberate choice, not a silent default.
  final bool useAdaptiveTdee;

  UserProfile copyWithUseAdaptiveTdee(bool value) => UserProfile(
    heightCm: heightCm,
    weightKg: weightKg,
    age: age,
    sex: sex,
    activityLevel: activityLevel,
    goal: goal,
    targetRateKgPerWeek: targetRateKgPerWeek,
    programStartDate: programStartDate,
    disclaimerAcceptedAt: disclaimerAcceptedAt,
    useAdaptiveTdee: value,
  );

  /// Not persisted — used to feed a more recent logged weight into a TDEE
  /// calculation without mutating the stored profile (see tdeeResultProvider).
  UserProfile copyWithWeightKg(double value) => UserProfile(
    heightCm: heightCm,
    weightKg: value,
    age: age,
    sex: sex,
    activityLevel: activityLevel,
    goal: goal,
    targetRateKgPerWeek: targetRateKgPerWeek,
    programStartDate: programStartDate,
    disclaimerAcceptedAt: disclaimerAcceptedAt,
    useAdaptiveTdee: useAdaptiveTdee,
  );

  Map<String, dynamic> toJson() => {
    'heightCm': heightCm,
    'weightKg': weightKg,
    'age': age,
    'sex': sex.name,
    'activityLevel': activityLevel.name,
    'goal': goal.name,
    'targetRateKgPerWeek': targetRateKgPerWeek,
    'programStartDate': programStartDate.toIso8601String(),
    'disclaimerAcceptedAt': disclaimerAcceptedAt?.toIso8601String(),
    'useAdaptiveTdee': useAdaptiveTdee,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      age: json['age'] as int,
      sex: Sex.values.firstWhere((s) => s.name == json['sex'], orElse: () => Sex.female),
      activityLevel: ActivityLevel.values.firstWhere(
        (a) => a.name == json['activityLevel'],
        orElse: () => ActivityLevel.sedentary,
      ),
      goal: Goal.values.firstWhere((g) => g.name == json['goal'], orElse: () => Goal.maintain),
      targetRateKgPerWeek: (json['targetRateKgPerWeek'] as num).toDouble(),
      programStartDate: DateTime.parse(json['programStartDate'] as String),
      disclaimerAcceptedAt: json['disclaimerAcceptedAt'] != null
          ? DateTime.parse(json['disclaimerAcceptedAt'] as String)
          : null,
      useAdaptiveTdee: json['useAdaptiveTdee'] as bool? ?? false,
    );
  }
}
