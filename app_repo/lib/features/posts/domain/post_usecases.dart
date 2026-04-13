import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/features/posts/domain/post.dart'; 
import 'package:blog_app/features/posts/domain/post_repository.dart'; 
import 'package:fpdart/fpdart.dart';

class UploadPost implements UseCase<Post, UploadPostParams> { // Renamed from UploadBlog to UploadPost
  final PostRepository blogRepository; 
  UploadPost(this.blogRepository);

  @override
  Future<Either<Failure, Post>> call(UploadPostParams params) async { // Renamed from UploadBlogParams to UploadPostParams
    return await blogRepository.uploadPost( // Renamed from uploadBlog to uploadPost
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadPostParams { // Renamed from UploadBlogParams to UploadPostParams
  final String posterId;
  final String title;
  final String content;
  final File? image;
  final List<String> topics;
  UploadPostParams({
    required this.posterId,
    required this.title,
    required this.content,
    this.image,
    required this.topics,
  });
}

class GetAllPosts implements UseCase<List<Post>, NoParams> { // Renamed from GetAllBlogs to GetAllPosts
  final PostRepository postRepository; 
  GetAllPosts(this.postRepository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await postRepository.getAllPosts(); 
  }
}