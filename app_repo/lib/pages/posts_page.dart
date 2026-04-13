import 'package:blog_app/core/widgets/loader.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.menu_rounded, color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor),
                        onPressed: null,
                      ),
                      Container(
                        height: 24,
                        width: 1,
                        color: AppPallete.borderColor,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      Text(
                        'Blog App',
                        style: TextStyle(
                          color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocConsumer<BlogBloc, BlogState>(
                    listener: (context, state) {
                      if (state is BlogFailure) {
                        showSnackBar(context, state.message);
                      } else if (state is BlogUploadSuccess) {
                        context.read<BlogBloc>().add(BlogFetchAllBlogs());
                      }
                    },
                    builder: (context, state) {
                      if (state is BlogLoading) {
                        return const Loader();
                      }
                      if (state is BlogsDisplaySuccess) {
                        return ListView.builder(
                          itemCount: state.blogs.length,
                          itemBuilder: (context, index) {
                            final blog = state.blogs[index];
                            return BlogCard(
                              blog: blog,
                              color: index % 3 == 0
                                  ? const Color(0xFF18D29F)
                                  : index % 3 == 1
                                      ? const Color(0xFFFCC469)
                                      : const Color(0xFFE16259),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, AddNewBlogPage.route());
                },
                backgroundColor: AppPallete.primaryColor,
                shape: const CircleBorder(),
                child: Icon(
                  Icons.add,
                  color: AppPallete.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
