import 'dart:async';
import 'package:core/core.dart';
import 'package:post_list/src/data/mappers/post_summary_mapper.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_input.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_output.dart';
import 'package:post_list/src/domain/repositories/post_repository.dart';

class PostRemoteRepository implements PostRepository {
  final BaseUrl _baseUrl;
  final HttpManager _httpManager;

  PostRemoteRepository({
    required BaseUrl baseUrl,
    required HttpManager httpManager,
  })  : _baseUrl = baseUrl,
        _httpManager = httpManager;

  @override
  Future<GetAllPostsOutput> getAll(GetAllPostsInput input) async {
    final offset = input.pagination.pageNumber * input.pagination.pageSize;
    final url = '${_baseUrl.value}/posts?_start=$offset&_limit=${input.pagination.pageSize}';

    var result = await _httpManager.get(url);

    if (result.isOk()) {
      return GetAllPostsOutput.withData(data: PostSummaryMapper.fromJsonList(result.data));
    }
    return GetAllPostsOutput.withErrors(error: result.error ?? 'Unknown error');
  }
}
