import 'package:flutter/foundation.dart';
import 'care.dart';

class CareHistory {
  final String id;
  final String plantId;
  final CareType type;
  final DateTime timestamp;
  final String? notes;

  CareHistory({
    required this.id,
    required this.plantId,
    required this.type,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plantId': plantId,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory CareHistory.fromMap(Map<String, dynamic> map) {
    return CareHistory(
      id: map['id'] as String,
      plantId: map['plantId'] as String,
      type: CareType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => CareType.other,
      ),
      timestamp: DateTime.parse(map['timestamp'] as String),
      notes: map['notes'] as String?,
    );
  }
}
