import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PostRepository {
  Future<Either<Failure, Post>> uploadPost({
    required File? image,
    required String title,
    required String content,
    required String posterId,
    required String posterName, // Added posterName
    required List<String> topics,
  });

  Future<Either<Failure, List<Post>>> getAllPosts();
}