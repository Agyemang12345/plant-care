class PlantInfo {
  final String commonName;
  final String scientificName;
  final String description;
  final String watering;
  final String sunlight;
  final String propagation;
  final double confidence;

  PlantInfo({
    required this.commonName,
    required this.scientificName,
    required this.description,
    required this.watering,
    required this.sunlight,
    required this.propagation,
    required this.confidence,
  });

  factory PlantInfo.fromJson(Map<String, dynamic> json) {
    final suggestions = json['suggestions'] as List?;
    if (suggestions == null || suggestions.isEmpty) {
      return PlantInfo(
        commonName: 'Unknown',
        scientificName: 'Unknown',
        description: 'No description available',
        watering: 'Information not available',
        sunlight: 'Information not available',
        propagation: 'Information not available',
        confidence: 0.0,
      );
    }
    final suggestion = suggestions[0];
    final plantDetails = suggestion['plant_details'] ?? {};

    return PlantInfo(
      commonName: (plantDetails['common_names'] as List?)?.first ?? 'Unknown',
      scientificName: plantDetails['scientific_name'] ?? 'Unknown',
      description: plantDetails['wiki_description']?['value'] ??
          'No description available',
      watering: plantDetails['watering']?['description'] ??
          'Information not available',
      sunlight: (plantDetails['sunlight'] as List?)?.join(', ') ??
          'Information not available',
      propagation: (plantDetails['propagation'] as List?)?.join(', ') ??
          'Information not available',
      confidence: suggestion['probability'] ?? 0.0,
    );
  }
}
