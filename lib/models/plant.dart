import 'package:flutter/foundation.dart';
import 'care.dart';

class Plant {
  final String id;
  final String name;
  final String species;
  final String? imageUrl;
  final int wateringFrequency;
  final DateTime? lastWatered;
  final DateTime? lastFertilized;
  final int fertilizingFrequency;
  final List<Care> careHistory;
  final String? notes;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    this.imageUrl,
    required this.wateringFrequency,
    this.lastWatered,
    this.lastFertilized,
    required this.fertilizingFrequency,
    List<Care>? careHistory,
    this.notes,
  }) : careHistory = careHistory ?? [];

  Plant copyWith({
    String? id,
    String? name,
    String? species,
    String? imageUrl,
    int? wateringFrequency,
    DateTime? lastWatered,
    DateTime? lastFertilized,
    int? fertilizingFrequency,
    List<Care>? careHistory,
    String? notes,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      imageUrl: imageUrl ?? this.imageUrl,
      wateringFrequency: wateringFrequency ?? this.wateringFrequency,
      lastWatered: lastWatered ?? this.lastWatered,
      lastFertilized: lastFertilized ?? this.lastFertilized,
      fertilizingFrequency: fertilizingFrequency ?? this.fertilizingFrequency,
      careHistory: careHistory ?? this.careHistory,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'imageUrl': imageUrl,
      'wateringFrequency': wateringFrequency,
      'lastWatered': lastWatered?.toIso8601String(),
      'lastFertilized': lastFertilized?.toIso8601String(),
      'fertilizingFrequency': fertilizingFrequency,
      'careHistory': careHistory.map((care) => care.toMap()).toList(),
      'notes': notes,
    };
  }

  factory Plant.fromMap(Map<String, dynamic> map) {
    return Plant(
      id: map['id'] as String,
      name: map['name'] as String,
      species: map['species'] as String,
      imageUrl: map['imageUrl'] as String?,
      wateringFrequency: map['wateringFrequency'] as int,
      lastWatered: map['lastWatered'] != null
          ? DateTime.parse(map['lastWatered'] as String)
          : null,
      lastFertilized: map['lastFertilized'] != null
          ? DateTime.parse(map['lastFertilized'] as String)
          : null,
      fertilizingFrequency: map['fertilizingFrequency'] as int,
      careHistory: (map['careHistory'] as List?)
              ?.map((e) => Care.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: map['notes'] as String?,
    );
  }

  @override
  String toString() {
    return 'Plant(id: $id, name: $name, species: $species)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Plant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
