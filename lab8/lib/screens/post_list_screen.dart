import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key, this.apiService});

  final ApiService? apiService;

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late final ApiService _apiService;
  late Future<List<Post>> _postsFuture;
  final List<Post> _createdPosts = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? ApiService();
    // Cache the Future so rebuilding the UI does not repeat the request.
    _postsFuture = _apiService.fetchPosts();
  }

  @override
  void dispose() {
    if (widget.apiService == null) _apiService.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final future = _apiService.fetchPosts();
    setState(() {
      _createdPosts.clear();
      _postsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // FutureBuilder displays the error; finish the refresh animation.
    }
  }

  Future<void> _createPost() async {
    final post = await Navigator.push<Post>(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(apiService: _apiService),
      ),
    );
    if (!mounted || post == null) return;

    setState(() => _createdPosts.insert(0, post));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Post #${post.id} created for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lab 8.3 + 8.4: render loading, error and data from the service Future.
    return FutureBuilder<List<Post>>(
      future: _postsFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState != ConnectionState.done;

        return Scaffold(
          appBar: AppBar(
            title: const Text('LAB8 - API Posts'),
            actions: [
              IconButton(
                tooltip: 'Reload posts',
                onPressed: isLoading ? null : _reload,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(child: _buildBody(snapshot, isLoading)),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: isLoading || snapshot.hasError ? null : _createPost,
            icon: const Icon(Icons.add),
            label: const Text('New post'),
          ),
        );
      },
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Post>> snapshot, bool isLoading) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(semanticsLabel: 'Loading posts'),
            SizedBox(height: 20),
            Text('Loading posts...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Please wait while we fetch the latest posts.'),
          ],
        ),
      );
    }

    if (snapshot.hasError) {
      final error = snapshot.error;
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error is ApiException
                    ? error.message
                    : 'Could not load posts. Please try again.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final posts = [..._createdPosts, ...?snapshot.data];
    return RefreshIndicator(
      onRefresh: _reload,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest posts',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('${posts.length} posts - JSONPlaceholder'),
                const SizedBox(height: 4),
                const Text('Pull down to refresh. Tap a post to read more.'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              itemCount: posts.isEmpty ? 1 : posts.length,
              itemBuilder: (context, index) {
                if (posts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No posts yet. Pull down to try again.'),
                  );
                }
                return _buildPostCard(posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(child: Text('${post.id}')),
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            'User ${post.userId}\n${post.body.replaceAll('\n', ' ')}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
      ),
    );
  }
}
