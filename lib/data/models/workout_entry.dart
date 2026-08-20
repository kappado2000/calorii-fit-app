import '../../domain/usecases/met_calorie_estimator.dart';

class WorkoutEntry {
  const WorkoutEntry({
    required this.id,
    required this.activityType,
    required this.duration,
    required this.caloriesBurned,
    this.healthSourceUuid,
  });

  final String id;
  final ActivityType activityType;
  final Duration duration;
  final double caloriesBurned;

  /// Non-null only for a workout imported from Apple Health / Health
  /// Connect — the health platform's own stable record id, so a repeat
  /// sync can tell "already imported" apart from a genuinely new session
  /// instead of duplicating it on every sync.
  final String? healthSourceUuid;

  Map<String, dynamic> toJson() => {
    'activityType': activityType.name,
    'durationMinutes': duration.inMinutes,
    'caloriesBurned': caloriesBurned,
    'healthSourceUuid': healthSourceUuid,
  };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutEntry(
      id: json['id'] as String,
      activityType: ActivityType.values.firstWhere(
        (type) => type.name == json['activityType'],
        orElse: () => ActivityType.other,
      ),
      duration: Duration(minutes: json['durationMinutes'] as int),
      caloriesBurned: (json['caloriesBurned'] as num).toDouble(),
      healthSourceUuid: json['healthSourceUuid'] as String?,
    );
  }
}
