import 'package:blog_app/features/blog/domain/blog.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<Blog> blogs});
  List<Blog> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;
  BlogLocalDataSourceImpl(this.box);

  @override
  List<Blog> loadBlogs() {
    List<Blog> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        final data = box.get(i.toString());
        if (data != null) {
          blogs.add(Blog.fromJson(Map<String, dynamic>.from(data)));
        }
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<Blog> blogs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
