import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../services/community_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'plant_lover_profile.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CommunityService _communityService = CommunityService();
  final List<String> avatarStickers = [
    'assets/images/avatars/james.jpg',
    'assets/images/avatars/lisa.jpg',
    'assets/images/avatars/michael.jpg',
    'assets/images/avatars/sarah.jpg',
    'assets/images/avatars/david.jpg',
    'assets/images/avatars/emma.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Community'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Reviews'),
            Tab(text: 'Plant Lovers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsTab(),
          _buildReviewsTab(),
          _buildPlantLoversTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePostPage()),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPostsTab() {
    final posts = _communityService.getPosts();
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: _buildAvatar(post.authorAvatar, index),
                title: Text(post.authorName),
                subtitle: Text(post.authorExpertise),
                trailing: Text(
                  timeago.format(post.timestamp),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(post.content),
              ),
              if (post.imageUrl != null)
                Image.asset(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8,
                  children: post.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                          ))
                      .toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    label: Text('${post.likes}'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.comment_outlined),
                    label: Text('${post.comments}'),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_outlined),
                    label: const Text('Share'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    final reviews = _communityService.getReviews();
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: _buildAvatar(review.authorAvatar, index),
                title: Text(review.authorName),
                subtitle: Text(review.authorExpertise),
              ),
              if (review.imageUrl != null)
                Image.asset(
                  review.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.plantName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              review.rating.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(review.review),
                    const SizedBox(height: 8),
                    Text(
                      timeago.format(review.timestamp),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlantLoversTab() {
    final plantLovers = [
      {
        'name': 'James Green',
        'expertise': 'Indoor Plants Expert',
        'achievements': [
          'Grew a 10-foot Monstera Deliciosa',
          'Successfully propagated over 50 plants',
          'Won "Best Indoor Garden" Award 2023',
          'Created an indoor jungle with 100+ plants',
          'Featured in Home & Garden Magazine',
        ],
      },
      {
        'name': 'Sarah Chen',
        'expertise': 'Succulent Specialist',
        'achievements': [
          'Maintained a collection of 100+ rare succulents',
          'Published "The Ultimate Succulent Care Guide"',
          'Hosted 20+ succulent propagation workshops',
          'Created a drought-resistant garden design',
          'Won "Best Succulent Display" at Garden Show 2023',
        ],
      },
      {
        'name': 'Michael Rodriguez',
        'expertise': 'Garden Design Expert',
        'achievements': [
          'Designed 25+ community gardens',
          'Grew award-winning roses for 5 consecutive years',
          'Lead botanist at City Botanical Gardens',
          'Published "Modern Garden Design" book',
          'Featured on Garden & Home TV Show',
        ],
      },
      {
        'name': 'Emma Thompson',
        'expertise': 'Flower Expert',
        'achievements': [
          'Created butterfly gardens in 10 schools',
          'Won "Best Flower Arrangement" 3 years running',
          'Conducted 50+ flower care seminars',
          'Developed new hybrid rose variety',
          'Judge at National Flower Show',
        ],
      },
      {
        'name': 'David Lee',
        'expertise': 'Herb Master',
        'achievements': [
          'Cultivated 50+ varieties of rare herbs',
          'Published "Cooking with Home-Grown Herbs"',
          'Created healing herb garden program',
          'Supplied herbs to top restaurants',
          'Won "Best Herb Garden" award 2023',
        ],
      },
      {
        'name': 'Lisa Martinez',
        'expertise': 'Urban Farming Expert',
        'achievements': [
          'Created 15 urban farming projects',
          'Led 100+ gardening workshops',
          'Transformed 5 acres into community gardens',
          'Started "Green City" initiative',
          'Featured in "Urban Farming Today" magazine',
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plantLovers.length,
      itemBuilder: (context, index) {
        final lover = plantLovers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                (lover['name'] as String).substring(0, 1),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(lover['name'] as String),
            subtitle: Text(lover['expertise'] as String),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlantLoverProfile(
                    name: lover['name'] as String,
                    expertise: lover['expertise'] as String,
                    achievements:
                        List<String>.from(lover['achievements'] as List),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String? avatarPath, int index, {double radius = 24}) {
    final sticker = avatarStickers[index % avatarStickers.length];
    if (avatarPath == null || avatarPath.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: Image.asset(
            sticker,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
          ),
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: Image.asset(
          avatarPath,
          fit: BoxFit.cover,
          width: radius * 2,
          height: radius * 2,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            sticker,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
          ),
        ),
      ),
    );
  }
}

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement post creation logic
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
