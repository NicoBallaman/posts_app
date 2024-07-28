import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:post_list/post_list.dart';
import 'package:posts_app/modules/posts_module/post_module.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final injector = InjectorContainer.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Posts',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: PostListComponent(
        bloc: injector.resolve<PostListBloc>(),
        serviceBus: injector.resolve<ServiceBus>(),
        onPostPressed: (int id) => PostModule.navigateToPostDetail(context, id),
      ),
    );
  }
}
