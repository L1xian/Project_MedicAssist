import 'dart:io';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/constants/connection_checker.dart';
import 'package:blog_app/features/posts/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:blog_app/features/posts/domain/post_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;
  final ConnectionChecker connectionChecker;

  PostRepositoryImpl(
    this.postRemoteDataSource,
    this.postLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, Post>> uploadPost({
    required File? image,
    required String title,
    required String content,
    required String posterId,
    required String posterName, // Added posterName
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      Post post = Post(
        id: const Uuid().v1(),
        posterId: posterId,
        posterName: posterName, // Added posterName
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      if (image != null) {
        final imageUrl = await postRemoteDataSource.uploadPostImage(
          image: image,
          post: post,
        );
        post = post.copyWith(imageUrl: imageUrl);
      }

      final uploadedPost = await postRemoteDataSource.uploadPost(post);
      return right(uploadedPost);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return right(await postLocalDataSource.loadPosts());
      }
      final posts = await postRemoteDataSource.getAllPosts();
      await postLocalDataSource.uploadLocalPosts(posts: posts);
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}