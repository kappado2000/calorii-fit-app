enum WeightSource { manual, healthConnect, appleHealth, bluetoothScale }

class WeightEntry {
  const WeightEntry({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.source,
  });

  final String id;
  final DateTime date;
  final double weightKg;
  final WeightSource source;

  Map<String, dynamic> toJson() => {'weightKg': weightKg, 'source': source.name};

  factory WeightEntry.fromJson(Map<String, dynamic> json, {required DateTime date}) {
    return WeightEntry(
      id: json['id'] as String,
      date: date,
      weightKg: (json['weightKg'] as num).toDouble(),
      source: WeightSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => WeightSource.manual,
      ),
    );
  }
}
