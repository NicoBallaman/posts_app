import 'package:post_comments/src/domain/input_output/get_all_comments_input.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_output.dart';

abstract class PostCommentsRepository {
  Future<GetAllCommentsOutput> getAll(GetAllCommentsInput input);
}
