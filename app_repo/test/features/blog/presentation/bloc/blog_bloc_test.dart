import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/cubits/app_user/app_user_state.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'blog_bloc_test.mocks.dart';

@GenerateMocks([UploadBlog, GetAllBlogs, AppUserCubit])
void main() {
  late BlogBloc blogBloc;
  late MockUploadBlog mockUploadBlog;
  late MockGetAllBlogs mockGetAllBlogs;
  late MockAppUserCubit mockAppUserCubit;

  setUp(() {
    mockUploadBlog = MockUploadBlog();
    mockGetAllBlogs = MockGetAllBlogs();
    mockAppUserCubit = MockAppUserCubit();
    blogBloc = BlogBloc(
      uploadBlog: mockUploadBlog,
      getAllBlogs: mockGetAllBlogs,
    );
  });

  group('BlogUpload', () {
    final tPosterId = '123';
    final tTitle = 'Test Title';
    final tContent = 'Test Content';
    final tTopics = ['Tech', 'Flutter'];
    final tImage = File('path/to/image.png');

    final tBlog = Blog(
      id: '456',
      posterId: tPosterId,
      title: tTitle,
      content: tContent,
      imageUrl: 'test_image_url',
      topics: tTopics,
      updatedAt: DateTime.now(),
    );

    test('initial state is BlogInitial', () {
      expect(blogBloc.state, BlogInitial());
    });

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogUploadSuccess] when BlogUpload is successful with image',
      build: () {
        when(mockUploadBlog(any)).thenAnswer((_) async => right(tBlog));
        return blogBloc;
      },
      act: (bloc) => bloc.add(
        BlogUpload(
          posterId: tPosterId,
          title: tTitle,
          content: tContent,
          image: tImage,
          topics: tTopics,
        ),
      ),
      expect: () => [
        BlogLoading(),
        BlogUploadSuccess(),
      ],
      verify: (_) {
        verify(mockUploadBlog(
          UploadBlogParams(
            posterId: tPosterId,
            title: tTitle,
            content: tContent,
            image: tImage,
            topics: tTopics,
          ),
        )).called(1);
      },
    );

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogUploadSuccess] when BlogUpload is successful without image',
      build: () {
        when(mockUploadBlog(any)).thenAnswer((_) async => right(tBlog));
        return blogBloc;
      },
      act: (bloc) => bloc.add(
        BlogUpload(
          posterId: tPosterId,
          title: tTitle,
          content: tContent,
          image: null,
          topics: tTopics,
        ),
      ),
      expect: () => [
        BlogLoading(),
        BlogUploadSuccess(),
      ],
      verify: (_) {
        verify(mockUploadBlog(
          UploadBlogParams(
            posterId: tPosterId,
            title: tTitle,
            content: tContent,
            image: null,
            topics: tTopics,
          ),
        )).called(1);
      },
    );

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogFailure] when BlogUpload is unsuccessful',
      build: () {
        when(mockUploadBlog(any)).thenAnswer(
            (_) async => left(const Failure('Failed to upload blog')));
        return blogBloc;
      },
      act: (bloc) => bloc.add(
        BlogUpload(
          posterId: tPosterId,
          title: tTitle,
          content: tContent,
          image: tImage,
          topics: tTopics,
        ),
      ),
      expect: () => [
        BlogLoading(),
        const BlogFailure('Failed to upload blog'),
      ],
      verify: (_) {
        verify(mockUploadBlog(
          UploadBlogParams(
            posterId: tPosterId,
            title: tTitle,
            content: tContent,
            image: tImage,
            topics: tTopics,
          ),
        )).called(1);
      },
    );
  });

  group('BlogFetchAllBlogs', () {
    final tBlogList = <Blog>[
      Blog(
        id: '1',
        posterId: '123',
        title: 'Blog 1',
        content: 'Content 1',
        imageUrl: 'url1',
        topics: ['Tech'],
        updatedAt: DateTime.now(),
      ),
      Blog(
        id: '2',
        posterId: '456',
        title: 'Blog 2',
        content: 'Content 2',
        imageUrl: 'url2',
        topics: ['Health'],
        updatedAt: DateTime.now(),
      ),
    ];

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogsDisplaySuccess] when BlogFetchAllBlogs is successful',
      build: () {
        when(mockGetAllBlogs(any)).thenAnswer((_) async => right(tBlogList));
        return blogBloc;
      },
      act: (bloc) => bloc.add(BlogFetchAllBlogs()),
      expect: () => [
        BlogLoading(),
        BlogsDisplaySuccess(tBlogList),
      ],
      verify: (_) {
        verify(mockGetAllBlogs(any)).called(1);
      },
    );

    blocTest<BlogBloc, BlogState>(
      'emits [BlogLoading, BlogFailure] when BlogFetchAllBlogs is unsuccessful',
      build: () {
        when(mockGetAllBlogs(any)).thenAnswer(
            (_) async => left(const Failure('Failed to fetch blogs')));
        return blogBloc;
      },
      act: (bloc) => bloc.add(BlogFetchAllBlogs()),
      expect: () => [
        BlogLoading(),
        const BlogFailure('Failed to fetch blogs'),
      ],
      verify: (_) {
        verify(mockGetAllBlogs(any)).called(1);
      },
    );
  });
}
