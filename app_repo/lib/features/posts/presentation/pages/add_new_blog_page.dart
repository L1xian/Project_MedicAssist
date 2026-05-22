import 'dart:io';

import 'package:blog_app/core/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/widgets/loader.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/posts/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/posts/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/widgets/custom_app_bar.dart'; // Import CustomAppBar

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final topicsController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (formKey.currentState!.validate()) {
      final userState = context.read<AppUserCubit>().state;
      if (userState is! AppUserLoggedIn) {
        showSnackBar(context, 'You must be logged in to post');
        return;
      }
      
      final posterId = userState.user.id;
      
      final topics = topicsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (topics.isEmpty) {
        showSnackBar(context, 'Please enter at least one topic');
        return;
      }

      context.read<PostsBloc>().add(
            PostsUploadPost(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image,
              topics: topics,
            ),
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
    topicsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Blog',
        actions: [
          IconButton(
            onPressed: uploadBlog, // Corrected from PostUpload
            icon: const Icon(Icons.done_rounded),
          ),
        ],
        hideAssistantIcon: true, // Hide AI assistant icon on this page
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        listener: (context, state) {
          if (state is PostsFailure) {
            showSnackBar(context, state.message);
          } else if (state is PostsUploadSuccess) { // Corrected from PostUploadSuccess
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image (Optional)',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    BlogEditor(
                      controller: topicsController,
                      hintText: 'Topics (separated by commas)',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: 'Blog title',
                    ),
                    const SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}