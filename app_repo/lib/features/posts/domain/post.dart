class Post {
  final String id;
  final String posterId;
  final String posterName;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.posterId,
    required this.posterName,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'poster_name': posterName,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      posterId: map['poster_id'] ?? '',
      posterName: map['poster_name'] ?? 'Unknown User',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['image_url'] ?? '',
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : DateTime.now(),
    );
  }

  Post copyWith({
    String? id,
    String? posterId,
    String? posterName,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      posterName: posterName ?? this.posterName,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}