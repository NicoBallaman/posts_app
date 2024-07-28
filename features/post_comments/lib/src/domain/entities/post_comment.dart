class PostComment {
  final int id;
  final int postId;
  final String name;
  final String email;
  final String body;

  PostComment({
    required this.id,
    required this.postId,
    required this.name,
    required this.email,
    required this.body,
  });
}
