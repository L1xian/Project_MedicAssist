import 'package:blog_app/features/posts/domain/post.dart'; // Updated import path

class PostModel extends Post { // Renamed BlogModel to PostModel, and Blog to Post
  PostModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    required super.posterName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
      'poster_name': posterName,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel( // Renamed BlogModel to PostModel
      id: map['id'] ?? '',
      posterId: map['poster_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['image_url'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: DateTime.parse(map['updated_at']),
      posterName: map['poster_name'] ?? '',
    );
  }

  PostModel copyWith({ // Renamed BlogModel to PostModel
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return PostModel( // Renamed BlogModel to PostModel
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}
