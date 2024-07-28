import 'package:post_list/src/domain/input_output/get_all_posts_input.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_output.dart';
import 'package:post_list/src/domain/interactor/get_all_posts_use_case.dart';
import 'package:post_list/src/domain/repositories/post_repository.dart';

class GetAllPostsUseCaseImpl implements GetAllPostsUseCase {
  final PostRepository _postRepository;

  GetAllPostsUseCaseImpl({
    required PostRepository postRepository,
  }) : _postRepository = postRepository;

  @override
  Future<GetAllPostsOutput> execute(GetAllPostsInput input) async {
    final result = await _postRepository.getAll(input);
    if (result.hasErrors) {
      return GetAllPostsOutput.withErrors(error: result.error);
    }

    return GetAllPostsOutput.withData(data: result.data);
  }
}
