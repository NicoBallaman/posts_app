import 'package:post_comments/src/domain/entities/post_comment.dart';

class PostCommentMapper {
  static List<PostComment> fromJsonList(List<dynamic>? jsonList) {
    return jsonList == null ? [] : jsonList.map(fromJson).toList();
  }

  static PostComment fromJson(dynamic json) => PostComment(
        id: json['id'],
        postId: json['postId'],
        name: json['name'],
        email: json['email'],
        body: json['body'],
      );
}
