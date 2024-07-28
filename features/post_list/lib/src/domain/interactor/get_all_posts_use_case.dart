import 'package:post_list/src/domain/input_output/get_all_posts_input.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_output.dart';

abstract class GetAllPostsUseCase {
  Future<GetAllPostsOutput> execute(GetAllPostsInput input);
}
