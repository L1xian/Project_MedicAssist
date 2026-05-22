import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/features/posts/domain/post.dart'; 
import 'package:blog_app/features/posts/domain/post_repository.dart'; 
import 'package:fpdart/fpdart.dart';

class UploadPost implements UseCase<Post, UploadPostParams> {
  final PostRepository blogRepository; 
  UploadPost(this.blogRepository);

  @override
  Future<Either<Failure, Post>> call(UploadPostParams params) async {
    return await blogRepository.uploadPost(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      posterName: params.posterName, // Added posterName
      topics: params.topics,
    );
  }
}

class UploadPostParams {
  final String posterId;
  final String posterName; // Added posterName
  final String title;
  final String content;
  final File? image;
  final List<String> topics;
  UploadPostParams({
    required this.posterId,
    required this.posterName, // Added posterName
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

class GetAllPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository postRepository; 
  GetAllPosts(this.postRepository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await postRepository.getAllPosts(); 
  }
}