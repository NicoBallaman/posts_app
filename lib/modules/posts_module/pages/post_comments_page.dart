import 'package:core/core.dart';
import 'package:fav_post/fav_post.dart';
import 'package:flutter/material.dart';
import 'package:post_comments/post_comments.dart';

class PostCommentsPage extends StatelessWidget {
  final int postId;
  const PostCommentsPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final injector = InjectorContainer.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Comments',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          FavPostComponent(
            postId: postId,
            serviceBus: injector.resolve<ServiceBus>(),
          ),
        ],
      ),
      body: PostCommentsComponent(
        postId: postId,
        bloc: injector.resolve<PostCommentsBloc>(),
      ),
    );
  }
}
