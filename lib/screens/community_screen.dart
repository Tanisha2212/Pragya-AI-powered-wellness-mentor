// screens/community_screen.dart
import 'package:flutter/material.dart';
import 'package:sanskrit_daily_subhasita/models/subhashita_model.dart';
import 'package:sanskrit_daily_subhasita/screens/subhashita_service.dart';


class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CommunityPost> communityPosts = [];
  List<Subhashita> popularShlokas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCommunityData();
  }

  Future<void> _loadCommunityData() async {
    await SubhashitaService.loadSubhashitas();
    
    // Mock community posts
    communityPosts = [
      CommunityPost(
        username: 'WisdomSeeker',
        userAvatar: Icons.person,
        timeAgo: '2h ago',
        subhashita: SubhashitaService.getRandomSubhashita(),
        reflection: 'This verse helped me find peace during a difficult time.',
        likes: 24,
        comments: 8,
      ),
      CommunityPost(
        username: 'SanskritLover',
        userAvatar: Icons.person_2,
        timeAgo: '5h ago',
        subhashita: SubhashitaService.getRandomSubhashita(),
        reflection: 'Perfect morning motivation! Starting my day with this wisdom.',
        likes: 18,
        comments: 5,
      ),
    ];

    popularShlokas = SubhashitaService.getAllSubhashitas().take(10).toList();
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange[700],
          labelColor: Colors.orange[700],
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Feed', icon: Icon(Icons.home, size: 20)),
            Tab(text: 'Popular', icon: Icon(Icons.trending_up, size: 20)),
            Tab(text: 'Share', icon: Icon(Icons.add_circle, size: 20)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFE0B2)],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildFeedTab(),
                  _buildPopularTab(),
                  _buildShareTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildFeedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: communityPosts.length,
      itemBuilder: (context, index) => _buildPostCard(communityPosts[index]),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Icon(post.userAvatar),
                backgroundColor: Colors.orange[100],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(post.timeAgo, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Column(
              children: [
                Text(
                  post.subhashita.sanskrit,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6A4C93),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  post.subhashita.english,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(post.reflection),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton(Icons.favorite_border, '${post.likes}', Colors.red),
              const SizedBox(width: 16),
              _buildActionButton(Icons.comment_outlined, '${post.comments}', Colors.blue),
              const Spacer(),
              _buildActionButton(Icons.share_outlined, 'Share', Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPopularTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: popularShlokas.length,
      itemBuilder: (context, index) {
        final shloka = popularShlokas[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange[100],
              child: Text('${index + 1}', style: TextStyle(color: Colors.orange[700])),
            ),
            title: Text(shloka.english, maxLines: 2, overflow: TextOverflow.ellipsis),
            subtitle: Text(shloka.category.toUpperCase()),
            trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            onTap: () => _showShlokaDetail(shloka),
          ),
        );
      },
    );
  }

  Widget _buildShareTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Share Your Favorite Shloka',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Image'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share your reflection or experience...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post shared successfully!')),
              );
            },
            child: const Text('Share with Community'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  void _showShlokaDetail(Subhashita shloka) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(shloka.sanskrit, style: const TextStyle(fontSize: 18, color: Color(0xFF6A4C93))),
            const SizedBox(height: 16),
            Text(shloka.english, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text(shloka.meaning, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class CommunityPost {
  final String username;
  final IconData userAvatar;
  final String timeAgo;
  final Subhashita subhashita;
  final String reflection;
  final int likes;
  final int comments;

  CommunityPost({
    required this.username,
    required this.userAvatar,
    required this.timeAgo,
    required this.subhashita,
    required this.reflection,
    required this.likes,
    required this.comments,
  });
}