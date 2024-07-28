import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_input.dart';
import 'package:post_comments/src/domain/interactor/get_all_comments_use_case.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_event.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_state.dart';

class PostCommentsBloc extends Bloc<PostCommentsEvent, PostCommentsState> {
  final GetAllCommentsUseCase _getAllCommentsUseCase;

  // ignore: prefer_final_fields
  Pagination _pagination = Pagination(pageNumber: 0, pageSize: 20, isFinal: false);
  Pagination get pagination => _pagination;

  PostCommentsBloc({
    required GetAllCommentsUseCase getAllCommentsUseCase,
  })  : _getAllCommentsUseCase = getAllCommentsUseCase,
        super(const InitialBlocState()) {
    on<LoadMoreEvent>(_loadMore);
  }

  void _loadMore(LoadMoreEvent event, Emitter<PostCommentsState> emit) async {
    if (_pagination.isFinal) {
      return;
    }
    emit(const LoadingBlocState());

    final input = GetAllCommentsInput(postId: event.postId, pagination: _pagination);
    final result = await _getAllCommentsUseCase.execute(input);
    final List<PostComment> comments = result.data;
    if (comments.length < _pagination.pageSize) {
      _pagination.isFinal = true;
    }

    emit(LoaddedBlocState(comments: comments, pagination: _pagination));
    _pagination.pageNumber++;
  }
}
