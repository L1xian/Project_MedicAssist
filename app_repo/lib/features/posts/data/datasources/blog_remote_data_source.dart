import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/utils/local_db_service.dart';
import 'package:blog_app/features/posts/domain/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

abstract interface class PostRemoteDataSource {
  Future<Post> uploadPost(Post post);
  Future<String> uploadPostImage({required File image, required Post post});
  Future<List<Post>> getAllPosts();
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final SupabaseClient supabaseClient;
  final LocalDbService? localDb;

  PostRemoteDataSourceImpl(this.supabaseClient, {this.localDb});

  @override
  Future<Post> uploadPost(Post post) async {
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
        return Post.fromJson(res.first.toColumnMap());
      }

      final blogData = await supabaseClient.from('blogs').insert(post.toJson()).select();
      return Post.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadPostImage({required File image, required Post post}) async {
    try {
      // Storage still uses Supabase (unless you want to handle local files)
      await supabaseClient.storage.from('blog_images').upload(post.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(post.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      if (kDebugMode && localDb != null) {
        final res = await localDb!.query(
          'SELECT blogs.*, profiles.name as poster_name FROM blogs '
          'LEFT JOIN profiles ON blogs.poster_id = profiles.id'
        );
        return res.map((row) {
          final map = row.toColumnMap();
          return Post.fromJson(map).copyWith(posterName: map['poster_name']);
        }).toList();
      }

      final blogs = await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => Post.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
