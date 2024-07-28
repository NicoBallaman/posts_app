import 'dart:async';
import 'package:core/core.dart';
import 'package:post_comments/src/data/repositories/post_comments_repository.dart';
import 'package:post_comments/src/domain/interactor/get_all_comments_use_case.dart';
import 'package:post_comments/src/domain/interactor/get_all_comments_use_case_impl.dart';
import 'package:post_comments/src/domain/repositories/post_comments_repository.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_bloc.dart';

class PostCommentsInjectionModule implements InjectionModule {
  @override
  FutureOr<void> registerDependencies(InjectorContainer injector) async {
    injector.registerFactory<PostCommentsRepository>(
      () => PostCommentsRemoteRepository(
        baseUrl: injector.resolve<BaseUrl>(),
        httpManager: injector.resolve<HttpManager>(),
      ),
    );

    injector.registerFactory<GetAllCommentsUseCase>(
      () => GetAllCommentsUseCaseImpl(
        postCommentsRepository: injector.resolve<PostCommentsRepository>(),
      ),
    );

    injector.registerFactory<PostCommentsBloc>(
      () => PostCommentsBloc(
        getAllCommentsUseCase: injector.resolve<GetAllCommentsUseCase>(),
      ),
    );
  }
}
