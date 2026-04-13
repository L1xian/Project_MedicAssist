import 'dart:io';
import 'package:blog_app/core/constants/errors.dart';
import 'package:blog_app/features/blog/domain/post.dart';
import 'package:blog_app/features/blog/domain/post_usecases.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart'; // Renamed part file
part 'post_state.dart'; // Renamed part file

class PostBloc extends Bloc<PostEvent, PostState> { // Renamed BlogBloc to PostBloc
  final UploadPost _uploadPost;
  final GetAllPosts _getAllPosts;

  PostBloc({
    required UploadPost uploadPost,
    required GetAllPosts getAllPosts,
  })  : _uploadPost = uploadPost,
        _getAllPosts = getAllPosts,
        super(PostInitial()) { // Renamed BlogInitial to PostInitial
    on<PostEvent>((event, emit) => emit(PostLoading())); // Renamed BlogEvent to PostEvent, BlogLoading to PostLoading
    on<PostUpload>(_onPostUpload);
    on<PostsFetchAllPosts>(_onFetchAllPosts);
  }

  void _onPostUpload(
    PostUpload event,
    Emitter<PostState> emit, // Renamed BlogState to PostState
  ) async {
    final res = await _uploadPost(
      UploadPostParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(PostFailure(l.message)), // Renamed BlogFailure to PostFailure
      (r) => emit(PostUploadSuccess()), // Renamed BlogUploadSuccess to PostUploadSuccess
    );
  }

  void _onFetchAllPosts(
    PostsFetchAllPosts event,
    Emitter<PostState> emit, // Renamed BlogState to PostState
  ) async {
    final res = await _getAllPosts(NoParams());

    res.fold(
      (l) => emit(PostFailure(l.message)), // Renamed BlogFailure to PostFailure
      (r) => emit(PostsDisplaySuccess(r)), // Renamed BlogsDisplaySuccess to PostsDisplaySuccess
    );
  }
}