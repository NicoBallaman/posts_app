import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';
import 'package:post_comments/src/localization/post_comments_localization.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_bloc.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_event.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_state.dart';
import 'package:post_comments/src/presentation/widgets/comment_item.dart';

class PostCommentsComponent extends StatefulWidget {
  final int _postId;
  final PostCommentsBloc _bloc;

  const PostCommentsComponent({
    super.key,
    required int postId,
    required PostCommentsBloc bloc,
  })  : _postId = postId,
        _bloc = bloc;

  @override
  State<PostCommentsComponent> createState() => _PostCommentsComponentState();
}

class _PostCommentsComponentState extends State<PostCommentsComponent> {
  final PagingController<int, PostComment> _pagingController = PagingController(firstPageKey: 0);
  late StreamSubscription _blocListingStateSubscription;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    widget._bloc.add(LoadMoreEvent(postId: widget._postId));
    _blocListingStateSubscription = widget._bloc.stream.listen(_listenEvents);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = PostCommentsLocalization.of(context);
    final heightScreen = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - 40;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: SizedBox(
        height: heightScreen,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.zero,
              sliver: PagedSliverList<int, PostComment>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<PostComment>(
                  itemBuilder: (context, item, index) => CommentItem(
                    comment: item,
                  ),
                  noItemsFoundIndicatorBuilder: (_) => Center(
                    child: Text(i18n.translate('post_list.no_items_found')),
                  ),
                  firstPageErrorIndicatorBuilder: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  firstPageProgressIndicatorBuilder: (context) => const SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenEvents(PostCommentsState state) {
    if (state is LoaddedBlocState) {
      if (state.pagination.isFinal) {
        _pagingController.appendLastPage(state.comments);
      } else {
        final nextPageKey = state.pagination.pageNumber + state.comments.length;
        _pagingController.appendPage(state.comments, nextPageKey);
      }
    }
    if (state is ErrorBlocState) {
      _pagingController.error = state.message;
    }
  }

  void _onScroll() {
    final double triggerFetchMoreSize = 0.7 * _scrollController.position.maxScrollExtent;

    if (widget._bloc.pagination.isFinal == true) {
      return;
    }
    if (widget._bloc.state is LoadingBlocState) {
      return;
    }
    if (_scrollController.position.pixels > triggerFetchMoreSize) {
      widget._bloc.add(LoadMoreEvent(postId: widget._postId));
    }
  }

  @override
  void dispose() {
    _blocListingStateSubscription.cancel();
    _scrollController.dispose();
    widget._bloc.close();
    super.dispose();
  }
}
