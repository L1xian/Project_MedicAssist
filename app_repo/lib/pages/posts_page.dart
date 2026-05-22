import 'package:blog_app/core/widgets/loader.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/posts/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/posts/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/posts/presentation/widgets/x_post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/core/widgets/custom_app_bar.dart';
import 'package:blog_app/features/posts/domain/post.dart';

class PostsPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const PostsPage(),
      );

  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String? _selectedCategory;
  final List<String> _categories = ['For you', 'Trending Health', 'Diet', 'Medicines'];
  List<Post> _displayPosts = [];
  List<Post> _allFetchedPosts = [];
  String _authorFilter = 'Anyone'; // Default to 'Anyone'
  String _locationFilter = 'Anywhere'; // Default to 'Anywhere'
  bool _showBookmarksOnly = false;

  // Animation for FAB
  late AnimationController _fabAnimationController;
  late Animation<double> _fabRotationAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _selectedCategory = _categories[_tabController.index];
    context.read<PostsBloc>().add(PostsFetchAllPosts());
    _searchController.addListener(_applyFilters);

    // Initialize FAB animation
    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabRotationAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeOut,
      ),
    );
    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyFilters);
    _searchController.dispose();
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _displayPosts = _allFetchedPosts.where((post) {
        final query = _searchController.text.toLowerCase();
        final matchesSearch = query.isEmpty ||
            post.title.toLowerCase().contains(query) ||
            post.content.toLowerCase().contains(query) ||
            post.topics.any((t) => t.toLowerCase().contains(query));

        final matchesCategory = _selectedCategory == 'For you' ||
            _selectedCategory == null ||
            post.topics.any((t) => t.toLowerCase() == _selectedCategory!.toLowerCase());

        // Apply Author Filter
        bool matchesAuthorFilter = true;
        if (_authorFilter == 'Followed') {
          // Mock: Assume posts by 'Dr. Alice Smith' are from followed users
          matchesAuthorFilter = post.posterName == 'Dr. Alice Smith';
        }

        // Apply Location Filter
        bool matchesLocationFilter = true;
        if (_locationFilter == 'Nearby') {
          // Mock: Assume posts with 'Local' topic are nearby
          matchesLocationFilter = post.topics.any((t) => t.toLowerCase() == 'local');
        }

        // Apply Bookmark Filter (Mock logic: assume even hashcodes are bookmarked)
        bool matchesBookmarkFilter = !_showBookmarksOnly || post.id.hashCode % 2 == 0;

        return matchesSearch && matchesCategory && matchesAuthorFilter && 
               matchesLocationFilter && matchesBookmarkFilter;
      }).toList();
    });
  }

  void _injectMockPostsAndFilter() {
    if (_allFetchedPosts.isEmpty) {
      _allFetchedPosts = [
        Post(
          id: '1',
          posterId: 'user1',
          posterName: 'Dr. Alice Smith',
          title: 'Healthy Eating Habits',
          content: 'Maintaining a balanced diet is essential for long-term health. Focus on whole foods, lean proteins, and plenty of greens.',
          imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=1000&auto=format&fit=crop',
          topics: ['Diet', 'Trending Health'],
          updatedAt: DateTime.now(),
        ),
        Post(
          id: '2',
          posterId: 'user2',
          posterName: 'Fitness Pro',
          title: 'Daily Exercise Routine',
          content: 'Just 30 minutes of moderate activity each day can significantly improve your cardiovascular health and mood. Consistency is key!',
          imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=1000&auto=format&fit=crop',
          topics: ['For you', 'Trending Health'],
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Post(
          id: '3',
          posterId: 'user3',
          posterName: 'Local Health Clinic',
          title: 'Community Health Awareness',
          content: 'Join us this weekend for a free health screening event at the community center. Everyone is welcome to join and learn about local resources.',
          imageUrl: '',
          topics: ['Medicines', 'local'],
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Post(
          id: '4',
          posterId: 'user4',
          posterName: 'Nutritionist Mike',
          title: 'Superfoods for Immunity',
          content: 'Berries, nuts, and citrus fruits are packed with antioxidants that help boost your immune system naturally.',
          imageUrl: 'https://images.unsplash.com/photo-1494390248081-4e521a5940db?q=80&w=1000&auto=format&fit=crop',
          topics: ['Diet', 'For you'],
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];
    }
    _applyFilters();
  }

  void _toggleFab() {
    if (_fabAnimationController.isDismissed) {
      _fabAnimationController.forward();
    } else {
      _fabAnimationController.reverse();
    }
  }

  // Removed _showBookingDialog as it was part of the changes to be undone.
  // Removed _buildRadio as it was part of the changes to be undone.
  // Removed _showSettingsMenu as it was part of the changes to be undone.
  // Removed _sectionHeader as it was part of the changes to be undone.

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Posts',
        actions: [
          // Reverted to original state, removing settings icon
          // IconButton(
          //   onPressed: () => _showSettingsMenu(context),
          //   icon: Icon(Icons.settings_outlined, color: textColor),
          // ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search posts...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _applyFilters();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? AppPallete.surfaceColor : Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    ),
                    style: TextStyle(color: textColor),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 32,
                  width: 1,
                  color: AppPallete.borderColor.withOpacity(0.5),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showBookmarksOnly = !_showBookmarksOnly;
                      _applyFilters();
                    });
                  },
                  icon: Icon(
                    _showBookmarksOnly ? Icons.bookmark : Icons.bookmark_border,
                    color: _showBookmarksOnly ? AppPallete.primaryColor : textColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppPallete.borderColor.withOpacity(0.5), width: 0.5),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppPallete.primaryColor,
              unselectedLabelColor: textColor.withOpacity(0.7),
              indicatorColor: AppPallete.primaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              tabAlignment: TabAlignment.start, // Added to align tabs to the left
              tabs: _categories.map((category) => Tab(text: category)).toList(),
            ),
          ),
          Expanded(
            child: BlocConsumer<PostsBloc, PostsState>(
              listener: (context, state) {
                if (state is PostsFailure) {
                  showSnackBar(context, state.message);
                  _allFetchedPosts = []; // Clear to ensure mocks are injected
                  _injectMockPostsAndFilter();
                } else if (state is PostsDisplaySuccess) {
                  _allFetchedPosts = state.posts;
                  _injectMockPostsAndFilter();
                }
              },
              builder: (context, state) {
                if (state is PostsLoading) {
                  return const Loader();
                }
                return _displayPosts.isEmpty
                    ? Center(
                        child: Text(
                          'No posts found.',
                          style: TextStyle(color: textColor.withOpacity(0.7)),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _displayPosts.length,
                        separatorBuilder: (context, index) => Divider(
                          color: AppPallete.borderColor.withOpacity(0.3),
                          height: 1,
                          thickness: 0.5,
                          indent: 0,
                          endIndent: 0,
                        ),
                        itemBuilder: (context, index) {
                          final post = _displayPosts[index];
                          return XPostCard(
                            blog: post,
                            // Removed onBookAppointment as it was part of the changes to be undone.
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ScaleTransition(
            scale: _fabScaleAnimation,
            child: FadeTransition(
              opacity: _fabScaleAnimation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _toggleFab();
                    Navigator.push(context, AddNewBlogPage.route());
                  },
                  backgroundColor: AppPallete.primaryColor,
                  label: Text(
                    'New Post',
                    style: TextStyle(color: AppPallete.whiteColor, fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(Icons.edit_note_rounded, color: AppPallete.whiteColor),
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: _toggleFab,
            backgroundColor: AppPallete.primaryColor,
            shape: const CircleBorder(),
            child: RotationTransition(
              turns: _fabRotationAnimation,
              child: Icon(
                Icons.add,
                color: AppPallete.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}