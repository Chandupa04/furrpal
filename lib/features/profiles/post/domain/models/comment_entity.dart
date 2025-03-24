class CommentEntity {
  final String userId;
  final String name;
  final String content;
  final String? profilePicture;

  CommentEntity({
    required this.userId,
    required this.name,
    required this.content,
    this.profilePicture,
  });

  factory CommentEntity.fromJson(Map<String, dynamic> json) {
    return CommentEntity(
      userId: json['userId'],
      name: json['name'],
      content: json['content'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'content': content,
      'profilePicture': profilePicture,
    };
  }
}
