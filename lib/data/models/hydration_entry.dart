/// A single "add water" tap — logged individually (like foodLogs) rather
/// than as one running total per day, so a mistaken tap can be undone
/// without resetting the whole day's total.
class HydrationEntry {
  const HydrationEntry({required this.id, required this.amountMl});

  final String id;
  final double amountMl;

  Map<String, dynamic> toJson() => {'amountMl': amountMl};

  factory HydrationEntry.fromJson(Map<String, dynamic> json) {
    return HydrationEntry(id: json['id'] as String, amountMl: (json['amountMl'] as num).toDouble());
  }
}
