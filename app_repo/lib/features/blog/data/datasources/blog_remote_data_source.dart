import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/core/utils/local_db_service.dart';
import 'package:blog_app/features/blog/domain/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

abstract interface class BlogRemoteDataSource {
  Future<Blog> uploadBlog(Blog blog);
  Future<String> uploadBlogImage({required File image, required Blog blog});
  Future<List<Blog>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  final LocalDbService? localDb;

  BlogRemoteDataSourceImpl(this.supabaseClient, {this.localDb});

  @override
  Future<Blog> uploadBlog(Blog blog) async {
    try {
      if (kDebugMode && localDb != null) {
        final res = await localDb!.query(
          'INSERT INTO blogs (id, poster_id, title, content, image_url, topics, updated_at) '
          'VALUES (@id, @poster_id, @title, @content, @image_url, @topics, @updated_at) RETURNING *',
          parameters: {
            'id': blog.id,
            'poster_id': blog.posterId,
            'title': blog.title,
            'content': blog.content,
            'image_url': blog.imageUrl,
            'topics': blog.topics,
            'updated_at': blog.updatedAt.toIso8601String(),
          },
        );
        return Blog.fromJson(res.first.toColumnMap());
      }

      final blogData = await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return Blog.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({required File image, required Blog blog}) async {
    try {
      // Storage still uses Supabase (unless you want to handle local files)
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Blog>> getAllBlogs() async {
    try {
      if (kDebugMode && localDb != null) {
        final res = await localDb!.query(
          'SELECT blogs.*, profiles.name as poster_name FROM blogs '
          'LEFT JOIN profiles ON blogs.poster_id = profiles.id'
        );
        return res.map((row) {
          final map = row.toColumnMap();
          return Blog.fromJson(map).copyWith(posterName: map['poster_name']);
        }).toList();
      }

      final blogs = await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogs
          .map(
            (blog) => Blog.fromJson(blog).copyWith(
              posterName: blog['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
