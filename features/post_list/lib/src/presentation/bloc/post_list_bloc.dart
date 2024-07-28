import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_input.dart';
import 'package:post_list/src/domain/interactor/get_all_posts_use_case.dart';
import 'package:post_list/src/presentation/bloc/post_list_event.dart';
import 'package:post_list/src/presentation/bloc/post_list_state.dart';

class PostListBloc extends Bloc<PostListEvent, PostListState> {
  final GetAllPostsUseCase _getAllPostsUseCase;

  // ignore: prefer_final_fields
  Pagination _pagination = Pagination(pageNumber: 0, pageSize: 20, isFinal: false);
  Pagination get pagination => _pagination;

  PostListBloc({
    required GetAllPostsUseCase getAllPostsUseCase,
  })  : _getAllPostsUseCase = getAllPostsUseCase,
        super(const InitialBlocState()) {
    on<LoadMoreEvent>(_loadMore);
  }

  void _loadMore(LoadMoreEvent event, Emitter<PostListState> emit) async {
    if (_pagination.isFinal) {
      return;
    }
    emit(const LoadingBlocState());

    final input = GetAllPostsInput(pagination: _pagination);
    final result = await _getAllPostsUseCase.execute(input);
    final List<PostSummary> posts = result.data;
    if (posts.length < _pagination.pageSize) {
      _pagination.isFinal = true;
    }

    emit(LoaddedBlocState(posts: posts, pagination: _pagination));
    _pagination.pageNumber++;
  }
}
