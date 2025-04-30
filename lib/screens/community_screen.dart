import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../services/community_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

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
          // TODO: Implement post creation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Coming soon: Create a post')),
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
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: CommunityService.plantLovers.length,
      itemBuilder: (context, index) {
        final lover = CommunityService.plantLovers[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage(lover['avatar']!),
                  onBackgroundImageError: (e, s) =>
                      _buildAvatar(null, index, radius: 36),
                ),
                const SizedBox(height: 8),
                Text(
                  lover['name']!,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  lover['expertise']!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Follow', style: TextStyle(fontSize: 13)),
                  ),
                ),
              ],
            ),
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
