import 'dart:io';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/constants/connection_checker.dart';
import 'package:blog_app/features/posts/data/datasources/post_local_data_source.dart'; // Changed import
import 'package:blog_app/features/posts/data/datasources/post_remote_data_source.dart'; // Changed import
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:blog_app/features/posts/domain/post_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository { // Renamed BlogRepositoryImpl to PostRepositoryImpl
  final PostRemoteDataSource postRemoteDataSource; // Renamed blogRemoteDataSource to postRemoteDataSource
  final PostLocalDataSource postLocalDataSource; // Renamed blogLocalDataSource to postLocalDataSource
  final ConnectionChecker connectionChecker;

  PostRepositoryImpl( // Renamed BlogRepositoryImpl to PostRepositoryImpl
    this.postRemoteDataSource, // Renamed blogRemoteDataSource to postRemoteDataSource
    this.postLocalDataSource, // Renamed blogLocalDataSource to postLocalDataSource
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
        final imageUrl = await postRemoteDataSource.uploadPostImage( // Renamed blogRemoteDataSource to postRemoteDataSource
          image: image,
          post: post,
        );
        post = post.copyWith(imageUrl: imageUrl);
      }

      final uploadedPost = await postRemoteDataSource.uploadPost(post); // Renamed blogRemoteDataSource to postRemoteDataSource
      return right(uploadedPost);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return right(postLocalDataSource.loadPosts()); // Renamed blogLocalDataSource to postLocalDataSource
      }
      final posts = await postRemoteDataSource.getAllPosts(); // Renamed blogs to posts, blogRemoteDataSource to postRemoteDataSource
      postLocalDataSource.uploadLocalPosts(posts: posts); // Renamed blogLocalDataSource to postLocalDataSource, blogs to posts
      return right(posts); // Renamed blogs to posts
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}