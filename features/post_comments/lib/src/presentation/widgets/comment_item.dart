import 'package:flutter/material.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';
import 'package:post_comments/src/localization/post_comments_localization.dart';

class CommentItem extends StatefulWidget {
  final PostComment comment;
  const CommentItem({super.key, required this.comment});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool _expanded = false;
  static const int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    final i18n = PostCommentsLocalization.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.comment.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              widget.comment.email,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final TextSpan textSpan = TextSpan(
                  text: widget.comment.body,
                  style: Theme.of(context).textTheme.titleSmall,
                );
                final TextPainter textPainter = TextPainter(
                  text: textSpan,
                  maxLines: _maxLines,
                  textDirection: TextDirection.ltr,
                );
                textPainter.layout(maxWidth: constraints.maxWidth);

                if (textPainter.didExceedMaxLines) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.body,
                        maxLines: _expanded ? null : _maxLines,
                        overflow: _expanded ? null : TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        child: Text(
                          _expanded ? i18n.translate('post_comments.view_less') : i18n.translate('post_comments.view_more'),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Text(widget.comment.body);
                }
              },
            ),
          ],
        ),
      ),
    );
    // return Card(
    //   elevation: 4.0,
    //   margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12.0),
    //   ),
    //   child: ListTile(
    //     contentPadding: const EdgeInsets.all(16.0),
    //     title: Text(
    //       comment.name,
    //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
    //             fontWeight: FontWeight.bold,
    //           ),
    //       maxLines: 1,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //     subtitle: Text(
    //       comment.body,
    //       style: Theme.of(context).textTheme.bodyMedium,
    //       maxLines: 3,
    //       overflow: TextOverflow.ellipsis,
    //     ),
    //   ),
    // );
  }
}
