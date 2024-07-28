import 'package:core/core.dart';

class GetAllCommentsInput {
  final int postId;
  final Pagination pagination;

  GetAllCommentsInput({
    required this.postId,
    required this.pagination,
  });
}
