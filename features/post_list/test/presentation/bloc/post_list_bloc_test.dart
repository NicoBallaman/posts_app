import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:post_list/src/domain/entities/post_summary.dart';
import 'package:post_list/src/domain/input_output/get_all_posts_output.dart';
import 'package:post_list/src/domain/interactor/get_all_posts_use_case.dart';
import 'package:post_list/src/presentation/bloc/post_list_bloc.dart';
import 'package:post_list/src/presentation/bloc/post_list_event.dart';
import 'package:post_list/src/presentation/bloc/post_list_state.dart';

@GenerateMocks([GetAllPostsUseCase])
import 'post_list_bloc_test.mocks.dart';

void main() {
  group('PostListBloc Tests', () {
    late MockGetAllPostsUseCase mockGetAllPostsUseCase;
    late PostListBloc postListBloc;

    final postListFullPage = List.generate(20, (index) => PostSummary(id: index, title: 'Post $index', body: ''));
    final postListIncompletePage = List.generate(10, (index) => PostSummary(id: index, title: 'Post $index', body: ''));

    setUp(() {
      mockGetAllPostsUseCase = MockGetAllPostsUseCase();
      postListBloc = PostListBloc(getAllPostsUseCase: mockGetAllPostsUseCase);
    });

    blocTest<PostListBloc, PostListState>(
      'emits [LoadingBlocState, LoaddedBlocState] when LoadMoreEvent is added and posts are returned',
      build: () {
        when(mockGetAllPostsUseCase.execute(any)).thenAnswer((_) async => GetAllPostsOutput.withData(data: postListFullPage));
        return postListBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent()),
      expect: () => [
        isA<LoadingBlocState>(),
        isA<LoaddedBlocState>()
            .having((state) => state.posts, 'posts', postListFullPage)
            .having((state) => state.pagination.isFinal, 'is final', false),
      ],
      verify: (_) {
        verify(mockGetAllPostsUseCase.execute(any)).called(1);
        expect(postListBloc.pagination.pageNumber, 1);
      },
    );

    blocTest<PostListBloc, PostListState>(
      'emits [LoadingBlocState, LoaddedBlocState] with isFinal true when less than pageSize posts are returned',
      build: () {
        when(mockGetAllPostsUseCase.execute(any)).thenAnswer((_) async => GetAllPostsOutput.withData(data: postListIncompletePage));
        return postListBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent()),
      expect: () => [
        isA<LoadingBlocState>(),
        isA<LoaddedBlocState>()
            .having((state) => state.posts, 'posts', postListIncompletePage)
            .having((state) => state.pagination.isFinal, 'is final', true),
      ],
      verify: (_) {
        verify(mockGetAllPostsUseCase.execute(any)).called(1);
        expect(postListBloc.pagination.pageNumber, 1);
        expect(postListBloc.pagination.isFinal, true);
      },
    );

    blocTest<PostListBloc, PostListState>(
      'does not emit new states when LoadMoreEvent is added and pagination is final',
      build: () {
        postListBloc.pagination.isFinal = true;
        return postListBloc;
      },
      act: (bloc) => bloc.add(const LoadMoreEvent()),
      expect: () => [],
      verify: (_) {
        verifyNever(mockGetAllPostsUseCase.execute(any));
      },
    );
  });
}
