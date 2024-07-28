import 'dart:async';
import 'package:core/core.dart';
import 'package:post_comments/src/data/mappers/post_comment_summary_mapper.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_input.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_output.dart';
import 'package:post_comments/src/domain/repositories/post_comments_repository.dart';

class PostCommentsRemoteRepository implements PostCommentsRepository {
  final BaseUrl _baseUrl;
  final HttpManager _httpManager;

  PostCommentsRemoteRepository({
    required BaseUrl baseUrl,
    required HttpManager httpManager,
  })  : _baseUrl = baseUrl,
        _httpManager = httpManager;

  @override
  Future<GetAllCommentsOutput> getAll(GetAllCommentsInput input) async {
    final offset = input.pagination.pageNumber * input.pagination.pageSize;
    final url = '${_baseUrl.value}/comments?postId=${input.postId}&_start=$offset&_limit=${input.pagination.pageSize}';

    var result = await _httpManager.get(url);

    if (result.isOk()) {
      return GetAllCommentsOutput.withData(data: PostCommentMapper.fromJsonList(result.data));
    }
    return GetAllCommentsOutput.withErrors(error: result.error ?? 'Unknown error');
  }
}
