import 'dart:io';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/constants/connection_checker.dart';
import 'package:blog_app/features/posts/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/posts/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:blog_app/features/posts/domain/post_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource blogRemoteDataSource;
  final PostLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  PostRepositoryImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Post>> uploadPost({
    required File? image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      Post post = Post(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      if (image != null) {
        final imageUrl = await blogRemoteDataSource.uploadPostImage(
          image: image,
          post: post,
        );
        post = post.copyWith(imageUrl: imageUrl);
      }

      final uploadedPost = await blogRemoteDataSource.uploadPost(post);
      return right(uploadedPost);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return right(blogLocalDataSource.loadPosts());
      }
      final blogs = await blogRemoteDataSource.getAllPosts();
      blogLocalDataSource.uploadLocalPosts(posts: blogs);
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
