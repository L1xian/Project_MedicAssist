class ActivityModel {
  final double value;
  final DateTime date;
  final String type; // 'steps', 'heart_rate', 'calories', 'sleep'

  ActivityModel({
    required this.value,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  factory ActivityModel.fromJson(Map<String, dynamic> map) {
    return ActivityModel(
      value: (map['value'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      type: map['type'] as String,
    );
  }
}
