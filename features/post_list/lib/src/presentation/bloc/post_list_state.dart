import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';

abstract class PostListState extends Equatable {
  const PostListState();
  @override
  List<Object> get props => [];
}

class InitialBlocState extends PostListState {
  const InitialBlocState();
}

class LoadingBlocState extends PostListState {
  const LoadingBlocState();
}

class LoaddedBlocState extends PostListState {
  final List<PostSummary> posts;
  final Pagination pagination;

  const LoaddedBlocState({
    required this.posts,
    required this.pagination,
  });

  @override
  List<Object> get props => [posts, pagination];
}

class ErrorBlocState extends PostListState {
  final String message;

  const ErrorBlocState(this.message);

  @override
  List<Object> get props => [message];
}
