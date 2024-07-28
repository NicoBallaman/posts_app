import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';

class PostItem extends StatefulWidget {
  final PostSummary post;
  final ServiceBus serviceBus;
  final Function(int id) onTap;
  const PostItem({super.key, required this.post, required this.onTap, required this.serviceBus});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> implements ServiceBusSubscriber {
  bool _isFavorite = false;
  late final ServiceBusEvent _event;

  @override
  void initState() {
    //TODO read isFavorite from localStorage

    _event = ServiceBusEvent(eventId: 'favorite_post_changed_${widget.post.id}');
    widget.serviceBus.subscribe(serviceBusSubscriber: this, event: _event);
    super.initState();
  }

  @override
  void dispose() {
    widget.serviceBus.unsubscribe(serviceBusSubscriber: this, event: _event);
    super.dispose();
  }

  @override
  Future<void> onEventPublished<T>(T data, ServiceBusEvent event) async {
    if (event.eventId == _event.eventId) {
      _isFavorite = (data as bool);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        onTap: () => widget.onTap(widget.post.id),
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          widget.post.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.post.body,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            _isFavorite ? const Icon(Icons.favorite, color: Colors.red) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
