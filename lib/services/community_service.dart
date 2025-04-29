import '../models/community_post.dart';

class CommunityService {
  // Sample plant lovers with their expertise
  static final List<Map<String, String>> plantLovers = [
    {
      'name': 'Sarah Chen',
      'avatar': 'assets/images/avatars/sarah.jpg',
      'expertise': 'Succulent Specialist',
    },
    {
      'name': 'Michael Rodriguez',
      'avatar': 'assets/images/avatars/michael.jpg',
      'expertise': 'Tropical Plants Expert',
    },
    {
      'name': 'Emma Thompson',
      'avatar': 'assets/images/avatars/emma.jpg',
      'expertise': 'Herb Garden Enthusiast',
    },
    {
      'name': 'David Kim',
      'avatar': 'assets/images/avatars/david.jpg',
      'expertise': 'Indoor Plant Specialist',
    },
    {
      'name': 'Lisa Patel',
      'avatar': 'assets/images/avatars/lisa.jpg',
      'expertise': 'Orchid Cultivator',
    },
    {
      'name': 'James Wilson',
      'avatar': 'assets/images/avatars/james.jpg',
      'expertise': 'Urban Garden Designer',
    },
  ];

  // Sample community posts
  List<CommunityPost> getPosts() {
    return [
      CommunityPost(
        id: '1',
        authorName: 'Sarah Chen',
        authorAvatar: 'assets/images/avatars/sarah.jpg',
        content:
            'Just discovered a great way to propagate succulents! Here\'s my step-by-step guide: 1. Choose a healthy leaf 2. Let it callus for 2-3 days 3. Place on well-draining soil 4. Mist occasionally. Success rate has been amazing! 🌱',
        imageUrl: 'assets/images/posts/succulent_prop.jpg',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['Succulents', 'Propagation', 'Tips'],
        likes: 45,
        comments: 12,
        authorExpertise: 'Succulent Specialist',
      ),
      CommunityPost(
        id: '2',
        authorName: 'Michael Rodriguez',
        authorAvatar: 'assets/images/avatars/michael.jpg',
        content:
            'The PlantCare app\'s water calculator is a game-changer! My monstera has been thriving since I started following its watering schedule. Highly recommend checking it out! 💧',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        tags: ['App Review', 'Watering Tips'],
        likes: 38,
        comments: 8,
        authorExpertise: 'Tropical Plants Expert',
      ),
    ];
  }

  // Sample plant reviews
  List<PlantReview> getReviews() {
    return [
      PlantReview(
        id: '1',
        authorName: 'Emma Thompson',
        authorAvatar: 'assets/images/avatars/emma.jpg',
        plantName: 'Basil',
        rating: 4.5,
        review:
            'Growing basil has never been easier with the app\'s guidance. The reminders and care tips are spot-on!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: 'assets/images/reviews/basil.jpg',
        authorExpertise: 'Herb Garden Enthusiast',
      ),
      PlantReview(
        id: '2',
        authorName: 'David Kim',
        authorAvatar: 'assets/images/avatars/david.jpg',
        plantName: 'Snake Plant',
        rating: 5.0,
        review:
            'Perfect low-maintenance plant for beginners. The app helped me understand its light requirements perfectly.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'assets/images/reviews/snake_plant.jpg',
        authorExpertise: 'Indoor Plant Specialist',
      ),
      PlantReview(
        id: '3',
        authorName: 'Lisa Patel',
        authorAvatar: 'assets/images/avatars/lisa.jpg',
        plantName: 'Phalaenopsis Orchid',
        rating: 4.8,
        review:
            'The community tips for orchid care have been invaluable. My orchids are blooming beautifully!',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        imageUrl: 'assets/images/reviews/orchid.jpg',
        authorExpertise: 'Orchid Cultivator',
      ),
      PlantReview(
        id: '4',
        authorName: 'James Wilson',
        authorAvatar: 'assets/images/avatars/james.jpg',
        plantName: 'Vertical Herb Garden',
        rating: 4.7,
        review:
            'Created a beautiful vertical herb garden using the spacing and sunlight tips from the app. Amazing results!',
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        imageUrl: 'assets/images/reviews/herb_garden.jpg',
        authorExpertise: 'Urban Garden Designer',
      ),
    ];
  }
}
