import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:post_comments/post_comments.dart';
import 'package:post_comments/src/domain/entities/post_comment.dart';
import 'package:post_comments/src/domain/input_output/get_all_comments_output.dart';
import 'package:post_comments/src/domain/interactor/get_all_comments_use_case.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_event.dart';
import 'package:post_comments/src/presentation/bloc/post_comments_state.dart';

@GenerateMocks([GetAllCommentsUseCase])
import 'post_comments_bloc_test.mocks.dart';

void main() {
  group('PostCommentsBloc Tests', () {
    late MockGetAllCommentsUseCase mockGetAllCommentsUseCase;
    late PostCommentsBloc postCommentsBloc;
    const postId = 1;
    final postCommentsFullPage = List.generate(20, (index) => PostComment(id: index, postId: postId, name: '', email: '', body: ''));
    final postCommentsIncompletePage = List.generate(10, (index) => PostComment(id: index, postId: postId, name: '', email: '', body: ''));

    setUp(() {
      mockGetAllCommentsUseCase = MockGetAllCommentsUseCase();
      postCommentsBloc = PostCommentsBloc(getAllCommentsUseCase: mockGetAllCommentsUseCase);
    });

    blocTest<PostCommentsBloc, PostCommentsState>(
      'emits [LoadingBlocState, LoaddedBlocState] when LoadMoreEvent is added and comments are returned',
      build: () {
        when(mockGetAllCommentsUseCase.execute(any)).thenAnswer((_) async => GetAllCommentsOutput.withData(data: postCommentsFullPage));
        return postCommentsBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent(postId: postId)),
      expect: () => [
        isA<LoadingBlocState>(),
        isA<LoaddedBlocState>()
            .having((state) => state.comments, 'comments', postCommentsFullPage)
            .having((state) => state.pagination.isFinal, 'is final', false),
      ],
      verify: (_) {
        verify(mockGetAllCommentsUseCase.execute(any)).called(1);
        expect(postCommentsBloc.pagination.pageNumber, 1);
      },
    );

    blocTest<PostCommentsBloc, PostCommentsState>(
      'emits [LoadingBlocState, LoaddedBlocState] with isFinal true when less than pageSize comments are returned',
      build: () {
        when(mockGetAllCommentsUseCase.execute(any)).thenAnswer((_) async => GetAllCommentsOutput.withData(data: postCommentsIncompletePage));
        return postCommentsBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent(postId: postId)),
      expect: () => [
        isA<LoadingBlocState>(),
        isA<LoaddedBlocState>()
            .having((state) => state.comments, 'comments', postCommentsIncompletePage)
            .having((state) => state.pagination.isFinal, 'is final', true),
      ],
      verify: (_) {
        verify(mockGetAllCommentsUseCase.execute(any)).called(1);
        expect(postCommentsBloc.pagination.pageNumber, 1);
        expect(postCommentsBloc.pagination.isFinal, true);
      },
    );

    blocTest<PostCommentsBloc, PostCommentsState>(
      'does not emit new states when LoadMoreEvent is added and pagination is final',
      build: () {
        postCommentsBloc.pagination.isFinal = true;
        return postCommentsBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent(postId: postId)),
      expect: () => [],
      verify: (_) {
        verifyNever(mockGetAllCommentsUseCase.execute(any));
      },
    );
  });
}
