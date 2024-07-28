import 'package:post_comments/src/domain/entities/post_comment.dart';

class GetAllCommentsOutput {
  final List<PostComment> data;
  final String? error;

  GetAllCommentsOutput.withData({required this.data}) : error = null;

  GetAllCommentsOutput.withErrors({required this.error}) : data = [];

  bool get hasErrors => error?.isNotEmpty ?? false;
}
