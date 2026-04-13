import 'package:blog_app/features/posts/domain/post.dart';
import 'package:hive/hive.dart';

abstract interface class PostLocalDataSource {
  void uploadLocalPosts({required List<Post> posts});
  List<Post> loadPosts();
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final Box box;
  PostLocalDataSourceImpl(this.box);

  @override
  List<Post> loadPosts() {
    List<Post> posts = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final data = box.get(i.toString());
        if (data != null) {
          posts.add(Post.fromJson(Map<String, dynamic>.from(data)));
        }
      }
    });
    return posts;
  }

  @override
  void uploadLocalPosts({required List<Post> posts}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < posts.length; i++) {
        box.put(i.toString(), posts[i].toJson());
      }
    });
  }
}
