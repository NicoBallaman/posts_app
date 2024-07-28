import 'package:equatable/equatable.dart';

abstract class PostCommentsEvent extends Equatable {
  const PostCommentsEvent();
  @override
  List<Object> get props => [];
}

class LoadMoreEvent extends PostCommentsEvent {
  final int postId;
  const LoadMoreEvent({required this.postId});
}
