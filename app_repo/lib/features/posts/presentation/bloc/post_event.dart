part of 'post_bloc.dart'; // Changed to part of 'post_bloc.dart'

@immutable
sealed class PostEvent {} // Renamed PostsEvent to PostEvent

final class PostUpload extends PostEvent { // Renamed PostUpload to PostUpload
  final String posterId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;

  PostUpload({
    required this.posterId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

final class PostsFetchAllPosts extends PostEvent {} // Renamed PostsFetchAllPosts to PostsFetchAllPosts