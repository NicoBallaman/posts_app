import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';

abstract class PostCommentsState extends Equatable {
  const PostCommentsState();
  @override
  List<Object> get props => [];
}

class InitialBlocState extends PostCommentsState {
  const InitialBlocState();
}

class LoadingBlocState extends PostCommentsState {
  const LoadingBlocState();
}

class LoaddedBlocState extends PostCommentsState {
  final List<PostComment> comments;
  final Pagination pagination;

  const LoaddedBlocState({
    required this.comments,
    required this.pagination,
  });

  @override
  List<Object> get props => [comments, pagination];
}

class ErrorBlocState extends PostCommentsState {
  final String message;

  const ErrorBlocState(this.message);

  @override
  List<Object> get props => [message];
}
