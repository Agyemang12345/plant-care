class CommunityPost {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  final List<String> tags;
  final int likes;
  final int comments;
  final String authorExpertise;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.authorExpertise,
  });
}

class PlantReview {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String plantName;
  final double rating;
  final String review;
  final DateTime timestamp;
  final String? imageUrl;
  final String authorExpertise;

  PlantReview({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.plantName,
    required this.rating,
    required this.review,
    required this.timestamp,
    this.imageUrl,
    required this.authorExpertise,
  });
}
