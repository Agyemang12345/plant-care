
enum CareType {
  water,
  fertilize,
  pruning,
  repotting,
  other,
}

class Care {
  final String id;
  final String plantId;
  final CareType type;
  final DateTime date;
  final String? notes;

  Care({
    required this.id,
    required this.plantId,
    required this.type,
    required this.date,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'type': type.toString(),
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  factory Care.fromMap(Map<String, dynamic> map) {
    return Care(
      id: map['id'] as String,
      plantId: map['plantId'] as String,
      type: CareType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => CareType.other,
      ),
      date: DateTime.parse(map['date'] as String),
      notes: map['notes'] as String?,
    );
  }
}
