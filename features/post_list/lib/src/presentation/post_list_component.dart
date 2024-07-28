import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';
import 'package:post_list/src/localization/post_list_localization.dart';
import 'package:post_list/src/presentation/bloc/post_list_bloc.dart';
import 'package:post_list/src/presentation/bloc/post_list_event.dart';
import 'package:post_list/src/presentation/bloc/post_list_state.dart';
import 'package:post_list/src/presentation/widgets/post_item.dart';

class PostListComponent extends StatefulWidget {
  final PostListBloc _bloc;
  final ServiceBus _serviceBus;
  final Function(int id) _onPostPressed;
  const PostListComponent({
    super.key,
    required PostListBloc bloc,
    required ServiceBus serviceBus,
    required Function(int id) onPostPressed,
  })  : _bloc = bloc,
        _serviceBus = serviceBus,
        _onPostPressed = onPostPressed;

  @override
  State<PostListComponent> createState() => _PostListComponentState();
}

class _PostListComponentState extends State<PostListComponent> {
  final PagingController<int, PostSummary> _pagingController = PagingController(firstPageKey: 0);
  late StreamSubscription _blocListingStateSubscription;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    widget._bloc.add(const LoadMoreEvent());
    _blocListingStateSubscription = widget._bloc.stream.listen(_listenEvents);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = PostListLocalization.of(context);
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
              sliver: PagedSliverList<int, PostSummary>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<PostSummary>(
                  itemBuilder: (context, item, index) => PostItem(
                    post: item,
                    serviceBus: widget._serviceBus,
                    onTap: widget._onPostPressed,
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

  void _listenEvents(PostListState state) {
    if (state is LoaddedBlocState) {
      if (state.pagination.isFinal) {
        _pagingController.appendLastPage(state.posts);
      } else {
        final nextPageKey = state.pagination.pageNumber + state.posts.length;
        _pagingController.appendPage(state.posts, nextPageKey);
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
      widget._bloc.add(const LoadMoreEvent());
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
