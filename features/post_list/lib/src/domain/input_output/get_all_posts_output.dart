import 'package:post_list/src/domain/entities/post_summary.dart';

class GetAllPostsOutput {
  final List<PostSummary> data;
  final String? error;

  GetAllPostsOutput.withData({required this.data}) : error = null;

  GetAllPostsOutput.withErrors({required this.error}) : data = [];

  bool get hasErrors => error?.isNotEmpty ?? false;
}
