part of 'blog_bloc.dart';

@immutable
sealed class PostsState {}

final class PostsInitial extends PostsState {}

final class PostsLoading extends PostsState {}

final class PostsFailure extends PostsState {
  final String message;
  PostsFailure(this.message);
}

final class PostUploadSuccess extends PostsState {}

final class PostsDisplaySuccess extends PostsState {
  final List<Post> posts;
  PostsDisplaySuccess(this.posts);
}