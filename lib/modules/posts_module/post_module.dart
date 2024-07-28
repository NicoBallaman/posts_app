import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:post_comments/post_comments.dart';
import 'package:post_list/post_list.dart';
import 'package:posts_app/modules/posts_module/pages/post_comments_page.dart';
import 'package:posts_app/modules/posts_module/pages/post_list_page.dart';

class PostModule extends AppModule {
  static late final NavigationManager _navigationManager;
  static const String _rootPath = '/posts';
  static const String _commentsPath = '/comments';

  static void navigateToPost<T>(BuildContext context) {
    return _navigationManager.navigateTo(context, _rootPath);
  }

  static void navigateToPostDetail<T>(BuildContext context, int postId) {
    return _navigationManager.navigateTo(context, '$_rootPath/$postId/$_commentsPath');
  }

  @override
  registerDependencies(InjectorContainer injector) {
    _navigationManager = injector.resolve<NavigationManager>();
    PostListResolver().injectionModule!.registerDependencies(injector);
    PostCommentsResolver().injectionModule!.registerDependencies(injector);
  }

  @override
  List<LocalizationsDelegate<dynamic>?> get localeDelegates => [
        PostListResolver().localeDelegate,
        PostCommentsResolver().localeDelegate,
      ];

  @override
  List<AppRoute> generateRoutes() {
    return [
      AppRoute(
        path: _rootPath,
        routeType: RouteType.protected,
        pageBuilder: (_) => const PostListPage(),
        routes: [
          AppRoute(
            path: ':id/$_commentsPath',
            routeType: RouteType.protected,
            pageBuilder: (params) {
              final id = int.tryParse(params?['id'] ?? '') ?? -1;
              return PostCommentsPage(postId: id);
            },
          )
        ],
      ),
    ];
  }
}
