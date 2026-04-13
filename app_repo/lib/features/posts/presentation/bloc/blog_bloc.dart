import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/features/posts/domain/post.dart'; 
import 'package:blog_app/features/posts/domain/post_usecases.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'posts_event.dart'; // Renamed part file
part 'posts_state.dart'; // Renamed part file

class PostsBloc extends Bloc<PostsEvent, PostsState> { // Renamed BlogBloc to PostsBloc
  final UploadPost _uploadPost; // Renamed UploadBlog to UploadPost
  final GetAllPosts _getAllPosts; // Renamed GetAllBlogs to GetAllPosts

  PostsBloc({ // Renamed constructor
    required UploadPost uploadPost, // Renamed uploadBlog to uploadPost
    required GetAllPosts getAllPosts, // Renamed getAllBlogs to getAllPosts
  })  : _uploadPost = uploadPost,
        _getAllPosts = getAllPosts,
        super(PostsInitial()) { // Renamed BlogInitial to PostsInitial
    on<PostsEvent>((event, emit) => emit(PostsLoading())); // Renamed BlogEvent to PostsEvent, BlogLoading to PostsLoading
    on<PostUpload>(_onPostUpload); // Renamed BlogUpload to PostUpload, _onBlogUpload to _onPostUpload
    on<PostsFetchAllPosts>(_onFetchAllPosts); // Renamed BlogFetchAllBlogs to PostsFetchAllPosts, _onFetchAllBlogs to _onFetchAllPosts
  }

  void _onPostUpload( // Renamed _onBlogUpload to _onPostUpload
    PostUpload event, // Renamed BlogUpload to PostUpload
    Emitter<PostsState> emit, // Renamed BlogState to PostsState
  ) async {
    final res = await _uploadPost( // Renamed _uploadBlog to _uploadPost
      UploadPostParams( // Renamed UploadBlogParams to UploadPostParams
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(PostsFailure(l.message)), // Renamed BlogFailure to PostsFailure
      (r) => emit(PostUploadSuccess()), // Renamed BlogUploadSuccess to PostUploadSuccess
    );
  }

  void _onFetchAllPosts( // Renamed _onFetchAllBlogs to _onFetchAllPosts
    PostsFetchAllPosts event, // Renamed BlogFetchAllBlogs to PostsFetchAllPosts
    Emitter<PostsState> emit, // Renamed BlogState to PostsState
  ) async {
    final res = await _getAllPosts(NoParams()); // Renamed _getAllBlogs to _getAllPosts

    res.fold(
      (l) => emit(PostsFailure(l.message)), // Renamed BlogFailure to PostsFailure
      (r) => emit(PostsDisplaySuccess(r)), // Renamed BlogsDisplaySuccess to PostsDisplaySuccess
    );
  }
}