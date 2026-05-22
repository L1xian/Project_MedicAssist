import 'package:blog_app/features/posts/domain/post.dart';
import 'package:hive/hive.dart';

abstract interface class PostLocalDataSource {
  Future<void> uploadLocalPosts({required List<Post> posts}); // Changed to Future<void>
  List<Post> loadPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box box;
  PostLocalDataSourceImpl(this.box);

  @override
  List<Post> loadPosts() {
    List<Post> posts = [];
    // Iterate through all values in the box
    for (var data in box.values) {
      posts.add(Post.fromJson(Map<String, dynamic>.from(data)));
    }
    return posts;
  }

  @override
  Future<void> uploadLocalPosts({required List<Post> posts}) async { // Changed to async Future<void>
    await box.clear(); // Clear existing data
    for (int i = 0; i < posts.length; i++) {
      await box.put(i.toString(), posts[i].toJson()); // Use put with an index as key
    }
  }
}