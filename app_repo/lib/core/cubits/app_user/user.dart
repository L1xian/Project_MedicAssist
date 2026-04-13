class User {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
