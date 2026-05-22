import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:blog_app/features/posts/domain/post_usecases.dart';
import 'package:blog_app/core/constants/errors.dart';
import 'dart:io';

// Events
abstract class PostsEvent {}

class PostsFetchAllPosts extends PostsEvent {}

class PostsToggleLike extends PostsEvent {
  final String postId;
  final bool isCurrentlyLiked;

  PostsToggleLike({required this.postId, required this.isCurrentlyLiked});
}

class PostsUploadPost extends PostsEvent {
  final String posterId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;

  PostsUploadPost({
    required this.posterId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

// States
abstract class PostsState {}

class PostsInitial extends PostsState {}
class PostsLoading extends PostsState {}
class PostsDisplaySuccess extends PostsState {
  final List<Post> posts;
  PostsDisplaySuccess(this.posts);
}
class PostsFailure extends PostsState {
  final String message;
  PostsFailure(this.message);
}
class PostsUploadSuccess extends PostsState {}


class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final UploadPost _uploadPost;
  final GetAllPosts _getAllPosts;

  PostsBloc({
    required UploadPost uploadPost,
    required GetAllPosts getAllPosts,
  })  : _uploadPost = uploadPost,
        _getAllPosts = getAllPosts,
        super(PostsInitial()) {
    on<PostsFetchAllPosts>((event, emit) async {
      final res = await _getAllPosts(NoParams());
      res.fold(
        (l) => emit(PostsFailure(l.message)),
        (r) => emit(PostsDisplaySuccess(r)),
      );
    });

    on<PostsToggleLike>((event, emit) {
      if (state is PostsDisplaySuccess) {
        final currentPosts = (state as PostsDisplaySuccess).posts;
        // In a real app, you'd update the backend here.
        // For now, we'll simulate the change in the UI.
        // This part would typically involve a repository call.
        // For this example, we're not modifying the actual list in the bloc,
        // as the mock data is re-injected on every fetch.
        // A proper implementation would update the specific post in the list.
      }
    });

    on<PostsUploadPost>((event, emit) async {
      emit(PostsLoading());
      // posterName is required by UploadPostParams and repository layer.
      // Derive it from backend-required profile fields is app-specific; for now,
      // we store a fallback name based on the user id.
      final posterNameFallback = event.posterId;

      final res = await _uploadPost(
        UploadPostParams(
          posterId: event.posterId,
          posterName: posterNameFallback,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics,
        ),
      );
      res.fold(
        (l) => emit(PostsFailure(l.message)),
        (r) => emit(PostsUploadSuccess()),
      );
    });
  }
}