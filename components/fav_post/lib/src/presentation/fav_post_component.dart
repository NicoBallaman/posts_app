import 'package:core/core.dart';
import 'package:flutter/material.dart';

class FavPostComponent extends StatefulWidget {
  final int _postId;
  final ServiceBus _serviceBus;
  const FavPostComponent({
    super.key,
    required int postId,
    required ServiceBus serviceBus,
  })  : _postId = postId,
        _serviceBus = serviceBus;

  @override
  State<FavPostComponent> createState() => _FavPostComponentState();
}

class _FavPostComponentState extends State<FavPostComponent> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded),
      onPressed: () {
        _isFavorite = !_isFavorite;
        setState(() {});

        //TODO save in localStorage and read on initState

        widget._serviceBus.publish(
          data: _isFavorite,
          event: ServiceBusEvent(eventId: 'favorite_post_changed_${widget._postId}'),
        );
      },
    );
  }
}
