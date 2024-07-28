import 'package:equatable/equatable.dart';

abstract class PostListEvent extends Equatable {
  const PostListEvent();
  @override
  List<Object> get props => [];
}

class LoadMoreEvent extends PostListEvent {
  const LoadMoreEvent();
}
