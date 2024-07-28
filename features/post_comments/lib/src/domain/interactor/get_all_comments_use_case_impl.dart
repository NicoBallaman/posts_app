import 'package:post_comments/src/domain/input_output/get_all_comments_input.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_output.dart';
import 'package:post_comments/src/domain/interactor/get_all_comments_use_case.dart';
import 'package:post_comments/src/domain/repositories/post_comments_repository.dart';

class GetAllCommentsUseCaseImpl implements GetAllCommentsUseCase {
  final PostCommentsRepository _postCommentsRepository;

  GetAllCommentsUseCaseImpl({
    required PostCommentsRepository postCommentsRepository,
  }) : _postCommentsRepository = postCommentsRepository;

  @override
  Future<GetAllCommentsOutput> execute(GetAllCommentsInput input) async {
    final result = await _postCommentsRepository.getAll(input);
    if (result.hasErrors) {
      return GetAllCommentsOutput.withErrors(error: result.error);
    }

    return GetAllCommentsOutput.withData(data: result.data);
  }
}
