import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/utils/local_db_service.dart';
import 'package:blog_app/features/posts/domain/post.dart'; // Changed import from blog.dart to post.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

abstract interface class PostRemoteDataSource { // Renamed BlogRemoteDataSource to PostRemoteDataSource
  Future<Post> uploadPost(Post post); // Renamed uploadBlog to uploadPost, Blog to Post
  Future<String> uploadPostImage({required File image, required Post post}); // Renamed uploadBlogImage to uploadPostImage, Blog to Post
  Future<List<Post>> getAllPosts(); // Renamed getAllBlogs to getAllPosts, List<Blog> to List<Post>
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource { // Renamed BlogRemoteDataSourceImpl to PostRemoteDataSourceImpl
  final SupabaseClient supabaseClient;
  final LocalDbService? localDb;

  PostRemoteDataSourceImpl(this.supabaseClient, {this.localDb}); // Renamed BlogRemoteDataSourceImpl to PostRemoteDataSourceImpl

  @override
  Future<Post> uploadPost(Post post) async { // Renamed uploadBlog to uploadPost, Blog to Post
    try {
      if (kDebugMode && localDb != null) {
        final res = await localDb!.query(
          'INSERT INTO blogs (id, poster_id, title, content, image_url, topics, updated_at) '
          'VALUES (@id, @poster_id, @title, @content, @image_url, @topics, @updated_at) RETURNING *',
          parameters: {
            'id': post.id,
            'poster_id': post.posterId,
            'title': post.title,
            'content': post.content,
            'image_url': post.imageUrl,
            'topics': post.topics,
            'updated_at': post.updatedAt.toIso8601String(),
          },
        );
        return Post.fromJson(res.first.toColumnMap()); // Renamed Blog.fromJson to Post.fromJson
      }

      final postData = await supabaseClient.from('blogs').insert(post.toJson()).select(); // Renamed blogData to postData
      return Post.fromJson(postData.first); // Renamed Blog.fromJson to Post.fromJson
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadPostImage({required File image, required Post post}) async { // Renamed uploadBlogImage to uploadPostImage, Blog to Post
    try {
      // Storage still uses Supabase (unless you want to handle local files)
      await supabaseClient.storage.from('blog_images').upload(post.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(post.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPosts() async { // Renamed getAllBlogs to getAllPosts, List<Blog> to List<Post>
    try {
      if (kDebugMode && localDb != null) {
        final res = await localDb!.query(
          'SELECT blogs.*, profiles.name as poster_name FROM blogs '
          'LEFT JOIN profiles ON blogs.poster_id = profiles.id'
        );
        return res.map((row) {
          final map = row.toColumnMap();
          return Post.fromJson(map).copyWith(posterName: map['poster_name']); // Renamed Post.fromJson to Post.fromJson
        }).toList();
      }

      final posts = await supabaseClient.from('blogs').select('*, profiles (name)'); // Renamed blogs to posts
      return posts // Renamed blogs to posts
          .map(
            (post) => Post.fromJson(post).copyWith( // Renamed blog to post, Blog.fromJson to Post.fromJson
              posterName: post['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}