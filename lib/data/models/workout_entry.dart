import '../../domain/usecases/met_calorie_estimator.dart';

class WorkoutEntry {
  const WorkoutEntry({
    required this.id,
    required this.activityType,
    required this.duration,
    required this.caloriesBurned,
  });

  final String id;
  final ActivityType activityType;
  final Duration duration;
  final double caloriesBurned;

  Map<String, dynamic> toJson() => {
    'activityType': activityType.name,
    'durationMinutes': duration.inMinutes,
    'caloriesBurned': caloriesBurned,
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
    );
  }
}
