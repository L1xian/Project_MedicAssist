part of 'blog_bloc.dart'; // This will be changed to part of 'posts_bloc.dart' later

@immutable
sealed class PostsEvent {} // Renamed BlogEvent to PostsEvent

final class PostUpload extends PostsEvent { // Renamed BlogUpload to PostUpload
  final String posterId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;

  PostUpload({ // Renamed constructor from BlogUpload to PostUpload
    required this.posterId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

final class PostsFetchAllPosts extends PostsEvent {} // Renamed BlogFetchAllBlogs to PostsFetchAllPosts