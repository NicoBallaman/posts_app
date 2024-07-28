import 'dart:async';
import 'package:core/core.dart';
import 'package:post_list/src/data/repositories/post_remote_repository.dart';
import 'package:post_list/src/domain/interactor/get_all_posts_use_case.dart';
import 'package:post_list/src/domain/interactor/get_all_posts_use_case_impl.dart';
import 'package:post_list/src/domain/repositories/post_repository.dart';
import 'package:post_list/src/presentation/bloc/post_list_bloc.dart';

class PostListInjectionModule implements InjectionModule {
  @override
  FutureOr<void> registerDependencies(InjectorContainer injector) async {
    injector.registerFactory<PostRepository>(
      () => PostRemoteRepository(
        baseUrl: injector.resolve<BaseUrl>(),
        httpManager: injector.resolve<HttpManager>(),
      ),
    );

    injector.registerFactory<GetAllPostsUseCase>(
      () => GetAllPostsUseCaseImpl(
        postRepository: injector.resolve<PostRepository>(),
      ),
    );

    injector.registerFactory<PostListBloc>(
      () => PostListBloc(
        getAllPostsUseCase: injector.resolve<GetAllPostsUseCase>(),
      ),
    );
  }
}
